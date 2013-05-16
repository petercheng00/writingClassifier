function rand_forest_classify_voting( labels, features, voteMapping, trainEndInd)
    addpath('../..');
    if nargin < 4
        trainEndInd = round(0.75 * size(labels,1));
    end
    

    numTrees = 200;
    resamplePct = 0.5;
    varsToSample = size(features,2)/2;
    minLeafSize = 10;
    
    train_labels = labels(1:trainEndInd);
    test_labels = labels(trainEndInd+1:end);
    train_features = features(1:trainEndInd,:);
    test_features = features(trainEndInd+1:end,:);
    
    test_mapping = voteMapping(trainEndInd+1:end,:);
    test_vote_labels = getAuthorLabels(test_mapping, test_labels);
    
    
    disp('Building forest...');
    tb = TreeBagger(numTrees, train_features, train_labels, ...
        'NPrint', 50, ...
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
    
    [pred_vote_labels,dists] = getAuthorLabels(test_mapping, pred_labels);
    figure;
    bar(dists);
    
    correct = (pred_vote_labels == test_vote_labels);
    
    accuracy = sum(correct) / size(test_vote_labels,1);
    
    disp(['Accuracy is ', num2str(accuracy)]);
end

