% for each file in lineImages:
im = imread('101_1.bmp');

im = edge(im);
[n, r] = boxcount(im);
x = log(n);
y = log(r .* n) - log(n)
slm = slmengine(x,y,'plot','on','degree',1,'knots',4)
% get slopes p0, p1, p2

f1 = 1 - p1
f2 = 1 - p2
if f2 > f1
    f2 = f1

f3 = f1 - f2


   



