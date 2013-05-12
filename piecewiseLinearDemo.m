function piecewiseLinearDemo()
addpath('SLMtools/SLMtools');
x = (sort(rand(1,100)) - 0.5)*pi;
y = sin(x).^5 + randn(size(x))/10;

%degree 1 means linear
%4 knots = 3 lines
slm = slmengine(x,y,'plot','on','degree',1,'knots',4)
end

