function wordSegmentation(inDir, outputFile)
addpath('multiwaitbar');
if nargin < 2
    outputFile = 'wordBoxes.csv';
end
inDir = strcat(inDir, '/');
inFiles = dir(strcat(inDir,'*_4.jpg'));
numFiles = size(inFiles,1);

fileIDs = zeros(1,0);
boundingBoxes = zeros(4,0);
rotAngles = zeros(1,0);

fileCounter = 1;
for file = inFiles'
  multiWaitbar('Processing Files', fileCounter/numFiles);
  origIm = imread(strcat(inDir,file.name));
  [cropIm, cropDim] = preprocess(origIm);
  boxes = getWords(cropIm);

  currFileIds = repmat(str2double(file.name(1:end-6)),[1,size(boxes,1)]);
  currBBs = zeros(4,size(boxes,1));
  currAngles = zeros(1,size(boxes,1));
  for boxInd = 1:size(boxes,1)
      [currBBs(:,boxInd),currAngles(boxInd)] = getAABB(boxes(boxInd));
  end
  fileIDs = [fileIDs, currFileIds];
  boundingBoxes = [boundingBoxes, currBBs];
  rotAngles = [rotAngles, currAngles];  
  fileCounter = fileCounter + 1;
end

totalMat = [fileIDs;boundingBoxes;rotAngles]';

csvwrite(outputFile, totalMat);
multiWaitbar('CLOSEALL');
end

