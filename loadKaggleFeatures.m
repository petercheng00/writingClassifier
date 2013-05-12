function [features, labels] = loadKaggleFeatures()
features = importdata('kagglefeaturestrain.csv');
features = features.data;

labels = importdata('train_answers.csv');
labels = labels.data(:,2);
r = repmat(labels,1,4)';
r = r(:)';
labels = r';

end

