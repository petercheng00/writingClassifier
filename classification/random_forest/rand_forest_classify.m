function rand_forest_classify( labels, features, trainEndInd)
    if nargin < 3
        trainEndInd = round(0.75 * size(labels,1));
    end
    
    numTrees = 50;
    resamplePct = 0.5;
    varsToSample = size(features,2)/2;
    minLeafSize = 10;
    
    train_labels = labels(1:trainEndInd);
    test_labels = labels(trainEndInd+1:end);
    train_features = features(1:trainEndInd,:);
    test_features = features(trainEndInd+1:end,:);
    
    disp('Building forest...');
    tb = TreeBagger(numTrees, train_features, train_labels, ...
        'NPrint', 1, ...
        'FBoot', resamplePct, ...
        'OOBPred', 'on', ...
        'NVarToSample', varsToSample, ...
        'MinLeaf', minLeafSize)
    
    plot(oobError(tb))
    xlabel('num trees')
    ylabel('oob error')
    drawnow
    disp('Predicting...');
    pred_labels = predict(tb, test_features);
    pred_labels = str2double(pred_labels);
    
    correct = (pred_labels == test_labels);
    
    accuracy = sum(correct) / size(test_labels,1);
    
    disp(['Accuracy is ', num2str(accuracy)]);
end

