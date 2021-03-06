function [ wordIm ] = getRotatedBox(cropIm, currBB, currAngle);
    minY = currBB(1);
    maxY = currBB(2);
    minX = currBB(3);
    maxX = currBB(4);
        
    centerY = round((minY + maxY) / 2);
    centerX = round((minX + maxX) / 2);
    
    relMinY = minY - centerY;
    relMaxY = maxY - centerY;
    relMinX = minX - centerX;
    relMaxX = maxX - centerX;
    
    boxDist = 2 * round(max(maxX - centerX, maxY - centerY));
    
    padIm = padarray(cropIm,[boxDist,boxDist],0);
    
    
    imsub = padIm(centerY:centerY+2*boxDist,centerX:centerX+2*boxDist);
    
    rotIm = imrotate(imsub, currAngle);
    
    cY2 = round(size(rotIm,1)/2);
    cX2 = round(size(rotIm,2)/2);
    
    wordIm = rotIm(cY2+relMinY:cY2+relMaxY,cX2+relMinX:cX2+relMaxX);
end

