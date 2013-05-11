function [authorId, wordId] = getAuthorNums (str)
    authorId = zeros(size(str));
    wordId = zeros(size(str));
    charStr = char(str);
    boolStr = (charStr == '_');
    inds = arrayfun( @(i) find(boolStr(i,:) == 1), 1:size(boolStr,1));
    for i = 1:size(str,1)
        authorId(i) = str2double(charStr(i,12:inds(i)-1));
        wordId(i) = str2double(charStr(i,inds(i)+1:end-4));
    end
end