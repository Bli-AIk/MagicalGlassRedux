# MagicalGlassRedux

[![license](https://img.shields.io/badge/license-MIT%2FApache--2.0-blue)](LICENSE-APACHE) <img src="https://img.shields.io/github/repo-size/Bli-AIk/MagicalGlassRedux.svg"/> <img src="https://img.shields.io/github/last-commit/Bli-AIk/MagicalGlassRedux.svg"/> <img src="https://img.shields.io/github/v/release/Bli-AIk/MagicalGlassRedux.svg"/> <br>
<img src="https://img.shields.io/badge/UNDERTALE-000000?style=for-the-badge&logo=undertale&logoColor=ff0000" /> <img src="https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white" /> <img src="https://img.shields.io/badge/Kristal-FF6B35?style=for-the-badge&logo=love2d&logoColor=white" />

**MagicalGlassRedux** — an UNDERTALE-style light-world battle system for [Kristal](https://github.com/KristalTeam/Kristal): spells and TP, blue/green/purple/yellow souls, UT-style shops/save points/menus/items, and a full light battle framework ("LightBattle").

This repository is a **maintenance fork**: upstream ([FireRainV/Noelle-Libraries-Pack](https://github.com/FireRainV/Noelle-Libraries-Pack)) targets Kristal 0.10 and is no longer actively maintained, so this fork ports the library to Kristal 0.11-dev and adds optional [kristal-i18n](https://github.com/Bli-AIk/kristal-i18n) support. See [`UPSTREAM.md`](UPSTREAM.md) and [`CHANGELOG.md`](CHANGELOG.md).

| English | 简体中文                        |
| ------- | ------------------------------- |
| English | [简体中文](./README_zh_hans.md) |

## Kristal Version Support

| Kristal version | MagicalGlassRedux |
| --------------- | ----------------- |
| [v0.11.0-dev](https://github.com/KristalTeam/Kristal/commit/f62afea63ccab02f468c24ac0d096bd8a2c9aa81) (`f62afea`, 2026-08-17) | v0.0.0 (fork), engineVer `v0.11.0-dev` |
| v0.10.0 | v5.0.1 (upstream; `f182f69`) |

`v0.0.0` is the fork's current version line in `lib.json`; there is no packaged fork release yet (see [`CHANGELOG.md`](CHANGELOG.md)).

### Upstream alignment

| Fork version | Aligned upstream | Upstream ref | Notes |
| ------------ | ---------------- | ------------ | ----- |
| v0.0.0 | MagicalGlassRedux v5.0.1 | Noelle-Libraries-Pack `f182f69` (folder tree `b6684d0`) | Kristal 0.11-dev port + kristal-i18n adaption |

The pins live in `.github/upstream-facts.json`; see [`UPSTREAM.md`](UPSTREAM.md) for how they are computed.

## Features

**1. UNDERTALE-style light battles**

A complete light battle framework ("LightBattle"): light enemies, waves and bullets, FIGHT/MERCY/SPARE with soul-based bullet boards (blue/green/purple/yellow), TP, grazing and the Defend command, multi-party light battles, enemy HP/MERCY gauges and an optional mercy bar.

**2. Light-world systems**

UT-style shops, save points (UNDERTALE or DELTARUNE style), menus and items; item/equipment conversion between light and dark worlds, like in Deltarune; plus UT-style text-skipping and game-over skipping options.

**3. Optional localization**

When [kristal-i18n](https://github.com/Bli-AIk/kristal-i18n) is loaded, the library's UI strings localize automatically — see [below](#kristal-i18n-support-optional).

## How to Use

**1. Install the library**

Drop it into `libraries/MagicalGlassRedux/` inside your mod (keep the upstream folder name), as a git submodule or a plain copy. The engine auto-discovers it via `lib.json` (library id `magical-glass`).

```sh
git submodule add https://github.com/Bli-AIk/MagicalGlassRedux.git \
  libraries/MagicalGlassRedux
```

Complementary libraries (optional):

- [UndertaleMonstersRecreation](https://github.com/Bli-AIk/UndertaleMonstersRecreation) — UT monsters (Froggit, Moldsmal…) for light battles.
- [kristal-i18n](https://github.com/Bli-AIk/kristal-i18n) — localization framework (see below).

**2. Register content**

Register content through the `MG_EVENT` registry from your mod — `onRegisterLightEncounters`, `onRegisterLightEnemies`, `onRegisterLightWaves`, `onRegisterLightShops`, `onRegisterLightBullets`, `getPaletteColor` — mirroring how `UndertaleMonstersRecreation` and the upstream test mod do it.

**3. Configure**

Defaults live in `lib.json`; read them with `Kristal.getLibConfig("magical-glass", ...)`.

> ⚠️ Do **not** call `Kristal.getLibConfig("magical-glass", ...)` when the library is absent — it errors.

## Runtime Enable Switch

The library is always discovered once it is in `libraries/`, but a main mod can disable it cleanly from its `mod.json` (`config.magical-glass.enabled` — the key is read as a normal lib config, so `lib.json`'s default of `true` can be overridden without touching the library):

```json
"config": {
    "magical-glass": { "enabled": false }
}
```

When disabled: the lib table is a no-op, every hook file bails out, and no content is registered — `Mod.libs["magical-glass"]` still exists, so dependent code using existence guards (e.g. the optional kristal-i18n adapter, UndertaleMonstersRecreation) stays safe. To disable the monsters library as well, add `"undertale_monsters_recreation": { "enabled": false }`.

## kristal-i18n Support (optional)

When the kristal-i18n library (`kristalI18n`) is loaded, this library auto-localizes its UI strings (light shop, light menus, action buttons, enemy names/check texts) through `Game:loc` with `Game:hasStr` guards, and ships per-language assets under `assets/sprites/lang/<lang>/...` (e.g. Chinese battle button sprites). Without kristal-i18n, nothing is patched and everything stays in upstream English. Language data lives in `lang/` and is merged by kristal-i18n automatically.

**Chinese fallback font** — `assets/fonts/small.json` overrides the engine `small` font settings to add a Chinese fallback font ([fusion-pixel-font](https://github.com/TakWolf/fusion-pixel-font), 8px monospaced `zh_hans`, SIL OFL 1.1 — see `assets/fonts/LICENSE-fusion-pixel-font.txt`). ASCII glyphs keep the original `small` font; only missing Chinese glyphs fall back.

Translation provenance is recorded in the comments of `lang/zh_hans.json`; see [Upstream & References](#upstream--references) for the sources.

## Upstream & References

| Source | Author |
| ------ | ------ |
| [Noelle-Libraries-Pack](https://github.com/FireRainV/Noelle-Libraries-Pack) (upstream) | FireRainV |
| Noelle-Libraries-Pack-v11-dev (commit `77bf47c`) — base of this fork's Kristal 0.11-dev port | Stevenson89 |
| UT 汉化补丁 0.3.3 key-value extraction (original UT translation: 好人汉化组) | 真是滑稽了啊 |
| [DeltaruneChinese](https://github.com/gm3dr/DeltaruneChinese) — overrides where the light-world UI overlaps | [Goodman 3 Localization Group \| UNDERTALE & DELTARUNE Chinese Localization](https://github.com/gm3dr/) |
| [kristal-i18n](https://github.com/Bli-AIk/kristal-i18n) | Bli-AIk |

## Contributing

Issues and Pull Requests are welcome. For the repo layout (upstream vs fork code), land rules and translation review requirements, see [CONTRIBUTING.md](CONTRIBUTING.md).

## License

**License split** (important — see [LICENSE-UPSTREAM.md](LICENSE-UPSTREAM.md), [LICENSE-MIT](LICENSE-MIT), [LICENSE-APACHE](LICENSE-APACHE)):

- *Upstream code* — everything originally shipped in the pack library (`assets/`, `scripts/`, `lib.json`, `lib.lua` as imported at commit `e2f568d`, itself pinned to upstream `f182f69`) — **retains all rights** © the original authors listed in `lib.json` (Nyakorita, Sam Deluxe, FireRainV, SadDiamondMan, Azrael, Trashcat, Annie, vitellary, TheSkerch); upstream published it **without a license grant**. No open-source license is claimed for it here.
- *Third-party assets* — the fusion-pixel-font binary under `assets/fonts/` is © TakWolf, licensed under the **SIL Open Font License 1.1** (`assets/fonts/LICENSE-fusion-pixel-font.txt`), not covered by the fork license.
- *Fork code* — 0.11-dev port fixes, the kristal-i18n adapter, CI, and docs — is **dual-licensed MIT OR Apache-2.0, at your option**.
- The split follows `git log`: every commit up to and including `Import MagicalGlassRedux v5.0.1 ...` is upstream; everything after is fork code. Files are not individually annotated.
- Translations derived from upstream text fall under the upstream rights; fork-original translations are covered by the fork license.
