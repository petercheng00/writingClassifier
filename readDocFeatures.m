function [writerIDs, labels, features] = readDocFeatures(infile)
A = importdata(infile,',',0);
writerIDs = A(:,1);
labels = A(:,2);
features = A(:,3:end);
end

