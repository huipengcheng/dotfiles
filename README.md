# Dotfiles

个人 Linux 系统配置文件集合，使用 GNU Stow 管理，支持模块化部署。

## 系统要求

- **操作系统**: Linux (推荐 Arch Linux)
- **必需工具**: GNU Stow
- **可选工具**: rsync (用于备份)

## 快速开始

### 克隆仓库

```bash
git clone <repository-url> ~/dotfiles
cd ~/dotfiles
```

### 安装配置

```bash
chmod +x install.sh
./install.sh
```

## 包含的配置

项目包含以下应用程序的配置文件：

| 配置包 | 描述 |
|--------|------|
| **bash** | Bash shell 配置 |
| **bat** | Cat 命令增强版配置 |
| **bin** | 自定义脚本和可执行文件 |
| **chromium** | Chromium 浏览器配置 |
| **electron** | Electron 应用配置 |
| **fastfetch** | 系统信息显示工具配置 |
| **fcitx5** | 中文输入法框架配置 |
| **firefox** | Firefox 浏览器配置 |
| **fish** | Fish shell 配置 |
| **git** | Git 版本控制配置 |
| **gtk** | GTK 主题配置 |
| **hypr** | Hyprland 窗口管理器配置 |
| **keyd** | 键盘重映射工具配置 (系统级) |
| **kitty** | Kitty 终端模拟器配置 |
| **nvim** | Neovim 编辑器配置 |
| **paru** | AUR 助手配置 |
| **qtile** | Qtile 窗口管理器配置 |
| **rime** | Rime 输入法引擎配置 |
| **starship** | 跨 Shell 提示符配置 |
| **waybar** | Wayland 状态栏配置 |
| **wofi** | Wayland 应用启动器配置 |
| **x11** | X11 窗口系统配置 |
| **zathura** | PDF 阅读器配置 |

## 使用方法

### 全量安装

安装所有配置包：

```bash
./install.sh
```

### 选择性安装

只安装指定的配置包：

```bash
./install.sh fish starship nvim
```

### 安全模式

在实际修改前预览将要执行的操作：

```bash
./install.sh --dry-run
```

### 调试模式

显示详细的执行日志：

```bash
./install.sh --verbose
```

### 组合使用

```bash
./install.sh --dry-run --verbose fish git nvim
```

## 脚本说明

### install.sh

主安装脚本，提供以下功能：

- **自动备份**: 在部署前自动备份现有配置
- **模块化部署**: 可选择性地安装特定配置包
- **安全防护**: 对系统级配置路径进行白名单验证
- **Hook 支持**: 支持全局和包级别的 pre_install/post_install 钩子
- **用户级配置**: 通过 Stow 部署到 `$HOME` 目录
- **系统级配置**: 通过 Sudo + Stow 部署到 `/etc` 等系统目录

**选项**:
- `--dry-run`: 模拟执行，不实际修改文件
- `--verbose, -v`: 显示详细日志

### backup.sh

配置备份脚本：

- 备份 `~/.config` 目录到 `~/backup/dotfiles/.config`
- 使用时间戳命名备份目录
- 优先使用 rsync (如可用)
- 自动清理旧备份，保留最近 50 个

## 项目结构

```
dotfiles/
├── install.sh              # 主安装脚本
├── backup.sh               # 备份脚本
├── <package>/              # 配置包目录
│   ├── .config/           # 用户级配置 (~/.config)
│   ├── root/              # 系统级配置 (/)
│   ├── pre_install.sh     # 安装前钩子 (可选)
│   └── post_install.sh    # 安装后钩子 (可选)
└── README.md
```

## 系统级配置

部分配置需要系统级权限（如 keyd），脚本会：

1. 验证目标路径是否在白名单内
2. 提示需要 sudo 权限
3. 使用 `sudo stow` 部署到系统目录

**允许的系统路径**:
- `/etc/keyd`

## 钩子机制

支持在安装过程中执行自定义脚本：

### 全局钩子

放置在项目根目录：
- `pre_install.sh`: 在所有包部署前执行
- `post_install.sh`: 在所有包部署后执行

### 包级钩子

放置在各配置包目录下：
- `<package>/pre_install.sh`: 在该包部署前执行
- `<package>/post_install.sh`: 在该包部署后执行

## 注意事项

1. **备份重要**: 首次运行会自动备份，但建议手动备份重要配置
2. **冲突处理**: 如果目标位置已有文件，Stow 会报错，需手动处理冲突
3. **系统权限**: 部署系统级配置需要 sudo 密码
4. **Git 子模块**: 某些配置可能使用 Git 子模块，需执行：
   ```bash
   git submodule update --init --recursive
   ```

## 卸载

移除已部署的配置：

```bash
cd ~/dotfiles
stow -D <package-name>
```

移除系统级配置：

```bash
cd ~/dotfiles/<package>
sudo stow -D -t / root
```

## 许可证

本项目采用 [LICENSE](LICENSE) 中指定的许可证。

## 维护

- 定期同步配置变更到仓库
- 使用 Git 进行版本控制
- 添加新配置时遵循现有目录结构
