# HHKB キーボード統一セットアップ 設計書

## 前提条件

- キーボード: HHKB Professional HYBRID Type-S 英字配列
- 開発環境: WezTerm + LazyVim + ブラウザ

## ディップスイッチ設定

| SW | 状態 | 理由 |
|---|---|---|
| SW1 | OFF | Mac モードにするため |
| SW2 | ON | Mac モード。Mac/Windows 両対応 |
| SW3 | ON | Delete キーを Delete として使う |
| SW4 | OFF | ◇キーをそのまま使う |
| SW5 | OFF | Alt と Opt の位置をそのまま |

## 設計方針

**「◇キーと Ctrl キーを起点に、Mac も Windows も同じ指の動きで操作する」**

- Mac: ◇=Cmd、Karabiner で Ctrl→Cmd に変換（ターミナル除外）
- Windows: ◇=Win キー、Ctrl 中心が標準なのでキーリマップ不要
- ターミナル内（WezTerm）は Ctrl をそのまま通す（SIGINT 等が壊れないように）
- WezTerm と LazyVim の設定ファイルは両 OS 共通で使う

---

## 操作の統一一覧

| やりたいこと | 押すキー | Mac が受け取る | Windows が受け取る |
|---|---|---|---|
| アプリ切替 | ◇+Tab | Cmd+Tab | Alt+Tab |
| IME 切替 | Shift+Space | IME 切替（Karabiner が処理） | OS 設定で管理 |
| ブラウザ 次のタブ | Ctrl+Tab | そのまま動く | そのまま動く |
| ブラウザ 前のタブ | Ctrl+Shift+Tab | そのまま動く | そのまま動く |
| 新規タブ | Ctrl+T | Cmd+T（Karabiner が変換） | Ctrl+T（そのまま） |
| タブを閉じる | Ctrl+W | Cmd+W（Karabiner が変換） | Ctrl+W（そのまま） |
| アドレスバー | Ctrl+L | Cmd+L（Karabiner が変換） | Ctrl+L（そのまま） |
| コピー | Ctrl+C | Cmd+C（Karabiner が変換） | Ctrl+C（そのまま） |
| 貼付 | Ctrl+V | Cmd+V（Karabiner が変換） | Ctrl+V（そのまま） |
| 切取 | Ctrl+X | Cmd+X（Karabiner が変換） | Ctrl+X（そのまま） |
| 取消 | Ctrl+Z | Cmd+Z（Karabiner が変換） | Ctrl+Z（そのまま） |
| 保存 | Ctrl+S | Cmd+S（Karabiner が変換） | Ctrl+S（そのまま） |
| 全選択 | Ctrl+A | Cmd+A（Karabiner が変換） | Ctrl+A（そのまま） |
| ウィンドウ左半分 | ◇+← | Cmd+←（Rectangle） | Win+←（そのまま） |
| ウィンドウ右半分 | ◇+→ | Cmd+→（Rectangle） | Win+→（そのまま） |
| ウィンドウ最大化 | ◇+↑ | Cmd+↑（Rectangle） | Win+↑（そのまま） |
| ターミナル タブ操作 | Ctrl+Space → t/w/[/] | WezTerm が処理 | WezTerm が処理 |
| ターミナル ペイン操作 | Ctrl+Space → h/j/k/l | WezTerm が処理 | WezTerm が処理 |
| SIGINT | Ctrl+C（ターミナル内） | そのまま | そのまま |
| Vim ノーマルモード | Ctrl+[（ターミナル内） | そのまま | そのまま |

---

## 各ツールの役割

### Karabiner-Elements（Mac のみ）

ターミナル以外のアプリで Ctrl+[key] → Cmd+[key] に変換する。

**除外アプリ（ターミナル内では Ctrl をそのまま通す）**
- `com.github.wez.wezterm`
- `com.apple.Terminal`
- `io.alacritty`

### Rectangle（Mac のみ）

◇+←/→/↑ でウィンドウを左半分・右半分・最大化する。

### WezTerm（両 OS 共通）

Leader = `Ctrl+Space`

| 操作 | キー |
|---|---|
| 新規タブ | Leader + t |
| タブを閉じる | Leader + w |
| タブ左移動 | Leader + [ |
| タブ右移動 | Leader + ] |
| 上下分割 | Leader + - |
| 左右分割 | Leader + \ |
| ペイン移動 | Leader + h/j/k/l |
| ペインを閉じる | Leader + x |
| コピーモード | Leader + v |

### LazyVim（両 OS 共通）

LazyVim のデフォルトキーバインドをベースに使う。

**追加設定**

| 操作 | キー |
|---|---|
| システムクリップボードにコピー | Leader+y |
| システムクリップボードから貼付 | Leader+p |
| ファイラ（oil.nvim）を開く | - |
