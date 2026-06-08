LATEXFLAGS += -shell-escape

.PHONY: all weave clean distclean
all: maventyr.pdf

weave: maventyr.tex

../src/maventyr/maventyr.tex: ../src/maventyr/maventyr.nw

%.tex: %.nw
	${MAKE} -C $(dirname $@) $(basename $@)

maventyr.pdf: maventyr.tex ../src/maventyr/maventyr.tex
maventyr.pdf: bibliography.bib preamble.tex

clean:
	${RM} maventyr.tex maventyr.pdf

distclean:

INCLUDE_MAKEFILES = ../makefiles
include ${INCLUDE_MAKEFILES}/noweb.mk

# This document uses biblatex with the biber backend.  The shared tex.mk offers
# two ways to build a .bbl --- from .aux (bibtexu) and from .bcf (biber) --- but
# make's pattern-rule ordering otherwise selects the bibtexu rule, which cannot
# read biblatex's .bcf-based citations.  Pin the biber rule for this document so
# that \autocite references resolve.  (Placed after the include so TEX_OUTDIR
# and BIBLIOGRAPHY.bcf are defined.)
${TEX_OUTDIR}/maventyr.bbl: ${TEX_OUTDIR}/maventyr.bcf
	${BIBLIOGRAPHY.bcf}
