function svm_linear( labels, features, trainEndInd )
    addpath('../../liblinear-1.93/matlab');
    
    if nargin < 3
        trainEndInd = round(0.75 * size(labels,1));
    end

    for c = [1e-5,1e-4,1e-3,1e-2,1e-1,1,1e1,1e2,1e3]
    
    train_labels = labels(1:trainEndInd);
    test_labels = labels(trainEndInd+1:end);
    train_features = features(1:trainEndInd,:);
    test_features = features(trainEndInd+1:end,:);
    disp(['training with c = ', num2str(c)]);
    model = train(train_labels, sparse(train_features), ['-c ', num2str(c)]);
    disp('predicting');
    predict(test_labels, sparse(test_features), model);  
    
    end
end



