function nearest_neighbors( labels, features, trainEndInd)
    if nargin < 3
        trainEndInd = round(0.75 * size(labels,1));
    end
    
    for k = 1:40
    
    train_labels = labels(1:trainEndInd);
    test_labels = labels(trainEndInd+1:end);
    train_features = features(1:trainEndInd,:);
    test_features = features(trainEndInd+1:end,:);
    
    mdl = ClassificationKNN.fit(train_features, train_labels, ...
        'NumNeighbors', k);
    
    pred_labels = predict(mdl,test_features);
    
    pred_labels = double(pred_labels);
    correct = (pred_labels == test_labels);
    accuracy = sum(correct)/size(test_labels,1);
    
    disp(['accuracy for k=', num2str(k), 'is ', num2str(accuracy)]);
    end


end

