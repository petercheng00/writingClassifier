addpath('liblinear-1.93');

A = importdata('wordFeaturesAveraged.csv',',',0);
labels = A(:,2);
features = A(:,3:end);
writers = A(:,1);

threshold = 0.5 * size(A, 1);

train_X = sparse(features(1:threshold, :));
train_Y = sparse(labels(1:threshold, :));
test_X = sparse(features(threshold:size(A,1),:));
test_Y = sparse(labels(threshold:size(A,1),:));

logistic_model = train(train_Y, train_X, '-s 0 -e 0.001');

[predicted] = predict(test_Y, test_X, logistic_model, '-b 1');
benchmark(predicted, test_Y);

% logistic_cv = train(train_Y, train_X, '-v 5 -e 0.001');
