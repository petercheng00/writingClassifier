function getTextLines( im )
%BW = edge(im,'canny');
[H,T,R] = hough(im);
P  = houghpeaks(H,50,'threshold',ceil(0.3*max(H(:))));
% Find lines and plot them
lines = houghlines(im,T,R,P,'FillGap',500,'MinLength',3000);

validInds = false(1,length(lines));
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    xDiff = xy(1,1) - xy(2,1);
    yDiff = xy(1,2) - xy(2,2);

    angle = 180 * atan2(yDiff, xDiff)/pi;
    validInds(k) = ((angle < 15) && (angle > -15)) || ...
                    (angle < -165) || (angle > 165);
end
textLines = lines(validInds);

figure, imshow(im), hold on

for k = 1:length(textLines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
end

% highlight the longest line segment


end

