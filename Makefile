SUBDIR_GOALS=	all clean distclean

SUBDIR+=		src/maventyr
SUBDIR+=		tests
SUBDIR+=		doc

version=$(shell sed -n 's/^ *version *= *\"\([^\"]\+\)\"/\1/p' pyproject.toml)


.PHONY: all
all: compile doc/maventyr.pdf test

.PHONY: test
test: compile
	${MAKE} -C tests test

.PHONY: install
install: compile
	pipx install .

.PHONY: compile
compile:
	${MAKE} -C src/maventyr all
	poetry build

.PHONY: publish publish-github publish-pypi
publish: publish-github

publish-github: doc/maventyr.pdf
	git push
	gh release create -t v${version} v${version} doc/maventyr.pdf

doc/maventyr.pdf:
	${MAKE} -C $(dir $@) $(notdir $@)

publish-pypi: compile
	poetry publish


.PHONY: clean
clean:

.PHONY: distclean
distclean:
	${RM} -R build dist maventyr.egg-info src/maventyr.egg-info


INCLUDE_MAKEFILES=makefiles
include ${INCLUDE_MAKEFILES}/subdir.mk
