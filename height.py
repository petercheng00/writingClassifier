import matplotlib.pyplot as plt
import matplotlib.cm as cm
import Image
import numpy

img = Image.open('test_cleaned.png')

# ones and zeros
im = numpy.array(img) / 255
sum_rows = numpy.sum(im, axis=1)
num_black = numpy.sum(sum_rows)

ub = 0.15 * num_black
lb = 0.9 * num_black

so_far, ub_row, lb_row = 0, 0, 0
for i in xrange(len(im)):
    so_far += numpy.sum(im[i])
    if ub_row == 0 and so_far > ub:
        ub_row = i
    if lb_row == 0 and so_far > lb:
        lb_row = i

plt.imshow(im, cmap=cm.Greys_r)
plt.hlines(numpy.array([ub_row, lb_row]), 0, 200, colors='g')
plt.show()

# top line - upper baseline
f1 = ub_row
# upper baseline - lower baseline
f2 = lb_row - ub_row
# lower baseline - bottom line
f3 = len(im) - lb_row
f4 = float(f1) / f2
f5 = float(f1) / f3
f6 = float(f2) / f3

import pdb
pdb.set_trace()
