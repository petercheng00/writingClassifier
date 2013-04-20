(TeX-add-style-hook "_region_"
 (lambda ()
    (LaTeX-add-bibliographies
     "report")
    (TeX-add-symbols
     '("horrule" 1))
    (TeX-run-style-hooks
     "fancyhdr"
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

