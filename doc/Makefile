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
