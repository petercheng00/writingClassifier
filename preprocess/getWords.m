function boxes = getWords( im )
[height,width] = size(im);

vis = true;

minWordLength = 0.02 * width;
gapBetweenLetters = 0.7 * minWordLength;

[H,T,R] = hough(im, 'RhoResolution',1,'Theta',[-90:-85,85:89]);
P = houghpeaks(H,500,'threshold',ceil(0.3*max(H(:))));
% Find lines and plot them
lines = houghlines(im,T,R,P,'FillGap',gapBetweenLetters,'MinLength',minWordLength);

for k = 1:length(lines)
   x1 = lines(k).point1(1);
   y1 = lines(k).point1(2);
   x2 = lines(k).point2(1);
   y2 = lines(k).point2(2);
   slope = (y2-y1)/(x2-x1);
   yinter = y1 - slope * (x1);
   minX = min(x1,x2);
   maxX = max(x1,x2);
   x = linspace(minX,maxX,100*(maxX-minX));
   y = slope * x + yinter;
   if vis
       y = [y-1,y+1,y-2,y+2,y-3,y+3];
       x = [x, x, x, x, x, x];
   end
   y = min(y,height);
   y = max(y,1);
   index = sub2ind(size(im),round(y),round(x));
   im(index) = 1;
end
if vis
    imagesc(im)
    pause
end

[labeled,numCC] = bwlabel(im);

boxes = cell(numCC,1);
validBoxes = false(numCC);

for k = 1:numCC
    [r,c] = find(labeled == k);
    if size(r) < 500
        continue;
    end
    validBoxes(k) = true;
    ccPoints = [c';r'];
    minBB = minBoundingBox(ccPoints);
    currBox.p1 = minBB(:,1);
    currBox.p2 = minBB(:,2);
    currBox.p3 = minBB(:,3);
    currBox.p4 = minBB(:,4);
    
    boxes{k} = currBox;
end
boxes = boxes(validBoxes);

end

