import itertools
import csv
from collections import defaultdict


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


def extract_features(file_name):
    '''
    first column is writer num, second column is line num
    '''
    features = defaultdict(dict)
    with open(file_name) as f_in:
        reader = csv.reader(f_in, delimiter=',', quoting=csv.QUOTE_MINIMAL)
        for line in reader:
            features[line[0]][line[1]] = line[2:]
    return features


def main():
    labels = {}
    with open('train_answers.csv', 'rb') as f_in:
        reader = csv.DictReader(f_in, delimiter=',',
                                quoting=csv.QUOTE_MINIMAL,
                                fieldnames=['writer', 'male'])
        for line in reader:
            labels[line['writer']] = line['male']
    males = sorted([x for x in sorted(labels.items()) if x[1] == '1'])
    females = sorted([x for x in sorted(labels.items()) if x[1] == '0'])

    word_feature = extract_features('wordFeaturesLine.csv')
    line_angle_feature = extract_features('lineAngleFeature.csv')
    contour_feature = extract_features('contourFeatures.csv')
    cc_feature = extract_features('ccFeatures.csv')
    er_feature = extract_features('erFeatures.csv')
    fractal_feature = extract_features('fractalFeatures.csv')
    all_features = [word_feature, line_angle_feature, contour_feature, cc_feature, er_feature, fractal_feature]

    with open('allFeatures.csv', 'wb') as f_out:
        csv_writer = csv.writer(f_out, delimiter=',', quoting=csv.QUOTE_MINIMAL)
        for writer_num, label in roundrobin(males, females):
            line_nums = set()
            for features in all_features:
                line_nums.update(features[writer_num].keys())
            for line_num in line_nums:
                word = word_feature[writer_num][line_num]
                angle = line_angle_feature[writer_num][line_num]
                contour = contour_feature[writer_num][line_num]
                cc = cc_feature[writer_num][line_num]
                er = er_feature[writer_num][line_num]
                fractal = fractal_feature[writer_num][line_num]
                csv_writer.writerow([writer_num, label] + word + angle + contour + cc + er + fractal)

if __name__ == '__main__':
    main()
