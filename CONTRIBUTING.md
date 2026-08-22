# Contributing

## Repo layout: upstream vs fork code

- The first commit (`Import MagicalGlassRedux v5.0.1 ...`) is a byte-identical
  import of upstream. **Never edit that commit.** Upstream files are not to be
  re-licensed (see `LICENSE-UPSTREAM.md`).
- All subsequent commits are fork code. For fixes that mirror upstream
  (e.g. Kristal 0.11 ports), prefer porting upstream's own commit via
  `git cherry-pick`-style application with a `Co-authored-by:` trailer, and
  record it in `CHANGELOG.md`.

## Land rules

- New files ⇔ covered by MIT OR Apache-2.0 (the fork license). Do **not** add
  license headers to upstream files.
- Editing an upstream file is allowed only with a clear rationale, a
  `Co-authored-by` credit where applicable, and a README/CHANGELOG note.
- Translations: only add `lang/zh_hans.json` entries sourced from the
  referenced translation provenance (see README). Entries that are not covered
  by the UT key-value extraction (「真是滑稽了啊」/ 好人汉化组) or the
  gm3dr Deltarune 汉化 **must be reviewed by the maintainer** before merging.
- CI checks (Kristal update check + upstream drift check) must not be bypassed;
  updating `.github/upstream-facts.json` pins requires a reviewed upstream diff
  (`UPSTREAM.md` documents the recompute commands).
- Prefer sending fixes upstream (FireRainV/Noelle-Libraries-Pack) as PRs when
  possible.

## Dev setup

- Local Kristal 0.11-dev checkout pinned at `f62afea` (see README support
  table). A `test-mgr` mod derived from the mod template is used for smoke
  testing light battles, shops and savepoints.
