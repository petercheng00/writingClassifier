function getTextLines( im )
width = size(im,2);
%im = edge(im, 'canny');
[H,T,R] = hough(im, 'RhoResolution',1,'Theta',-90:1:89.5);
P  = houghpeaks(H,500,'threshold',ceil(0.3*max(H(:))));
% Find lines and plot them
lines = houghlines(im,T,R,P,'FillGap',500,'MinLength',0.75*width);
validInds = false(1,length(lines));
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    xDiff = xy(1,1) - xy(2,1);
    yDiff = xy(1,2) - xy(2,2);

    angle = 180 * atan2(yDiff, xDiff)/pi;
    validInds(k) = ((angle < 10) && (angle > -10)) || ...
                    (angle < -170) || (angle > 170);
end
textLines = lines(validInds);
imcopy = im(:,:);
for k = 1:length(textLines)
   x1 = textLines(k).point1(1);
   y1 = textLines(k).point1(2);
   x2 = textLines(k).point2(1);
   y2 = textLines(k).point2(2);
   slope = (y2-y1)/(x2-x1);
   yinter = y1 - slope * (x1);
   x = linspace(1,width,100*width);
   y = slope * x + yinter;
   index = sub2ind(size(imcopy),round(y),round(x));
   imcopy(index) = 1;
end
[labeled] = bwlabel(imcopy);
for k = 1:length(textLines)
    x = textLines(k).point1(1);
    y = textLines(k).point1(2);
    l = labeled(y,x);
    currLine = false(size(im));
    currLine(labeled==l) = 1;
    viewimage(currLine);
    keyboard
end

end

