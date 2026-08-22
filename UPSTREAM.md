# Upstream facts

This repository is a **maintenance fork** of MagicalGlassRedux v5.0.1, imported from
the Noelle-Libraries-Pack by FireRainV. Upstream is not maintained for Kristal
0.11-dev, so this fork ports the library and adds optional kristal-i18n support.

## Pinned upstream facts

See `.github/upstream-facts.json` for machine-readable pins. Human summary:

| Fact | Value |
|---|---|
| Source repo | [FireRainV/Noelle-Libraries-Pack](https://github.com/FireRainV/Noelle-Libraries-Pack) |
| Branch | `main` |
| Path | `libraries/MagicalGlassRedux` |
| Ref (last commit touching the path) | `f182f69` ("Updated engineVer to v0.10.0") |
| Folder tree SHA | `b6684d07970c8dc83162a63b6395591e46fcc525` |
| Library version | `v5.0.1` |
| Library id | `magical-glass` |
| engineVer | `v0.10.0` |

## Extraction method

Upstream only distributes the library as a folder inside the pack repository.
This fork was created by sparse-cloning the pack at the pinned ref and importing
`libraries/MagicalGlassRedux/*` into the repository **root** (so the repo itself
is a valid `libraries/<id>/` for any Kristal mod). The import commit
`Import MagicalGlassRedux v5.0.1 ...` is byte-identical to upstream (verified:
`lib.lua` sha1 `c2be4ba9ea8a6a38be870d1797c14db10238aba6` matches upstream).

The upstream engineVer was `v0.10.0` at import time; this fork bumps it to
`v0.11.0-dev` in a later commit, and does **not** change the upstream `version`
until a packed fork release (see `CHANGELOG.md`).

## Attribution chain

- **Nyakorita** — Original Author
- **Sam Deluxe** — Previous Author and Lead Programmer
- **FireRainV** — Current Developer (upstream maintainer, Noelle-Libraries-Pack)
- **SadDiamondMan** — Frisk
- **Azrael** — Susie Light World Battle Sprites
- **Trashcat** — Blue Soul
- **Annie** — Green Soul
- **vitellary** — Yellow Soul
- **TheSkerch** — Purple Soul
- **Stevenson89** — Kristal 0.11-dev API fixes (`Noelle-Libraries-Pack-v11-dev`,
  commit `77bf47c`), upstream of this fork's port — see `CHANGELOG.md`

## Recomputing the pins

```sh
# Current pack head
gh api "repos/FireRainV/Noelle-Libraries-Pack/commits/main" --jq '.sha'
# Last commit touching the library path
gh api "repos/FireRainV/Noelle-Libraries-Pack/commits?path=libraries/MagicalGlassRedux&sha=main&per_page=1" --jq '.[0].sha'
# Folder tree SHA
gh api "repos/FireRainV/Noelle-Libraries-Pack/git/trees/main?recursive=1" \
  --jq '.tree[] | select(.path=="libraries/MagicalGlassRedux") | .sha'
# Upstream lib version
gh api "repos/FireRainV/Noelle-Libraries-Pack/contents/libraries/MagicalGlassRedux/lib.json?ref=main" \
  --jq '.content' | base64 -d | grep '"version"'
```

After reviewing upstream changes, update the pins in `.github/upstream-facts.json`
and re-run the drift check (`bash .github/scripts/drift-check.sh`).
