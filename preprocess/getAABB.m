function [ aabb, angle ] = getAABB( inBox )
    inBox = inBox{1};
    c = [inBox.p1,inBox.p2,inBox.p3,inBox.p4];
    % points always in CW order.
    % Assume boxes should be longer than taller
    d1 = norm(inBox.p2-inBox.p1);
    d2 = norm(inBox.p3-inBox.p2);

    
    if (d1 > d2)
        leftPoint = inBox.p2;
        rightPoint = inBox.p1;
    else
        leftPoint = inBox.p2;
        rightPoint = inBox.p3;
    end

    if (leftPoint(1) > rightPoint(1))
        temp = leftPoint;
        leftPoint = rightPoint;
        rightPoint = temp;
    end
    
    yDiff = rightPoint(2) - leftPoint(2);
    xDiff = rightPoint(1) - leftPoint(1);
    angle = atan2(yDiff,xDiff);


    rotMat = [cos(-angle), -sin(-angle); sin(-angle), cos(-angle)];
    rotPt = repmat(mean(c,2),[1,4]);

    relC = c - rotPt;
    rotRelC = rotMat * relC;
    newC = rotRelC + rotPt;
    
    %{
    figure
    plot(c(1,[1:end 1]),c(2,[1:end 1]),'r')
    hold on
    plot(newC(1,[1:end 1]),newC(2,[1:end 1]),'b')
    %}
    
    minX = floor(min(newC(1,:)));
    maxX = ceil(max(newC(1,:)));
    minY = floor(min(newC(2,:)));
    maxY = ceil(max(newC(2,:)));
    angle = radtodeg(angle);
    aabb = [minY, maxY, minX, maxX];
end

