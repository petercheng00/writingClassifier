function getERFeatures( inDir )
addpath('preprocess/multiwaitbar');

inDir = strcat(inDir, '/');
inFiles = dir(strcat(inDir,'*.bmp'));
numFiles = size(inFiles,1);


  
H = vision.BlobAnalysis;
H.AreaOutputPort = true;
H.CentroidOutputPort = false;
H.BoundingBoxOutputPort = false;
H.MajorAxisLengthOutputPort = true;
H.MinorAxisLengthOutputPort = true;
H.OrientationOutputPort = true;
H.EccentricityOutputPort = true;
H.EquivalentDiameterSquaredOutputPort = true;
H.ExtentOutputPort = true;
H.PerimeterOutputPort = true;

H.MinimumBlobArea = 2;
H.MaximumBlobArea = 10000;

%plus the two from the paper
numFeatures = H.getNumOutputs() + 2;

erFeatures = zeros(numFiles,(numFeatures*2)+2);

fileCounter = 1;
multiWaitbar('CLOSEALL');
for file = inFiles'
  multiWaitbar('Processing Files', fileCounter/numFiles);
  underscoreInd = find(file.name=='_');
  currAuthorNum = str2double(file.name(1:underscoreInd-1));
  currLineNum = str2double(file.name(underscoreInd+1:end-4));
    
  lineIm = imread(strcat(inDir,file.name));
  invertedIm = ~lineIm;
  
  [area, majAxis, minAxis, orient, ecc, eqdiam, ext, perim] = step(H, invertedIm);
  formFactor = (4 * double(area) * pi)./(perim .* perim);
  roundness = (perim .* perim) ./ double(area);
  currFeatures = double([area, majAxis, minAxis, orient, ecc, eqdiam, ext, perim, formFactor, roundness]);
  
  meanFeatures = mean(currFeatures,1);
  stdFeatures = zeros(1,size(currFeatures,2));
  if (size(currFeatures,1) > 1)
      stdFeatures = std(currFeatures,1);
  end
  erFeatures(fileCounter,:) = [currAuthorNum, currLineNum, ...
                                meanFeatures, stdFeatures];
  fileCounter = fileCounter + 1;
end

csvwrite('erFeatures.csv', erFeatures);
multiWaitbar('CLOSEALL');
end

