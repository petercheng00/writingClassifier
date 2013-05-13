function svm_linear( labels, features, trainEndInd )
    addpath('../../liblinear-1.93/matlab');
    
    if nargin < 3
        trainEndInd = round(0.75 * size(labels,1));
    end

    for c = [10,1,0.1,0.01,0.001,0.0001]
    
    train_labels = labels(1:trainEndInd);
    test_labels = labels(trainEndInd+1:end);
    train_features = features(1:trainEndInd,:);
    test_features = features(trainEndInd+1:end,:);
    disp('training');
    model = train(train_labels, sparse(train_features), ['-c ', num2str(c)]);
    disp('predicting');
    predict(test_labels, sparse(test_features), model);  
    
    end
end



