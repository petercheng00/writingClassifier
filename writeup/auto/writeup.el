(TeX-add-style-hook "writeup"
 (lambda ()
    (LaTeX-add-bibliographies
     "report")
    (LaTeX-add-labels
     "sec:background"
     "fig:docImage"
     "sec:pands"
     "fig:houghLineDetect"
     "fig:linefail"
     "fig:wordfail"
     "sec:feature"
     "fig:featureList"
     "fig:wordheight"
     "fig:wordwidth"
     "fig:wordslant"
     "fig:contourimage"
     "fig:fractaldimension"
     "sec:results"
     "fig:resultsTable"
     "fig:oob"
     "fig:votes")
    (TeX-add-symbols
     '("horrule" 1))
    (TeX-run-style-hooks
     "fancyhdr"
     "mdwlist"
     "multicol"
     "float"
     "hyperref"
     "amssymb"
     "subfig"
     "graphicx"
     "amsthm"
     "amsfonts"
     "amsmath"
     "babel"
     "english"
     "fontenc"
     "T1"
     "latex2e"
     "scrartcl10"
     "scrartcl")))

