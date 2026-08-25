# Changelog

All notable changes to this fork are documented here, following
[Conventional Commits](https://www.conventionalcommits.org/).

## Upstream history (one-line summary)

- **v5.0.1** (FireRainV, 2026-06-23) — upstream Noelle-Libraries-Pack release
  line: v5.0.0 → v5.0.1 (Choicebox updated to latest Kristal version), then
  engineVer bumped to v0.10.0. Imported at upstream commit `f182f69`,
  folder tree `b6684d0...`. Not released by this fork yet.

## [0.1.1](https://github.com/Bli-AIk/MagicalGlassRedux/compare/v0.1.0...v0.1.1) (2026-08-25)


### Bug Fixes

* support light encounter prefix ([c90210c](https://github.com/Bli-AIk/MagicalGlassRedux/commit/c90210c348b700d59de3d6005c712e6f152ab2e5))

## [0.1.0](https://github.com/Bli-AIk/MagicalGlassRedux/compare/v0.0.1...v0.1.0) (2026-08-24)


### chore

* force release 0.1.0 ([3c4c1e2](https://github.com/Bli-AIk/MagicalGlassRedux/commit/3c4c1e2bf323f015eddd8052796553a4a094e418))


### Features

* **config:** runtime enable/disable switch (mod.json override) ([e4342a5](https://github.com/Bli-AIk/MagicalGlassRedux/commit/e4342a5c6d26dc8cae3145ad175d26f01b1d7892))
* **i18n:** add fusion-pixel 8px fallback font for the small font ([070dab2](https://github.com/Bli-AIk/MagicalGlassRedux/commit/070dab22d43e1bd6c88685cb48939eb705812988))
* **i18n:** apply maintainer review pass 2 (14 directives) ([1bd8237](https://github.com/Bli-AIk/MagicalGlassRedux/commit/1bd823781392d64b83aede71990daea1b3ed4c31))
* **i18n:** debug give-item menus + item short/serious names ([fd7addd](https://github.com/Bli-AIk/MagicalGlassRedux/commit/fd7addd2fbf6a54ea07be518a5d882d6b27a0656))
* **i18n:** debug give-item panel — types, names, descriptions ([a42462e](https://github.com/Bli-AIk/MagicalGlassRedux/commit/a42462e5239550ae66866eae2a5a9de8d32e872f))
* **i18n:** equip-vs-use wording for the target bar ([cc9b358](https://github.com/Bli-AIk/MagicalGlassRedux/commit/cc9b3586db2e46254edb580e68e7da406d8f94a8))
* **i18n:** fill remaining translations (short/serious names, mg items, UI, debug) ([c2d39e9](https://github.com/Bli-AIk/MagicalGlassRedux/commit/c2d39e939e3f69aa04c170054d2574289ec38dc6))
* **i18n:** optional kristal-i18n adapter ([9bea726](https://github.com/Bli-AIk/MagicalGlassRedux/commit/9bea726230a6c55c2cb9efbc2ae2ae467d7a4561))
* **i18n:** short/serious names from UT item_nameb_/item_names_ keys ([96ebdf9](https://github.com/Bli-AIk/MagicalGlassRedux/commit/96ebdf996fd3d301f0bad3902325a5790763d314))
* **i18n:** zh_hans button sprites + namelv fallback tune ([481f315](https://github.com/Bli-AIk/MagicalGlassRedux/commit/481f3157007e3e159ead0598a2d364ed22a68d70))
* **lang:** ship UT character names and Frisk chara titles ([4f80481](https://github.com/Bli-AIk/MagicalGlassRedux/commit/4f80481ca6da48ca40f24e428be9726f4464b4bd))


### Bug Fixes

* **debug:** cache item picker labels ([9e752fe](https://github.com/Bli-AIk/MagicalGlassRedux/commit/9e752fe9909105d463ade292a2879d8da6a2d864))
* **i18n:** align flee lines with UT source wording ([4c079b5](https://github.com/Bli-AIk/MagicalGlassRedux/commit/4c079b5f65b607d14c571fbb7c417a7b45f93d94))
* **i18n:** bad_memory desc/useName; light battle use-text patterns ([2654aa2](https://github.com/Bli-AIk/MagicalGlassRedux/commit/2654aa286871af503acee48e35c7e506e92f8cd1))
* **i18n:** battle line templates + LightEncounter/battle menu adapters ([3d70f88](https://github.com/Bli-AIk/MagicalGlassRedux/commit/3d70f888971480540303a913b407503ce7c27a05))
* **i18n:** capture target item type via Inventory:getItem ([fc4f71f](https://github.com/Bli-AIk/MagicalGlassRedux/commit/fc4f71f012237d30f99bebf7059dda5801a7f0ab))
* **i18n:** CJK fallback for the namelv font (battle party names) ([7b2ee09](https://github.com/Bli-AIk/MagicalGlassRedux/commit/7b2ee0905c8e301e060b091b21a5b6632b3c63e8))
* **i18n:** debug give-item wording (暗/光世界物品, Undertale 全称) ([0bb8e61](https://github.com/Bli-AIk/MagicalGlassRedux/commit/0bb8e611c44ea954122251f4efb5ad81b91eaddc))
* **i18n:** debug item-label pattern missed the space before '|' ([6fdbe4e](https://github.com/Bli-AIk/MagicalGlassRedux/commit/6fdbe4e7f0872601a14a3bf2fb3b519a8ec99873))
* **i18n:** drop legacy space-simulation remnants from item texts ([ccf1795](https://github.com/Bli-AIk/MagicalGlassRedux/commit/ccf179576d891d00309ce0adb0abcb393f75104c))
* **i18n:** fall back to description when a spell keeps the check placeholder ([f6cc5e7](https://github.com/Bli-AIk/MagicalGlassRedux/commit/f6cc5e762361f5e5a636e7fae977ac56a1c3312d))
* **i18n:** global draw wrappers replace class draw hooks ([7867b0b](https://github.com/Bli-AIk/MagicalGlassRedux/commit/7867b0bed7187bd3bf4032bcdd6293a79eb7dea6))
* **i18n:** iterLibraries is an iterator, not a table ([d5df9f9](https://github.com/Bli-AIk/MagicalGlassRedux/commit/d5df9f913c7fe25e8bd7dd80710dc018a464af64))
* **i18n:** light stat value column + view-spells prompt ([307f0d8](https://github.com/Bli-AIk/MagicalGlassRedux/commit/307f0d82391a4f1fc9a8c2aa693e64e0a204affe))
* **i18n:** literal escape sequences and missing stat headers (mg items) ([484cfe3](https://github.com/Bli-AIk/MagicalGlassRedux/commit/484cfe376057d28a6abf596aa70bbfa459c4bfbc))
* **i18n:** localize item use texts ([37d8ab6](https://github.com/Bli-AIk/MagicalGlassRedux/commit/37d8ab6ba1c5301bbba8c91df969257999582d72))
* **i18n:** localize MGR spell check texts ([8e05514](https://github.com/Bli-AIk/MagicalGlassRedux/commit/8e05514987f11b0e56e520f59d9d3539ff5c7e84))
* **i18n:** merge debug translation into Game.lua hook, drop Debug.lua ([0f22ced](https://github.com/Bli-AIk/MagicalGlassRedux/commit/0f22ced8f75aed9042a0c51c0974435d2a9054e0))
* **i18n:** non-greedy verb capture (consumes -&gt; consume) ([e2ef0fc](https://github.com/Bli-AIk/MagicalGlassRedux/commit/e2ef0fc2af1e692d567e9e7f3447f9cba5174b0f))
* **i18n:** page auto-matched descriptions of engine spells ([b93a117](https://github.com/Bli-AIk/MagicalGlassRedux/commit/b93a11738582d03f4afc1afb2e00d8d17ff8e4f8))
* **i18n:** preserve newlines in UT-derived text ([c64fa7b](https://github.com/Bli-AIk/MagicalGlassRedux/commit/c64fa7b20f2b2c01ed52b955fd8a6e62b62852af))
* **i18n:** proxy Draw.printAlign too (Use-item target bar) ([677815c](https://github.com/Bli-AIk/MagicalGlassRedux/commit/677815ca82d881e2096b39f2250519733e6114b4))
* **i18n:** purge UT markup (\^N waits, \E escapes, ASCII commas) ([0f771f2](https://github.com/Bli-AIk/MagicalGlassRedux/commit/0f771f29e70d95f9a0e2a88ed4fa6359873f7e0c))
* **i18n:** re-entrant late-binding print wrappers (CJK spacing) ([ecfae0f](https://github.com/Bli-AIk/MagicalGlassRedux/commit/ecfae0ffe9391af6446943cb2f58bb77838d5318))
* **i18n:** rename TOSS/KEY entries to a dark-menu prefix, KEY = 重要 ([018aa63](https://github.com/Bli-AIk/MagicalGlassRedux/commit/018aa6313a657862de93b346fb71f727555b196d))
* **i18n:** run every library's enemy refresher on battle start; zh btn dir ([5e7f750](https://github.com/Bli-AIk/MagicalGlassRedux/commit/5e7f7500690a9062b7d5bcd631a2c3cc35cfaed1))
* **i18n:** Spare/Defend labels + item use line ([3ea1b56](https://github.com/Bli-AIk/MagicalGlassRedux/commit/3ea1b56cb868b5b32134821837a829fb6369f76b))
* **i18n:** spell check = API paging + optional key overrides ([a35a637](https://github.com/Bli-AIk/MagicalGlassRedux/commit/a35a63781917ae96b764710da7b6eae017b2b7a4))
* **i18n:** spell prompt wording + fallback font size ([a98bdb1](https://github.com/Bli-AIk/MagicalGlassRedux/commit/a98bdb16c5f7bc3c4fbefb66d52f1d5a28b24d43))
* **i18n:** split multi-page item checks into item_&lt;id&gt;_check_2 keys ([25a7a79](https://github.com/Bli-AIk/MagicalGlassRedux/commit/25a7a79f2d02f8d5d139351d43c9600ee0f621ed))
* **i18n:** stop refreshing enemy names from the UI-language keys ([11cb1dd](https://github.com/Bli-AIk/MagicalGlassRedux/commit/11cb1dd817da80b68d8db64d3fcd0f97c7c72a1c))
* **i18n:** strip doubled check headers; LightItemMenu use-target bar ([5234c20](https://github.com/Bli-AIk/MagicalGlassRedux/commit/5234c20b064c9cd66a9c68ea989031a18e39a10a))
* **i18n:** strip full-width-quote headers; never eat newlines ([3846640](https://github.com/Bli-AIk/MagicalGlassRedux/commit/3846640f5ab7f02ff8ead2edb7d46ffb6e91733b))
* **i18n:** translate DarkItemMenu TOSS / KEY headers ([4ccfd77](https://github.com/Bli-AIk/MagicalGlassRedux/commit/4ccfd779ef4428189d4810aa46523acb46952b9c))
* **i18n:** translate victory summary via battleText ([3878baa](https://github.com/Bli-AIk/MagicalGlassRedux/commit/3878baaaa1973e4e35921a1e60c01dfa13ca0487))
* **i18n:** type capture via dedicated LightItemMenu hook file ([180c667](https://github.com/Bli-AIk/MagicalGlassRedux/commit/180c66712bfd138c3a5dc36ec65a9f1523469109))
* **i18n:** wrap love.graphics.printf (debug menu option labels) ([6ca3c50](https://github.com/Bli-AIk/MagicalGlassRedux/commit/6ca3c5090bcd10f4e231adb8e68f0dfd9bdd130c))
* **lightshop:** localize selling interface ([a05ceb1](https://github.com/Bli-AIk/MagicalGlassRedux/commit/a05ceb170a140fdcaa143ff023e8e21f902b2364))
* **port:** use frames-based invuln API (inv_frames, getInvulnFrames) ([cd60f16](https://github.com/Bli-AIk/MagicalGlassRedux/commit/cd60f16a3b6eaef035f859dc5338d074d3d72071))


### Code Refactoring

* **i18n:** keep MGR localization private ([124cb35](https://github.com/Bli-AIk/MagicalGlassRedux/commit/124cb352f14ea73f480b48e002bb7762658e6525))
* **i18n:** properly handle base Game references and parameter passing ([3e21bc0](https://github.com/Bli-AIk/MagicalGlassRedux/commit/3e21bc0c892edfaf5ad268156254e2bd69c23fc2))
* **i18n:** single '把&lt;item&gt;给谁？' target-bar wording ([7506afc](https://github.com/Bli-AIk/MagicalGlassRedux/commit/7506afc3fce9749387f26185db631aaad76cc26d))
* **i18n:** spell INFO reuses the description keys ([7fe8707](https://github.com/Bli-AIk/MagicalGlassRedux/commit/7fe8707fafac99253fe6c7ff79dd637ec380b65f))

## [Unreleased] — fork development

### Port / i18n (in progress)

- Support `mod.json` direct light-encounter launches through `light/<id>`.
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
