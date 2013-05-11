function [author_labels] = getAuthorLabels(authors, word_labels)
    author_labels = zeros(size(unique(authors),1),1);
    [authors_uniq, sortVec] = sort(authors);
    UV(sortVec) = ([1;diff(authors_uniq)] ~= 0);
    authors_unique = authors(UV);
    for i=1:size(author_labels,1);
        author_num = authors_unique(i);
        startInd = find(authors==author_num, 1, 'first');
        endInd = find(authors==author_num, 1, 'last');
        currentLabels = word_labels(startInd:endInd);
        author_labels(i) = sum(currentLabels) > length(currentLabels) / 2;           
    end
end
