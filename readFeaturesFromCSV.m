function [filenames, features, labels] = readFeaturesFromCSV(infile)
A = importdata(infile,',',0);
labels = A.data(:,1);
features = A.data(:,2:end);
filenames = A.textdata;
end

