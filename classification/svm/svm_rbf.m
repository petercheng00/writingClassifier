function svm_rbf( labels, features, trainEndInd )
    addpath('../../liblinear-1.93/matlab');
    
    if nargin < 3
        trainEndInd = round(0.75 * size(labels,1));
    end
    
    train_labels = labels(1:trainEndInd);
    test_labels = labels(trainEndInd+1:end);
    train_features = features(1:trainEndInd,:);
    test_features = features(trainEndInd+1:end,:);
    
    disp('training');
    svmStruct = svmtrain(train_features,train_labels, ...
                        'kernel_function', 'rbf');
    
    
    disp('predicting');
    pred_labels = svmclassify(svmStruct,test_features);
    
    pred_labels = double(pred_labels);
    correct = (pred_labels == test_labels);
    accuracy = sum(correct) / size(pred_labels,1);
    
    disp(['accuracy is ', num2str(accuracy)]);
    
end



