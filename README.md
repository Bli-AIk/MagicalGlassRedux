# MagicalGlassRedux

An UNDERTALE-style light-world battle system for
[Kristal](https://github.com/KristalTeam/Kristal) — spells and TP, blue/green/
purple/yellow souls, UT-style shops/savepoints/menus/items, and a full light
battle framework ("LightBattle").

This repository is a **maintenance fork**: upstream
([FireRainV/Noelle-Libraries-Pack](https://github.com/FireRainV/Noelle-Libraries-Pack))
targets Kristal 0.10 and is not actively maintained, so this repo ports
MagicalGlassRedux to Kristal 0.11-dev and adds optional
[kristal-i18n](https://github.com/Bli-AIk/kristal-i18n) support. See
[`UPSTREAM.md`](UPSTREAM.md) and [`CHANGELOG.md`](CHANGELOG.md).

## Kristal version support

| Kristal v0.11.0-dev (`f62afea`, 2026-08-22) | MagicalGlassRedux v0.0.0, engineVer `v0.11.0-dev` |
|---|---|
| Kristal v0.10.0 | v5.0.1 (upstream; `f182f69`) |

### Upstream alignment

| fork 版本 | 对齐的上游 | 上游 ref | 说明 |
|---|---|---|---|
| 0.0.0 | MagicalGlassRedux v5.0.1 | Noelle-Libraries-Pack `f182f69` (tree `f7c33b9`) | 0.11-dev 移植 + kristal-i18n 适配 |

## Install

Drop this repository into `libraries/MagicalGlassRedux/` inside your mod
(the upstream folder name is `MagicalGlassRedux`), as a git submodule or a
plain copy. The engine auto-discovers it via `lib.json`
(library id `magical-glass`).

```sh
git submodule add https://github.com/Bli-AIk/MagicalGlassRedux.git \
  libraries/MagicalGlassRedux
```

Complementary libraries (optional):

- [UndertaleMonstersRecreation](https://github.com/Bli-AIk/UndertaleMonstersRecreation)
  — UT monsters (Froggit, Moldsmal…) for light battles.
- [kristal-i18n](https://github.com/Bli-AIk/kristal-i18n) — localization
  framework (see below).

## Runtime enable switch

The library is always discovered once it is in `libraries/`, but a main mod
can disable it cleanly from its `mod.json` (`config.magical-glass.enabled` —
the key is read as a normal lib config, so `lib.json`'s default of `true`
can be overridden without touching the library):

```json
"config": {
    "magical-glass": { "enabled": false }
}
```

When disabled: the lib table is a no-op, every hook file bails out, and no
content is registered — `Mod.libs["magical-glass"]` still exists, so
dependent code using existence guards (e.g. the optional kristal-i18n
adapter, UndertaleMonstersRecreation) stays safe. To disable the monsters
library as well, add `"undertale_monsters_recreation": { "enabled": false }`.

## Usage

Register content through the `MG_EVENT` registry (e.g. `onRegisterLightEncounters`,
`onRegisterLightEnemies`, `onRegisterLightWaves`, `onRegisterLightShops`,
`onRegisterLightBullets`, `getPaletteColor`) from your mod, mirroring how
`UndertaleMonstersRecreation` and the upstream test mod do. Configuration lives
in `lib.json` (`Kristal.getLibConfig("magical-glass", ...)` — do not call it
when the library is absent, it errors).

## kristal-i18n support (optional)

When the kristal-i18n library (`kristalI18n`) is loaded, this library
auto-localizes its UI strings (light shop, light menus, action buttons,
enemy names/check texts) through `Game:loc` with `Game:hasStr` guards, and
ships per-language assets under `assets/sprites/lang/<lang>/...` (e.g. Chinese
battle button sprites). Without kristal-i18n, nothing is patched and everything
stays in the upstream English text. Language data lives in `lang/` and is merged
by kristal-i18n automatically.

Translation sources (see `lang/zh_hans.json` provenance comments):

- UT string key-value extraction provided by 「真是滑稽了啊」 (UT 汉化原作: 好人汉化组)
- Deltarune 汉化: [Goodman 3 / gm3dr](https://github.com/gm3dr/DeltaruneChinese)
  — overrides where the light-world UI overlaps
- Fork-uncovered strings require maintainer review before translation

**Chinese fallback font** — `assets/fonts/small.json` overrides the engine
`small` font settings to add a Chinese fallback font
([fusion-pixel-font](https://github.com/TakWolf/fusion-pixel-font), 8px
monospaced `zh_hans`, SIL OFL 1.1 — see
`assets/fonts/LICENSE-fusion-pixel-font.txt`). ASCII glyphs keep the original
`small` font; only missing Chinese glyphs fall back, so e.g. the
`PRESS [Z] TO VIEW SPELLS` hint renders with a proper 8px pixel CJK face.

## License

**License split** (important — see `LICENSE-UPSTREAM.md`, `LICENSE-MIT`,
`LICENSE-APACHE`):

- *Upstream code* — everything originally shipped in the pack library
  (`assets/`, `scripts/`, `lib.json`, `lib.lua` as imported at commit
  `e2f568d`, itself pinned to upstream `f182f69`) — **retains all rights**
  © the original authors listed in `lib.json` (Nyakorita, Sam Deluxe,
  FireRainV, SadDiamondMan, Azrael, Trashcat, Annie, vitellary, TheSkerch);
  upstream published it **without a license grant**. No open-source license
  is claimed for it here.
- *Third-party assets* — the fusion-pixel-font binary under `assets/fonts/`
  is © TakWolf, licensed under the **SIL Open Font License 1.1**
  (`assets/fonts/LICENSE-fusion-pixel-font.txt`), not covered by the fork
  license.
- *Fork code* — 0.11-dev port fixes, the kristal-i18n adapter, CI, and docs —
  is **dual-licensed MIT OR Apache-2.0, at your option**.
- The split follows `git log`: every commit up to and including
  `Import MagicalGlassRedux v5.0.1 ...` is upstream; everything after is fork
  code. Files are not individually annotated.
- Translations derived from upstream text fall under the upstream rights;
  fork-original translations are covered by the fork license.

Maintenance note: upstream author FireRainV has been contacted regarding this
fork (see `UPSTREAM.md`); contributions back upstream via PR are preferred to
fork-local drift.
