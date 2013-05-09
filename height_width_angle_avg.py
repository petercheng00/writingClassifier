import matplotlib.pyplot as plt
import matplotlib.cm as cm
import Image
import ImageFilter
import numpy
import itertools
import operator
from collections import defaultdict
import pprint
import math
import csv
import progressbar
import glob

pr = pprint.PrettyPrinter(indent=2)


def pbar(size):
    bar = progressbar.ProgressBar(maxval=size,
                                  widgets=[progressbar.Bar('=', '[', ']'),
                                           ' ', progressbar.Percentage(),
                                           ' ', progressbar.ETA(),
                                           ' ', progressbar.Counter(),
                                           '/%s' % size])
    return bar


def height_features(im, plot=False):
    '''
    input the file name of a preprocessed image file. should be a line of words
    grayscale and whitespace trimmed using peter's preprocess.
    im has origin at upper left corner so top_line is 0.
    f1 is upper baseline - top_line
    f2 is lower baseline - upper baseline
    f3 is bottom line - lower_baseline
    f4 is f1 / f2
    f5 is f1 / f3
    f6 is f2 / f3
    '''
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

    f1 = ub_row
    f2 = lb_row - ub_row
    f3 = len(im) - lb_row
    f4 = float(f1) / f2
    f5 = float(f1) / f3
    f6 = float(f2) / f3
    return ub_row, lb_row, f1, f2, f3, f4, f5, f6


def width_feature(im, f2, plot=False):
    '''
    f7 is median of the gap lengths
    f8 is f2 / f7
    '''
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

    f7 = numpy.median(gap_lengths)
    return f7, float(f2) / f7


def get_intersection(y, x, goal_y, im, max_slides=5, slides=0):
    '''
    im is indexed (y, x) where y is vertical down and x is horizontal right
    origin is in upper left corner
    '''
    if y == goal_y:
        return y, x
    elif y > goal_y and im[y - 1][x] == 1:
        return get_intersection(y - 1, x, goal_y, im, max_slides, 0)
    elif y < goal_y and im[y + 1][x] == 1:
        return get_intersection(y + 1, x, goal_y, im, max_slides, 0)
    elif x + 1 < im.shape[1] and im[y][x + 1] == 1 and slides < max_slides:
        return get_intersection(y, x + 1, goal_y, im, max_slides, slides + 1)
    elif x - 1 > -1 and im[y][x - 1] == 1 and slides < max_slides:
        return get_intersection(y, x - 1, goal_y, im, max_slides, slides + 1)
    else:
        return None


def get_x(y, deg, p_x, p_y):
    return p_x + round((y - p_y) / -math.tan(math.radians(deg)))


def angle_feature(im, ub, lb, plot=False):
    '''
    f9 is average of slant angles (in degrees)
    f10 is std dev of slant angles (in degrees)
    '''
    mid = round((ub + lb) / 2)
    lines = []
    for x in range(len(im[mid])):
        if im[mid][x] == 1:
            top = get_intersection(mid, x, ub, im)
            bottom = get_intersection(mid, x, lb, im)
            if top is not None:
                lines.append(((mid, x), top))
            if bottom is not None:
                lines.append(((mid, x), bottom))

    # angle calculated with respect to mid, going counterclockwise
    angles = defaultdict(list)
    for (mid_y, p1x), (p2y, p2x) in lines:
        angle = math.degrees(math.atan2(mid_y - p2y, p2x - p1x))
        if angle < 0:
            angle += 180
        angles[(mid_y, p1x)].append(angle)
    avg_angles = {}
    for k, v in angles.items():
        avg_angles[k] = sum(v) / len(v)

    if plot:
        plt.imshow(im, cmap=cm.Greys_r)
        plt.hlines(numpy.array([ub, lb]), 0, im.shape[1], colors='y')
        plt.hlines(numpy.array([float(ub + lb) / 2]), 0, im.shape[1], colors='y')
        plt.autoscale(False)
        for (mid_y, x), deg in angles.items():
            x_zero = get_x(0, deg, x, mid_y)
            x_max = get_x(im.shape[0], deg, x, mid_y)
            plt.plot((x_zero, x_max), (0, im.shape[0]), color='b')
        for (p1x, p1y), (p2x, p2y) in lines:
            plt.plot((p1y, p2y), (p1x, p2x), color='r')
        plt.show()

    # usually there is an issue with word segmentation
    if len(avg_angles) == 0:
        f9, f10 = None, None
    else:
        f9 = sum(avg_angles.values()) / len(avg_angles)
        f10 = numpy.std(avg_angles.values())
    return f9, f10


def reject_outliers(data, m=2):
    return data[abs(data - numpy.mean(data)) < m * numpy.std(data)]


def main():
    input_file = 'train_answers.csv'
    labels = {}
    with open(input_file, 'rb') as f_in:
        reader = csv.DictReader(f_in, delimiter=',',
                                quoting=csv.QUOTE_MINIMAL,
                                fieldnames=['writer', 'male'])
        for line in reader:
            labels[line['writer']] = line['male']
    bar = pbar(len(glob.glob('wordImages/*')))
    count = 0
    bar.start()
    output_columns = ['file_name', 'label', 'f1', 'f2', 'f3', 'f4', 'f5', 'f6', 'f7', 'f8', 'f9', 'f10']
    writer_nums = sorted(list(set([x.split('/')[1].split('_')[0] for x in glob.glob('wordImages/*')])))
    with open('wordFeaturesAveraged.csv', 'wb') as f_out:
        writer = csv.DictWriter(f_out, delimiter=',',
                                quoting=csv.QUOTE_MINIMAL,
                                fieldnames=output_columns)
        for writer_num in writer_nums:
            f1s, f2s, f3s, f4s, f5s, f6s, f7s, f8s, f9s, f10s = [], [], [], [], [], [], [], [], [], []
            for file_name in glob.glob('wordImages/%s_*' % writer_num):
                count += 1
                bar.update(count)
                if not file_name.endswith('.bmp'):
                    continue
                img = Image.open(file_name)
                img = img.convert('L')
                img_outline = img.filter(ImageFilter.FIND_EDGES)
                im = numpy.array(img) / 255
                im_outline = numpy.array(img_outline) / 255

                ub, lb, f1, f2, f3, f4, f5, f6 = height_features(im, plot=False)
                f7, f8 = width_feature(im, f2, plot=False)
                f9, f10 = angle_feature(im_outline, ub, lb, plot=False)

                if f9 is None or f10 is None:
                    continue

                f1s.append(f1)
                f2s.append(f2)
                f3s.append(f3)
                f4s.append(f4)
                f5s.append(f5)
                f6s.append(f6)
                f7s.append(f7)
                f8s.append(f8)
                f9s.append(f9)
                f10s.append(f10)

            # remove outliers
            features = (f1s, f2s, f3s, f4s, f5s, f6s, f7s, f8s, f9s, f10s)
            avg_features = []
            for feat in features:
                avg_features.append(numpy.average(reject_outliers(numpy.array(feat))))
            f1, f2, f3, f4, f5, f6, f7, f8, f9, f10 = avg_features

            entry = {}
            entry['file_name'], entry['label'] = writer_num, labels[writer_num]
            entry['f1'], entry['f2'], entry['f3'], entry['f4'] = f1, f2, f3, f4
            entry['f5'], entry['f6'], entry['f7'], entry['f8'] = f5, f6, f7, f8
            entry['f9'], entry['f10'] = f9, f10
            # format_string = 'f1: %s\nf2: %s\nf3: %s\nf4: %s\nf5: %s\nf6: %s\nf7: %s\nf8:%s\nf9: %s\nf10: %s\n'
            # print format_string % (f1, f2, f3, f4, f5, f6, f7, f8, f9, f10)

            writer.writerow(entry)
            f_out.flush()
    bar.finish()

if __name__ == '__main__':
    main()
