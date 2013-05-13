function logistec_reg( labels, features, trainEndInd )
    addpath('../../liblinear-1.93/matlab');
    
    if nargin < 3
        trainEndInd = round(0.75 * size(labels,1));
    end

    
    train_labels = labels(1:trainEndInd);
    test_labels = labels(trainEndInd+1:end);
    train_features = features(1:trainEndInd,:);
    test_features = features(trainEndInd+1:end,:);
    disp('training');
    logistic_model = train(train_labels, sparse(train_features), '-s 0');
    disp('predicting');
    [pred_labels, accuracy] = predict(test_labels, test_features, logistic_model);
    
    disp(['accuracy is ', num2str(accuracy)]);
end

