# macOS niri 风格工作流

适用于本机 OmniWM 0.6.10 / Hammerspoon 1.1.1 / kitty 0.37.0。Linux 配置保持独立。

- `omniwm/settings.toml`：原生窗口动作、规则、工作区栏。
- `hammerspoon/init.lua`：应用和脚本快捷键、CLI 补充、显示器监听。
- `kitty/kitty.conf`：包含共享配置后的 Mac 覆盖。
- `bin/`、`lib/env.sh`：Mac 脚本和依赖路径。
- `zsh.conf`：由共享 zsh 的 Darwin 分支载入。
- `launchagents/`：登录启动；不使用 KeepAlive。
- `docs/迁移报告.md`：完整按键表、实际测试与尚待验证项。
- `docs/native-hotkeys.json`：实际原生绑定；`docs/hammerspoon-hotkeys.json`：伴随绑定。

本机配置入口以符号链接指向本目录。可在已忽略的 `local.conf` 覆盖 `NIRI_MAC_VAULT`、`NIRI_MAC_TODO`、`NIRI_MAC_PDF_APP`、`NIRI_MAC_RPC_URL`。

Win+Escape 暂停或恢复本次快捷键。原生 Command 快捷键保留；锁屏使用 Control+Command+Q。

回滚先预览：`bin/rollback.py --backup <manifest.json 所在目录>`。加 `--apply` 才执行；它会先保留当前配置，再恢复原入口和此前运行的 skhd、SketchyBar。应用安装、Homebrew 升级和 Zotero 数据不会自动回退。

三指左划对应一次 Win+L，右划对应一次 Win+H，上划对应一次 Win+J，下划对应一次 Win+K；系统桌面用四指左右划，Mission Control 用四指上划。设置、验证边界和回退方法见 `docs/三指切列.md`。

外接 R75Pro 的物理 Win 是独立 Mod；内置键盘按位置对应：Control 是 Ctrl，Option 是 Win/Mod，Command 是 Alt。左右 Option 和左右 Command 对称。两种键盘的物理 Ctrl 在普通应用发送 Command，kitty 内保持 Control。内置 Command+C/V 对应外接 Alt+C/V。Alt 留给应用，kitty 的 Alt+C/V 和其他 Alt 标签/窗格键恢复 Linux 源配置；Win+V 打开 Skim，Win+C 居中。滚轮使用 Win 层，Win+Escape 暂停或恢复。没有使用四键 Hyper 作为基础修饰键。

`karabiner/physical-control.json` 包含本工作流的一个统一规则组；`device-modifications.json` 包含外接 Win、内置 Option 到独立层，以及内置 Command 到 Alt 的设备映射。`docs/physical-hotkeys.json` 是物理键位对照。启用规则用 `bin/apply-keyboard-bridge.py --apply --backup-dir <备份目录>`，只合并具名规则和对应键位映射；`--remove` 只撤掉这些规则与映射。要回到上一轮 Option 方案，请使用本轮专用回退工具 `bin/rollback-win-layer.py <回退Win层信息.json>`。

Win+Space 发送 Hapigo 已配置的 Command+Space；外接键盘物理 Ctrl+Space 例外发送系统 Control+Space，切换输入法。两条例外包含在同一个改键组中。R75Pro 的其他物理 Ctrl 仍用于普通应用的 Command 快捷键，kitty 内保持 Control。内置 Control+Space 同样发送系统 Control+Space。内置 Option+Space 打开 Hapigo，Option+Control+H/L 移动列；kitty 中 Control+C 中断、Command+C/V 复制粘贴。

双屏排列按官方要求分开：系统技术坐标为外屏下、内屏右上角相接；OmniWM 自定义方向图保留内屏左、外屏右。`displays/P275MV-PLUS-staircase.json` 和 `bin/display-origins.py` 提供原点记录与恢复；不自动修改未知显示器或分辨率。排查、实测与回退见迁移报告文末。
