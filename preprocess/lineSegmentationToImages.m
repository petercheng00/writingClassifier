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

lineAngles = zeros(0,3);

fileCounter = 1;
multiWaitbar('CLOSEALL');
for file = inFiles'
  if fileCounter > 282
      break;
  end
  multiWaitbar('Processing Files', fileCounter/282);
  multiWaitbar('Processing Lines', 0);
  origIm = imread(strcat(inDir,file.name));
  [cropIm, cropDim] = preprocess(origIm);
  [lineImages, fileLineAngles] = getTextLines(cropIm);
  fileId = str2double(file.name(1:end-6));
  for lineInd = 1:size(lineImages,2)
      multiWaitbar('Processing Lines', lineInd/size(lineImages,2));
      lineIm = lineImages{lineInd};
      fileName = strcat(outputDir,'/',num2str(fileId),'_',num2str(lineInd),'.bmp');
      imwrite(lineIm, fileName);
      lineAngles(end+1,:) = [fileId, lineInd, fileLineAngles(lineInd)];
  end
  fileCounter = fileCounter + 1;
end
csvwrite(strcat(outputDir,'/','lineAngles.csv'),lineAngles);
multiWaitbar('CLOSEALL');
end

