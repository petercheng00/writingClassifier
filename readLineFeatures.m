function [writerIDs, lineNums, labels, features] = readLineFeatures(infile)
A = importdata(infile,',',0);
writerIDs = A(:,1);
lineNums = A(:,2);
labels = A(:,3);
features = A(:,4:end);
end

