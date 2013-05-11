function wordSegmentationFromLinesToImages(inDir, outputDir)
addpath('multiwaitbar');
if nargin < 2
    outputDir = 'wordImagesFromLines';
end

if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

inDir = strcat(inDir, '/');
inFiles = dir(strcat(inDir,'*_4.bmp'));
numFiles = size(inFiles,1);

fileCounter = 1;
multiWaitbar('CLOSEALL');
for file = inFiles'
  multiWaitbar('Processing Line Images', fileCounter/numFiles);
  multiWaitbar('Processing Words', 0);
  
  underscoreInd = find(file.name=='_');
  currAuthorNum = file.name(1:underscoreInd-1);
  currLineNum = file.name(underscoreInd+1:end-4);

  cropIm = imread(strcat(inDir,file.name));
  boxes = getWords(cropIm);
  
  wordCounter = 1;
  for boxInd = 1:size(boxes,1)
      multiWaitbar('Processing Words', boxInd/size(boxes,1));
      [currBB,currAngle] = getAABB(boxes(boxInd));
      if abs(currAngle) > 20
          continue;
      end
      wordIm = getRotatedBox(cropIm, currBB, currAngle);
      
      %write wordIm here
      fileName = strcat(outputDir,'/',currAuthorNum,'_',currLineNum,'_',num2str(wordCounter),'.bmp');
      imwrite(wordIm, fileName);
      wordCounter = wordCounter + 1;
  end
  fileCounter = fileCounter + 1;
end
multiWaitbar('CLOSEALL');
end

