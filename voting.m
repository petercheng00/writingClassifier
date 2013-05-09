function [author_labels] = getAuthorLabels(authors, word_labels)
    author_labels = zeros(size(unique(authors)),1);
    for i=min(authors):max(authors)
        startInd = find(authors==i, 1, 'first');
        endInd = find(authors==i, 1, 'last');
        if size(startInd,2)==0
            continue;
        end
        
        currentLabels = word_labels(startInd:endInd);
        author_labels(i) = sum(currentLabels) > length(currentLabels) / 2;
           
    end
end
