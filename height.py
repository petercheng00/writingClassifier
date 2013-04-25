import matplotlib.pyplot as plt
import matplotlib.cm as cm
import Image
import ImageFilter
import numpy
import itertools
import operator
from collections import defaultdict


def height_features(file_name, plot=False):
    '''
    input the file name of a preprocessed image file. should be a line of words
    grayscale and whitespace trimmed using peter's preprocess.
    f1-f7 based on https://docs.google.com/file/d/0B9xmmhddRXQNR1pfa0lmYWh5SHM/edit
    '''
    img = Image.open(file_name)

    # ones and zeros
    im = numpy.array(img) / 255
    sum_rows = numpy.sum(im, axis=1)
    num_black = numpy.sum(sum_rows)

    ub = 0.15 * num_black
    lb = 0.9 * num_black

    so_far, ub_row, lb_row = 0, 0, 0
    for i in xrange(len(im)):
        so_far += numpy.sum(im[i])
        if ub_row == 0 and so_far > ub:
            ub_row = i
        if lb_row == 0 and so_far > lb:
            lb_row = i

    if plot:
        plt.imshow(im, cmap=cm.Greys_r)
        plt.hlines(numpy.array([ub_row, lb_row]), 0, im.shape[1], colors='g')
        plt.hlines(numpy.array([float(ub_row + lb_row) / 2]), 0, im.shape[1], colors='y')
        plt.show()

    # top line - upper baseline
    f1 = ub_row
    # upper baseline - lower baseline
    f2 = lb_row - ub_row
    # lower baseline - bottom line
    f3 = len(im) - lb_row
    f4 = float(f1) / f2
    f5 = float(f1) / f3
    f6 = float(f2) / f3
    return ub_row, lb_row, f1, f2, f3, f4, f5, f6


def width_feature(file_name, plot=False):
    img = Image.open(file_name)

    # ones and zeros
    im = numpy.array(img) / 255
    transitions = []
    for i in xrange(len(im)):
        groups = itertools.groupby(list(im[i]))
        transitions.append((i, len([x for x in groups])))

    max_line, max_trans = max(transitions, key=operator.itemgetter(1))

    gap_lengths = []
    zeros_start = 0
    zeros = True
    for i in xrange(len(im[max_line])):
        pixel = im[max_line][i]
        if pixel == 1 and zeros is True:
            gap_lengths.append(i - zeros_start)
            zeros = False
        if pixel == 0 and zeros is not True:
            zeros_start = i
            zeros = True

    if plot:
        print gap_lengths
        plt.imshow(im, cmap=cm.Greys_r)
        plt.hlines(numpy.array([max_line]), 0, im.shape[1], colors='g')
        plt.show()

    return numpy.median(gap_lengths)


def get_intersection(x, y, goal_x, im, max_slides=3, slides=0):
    if x == goal_x:
        return x, y
    elif x > goal_x and im[x - 1][y] == 1:
        return get_intersection(x - 1, y, goal_x, im, max_slides, 0)
    elif x < goal_x and im[x + 1][y] == 1:
        return get_intersection(x + 1, y, goal_x, im, max_slides, 0)
    elif im[x][y + 1] == 1 and slides < max_slides:
        return get_intersection(x, y + 1, goal_x, im, max_slides, slides + 1)
    elif im[x][y - 1] == 1 and slides < max_slides:
        return get_intersection(x, y - 1, goal_x, im, max_slides, slides + 1)
    else:
        return None


def get_y(x, slope, p_x, p_y):
    return slope * (p_x - x) + p_y


def angle_feature(file_name, ub, lb, plot=False):
    img = Image.open(file_name)
    img_outline = img.filter(ImageFilter.FIND_EDGES)
    im = numpy.array(img_outline) / 255

    mid = round((ub + lb) / 2)
    lines = []
    for col in range(len(im[mid])):
        if im[mid][col] == 1:
            top = get_intersection(mid, col, ub, im)
            bottom = get_intersection(mid, col, lb, im)
            if top is not None:
                lines.append(((mid, col), top))
            if bottom is not None:
                lines.append(((mid, col), bottom))

    slopes = defaultdict(list)
    for (p1x, p1y), (p2x, p2y) in lines:
        if p2x == mid:
            slopes[(p2x, p2y)].append(-float(p2y-p1y) / (p2x-p1x))
        if p1x == mid:
            slopes[(p1x, p1y)].append(-float(p2y-p1y) / (p2x-p1x))
    # average slopes
    for k in slopes:
        slopes[k] = sum(slopes[k]) / float(len(slopes[k]))

    if plot:
        plt.imshow(im, cmap=cm.Greys_r)
        plt.hlines(numpy.array([ub, lb]), 0, im.shape[1], colors='y')
        plt.hlines(numpy.array([float(ub + lb) / 2]), 0, im.shape[1], colors='y')
        plt.autoscale(False)
        for k, v in slopes.items():
            y_zero = get_y(0, v, k[0], k[1])
            y_max = get_y(im.shape[0], v, k[0], k[1])
            plt.plot((y_zero, y_max), (0, im.shape[0]), color='b')
        for (p1x, p1y), (p2x, p2y) in lines:
            plt.plot((p1y, p2y), (p1x, p2x), color='r')
        plt.show()


def main():
    file_name = 'line_3.png'
    ub, lb, f1, f2, f3, f4, f5, f6 = height_features(file_name, plot=False)
    f7 = width_feature(file_name, plot=False)
    f8 = float(f2) / f7
    angle_feature(file_name, ub, lb, plot=True)


if __name__ == '__main__':
    main()
