LATEXFLAGS += -shell-escape

.PHONY: all weave clean distclean
all: maventyr.pdf

weave: maventyr.tex

# The PDF depends on every chapter the wrapper \inputs.  The chapter list is
# derived from the .nw sources, so a chapter added to src/maventyr/ joins the
# dependency list without this file needing an edit; the wrapper's \input
# list still has to be extended by hand.
CHAPTER_DIR = ../src/maventyr
CHAPTERS = $(patsubst %.nw,%.tex,$(wildcard ${CHAPTER_DIR}/*.nw))

# Weave a chapter by delegating to its own Makefile, which owns the flags
# chapters are woven with.  The directory-specific pattern has a shorter stem
# than noweb.mk's generic %.tex rule, so make prefers it for chapter paths.
${CHAPTER_DIR}/%.tex: ${CHAPTER_DIR}/%.nw
	${MAKE} -C ${CHAPTER_DIR} $*.tex

maventyr.pdf: maventyr.tex ${CHAPTERS}
maventyr.pdf: bibliography.bib preamble.tex abstract.tex ../LICENSE

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
