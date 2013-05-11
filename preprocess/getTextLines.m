function [lineImages, lineAngles] = getTextLines( im )
lineImages = {};
lineAngles = [];
[height, width]= size(im);
[H,T,R] = hough(im, 'RhoResolution',1,'Theta',[-90:-85,85:89]);

vis = false;

P  = houghpeaks(H,500,'threshold',ceil(0.3*max(H(:))));
% Find lines and plot them
lines = houghlines(im,T,R,P,'FillGap',0.1*width,'MinLength',0.75*width);

tempIm = im;
for k = 1:length(lines)
   x1 = lines(k).point1(1);
   y1 = lines(k).point1(2);
   x2 = lines(k).point2(1);
   y2 = lines(k).point2(2);
   slope = (y2-y1)/(x2-x1);
   yinter = y1 - slope * (x1);
   x = linspace(1,width,100*width);
   y = slope * x + yinter;
   if vis
       y = [y-1,y+1,y-2,y+2,y-3,y+3];
       x = [x, x, x, x, x, x];
   end
   y = min(y,height);
   y = max(y,1);

   index = sub2ind(size(im),round(y),round(x));
   tempIm(index) = 1; 
end
if vis
    imagesc(tempIm)
    pause
end
[labeled, numCC] = bwlabel(tempIm);

CCtoTextLine = zeros(1,numCC);

% first row is sum of all image lines
% second row is num image lines for this text line
processedLines = zeros(2,length(lines));

for k = 1:length(lines)
    x1 = lines(k).point1(1);
    y1 = lines(k).point1(2);
    x2 = lines(k).point2(1);
    y2 = lines(k).point2(2);
    l = labeled(y1,x1);
    [r,c] = find(labeled == l);
    if size(r) < 10000
        continue;
    end
    if ((max(c)-min(c)+1)/(max(r)-min(r)+1)) < 8.5
        continue;
    end
    
    if CCtoTextLine(l) == 0    
        newIm = logical(zeros(size(im)));
        inds = sub2ind(size(im),r,c);
        newIm(inds) = im(inds);
        lineImages{end+1} = newIm(min(r):max(r),min(c):max(c));
        CCtoTextLine(l) = size(lineImages,2);
    end
    angle = rad2deg(atan2(y2-y1,x2-x1));
    processedLines(1,CCtoTextLine(l)) = processedLines(1,CCtoTextLine(l)) + angle;
    processedLines(2,CCtoTextLine(l)) = processedLines(2,CCtoTextLine(l)) + 1;
end

lineAngles = (processedLines(1,:) ./ processedLines(2,:))';
lineAngles = lineAngles(1:size(lineImages,2));
end

