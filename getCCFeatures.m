function getCCFeatures( inDir )
inDir = strcat(inDir, '/');
inFiles = dir(strcat(inDir,'*.bmp'));
numFiles = size(inFiles,1);

ccFeatures = zeros(numFiles,8);

fileCounter = 1;
for file = inFiles'
  
  underscoreInd = find(file.name=='_');
  currAuthorNum = str2double(file.name(1:underscoreInd-1));
  currLineNum = str2double(file.name(underscoreInd+1:end-4));

    
  lineIm = imread(strcat(inDir,file.name));
  [ccLabels, numCC] = bwlabel(lineIm);
  
  minXs = zeros(1,numCC);
  maxXs = zeros(1,numCC);
  minYs = zeros(1,numCC);
  maxYs = zeros(1,numCC);
  
  for ccI = 1:numCC
      [r,c] = find(ccLabels == ccI);
      minXs(ccI) = min(c);
      maxXs(ccI) = max(c);
      minYs(ccI) = min(r);
      maxYs(ccI) = max(r);
  end
  
  %size of ccs
  widths = maxXs - minXs;
  heights = maxYs - minYs;
  
  avgWidth = mean(widths);
  avgHeight = mean(heights);
  stdWidth = std(widths);
  stdHeight = std(widths);
  
  %dist between ccs
  cropMaxXs = maxXs(1:end-1);
  cropMinXs = minXs(2:end);
  distXs = cropMinXs - cropMaxXs;
  
  avgDist = mean(distXs);
  stdDist = std(distXs);
  
  ccFeatures(fileCounter,:) = [currAuthorNum, currLineNum, ...
                                avgWidth, avgHeight, ...
                                stdWidth, stdHeight, ...
                                avgDist, stdDist];
  fileCounter = fileCounter + 1;
end

csvwrite('ccFeatures.csv', ccFeatures);

end

