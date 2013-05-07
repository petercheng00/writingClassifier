function [ boxes ] = getWordsFromLines( im )
    colSums = sum(im,1);
    %get all runs where zero
    colSums_rle = rle(colSums==0);
    runs = colSums_rle{2}(colSums_rle{1}==1);

    disp('not implemented!');
    keyboard
end

