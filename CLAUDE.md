# Dev Environment Setup

HHKB Professional HYBRID Type-S を使ったクロスプラットフォーム開発環境の設定リポジトリ。

## リポジトリ構成

```
common/   # Mac・Windows 両方に適用
  .claude/keybindings.json          → ~/.claude/keybindings.json
  .config/wezterm/wezterm.lua       → ~/.config/wezterm/wezterm.lua
  .config/nvim/lazyvim.json         → ~/.config/nvim/lazyvim.json
  .config/nvim/lua/config/          → ~/.config/nvim/lua/config/
  .config/nvim/lua/plugins/         → ~/.config/nvim/lua/plugins/

mac/      # Mac のみに適用
  .config/karabiner/assets/complex_modifications/
    hhkb-windows-unify.json         → ~/.config/karabiner/assets/complex_modifications/
    ime-switch.json                 → ~/.config/karabiner/assets/complex_modifications/
```

## Mac セットアップ手順

### 1. 必要なソフトウェアをインストール

```bash
# Homebrew（未インストールの場合）
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 各ツール
brew install --cask wezterm
brew install --cask karabiner-elements
brew install --cask rectangle
brew install neovim
brew install mise
brew install lazygit
```

### 2. フォントをインストール（WezTerm で使用）

```bash
brew install --cask font-hackgen-console-nerd-font
```

### 3. LazyVim をインストール

```bash
# 既存の nvim 設定をバックアップ（ある場合）
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null

# LazyVim starter をクローン
git clone https://github.com/LazyVim/starter ~/.config/nvim

# LazyVim の .git を削除（このリポジトリで管理するため）
rm -rf ~/.config/nvim/.git
```

### 4. このリポジトリの設定ファイルを配置

```bash
# common ファイルを配置
cp -r common/.claude ~/
cp -r common/.config/wezterm ~/.config/
cp common/.config/nvim/lazyvim.json ~/.config/nvim/
cp -r common/.config/nvim/lua/config/* ~/.config/nvim/lua/config/
cp -r common/.config/nvim/lua/plugins ~/.config/nvim/lua/

# Mac 専用ファイルを配置（Karabiner）
cp mac/.config/karabiner/assets/complex_modifications/* \
  ~/.config/karabiner/assets/complex_modifications/
```

### 5. Rectangle のショートカットを設定

```bash
defaults write com.knollsoft.Rectangle leftHalf  -dict keyCode 123 modifierFlags 1048576
defaults write com.knollsoft.Rectangle rightHalf -dict keyCode 124 modifierFlags 1048576
defaults write com.knollsoft.Rectangle maximize  -dict keyCode 126 modifierFlags 1048576
```

### 6. Rectangle を起動してアクセシビリティ権限を付与

```bash
open -a Rectangle
```

システム設定 → プライバシーとセキュリティ → アクセシビリティ で Rectangle を許可する。

### 7. macOS のネイティブタイル表示を無効化

システム設定 → デスクトップと Dock → 「ウインドウを画面端にドラッグしてタイル表示」をオフ。

### 8. Karabiner のルールを有効化

Karabiner-Elements を起動 → Complex Modifications → Add rule から以下を有効化:
- `HHKB Mac設定 — WindowsとCtrlベースで操作を統一`
- `Shift+Space でIME切替`

### 9. LazyVim のプラグインをインストール

```bash
nvim
```

初回起動時にプラグインが自動インストールされる。完了後 `:q` で終了。

---

## Windows セットアップ手順

WezTerm は Windows 上で動作し、起動すると自動的に WSL に接続する構成。
nvim・Claude Code 等のツールは WSL (Ubuntu) 側にインストールする。

### 1. Windows 側: Scoop と WezTerm をインストール

PowerShell で実行:

```powershell
# Scoop（未インストールの場合）
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

# WezTerm
scoop bucket add extras
scoop install extras/wezterm
```

### 2. Windows 側: フォントをインストール（WezTerm で使用）

1. https://github.com/yuru7/HackGen/releases から最新の `HackGen_NF_vX.X.X.zip` をダウンロード
2. zip を展開し、`HackGenConsoleNF-Regular.ttf` を右クリック →「すべてのユーザー用にインストール」

### 3. Windows 側: WSL をインストール

PowerShell（管理者）で実行:

```powershell
wsl --install
```

再起動後、Ubuntu が起動するのでユーザー名とパスワードを設定する。

### 4. Windows 側: WezTerm の設定ファイルを配置

PowerShell で実行:

```powershell
New-Item -ItemType Directory -Force "$env:USERPROFILE\.config\wezterm"
Copy-Item common\.config\wezterm\wezterm.lua "$env:USERPROFILE\.config\wezterm\"
```

### 5. Windows 側: Claude Code のキーバインドを配置

```powershell
New-Item -ItemType Directory -Force "$env:USERPROFILE\.claude"
Copy-Item common\.claude\keybindings.json "$env:USERPROFILE\.claude\"
```

`Shift+Enter` で改行できない場合は `keybindings.json` のコメントアウトを外して
`shift+enter: chat:newline` を有効化する。

### 6. WSL 側: このリポジトリをクローン

WSL (Ubuntu) のターミナルで実行:

```bash
git clone https://github.com/keyroot-dev/dev-env ~/dev/dev-env
cd ~/dev/dev-env
# このPCからは push しないようにする
git remote set-url --push origin no-push
```

### 6. WSL 側: Neovim をインストール

```bash
# mise でインストール（推奨）
curl https://mise.run | sh
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
source ~/.bashrc
mise use --global neovim@latest
mise use --global lazygit@latest
```

### 7. WSL 側: LazyVim をインストール

```bash
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
```

### 8. WSL 側: 設定ファイルを配置

```bash
mkdir -p ~/.claude ~/.config/nvim/lua/config ~/.config/nvim/lua/plugins

cp common/.config/nvim/lazyvim.json ~/.config/nvim/
cp common/.config/nvim/lua/config/* ~/.config/nvim/lua/config/
cp -r common/.config/nvim/lua/plugins ~/.config/nvim/lua/

# Claude Code のキーバインド（WSL 側にも配置）
cp common/.claude/keybindings.json ~/.claude/
```

### 9. WSL 側: LazyVim のプラグインをインストール

```bash
nvim
```

初回起動時にプラグインが自動インストールされる。完了後 `:q` で終了。

---

## HHKB ディップスイッチ設定

| SW | 状態 | 理由 |
|---|---|---|
| SW1 | OFF | Mac モード |
| SW2 | ON | Mac モード |
| SW3 | ON | Delete キーを Delete として使う |
| SW4 | OFF | そのまま |
| SW5 | OFF | そのまま |
