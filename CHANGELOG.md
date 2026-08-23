# Changelog

All notable changes to this fork are documented here, following
[Conventional Commits](https://www.conventionalcommits.org/).

## Upstream history (one-line summary)

- **v5.0.1** (FireRainV, 2026-06-23) — upstream Noelle-Libraries-Pack release
  line: v5.0.0 → v5.0.1 (Choicebox updated to latest Kristal version), then
  engineVer bumped to v0.10.0. Imported at upstream commit `f182f69`,
  folder tree `b6684d0...`. Not released by this fork yet.

## [0.1.0](https://github.com/Bli-AIk/MagicalGlassRedux/compare/v0.0.1...v0.1.0) (2026-08-23)


### Features

* **config:** runtime enable/disable switch (mod.json override) ([5328ae3](https://github.com/Bli-AIk/MagicalGlassRedux/commit/5328ae3f2672b320fa85c984cc2e3b368eeafe58))
* **i18n:** add fusion-pixel 8px fallback font for the small font ([e5a7441](https://github.com/Bli-AIk/MagicalGlassRedux/commit/e5a744161fa86dda1d60de3ee6b7ccdbe7567931))
* **i18n:** apply maintainer review pass 2 (14 directives) ([46dc5ca](https://github.com/Bli-AIk/MagicalGlassRedux/commit/46dc5ca4cd958463363986a6d374f4c8b33168f4))
* **i18n:** debug give-item menus + item short/serious names ([2d1010d](https://github.com/Bli-AIk/MagicalGlassRedux/commit/2d1010d8d8a4003a3c3b164c08dfb4722ef854ef))
* **i18n:** debug give-item panel — types, names, descriptions ([fd878ad](https://github.com/Bli-AIk/MagicalGlassRedux/commit/fd878ad1cdce0ef7e0ec6dc282e6872c00856300))
* **i18n:** equip-vs-use wording for the target bar ([71377f9](https://github.com/Bli-AIk/MagicalGlassRedux/commit/71377f93fa0ee5b9e1a1f301643fa16815d656af))
* **i18n:** fill remaining translations (short/serious names, mg items, UI, debug) ([a3ef105](https://github.com/Bli-AIk/MagicalGlassRedux/commit/a3ef10541283b4a025a04450e4ab83c87aae077c))
* **i18n:** optional kristal-i18n adapter ([90b925d](https://github.com/Bli-AIk/MagicalGlassRedux/commit/90b925d9fbfbdb2698aa368755ccf7734bc68209))
* **i18n:** short/serious names from UT item_nameb_/item_names_ keys ([a9bbd6a](https://github.com/Bli-AIk/MagicalGlassRedux/commit/a9bbd6a8cbedaf6e0d537d12a3ca745939533d10))
* **i18n:** zh_hans button sprites + namelv fallback tune ([085fd91](https://github.com/Bli-AIk/MagicalGlassRedux/commit/085fd9128a5e16d0eebd526abf2064e2ba40a4b3))
* **lang:** ship UT character names and Frisk chara titles ([eebb8fa](https://github.com/Bli-AIk/MagicalGlassRedux/commit/eebb8faf935a7ad44255afc228864765ca684eba))


### Bug Fixes

* **debug:** cache item picker labels ([7da426e](https://github.com/Bli-AIk/MagicalGlassRedux/commit/7da426e21f19cb3daee77fa28b84ad3ac9189268))
* **i18n:** align flee lines with UT source wording ([8a02e47](https://github.com/Bli-AIk/MagicalGlassRedux/commit/8a02e47a14599eac1fd52b99d4a119daf626c47b))
* **i18n:** bad_memory desc/useName; light battle use-text patterns ([7a1cfa3](https://github.com/Bli-AIk/MagicalGlassRedux/commit/7a1cfa3cc5f4b2290420b3fda89e6b9a1b45a653))
* **i18n:** battle line templates + LightEncounter/battle menu adapters ([07b1d79](https://github.com/Bli-AIk/MagicalGlassRedux/commit/07b1d79e8ce66df465a44d67abceb6a9ffe7cbd2))
* **i18n:** capture target item type via Inventory:getItem ([6b63d65](https://github.com/Bli-AIk/MagicalGlassRedux/commit/6b63d65bad44477b68836ea8aa20ee7980bba685))
* **i18n:** CJK fallback for the namelv font (battle party names) ([7250b38](https://github.com/Bli-AIk/MagicalGlassRedux/commit/7250b389949b2c3fc4a2d79274deddd9b46377ab))
* **i18n:** debug give-item wording (暗/光世界物品, Undertale 全称) ([0e53291](https://github.com/Bli-AIk/MagicalGlassRedux/commit/0e532910075e6fd2ccc114f6c5c9a21f8a73377e))
* **i18n:** debug item-label pattern missed the space before '|' ([cfcd58f](https://github.com/Bli-AIk/MagicalGlassRedux/commit/cfcd58f9a6da06d23982c110000d924687ee91cc))
* **i18n:** drop legacy space-simulation remnants from item texts ([b0e89f1](https://github.com/Bli-AIk/MagicalGlassRedux/commit/b0e89f1ac2ff512a46db2789e74709a02dd6955a))
* **i18n:** fall back to description when a spell keeps the check placeholder ([6b9255e](https://github.com/Bli-AIk/MagicalGlassRedux/commit/6b9255ed908ff72e1f2b42d45afec1f1aa8ca49d))
* **i18n:** global draw wrappers replace class draw hooks ([b325008](https://github.com/Bli-AIk/MagicalGlassRedux/commit/b325008b77882f35f0b39ec0a35ddd8609322638))
* **i18n:** iterLibraries is an iterator, not a table ([f90ff72](https://github.com/Bli-AIk/MagicalGlassRedux/commit/f90ff72194c2480c7fd061082aa484f3a6d77df3))
* **i18n:** light stat value column + view-spells prompt ([cfed399](https://github.com/Bli-AIk/MagicalGlassRedux/commit/cfed3998fa6994215474faf7aaed43de14bdb2e0))
* **i18n:** literal escape sequences and missing stat headers (mg items) ([3133838](https://github.com/Bli-AIk/MagicalGlassRedux/commit/31338387344b30d145cc7223457bb4cc509d6607))
* **i18n:** localize MGR spell check texts ([07724eb](https://github.com/Bli-AIk/MagicalGlassRedux/commit/07724eb5a5750b34c020e68306be416b69120e04))
* **i18n:** merge debug translation into Game.lua hook, drop Debug.lua ([3b05f5f](https://github.com/Bli-AIk/MagicalGlassRedux/commit/3b05f5feb8e2bc20cffec000078741653b3e290f))
* **i18n:** non-greedy verb capture (consumes -&gt; consume) ([8674f2b](https://github.com/Bli-AIk/MagicalGlassRedux/commit/8674f2bc5116910c8ad2a387224e483f466b3232))
* **i18n:** page auto-matched descriptions of engine spells ([086a4fb](https://github.com/Bli-AIk/MagicalGlassRedux/commit/086a4fb1c1cb0e2366464c44a03687054a5d5129))
* **i18n:** preserve newlines in UT-derived text ([53cb5f1](https://github.com/Bli-AIk/MagicalGlassRedux/commit/53cb5f10192bdc769eda91459d66c16729c0538a))
* **i18n:** proxy Draw.printAlign too (Use-item target bar) ([4c14950](https://github.com/Bli-AIk/MagicalGlassRedux/commit/4c149509ac1b53079b994e03309519ef5d5f56d9))
* **i18n:** purge UT markup (\^N waits, \E escapes, ASCII commas) ([2e5f6a1](https://github.com/Bli-AIk/MagicalGlassRedux/commit/2e5f6a1b67b8fdc569b9206b8f8c298c6f9a7396))
* **i18n:** re-entrant late-binding print wrappers (CJK spacing) ([3078079](https://github.com/Bli-AIk/MagicalGlassRedux/commit/30780797ef6494b74085be8fbbe2cda109f3d288))
* **i18n:** rename TOSS/KEY entries to a dark-menu prefix, KEY = 重要 ([cffedf9](https://github.com/Bli-AIk/MagicalGlassRedux/commit/cffedf91258f9d70449f4322239ffd40453f2366))
* **i18n:** run every library's enemy refresher on battle start; zh btn dir ([50934e7](https://github.com/Bli-AIk/MagicalGlassRedux/commit/50934e7669c21b2dac5cbb6ebeb29aa99530b320))
* **i18n:** Spare/Defend labels + item use line ([ea2fd9b](https://github.com/Bli-AIk/MagicalGlassRedux/commit/ea2fd9bd79cafd69971eb2c1a368958afff66572))
* **i18n:** spell check = API paging + optional key overrides ([58bbfcb](https://github.com/Bli-AIk/MagicalGlassRedux/commit/58bbfcb77098b34af111054c6923a220a8c10a28))
* **i18n:** spell prompt wording + fallback font size ([2f28981](https://github.com/Bli-AIk/MagicalGlassRedux/commit/2f28981f4eef780eec234cb45ed33df727761f3b))
* **i18n:** split multi-page item checks into item_&lt;id&gt;_check_2 keys ([3a0f875](https://github.com/Bli-AIk/MagicalGlassRedux/commit/3a0f87562d1888e64f4f98462e31c8079b34af4d))
* **i18n:** stop refreshing enemy names from the UI-language keys ([e20d6ab](https://github.com/Bli-AIk/MagicalGlassRedux/commit/e20d6ab5f5d4244d0d00fafef81b8b6657dbfb63))
* **i18n:** strip doubled check headers; LightItemMenu use-target bar ([879a9e8](https://github.com/Bli-AIk/MagicalGlassRedux/commit/879a9e8b72f87bc40f11d8aeb2db75c83730421b))
* **i18n:** strip full-width-quote headers; never eat newlines ([c4d90a2](https://github.com/Bli-AIk/MagicalGlassRedux/commit/c4d90a22c64bfddac29111ce8fccd2e7ed240808))
* **i18n:** translate DarkItemMenu TOSS / KEY headers ([ebf6817](https://github.com/Bli-AIk/MagicalGlassRedux/commit/ebf6817b19cc8a6051316bdf6795b722e814bc5b))
* **i18n:** translate victory summary via battleText ([acfeab1](https://github.com/Bli-AIk/MagicalGlassRedux/commit/acfeab1bbf95038e609c20002fab6b0f466e7cb2))
* **i18n:** type capture via dedicated LightItemMenu hook file ([76a2b87](https://github.com/Bli-AIk/MagicalGlassRedux/commit/76a2b87bb90b479b818f930d62f69e2942e6b875))
* **i18n:** wrap love.graphics.printf (debug menu option labels) ([a9910ac](https://github.com/Bli-AIk/MagicalGlassRedux/commit/a9910acab9b109f3f9647087e47db052bc8ce676))
* **port:** use frames-based invuln API (inv_frames, getInvulnFrames) ([9ca4a75](https://github.com/Bli-AIk/MagicalGlassRedux/commit/9ca4a75ed6ddb60b7a77ee0d5598372f0615f35f))


### Code Refactoring

* **i18n:** properly handle base Game references and parameter passing ([435fa37](https://github.com/Bli-AIk/MagicalGlassRedux/commit/435fa37594909f97008eec956eeab4ad409572cf))
* **i18n:** single '把&lt;item&gt;给谁？' target-bar wording ([a7b799d](https://github.com/Bli-AIk/MagicalGlassRedux/commit/a7b799d391561a16c7875e3e7c87154e034781be))
* **i18n:** spell INFO reuses the description keys ([e104170](https://github.com/Bli-AIk/MagicalGlassRedux/commit/e104170825817d0253ad24bae5cc722f38c8f450))

## [Unreleased] — fork development

### Port / i18n (in progress)

- Import MagicalGlassRedux v5.0.1 from upstream tree (see `UPSTREAM.md`).
- Kristal 0.11-dev API port (based on Stevenson89's `Noelle-Libraries-Pack-v11-dev`
  commit `77bf47c`).
- Optional kristal-i18n adapter + `lang/` data + localized assets.
- CI: Kristal update check + upstream drift check.

<!-- release-please will manage fork release notes from here -->
