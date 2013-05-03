function [ outIm, dims ] = preprocess( im )
imbw = im2bw(im, graythresh(im));
imbw = 1 - imbw;

[r,c] = find(imbw > 0);
rowinds = find(abs(r-mean(r)) > 2 * std(r));
colinds = find(abs(c-mean(c)) > 2 * std(c));
outlierinds = unique([rowinds;colinds]);
outlierinds = sub2ind(size(imbw), r(outlierinds), c(outlierinds));
imbw(outlierinds) = 0;

colSums = sum(imbw,1);
rowSums = sum(imbw,2);


filledCols = find(colSums > 0);
filledRows = find(rowSums > 0);

minCol = min(filledCols);
maxCol = max(filledCols);
minRow = min(filledRows);
maxRow = max(filledRows);

dims = [minRow, maxRow, minCol, maxCol];

outIm = imbw(minRow:maxRow, minCol:maxCol);

end

