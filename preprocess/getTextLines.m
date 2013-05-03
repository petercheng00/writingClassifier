function boxes = getTextLines( im )
boxes = {};
[height, width]= size(im);
%im = edge(im, 'canny');
[H,T,R] = hough(im, 'RhoResolution',1,'Theta',[-90:-80,80:90]);
P  = houghpeaks(H,500,'threshold',ceil(0.3*max(H(:))));
% Find lines and plot them
lines = houghlines(im,T,R,P,'FillGap',500,'MinLength',0.75*width);

for k = 1:length(lines)
   x1 = lines(k).point1(1);
   y1 = lines(k).point1(2);
   x2 = lines(k).point2(1);
   y2 = lines(k).point2(2);
   slope = (y2-y1)/(x2-x1);
   yinter = y1 - slope * (x1);
   x = linspace(1,width,100*width);
   y = slope * x + yinter;
   index = sub2ind(size(im),round(y),round(x));
   im(index) = 1;
end
[labeled] = bwlabel(im);
for k = 1:length(lines)
    x = lines(k).point1(1);
    y = lines(k).point1(2);
    l = labeled(y,x);
    [r,c] = find(labeled == l);
    currBox.minRow = min(r);
    currBox.maxRow = max(r);
    currBox.minCol = min(c);
    currBox.maxCol = max(c);
    boxes{end+1} = currBox;
end

end

