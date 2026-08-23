# Changelog

All notable changes to this fork are documented here, following
[Conventional Commits](https://www.conventionalcommits.org/).

## Upstream history (one-line summary)

- **v5.0.1** (FireRainV, 2026-06-23) — upstream Noelle-Libraries-Pack release
  line: v5.0.0 → v5.0.1 (Choicebox updated to latest Kristal version), then
  engineVer bumped to v0.10.0. Imported at upstream commit `f182f69`,
  folder tree `b6684d0...`. Not released by this fork yet.

## [Unreleased] — fork development

### Port / i18n (in progress)

- Import MagicalGlassRedux v5.0.1 from upstream tree (see `UPSTREAM.md`).
- Kristal 0.11-dev API port (based on Stevenson89's `Noelle-Libraries-Pack-v11-dev`
  commit `77bf47c`).
- Optional kristal-i18n adapter + `lang/` data + localized assets.
- Keep the adapter's item lookup and live enemy refresh private to MGR, and
  localize MGR UI at its own draw boundaries rather than wrapping global draw
  functions.
- Remove the unsupported runtime `enabled` switch.
- CI: Kristal update check + upstream drift check.

<!-- release-please will manage fork release notes from here -->
