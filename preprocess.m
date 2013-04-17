function [ outIm ] = preprocess( im )
imbw = im2bw(im, graythresh(im));

[height, width] = size(imbw);


colSums = sum(imbw,1);
rowSums = sum(imbw,2);

filledCols = find(colSums < height-3);
filledRows = find(rowSums < width-3);

minCol = min(filledCols);
maxCol = max(filledCols);
minRow = min(filledRows);
maxRow = max(filledRows);

outIm = imbw(minRow:maxRow, minCol:maxCol);
end

