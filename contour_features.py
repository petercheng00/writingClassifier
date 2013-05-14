import matplotlib.pyplot as plt
import matplotlib.cm as cm
import Image
import numpy
import itertools
import pprint
import csv
import progressbar
import glob
import scipy.signal
from operator import itemgetter

pr = pprint.PrettyPrinter(indent=2)


def pbar(size):
    bar = progressbar.ProgressBar(maxval=size,
                                  widgets=[progressbar.Bar('=', '[', ']'),
                                           ' ', progressbar.Percentage(),
                                           ' ', progressbar.ETA(),
                                           ' ', progressbar.Counter(),
                                           '/%s' % size])
    return bar


def characteristic_contour(contour):
    one_indices = [x[0] for x in sorted(zip(
        *numpy.where(contour == 1)), key=itemgetter(1))]
    char_one_indices = []
    index = one_indices[0]
    last_index = one_indices[0]
    for i in one_indices:
        if i > last_index:
            index += 1
        elif i < last_index:
            index -= 1
        char_one_indices.append(index)
        last_index = i
    smallest = min(char_one_indices)
    char_one_indices = [x - smallest for x in char_one_indices]
    char_contour = numpy.zeros((max(
        char_one_indices) + 1, contour.shape[1]), dtype=int)
    for i in range(len(char_one_indices)):
        char_contour[char_one_indices[i], i] = 1
    return char_contour


def avg_slopes(local_extrema, y, n=3):
    left_slopes = []
    right_slopes = []
    for ext in local_extrema:
        slope, intercept = numpy.polyfit(range(n), y[ext-n:ext], 1)
        left_slopes.append(slope)
        slope, intercept = numpy.polyfit(range(n), y[ext:ext+n], 1)
        right_slopes.append(slope)
    left_avg = sum(left_slopes) / len(left_slopes)
    right_avg = sum(right_slopes) / len(right_slopes)
    return left_avg, right_avg


def extract_contour_features(char_contour):
    x = numpy.array(range(char_contour.shape[1]))
    y = numpy.array([point[0] for point in sorted(zip(
        *numpy.where(char_contour == 1)), key=itemgetter(1))])
    slope, intercept = numpy.polyfit(x, y, 1)
    y_pred = numpy.polyval([slope, intercept], x)
    mean_sq_error = numpy.sum((y_pred - y)**2) / len(x)

    # can tune this parameter
    n = 3
    local_max = scipy.signal.argrelmax(y, order=n)[0]
    local_max = local_max[local_max > n]
    local_max = local_max[local_max < char_contour.shape[1]-n]
    local_min = scipy.signal.argrelmin(y, order=n)[0]
    local_min = local_min[local_min > n]
    local_min = local_min[local_min < char_contour.shape[1]-n]

    max_freq = float(len(local_max)) / char_contour.shape[1]
    min_freq = float(len(local_min)) / char_contour.shape[1]
    left_slope_max, right_slope_max = avg_slopes(local_max, y, n)
    left_slope_min, right_slope_min = avg_slopes(local_min, y, n)

    return slope, mean_sq_error, max_freq, min_freq, left_slope_max, right_slope_max, left_slope_min, right_slope_min


def contour_feature(im, plot=False):
    lower_contour = []
    upper_contour = []
    for i in range(im.shape[1]):
        if numpy.sum(im[:, i]) == 0:
            continue
        lower = numpy.zeros(im.shape[0], dtype=int)
        upper = numpy.zeros(im.shape[0], dtype=int)
        ones = numpy.where(im[:, i] == 1)[0]
        lower[ones[-1]] = 1
        upper[ones[0]] = 1
        lower_contour.append(lower)
        upper_contour.append(upper)
    lower_contour = numpy.vstack(lower_contour).transpose()
    upper_contour = numpy.vstack(upper_contour).transpose()
    char_lower_contour = characteristic_contour(lower_contour)
    char_upper_contour = characteristic_contour(upper_contour)

    f12, f13, f14, f15, f16, f17, f18, f19 = extract_contour_features(
        char_lower_contour)
    f20, f21, f22, f23, f24, f25, f26, f27 = extract_contour_features(
        char_upper_contour)

    if plot:
        f, (ax1, ax2, ax3) = plt.subplots(3)
        ax1.imshow(im, cmap=cm.Greys_r)
        ax2.imshow(lower_contour, cmap=cm.Greys_r)
        ax3.imshow(char_lower_contour, cmap=cm.Greys_r)
        plt.show()

    return f12, f13, f14, f15, f16, f17, f18, f19, f20, f21, f22, f23, f24, f25, f26, f27


def roundrobin(*iterables):
    "roundrobin('ABC', 'D', 'EF') --> A D E B F C"
    # Recipe credited to George Sakkis
    pending = len(iterables)
    nexts = itertools.cycle(iter(it).next for it in iterables)
    while pending:
        try:
            for next in nexts:
                yield next()
        except StopIteration:
            pending -= 1
            nexts = itertools.cycle(itertools.islice(nexts, pending))


def main():
    output_columns = ['writer', 'line', 'f12', 'f13', 'f14', 'f15', 'f16',
                      'f17', 'f18', 'f19', 'f20', 'f21', 'f22', 'f23', 'f24', 'f25', 'f26', 'f27']
    labels = {}
    with open('train_answers.csv', 'rb') as f_in:
        reader = csv.DictReader(f_in, delimiter=',',
                                quoting=csv.QUOTE_MINIMAL,
                                fieldnames=['writer', 'male'])
        for line in reader:
            labels[line['writer']] = line['male']
    angles = {}
    with open('lineAngleFeature.csv', 'rb') as f_in:
        reader = csv.DictReader(f_in, delimiter=',',
                                quoting=csv.QUOTE_MINIMAL,
                                fieldnames=['writer', 'line', 'angle'])
        for line in reader:
            angles[(line['writer'], line['line'])] = float(line['angle'])

    # consistent alternating ordering via roundrobin()
    males = sorted([x for x in sorted(labels.items()) if x[1] == '1'])
    females = sorted([x for x in sorted(labels.items()) if x[1] == '0'])

    bar = pbar(len(glob.glob('lineImages/*')))
    count = 0
    bar.start()
    with open('contourFeatures.csv', 'wb') as f_out:
        writer = csv.DictWriter(
            f_out, delimiter=',', fieldnames=output_columns)
        for writer_num, label in roundrobin(males, females):
            for file_name in glob.glob('lineImages/%s_*.bmp' % writer_num):
                line_num = file_name.split('/')[1].split('.')[0].split('_')[1]
                angle = angles[(writer_num, line_num)]
                count += 1
                bar.update(count)

                img = Image.open(file_name).rotate(angle).convert('L')
                im = numpy.array(img) / 255
                if count % 17 == 0:
                    features = contour_feature(im, plot=True)
                else:
                    features = contour_feature(im, plot=False)

                entry = {}
                entry['writer'], entry['line'] = writer_num, line_num
                feat_names = [x for x in output_columns if x.startswith('f')]
                for i in range(len(feat_names)):
                    entry[feat_names[i]] = features[i]

                writer.writerow(entry)
                f_out.flush()
    bar.finish()

if __name__ == '__main__':
    main()
