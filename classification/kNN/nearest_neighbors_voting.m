function nearest_neighbors_voting( labels, features, voteMapping, trainEndInd)
    if nargin < 4
        trainEndInd = round(0.75 * size(labels,1));
    end
    
    maxAccuracy = 0;
    bestK = 0;
    for k = 1:100
    
    train_labels = labels(1:trainEndInd);
    test_labels = labels(trainEndInd+1:end);
    train_features = features(1:trainEndInd,:);
    test_features = features(trainEndInd+1:end,:);
    
    
    test_mapping = voteMapping(trainEndInd+1:end,:);
    test_vote_labels = getAuthorLabels(test_mapping, test_labels);
    
    mdl = ClassificationKNN.fit(train_features, train_labels, ...
        'NumNeighbors', k);
    
    pred_labels = predict(mdl,test_features);
    
    pred_labels = double(pred_labels);
    
    [pred_vote_labels, dists] = getAuthorLabels(test_mapping, pred_labels);
    correct = (pred_vote_labels == test_vote_labels);
    accuracy = sum(correct)/size(test_vote_labels,1);
    
    if (accuracy > maxAccuracy)
        maxAccuracy = accuracy;
        bestK = k;
    end
    disp(['accuracy for k=', num2str(k), ' is ', num2str(accuracy)]);
    end

    disp(['best is k= ', num2str(bestK), ' with ', num2str(maxAccuracy)]);

end

