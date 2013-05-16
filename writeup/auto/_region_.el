(TeX-add-style-hook "_region_"
 (lambda ()
    (LaTeX-add-labels
     "sec:results"
     "fig:resultsTable")
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

