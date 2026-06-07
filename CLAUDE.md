# maventyr — guidance for Claude Code

`maventyr` ("Majas matematiska äventyr") is a text adventure, in the spirit of
the classic `adventure` game, that gamifies learning across the Swedish school
curriculum. It is in Swedish (switching to another language only when that
language is the active topic). It runs in the terminal (`play`) and in a
browser (`serve`).

## This is a literate program — read this first

The **source of truth is the `.nw` (noweb) files** under `src/maventyr/`. The
`.py`, `.tex`, and `.pdf` files are **generated build artifacts** and are
gitignored. Never edit a generated file; edit the `.nw` and regenerate.

**Before editing ANY `.nw` file, activate the `literate-programming` skill.**
Literate quality (narrative, chunk decomposition, explaining *why*) is part of
correctness here, not optional polish. The `latex-writing`, `variation-theory`,
and `didactic-notes` skills also apply to the prose.

Commit **only** `.nw` files and genuine sources (`preamble.tex`,
`abstract.tex`, `bibliography.bib`, Makefiles, `pyproject.toml`). Never commit
generated `.py`/`.tex`/`.pdf` or `ltxobj/`.

## The one architectural rule

**The game core never imports a UI and never calls `print`/`input`.** The core
exposes state plus a `command → events` interface; the terminal and web
frontends are thin translators over the *same* engine. Preserve this in every
change — it is what makes the two interfaces share one core. See the Overview
chapter in `src/maventyr/maventyr.nw`.

## Layout

```
src/maventyr/   # literate source (.nw) → tangles to .py, weaves to .tex
tests/          # auto-discovers <<test [[module.py]]>> chunks → unit/test_*.py
doc/            # document wrapper (.nw), preamble.tex, bibliography.bib → PDF
makefiles/      # SUBMODULE: shared noweb/tex/subdir build rules (dbosk/makefiles)
didactic/       # SUBMODULE: pedagogical LaTeX package (dbosk/didactic)
```

The package grows one `.nw` chapter per concern (entities, locations, maps,
game, render, questions, persistence, curriculum, didactics, content,
ui_terminal, ui_web, cli), each added by its own issue and `\input` into
`doc/maventyr.nw` in reading order. Keep that chapter list and this file in
sync when structure changes.

## Build & test

After cloning: `git submodule update --init --recursive`, then `poetry install`.

| Command | What it does |
|---------|--------------|
| `make compile` | Tangle `.nw` → `.py`, weave → `.tex`, `poetry build` the wheel |
| `make -C tests test` | Extract test chunks and run `poetry run pytest` |
| `make -C doc` | Build `doc/maventyr.pdf` (needs the `didactic` submodule) |
| `make` | compile → PDF → test |

Toolchain: noweb (`notangle`/`noweave`/`noroots`/`cpif`), GNU make, Poetry,
black, xelatex + latexmk + biber, pygments. Tests use pytest; mathematical
grading uses `sympy`.

## Roadmap lives in GitHub issues

The implementation plan is the issue tree on `dbosk/maventyr`: **#5 Main
design** is the tracking epic; area epics (#1–#4 plus the engineering epics)
hold dependency-ordered child issues, organised by milestones **M0–M7**.
M0 (this scaffold) is the buildable skeleton; M1 is the playable
single-subject slice.

**To find the next task:** take the lowest-numbered milestone that still has
open issues (`gh issue list --milestone M0 --state open`; if empty, try M1,
…). Within it, read each open issue's `Depends on:` line and pick one whose
dependencies are all closed — the gating issue is flagged as such in its body
(e.g. #13 "gates everything"). Completed issues are closed via `Closes #N`
in the commit that delivers them, so "open" means "remaining".

## Conventions

- **Swedish-first** content; user-facing strings belong in named constants /
  the content database (not literals), so they are translatable. Concretely,
  such strings are *constant directories* — `{lang: str}` dicts (`"sv"` +
  `"en"`) resolved via `localize(table, language)` (in `maventyr.nw`), which
  falls back to `DEFAULT_LANGUAGE` (`"sv"`) for missing translations. The
  active language lives on the `Engine`; the core never reads config — the
  CLI injects the language. See the "Speaking the player's language" and
  engine chapters for the rationale.
- **Pluggable graders per subject** (sympy for maths; keyword/rubric/MCQ/
  reading-comprehension for others) — do not hardcode maths-only grading.
- **Tasks are authored from the subject-didactics research literature**
  (epic E-did); cite sources in `doc/bibliography.bib`.
- Tests live **next to the code they verify** in the same `.nw` file, after
  the implementation — never collected in a trailing "Tests" section.
