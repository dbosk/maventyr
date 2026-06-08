NOTANGLEFLAGS.py=

MODULES+=	__init__.py maventyr.tex
MODULES+=	game.py game.tex
MODULES+=	entities.py entities.tex

.PHONY: all
all: ${MODULES}

__init__.py: maventyr.nw
	${NOTANGLE.py}


.PHONY: clean
clean:
	${RM} ${MODULES}


INCLUDE_MAKEFILES=../../makefiles
include ${INCLUDE_MAKEFILES}/tex.mk
include ${INCLUDE_MAKEFILES}/noweb.mk
