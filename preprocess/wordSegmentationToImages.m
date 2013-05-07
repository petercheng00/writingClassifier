function wordSegmentationToImages(inDir, outputDir)
addpath('multiwaitbar');
if nargin < 2
    outputDir = 'wordImages';
end

if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

inDir = strcat(inDir, '/');
inFiles = dir(strcat(inDir,'*_4.jpg'));
numFiles = size(inFiles,1);

fileCounter = 1;
multiWaitbar('CLOSEALL');
for file = inFiles'
  multiWaitbar('Processing Files', fileCounter/numFiles);
  multiWaitbar('Processing Words', 0);
  origIm = imread(strcat(inDir,file.name));
  [cropIm, cropDim] = preprocess(origIm);
  boxes = getWords(cropIm);

  fileId = str2double(file.name(1:end-6));
  wordCounter = 1;
  for boxInd = 1:size(boxes,1)
      multiWaitbar('Processing Words', boxInd/size(boxes,1));
      [currBB,currAngle] = getAABB(boxes(boxInd));
      if abs(currAngle) > 20
          continue;
      end
      wordIm = getRotatedBox(cropIm, currBB, currAngle);
      
      %write wordIm here
      fileName = strcat(outputDir,'/',num2str(fileId),'_',num2str(wordCounter),'.bmp');
      imwrite(wordIm, fileName);
      wordCounter = wordCounter + 1;
  end
  fileCounter = fileCounter + 1;
end
multiWaitbar('CLOSEALL');
end

