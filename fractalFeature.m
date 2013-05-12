function fractalFeature( inDir )
addpath('boxcount/boxcount');
addpath('preprocess/multiwaitbar');

inDir = strcat(inDir, '/');
inFiles = dir(strcat(inDir,'*.bmp'));
numFiles = size(inFiles,1);

ffFeatures = zeros(numFiles, 5);

fileCounter = 1;
multiWaitbar('CLOSEALL');
for file = inFiles'
  multiWaitbar('Processing Files', fileCounter/numFiles);
  underscoreInd = find(file.name=='_');
  currAuthorNum = str2double(file.name(1:underscoreInd-1));
  currLineNum = str2double(file.name(underscoreInd+1:end-4));
    
  lineIm = imread(strcat(inDir,file.name));
  edgeIm = edge(lineIm);
  [n, r] = boxcount(edgeIm);
  x = log(n);
  y = log(r .* n) - log(n);
  slm = slmengine(x,y,'degree',1,'knots',4);
  inds1 = x >= slm.knots(1) & x <= slm.knots(2);
  inds2 = x >= slm.knots(2) & x <= slm.knots(3);
  inds3 = x >= slm.knots(3) & x <= slm.knots(4);
  
  line1 = polyfit(x(inds1),y(inds1),1);
  line2 = polyfit(x(inds2),y(inds2),1);
  line3 = polyfit(x(inds3),y(inds3),1);
  ffFeatures(fileCounter,:) = [currAuthorNum, currLineNum, ...
                                line1(1),line2(1),line3(1)];
  fileCounter = fileCounter + 1;
end
csvwrite('fractalFeatures.csv', ffFeatures);
multiWaitbar('CLOSEALL');
end

   



