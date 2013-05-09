function lineSegmentationToImages(inDir, outputDir)
addpath('multiwaitbar');
if nargin < 2
    outputDir = 'lineImages';
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
  multiWaitbar('Processing Lines', 0);
  origIm = imread(strcat(inDir,file.name));
  [cropIm, cropDim] = preprocess(origIm);
  boxes = getTextLines(cropIm);
  fileId = str2double(file.name(1:end-6));
  lineCounter = 1;
  for boxInd = 1:size(boxes,2)
      multiWaitbar('Processing Lines', boxInd/size(boxes,1));
      lineIm = cropIm(boxes{boxInd}.minRow:boxes{boxInd}.maxRow,boxes{boxInd}.minCol:boxes{boxInd}.maxCol);
      fileName = strcat(outputDir,'/',num2str(fileId),'_',num2str(lineCounter),'.bmp');
      imwrite(lineIm, fileName);
      lineCounter = lineCounter + 1;
  end
  fileCounter = fileCounter + 1;
end
multiWaitbar('CLOSEALL');
end

