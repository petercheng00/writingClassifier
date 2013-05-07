function boxes = getWords( im )
[height,width] = size(im);

minWordLength = 0.02 * width;
gapBetweenLetters = 0.6 * minWordLength;

%im = edge(im, 'canny');
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
   if (min(y) < 1)
       keyboard
   end
   index = sub2ind(size(im),round(y),round(x));
   im(index) = 1;
end
[labeled,numCC] = bwlabel(im);

boxes = cell(numCC,1);
validBoxes = false(numCC);

for k = 1:numCC
    %x = lines(k).point1(1);
    %y = lines(k).point1(2);
    %l = labeled(y,x);
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
    
    %currBox.minRow = min(r);
    %currBox.maxRow = max(r);
    %currBox.minCol = min(c);
    %currBox.maxCol = max(c);
    boxes{k} = currBox;
    %size(r)
    %imagesc(im(min(r):max(r),min(c):max(c)));
    %pause
end
boxes = boxes(validBoxes);
%{
figure, imshow(im), hold on
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
end
%}

end

