# MagicalGlassRedux

[![license](https://img.shields.io/badge/license-MIT%2FApache--2.0-blue)](LICENSE-APACHE) <img src="https://img.shields.io/github/repo-size/Bli-AIk/MagicalGlassRedux.svg"/> <img src="https://img.shields.io/github/last-commit/Bli-AIk/MagicalGlassRedux.svg"/> <img src="https://img.shields.io/github/v/release/Bli-AIk/MagicalGlassRedux.svg"/> <br>
<img src="https://img.shields.io/badge/UNDERTALE-000000?style=for-the-badge&logo=undertale&logoColor=ff0000" /> <img src="https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white" /> <img src="https://img.shields.io/badge/Kristal-FF6B35?style=for-the-badge&logo=love2d&logoColor=white" />

**MagicalGlassRedux** — 面向 [Kristal](https://github.com/KristalTeam/Kristal) 的 UNDERTALE 风格光世界战斗系统：法术与 TP、蓝/绿/紫/黄灵魂、UT 风格商店/存档点/菜单/物品，以及完整的光战斗框架（"LightBattle"）。

本仓库是**维护 fork**：上游（[FireRainV/Noelle-Libraries-Pack](https://github.com/FireRainV/Noelle-Libraries-Pack)）面向 Kristal 0.10 且不再积极维护，因此本仓库将库移植到 Kristal 0.11-dev，并增加可选的 [kristal-i18n](https://github.com/Bli-AIk/kristal-i18n) 支持。详见 [`UPSTREAM.md`](UPSTREAM.md) 与 [`CHANGELOG.md`](CHANGELOG.md)。

| 简体中文 | English                |
| -------- | ---------------------- |
| 简体中文 | [English](./README.md) |

## Kristal 版本支持

| Kristal 版本 | MagicalGlassRedux |
| ------------ | ----------------- |
| [v0.11.0-dev](https://github.com/KristalTeam/Kristal/commit/f62afea63ccab02f468c24ac0d096bd8a2c9aa81)（`f62afea`，2026-08-17） | v0.0.0（fork），engineVer `v0.11.0-dev` |
| v0.10.0 | v5.0.1（上游；`f182f69`） |

`v0.0.0` 是本 fork 当前在 `lib.json` 中的版本线；本 fork 尚未发布打包版本（见 [`CHANGELOG.md`](CHANGELOG.md)）。

### 上游对齐

| fork 版本 | 对齐的上游 | 上游 ref | 说明 |
| --------- | ---------- | -------- | ---- |
| v0.0.0 | MagicalGlassRedux v5.0.1 | Noelle-Libraries-Pack `f182f69`（文件树 `b6684d0`） | Kristal 0.11-dev 移植 + kristal-i18n 适配 |

上游 pin 记录在 `.github/upstream-facts.json`；计算方法见 [`UPSTREAM.md`](UPSTREAM.md)。

## 特性

**1. UNDERTALE 风格光战斗**

完整的光战斗框架（"LightBattle"）：光敌人、波次与弹幕、FIGHT/MERCY/SPARE 与灵魂弹幕板（蓝/绿/紫/黄）、TP、擦弹与 Defend 指令、多成员光战斗、敌人 HP/MERCY 槽与可选的 MERCY 条。

**2. 光世界系统**

UT 风格商店、存档点（UNDERTALE 或 DELTARUNE 样式）、菜单与物品；像 Deltarune 一样在光世界与暗世界之间转换物品与装备；还有 UT 风格的文本跳过与 Game Over 跳过选项。

**3. 可选本地化**

加载 [kristal-i18n](https://github.com/Bli-AIk/kristal-i18n) 后，库的 UI 字符串自动本地化——见[下文](#kristal-i18n-支持可选)。

## 怎么用

**1. 把库装上**

放进 mod 的 `libraries/MagicalGlassRedux/`（保持上游文件夹名），可用 git submodule 或整目录拷贝。引擎通过 `lib.json` 自动发现（库 id `magical-glass`）。

```sh
git submodule add https://github.com/Bli-AIk/MagicalGlassRedux.git \
  libraries/MagicalGlassRedux
```

配套库（可选）：

- [UndertaleMonstersRecreation](https://github.com/Bli-AIk/UndertaleMonstersRecreation) —— UT 怪物（蛙吉特、摩登斯玛尔…）光战斗内容。
- [kristal-i18n](https://github.com/Bli-AIk/kristal-i18n) —— 本地化框架（见下）。

**2. 注册内容**

从 mod 侧通过 `MG_EVENT` 注册表注册内容——`onRegisterLightEncounters`、`onRegisterLightEnemies`、`onRegisterLightWaves`、`onRegisterLightShops`、`onRegisterLightBullets`、`getPaletteColor`——参照 `UndertaleMonstersRecreation` 与上游测试 mod 的做法。

**3. 配置**

默认配置在 `lib.json`，用 `Kristal.getLibConfig("magical-glass", ...)` 读取。

> ⚠️ 库不存在时**不要**调用 `Kristal.getLibConfig("magical-glass", ...)`，会报错。

## 运行时开关

库只要在 `libraries/` 里就会被发现，但主 mod 可以在自己的 `mod.json` 中干净地关掉它（`config.magical-glass.enabled`——该键按普通 lib 配置读取，因此不用改库文件就能覆盖 `lib.json` 的默认值 `true`）：

```json
"config": {
    "magical-glass": { "enabled": false }
}
```

关闭后：lib 表为 no-op，所有 hook 文件直接退出，不注册任何内容——`Mod.libs["magical-glass"]` 依然存在，所以用存在性守卫的依赖代码（可选的 kristal-i18n 适配层、UndertaleMonstersRecreation）仍然安全。要同时关闭怪物库，再加 `"undertale_monsters_recreation": { "enabled": false }`。

## kristal-i18n 支持（可选）

当加载了 kristal-i18n（`kristalI18n`）时，本库自动本地化其 UI 字符串（光商店、光菜单、动作按钮、敌人名/检查文本），经 `Game:loc` + `Game:hasStr` 守卫；并按语言携带资源覆盖于 `assets/sprites/lang/<lang>/...`（如中文战斗按钮贴图）。没有 kristal-i18n 时一切不生效，保持上游英文。语言数据位于 `lang/`，由 kristal-i18n 自动合并。

**中文回退字体** —— `assets/fonts/small.json` 覆盖引擎 `small` 字体设置，加入中文回退字体（[fusion-pixel-font](https://github.com/TakWolf/fusion-pixel-font)，8px 等宽 `zh_hans`，SIL OFL 1.1——见 `assets/fonts/LICENSE-fusion-pixel-font.txt`）。ASCII 字形保持原 `small` 字体，仅缺失的中文字形回退。

翻译出处记录在 `lang/zh_hans.json` 的注释里；来源见[上游来源与参考](#上游来源与参考)。

## 上游来源与参考

| 来源 | 作者 |
| ---- | ---- |
| [Noelle-Libraries-Pack](https://github.com/FireRainV/Noelle-Libraries-Pack)（上游） | FireRainV |
| Noelle-Libraries-Pack-v11-dev（commit `77bf47c`）—— 本 fork 0.11-dev 移植的基础 | Stevenson89 |
| UT 汉化补丁 0.3.3 键值对提取（UT 汉化原作：好人汉化组） | 真是滑稽了啊 |
| [DeltaruneChinese](https://github.com/gm3dr/DeltaruneChinese) —— 与光世界 UI 重叠处以它为准 | [Goodman 3 Localization Group \| UNDERTALE & DELTARUNE Chinese Localization](https://github.com/gm3dr/) |
| [kristal-i18n](https://github.com/Bli-AIk/kristal-i18n) | Bli-AIk |

## 参与贡献

欢迎提交 Issue 或 Pull Request。本 fork 是本地移植枢纽：非 fork 特有的修复请尽量以 PR 回捐上游（[FireRainV/Noelle-Libraries-Pack](https://github.com/FireRainV/Noelle-Libraries-Pack)），避免 fork 本地漂移。

仓库布局（上游代码 vs fork 代码）、落地规则与翻译审核要求见 [CONTRIBUTING.md](CONTRIBUTING.md)。

## 许可证

**许可拆分**（重要——见 [LICENSE-UPSTREAM.md](LICENSE-UPSTREAM.md)、[LICENSE-MIT](LICENSE-MIT)、[LICENSE-APACHE](LICENSE-APACHE)）：

- *上游代码* —— pack 库中最初随附的全部内容（`assets/`、`scripts/`、`lib.json`、`lib.lua`，import 提交 `e2f568d`，对应上游 `f182f69`）—— **保留所有权利** © `lib.json` 所列原作者（Nyakorita、Sam Deluxe、FireRainV、SadDiamondMan、Azrael、Trashcat、Annie、vitellary、TheSkerch）；上游发布时**未授予任何开源许可**。本仓库不对其主张任何开源许可。
- *第三方素材* —— `assets/fonts/` 下的 fusion-pixel-font 二进制 © TakWolf，依 **SIL Open Font License 1.1** 授权（`assets/fonts/LICENSE-fusion-pixel-font.txt`），不在 fork 许可范围内。
- *fork 代码* —— 0.11-dev 移植、kristal-i18n 适配、CI 与文档 —— **MIT OR Apache-2.0 双许可，任选其一**。
- 拆分以 `git log` 为准：`Import MagicalGlassRedux v5.0.1 ...` 及以前均为上游代码，其后为 fork 代码；文件不做逐个体标注。
- 上游文本的衍生物（如上游文本的翻译）归于上游权利；fork 原创翻译由 fork 许可覆盖。
