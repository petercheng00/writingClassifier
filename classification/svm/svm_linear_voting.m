function svm_linear_voting( labels, features, voteMapping, trainEndInd )
    addpath('../../liblinear-1.93/matlab');
    
    if nargin < 4
        trainEndInd = round(0.75 * size(labels,1));
    end

    for c = [1]
    
    train_labels = labels(1:trainEndInd);
    test_labels = labels(trainEndInd+1:end);
    train_features = features(1:trainEndInd,:);
    test_features = features(trainEndInd+1:end,:);
    
    test_mapping = voteMapping(trainEndInd+1:end,:);
    test_vote_labels = getAuthorLabels(test_mapping, test_labels);

    
    disp(['training with c = ', num2str(c)]);
    model = train(train_labels, sparse(train_features), ['-s 2 ', '-c ', num2str(c)]);
    disp('predicting');
    [pred_labels ] = predict(test_labels, sparse(test_features), model);  
    
    [pred_vote_labels,dists] = getAuthorLabels(test_mapping, pred_labels);
    figure
    keyboard
    bar(dists);
        
    correct = (pred_vote_labels == test_vote_labels);
    
    accuracy = sum(correct) / size(test_vote_labels,1);
    
    disp(['Accuracy is ', num2str(accuracy)]);
    end
end



