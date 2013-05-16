function [wLabels, wFeatures] = avgWriters( writers, labels, features)
    wLabels = zeros(size(unique(writers),1),1);
    wFeatures = zeros(size(unique(writers),1),size(features,2));
    ind = 1;
    for wInd = unique(writers)'
        currInds = writers==wInd;
        wLabels(ind) = min(labels(currInds));
        
        currFeatures = features(currInds,:);
        currAvgFeatures = mean(currFeatures,1);
        wFeatures(ind,:) = currAvgFeatures;
        ind = ind + 1;
    end
end
        
