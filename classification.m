fid = fopen('wordFeatures.csv');
C = textscan(fid, '%s%f%f%f%f%f%f%f%f%f%f%f', 'Delimiter', ',');
X = [C{3}, C{4}, C{5}, C{6}, C{7}, C{8}, C{9}, C{3}, C{10}, C{11}, C{12}];
Y = C{2};
train_X = sparse(X(1:15023, :));
train_Y = sparse(Y(1:15023, :));
test_X = sparse(X(15024:28010,:));
test_Y = sparse(Y(15024:28010,:));

logistic_model = train(train_Y, train_X, '-s 0 -e 0.001')

[predicted] = predict(test_Y, test_X, logistic_model, '-b 1');
benchmark(predicted, test_Y);

logistic_cv = train(train_Y, train_X, '-v 5 -e 0.001');

