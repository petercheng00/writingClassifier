function svm_rbf( labels, features, voteMapping, trainEndInd )
    addpath('../../liblinear-1.93/matlab');
    
    if nargin < 4
        trainEndInd = round(0.75 * size(labels,1));
    end
    
    train_labels = labels(1:trainEndInd);
    test_labels = labels(trainEndInd+1:end);
    train_features = features(1:trainEndInd,:);
    test_features = features(trainEndInd+1:end,:);
    
    test_mapping = voteMapping(trainEndInd+1:end,:);
    test_vote_labels = getAuthorLabels(test_mapping, test_labels);

    
    bestAccuracy = 0;
    bestC = 0;
    bestSigma = 0;
    for c = [1]
        for sigma = [6]
    disp(['training with c = ', num2str(c), ' sigma = ', num2str(sigma)]);
    svmStruct = svmtrain(train_features,train_labels, ...
                        'kernel_function', 'rbf', 'boxconstraint', c, 'rbf_sigma', sigma, 'tolkkt', 1e-3);
    
    
    disp('predicting');
    pred_labels = svmclassify(svmStruct,test_features);
    
    pred_labels = double(pred_labels);
    [pred_vote_labels, dists] = getAuthorLabels(test_mapping, pred_labels);
    correct = (pred_vote_labels == test_vote_labels);
    accuracy = sum(correct) / size(pred_vote_labels,1);
    keyboard
    if (accuracy > bestAccuracy)
        bestAccuracy = accuracy;
        bestC = c;
        bestSigma = sigma;
    end
    keyboard
    %disp(['accuracy is ', num2str(accuracy)]);
        end
    end
    disp(['best accuracy, c,  sigma are ', num2str(bestAccuracy), ', ' , num2str(bestC), ', ', num2str(bestSigma)]);
end



