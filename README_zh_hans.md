# MagicalGlassRedux

面向 [Kristal](https://github.com/KristalTeam/Kristal) 的 UNDERTALE 风格光世界战斗系统 ——
法术与 TP、蓝/绿/紫/黄灵魂、UT 风格商店/存档点/菜单/物品，以及完整的光战斗框架
（"LightBattle"）。

本仓库是**维护 fork**：上游
（[FireRainV/Noelle-Libraries-Pack](https://github.com/FireRainV/Noelle-Libraries-Pack)）
面向 Kristal 0.10 且不再积极维护，因此本仓库将 MagicalGlassRedux 移植到 Kristal
0.11-dev，并增加可选的 [kristal-i18n](https://github.com/Bli-AIk/kristal-i18n) 支持。
详见 [`UPSTREAM.md`](UPSTREAM.md) 与 [`CHANGELOG.md`](CHANGELOG.md)。

## Kristal 版本支持

| Kristal v0.11.0-dev（`f62afea`，2026-08-22） | MagicalGlassRedux v5.0.1，engineVer `v0.11.0-dev` |
|---|---|
| Kristal v0.10.0 | v5.0.1（上游；`f182f69`） |

## 安装

将本仓库放进 mod 的 `libraries/MagicalGlassRedux/`（保持上游文件夹名
`MagicalGlassRedux`），可用 git submodule 或整目录拷贝。引擎通过 `lib.json`
自动发现（库 id `magical-glass`）。

```sh
git submodule add https://github.com/Bli-AIk/MagicalGlassRedux.git \
  libraries/MagicalGlassRedux
```

配套库（可选）：

- [UndertaleMonstersRecreation](https://github.com/Bli-AIk/UndertaleMonstersRecreation)
  —— UT 怪物（蛙吉特、摩登斯玛尔…）光战斗内容。
- [kristal-i18n](https://github.com/Bli-AIk/kristal-i18n) —— 本地化框架（见下）。

## 使用

通过 `MG_EVENT` 注册表（如 `onRegisterLightEncounters`、`onRegisterLightEnemies`、
`onRegisterLightWaves`、`onRegisterLightShops`、`onRegisterLightBullets`、
`getPaletteColor`）从 mod 侧注册内容，参照 `UndertaleMonstersRecreation` 与上游
测试 mod 的做法。配置在 `lib.json` 中（`Kristal.getLibConfig("magical-glass", ...)`
——库不存在时不要调用，会报错）。

## kristal-i18n 支持（可选）

当加载了 kristal-i18n（`kristalI18n`）时，本库自动本地化其 UI 字符串（光商店、
光菜单、动作按钮、敌人名/检查文本），经 `Game:loc` + `Game:hasStr` 守卫；
并按语言携带资源覆盖于 `assets/sprites/lang/<lang>/...`（如中文战斗按钮贴图）。
没有 kristal-i18n 时全部不生效，保持上游英文。语言数据位于 `lang/`，由
kristal-i18n 自动合并。

翻译来源（见 `lang/zh_hans.json` 出处注释）：

- UT 键值对提取版由「真是滑稽了啊」提供（UT 汉化原作：好人汉化组）
- Deltarune 汉化：[Goodman 3 / gm3dr](https://github.com/gm3dr/DeltaruneChinese)
  —— 与光世界 UI 重叠处以它为准
- fork 未覆盖词条须经维护者审核后翻译

## 许可

**许可拆分**（重要 —— 见 `LICENSE-UPSTREAM.md`、`LICENSE-MIT`、`LICENSE-APACHE`）：

- *上游代码* —— pack 库中最初随附的全部内容（`assets/`、`scripts/`、`lib.json`、
  `lib.lua`，import 提交 `e2f568d`，对应上游 `f182f69`）—— **保留所有权利** ©
  `lib.json` 所列原作者（Nyakorita、Sam Deluxe、FireRainV、SadDiamondMan、Azrael、
  Trashcat、Annie、vitellary、TheSkerch）；上游发布时**未授予任何开源许可**。
  本仓库不对其主张任何开源许可。
- *fork 代码* —— 0.11-dev 移植、kristal-i18n 适配、CI 与文档 ——
  **MIT OR Apache-2.0 双许可，任选其一**。
- 拆分以 `git log` 为准：`Import MagicalGlassRedux v5.0.1 ...` 及以前均为上游代码，
  其后为 fork 代码；文件不做逐个体标注。
- 上游文本的衍生物（如上游文本的翻译）归于上游权利；fork 原创翻译由 fork 许可覆盖。

维护说明：已就本 fork 联系上游作者 FireRainV（见 `UPSTREAM.md`）；向上游回捐
PR 优先于 fork 本地漂移。
