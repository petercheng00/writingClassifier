import matplotlib.pyplot as plt
import matplotlib.cm as cm
import Image
import numpy
import itertools
import operator


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
    return f1, f2, f3, f4, f5, f6


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


def main():
    f1, f2, f3, f4, f5, f6 = height_features('images_subset/pre-processed/large.png', plot=False)
    f7 = width_feature('test_cleaned.png', plot=False)
    f8 = float(f2) / f7
    import pdb; pdb.set_trace()

if __name__ == '__main__':
    main()
