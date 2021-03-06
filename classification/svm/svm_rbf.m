function svm_rbf( labels, features, trainEndInd )
    addpath('../../liblinear-1.93/matlab');
    
    if nargin < 3
        trainEndInd = round(0.75 * size(labels,1));
    end
    
    train_labels = labels(1:trainEndInd);
    test_labels = labels(trainEndInd+1:end);
    train_features = features(1:trainEndInd,:);
    test_features = features(trainEndInd+1:end,:);
    
    bestAccuracy = 0;
    bestC = 0;
    bestSigma = 0;
    for c = [1e3,1e2,1e1,1,1e-1,1e-2]
        for sigma = [1,10,100]
    disp(['training with c = ', num2str(c), ' sigma = ', num2str(sigma)]);
    svmStruct = svmtrain(train_features,train_labels, ...
                        'kernel_function', 'rbf', 'boxconstraint', c, 'rbf_sigma', sigma, 'tolkkt', 1e-3);
    
    
    disp('predicting');
    pred_labels = svmclassify(svmStruct,test_features);
    
    pred_labels = double(pred_labels);
    correct = (pred_labels == test_labels);
    accuracy = sum(correct) / size(pred_labels,1);
    
    if (accuracy > bestAccuracy)
        bestAccuracy = accuracy;
        bestC = c;
        bestSigma = sigma;
    end
    
    %disp(['accuracy is ', num2str(accuracy)]);
        end
    end
    disp(['best accuracy, c,  sigma are ', num2str(bestAccuracy), ', ' , num2str(bestC), ', ', num2str(bestSigma)]);
end



