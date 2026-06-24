# Dotfiles

macOS開発環境の自動セットアップ用dotfiles管理システム

## 概要

このリポジトリには、macOS上で一貫した開発環境を自動的にセットアップするための設定ファイルとスクリプトが含まれています。GNU Stowによるシンボリックリンク管理とHomebrewによるパッケージ管理を使用しています。

## 特徴

- 🚀 **ワンコマンドセットアップ**: 自動インストールと設定
- 📦 **パッケージ管理**: Brewfileによる一貫性のあるパッケージバージョン管理
- 🔗 **設定ファイル管理**: GNU Stowによるクリーンなシンボリックリンク管理
- 🏗️ **ランタイム管理**: asdfによる複数言語バージョン管理
- 🎨 **シェルカスタマイズ**: starshipプロンプトとpecoを統合した強化zsh
- 🖥️ **ターミナル設定**: Alacrittyターミナルエミュレータの設定
- ⚡ **Git統合**: 最適化されたgitエイリアスと設定

## クイックスタート

### 前提条件

- macOS (macOS 10.15+でテスト済み)
- インターネット接続
- Xcode Command Line Toolsは自動でインストールされます

### インストール

```bash
# GitHubから直接インストールスクリプトを実行（推奨）
curl -fsSL https://raw.githubusercontent.com/YFurusawa727/dotfiles/main/install | bash
```

または、gitが既にインストール済みの場合：

```bash
git clone https://github.com/YFurusawa727/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install
```

### セットアップフロー

1. **Homebrewインストール** - 開発ツールのパッケージマネージャー
2. **パッケージインストール** - 必要な開発ツールとアプリケーション
3. **環境変数設定** - git設定のための個人情報入力（インタラクティブ）
4. **既存設定の取り込み** - 既存の設定ファイルをdotfilesに自動統合
5. **設定ファイル配置** - GNU Stowによるシンボリックリンク作成
6. **ランタイムセットアップ** - asdfによる言語環境構築

### 環境変数

インストール時に自動的に個人情報の入力が求められます：

```bash
📝 Please configure your personal information:
Would you like to set your git configuration now? (y/n): y
Enter your full name: あなたの名前
Enter your email: your.email@example.com
```

手動で設定する場合：

```bash
# .envファイルを編集
cd ~/dotfiles
cp .env.example .env
# .envを編集してGIT_USER_NAMEとGIT_USER_EMAILを設定
```

## インストールされるもの

### Homebrewパッケージ

**開発ツール:**
- `asdf` - ランタイムバージョンマネージャー
- `git` - バージョン管理システム
- `stow` - シンボリックリンクマネージャー
- `starship` - クロスシェルプロンプト
- `peco` - インタラクティブフィルタリングツール
- `coreutils` - GNU コアユーティリティ

**アプリケーション:**
- `alacritty` - GPU加速ターミナル
- `visual-studio-code` - コードエディタ
- `google-chrome` - ウェブブラウザ
- `docker` - コンテナプラットフォーム
- `slack` - コミュニケーションツール
- その他多数 ([Brewfile](./Brewfile)を参照)

### 設定ファイル

- **Git**: エイリアスとユーザー設定
- **Zsh**: カスタム関数付きシェル設定
- **Bash**: 共通エイリアスとショートカット
- **Starship**: カスタムプロンプト設定
- **Alacritty**: ターミナルエミュレータ設定
- **asdf**: ランタイムバージョン (Node.js, Python, Firebase CLI)

## ファイル構造

```
dotfiles/
├── README.md              # このファイル
├── install               # メインインストールスクリプト
├── Brewfile              # Homebrewパッケージ定義
├── Brewfile.lock.json    # Homebrewロックファイル
├── test_install.sh       # インストールテストスクリプト
├── validate.sh           # 設定検証スクリプト
├── .env.example          # 環境変数の例
└── packages/             # アプリケーション別設定ファイル
    ├── alacritty/        # ターミナルエミュレータ設定
    ├── asdf/             # ランタイムバージョン定義
    ├── bash/             # Bashエイリアスと関数
    ├── git/              # Git設定とエイリアス
    ├── starship/         # シェルプロンプト設定
    └── zsh/              # Zshシェル設定
```

## 使用方法

### 日常的なコマンド

設定には便利なエイリアスが含まれています：

```bash
# ナビゲーション
..          # cd ..
..2         # cd ../..
..3         # cd ../../..

# Gitショートカット
g           # git
ll          # clear && ls -alF

# Dotfiles管理
dotinstall  # インストールスクリプトの再実行
page        # ウェブページをインタラクティブに開く

# 検証・テストコマンド
dotcheck            # 事前検証（結果のみ）
dotvalidate         # 事前検証（詳細表示）
dottest             # インストール後テスト（サマリー表示）
dottest-full        # インストール後テスト（詳細表示）
dottest-summary     # 各テストの成功/失敗一覧表示
```

### シェル機能

- **Ctrl+R**: pecoによるインタラクティブな履歴検索
- **Ctrl+E**: pecoによるインタラクティブなディレクトリナビゲーション
- **Starshipプロンプト**: gitステータス、ランタイムバージョンなどを表示

## カスタマイズ

### 新しいパッケージの追加

1. `Brewfile`にパッケージを追加:
   ```ruby
   brew "package-name"
   cask "application-name"
   ```

2. インストールスクリプトを実行:
   ```bash
   ./install
   ```

### 新しい設定の追加

1. アプリケーション用のディレクトリを`packages/`に作成
2. 設定ファイルを追加
3. `install`スクリプトの`stow`コマンドを更新して新しいパッケージを含める

### ランタイムバージョン

言語バージョンを変更するには`packages/asdf/.tool-versions`を編集:

```
nodejs 22.18.0
python 3.12.3
firebase 14.12.1
```

## トラブルシューティング

### よくある問題

**権限拒否エラー:**
```bash
chmod +x ~/dotfiles/install
```

**Homebrewインストールの失敗:**
- インターネット接続を確認
- Xcode Command Line Toolsがインストールされていることを確認: `xcode-select --install`

**Stowの競合:**
```bash
# 競合するファイルを手動で削除
rm ~/.gitconfig
./install
```

**asdfプラグインの問題:**
```bash
# 問題のあるプラグインを手動で追加
asdf plugin add nodejs
asdf install nodejs
```

### 検証

すべてが正しくインストールされているかを確認:

```bash
# Homebrewパッケージの確認
brew list

# stowリンクの確認
stow -v -d ~/dotfiles/packages -t ~ git asdf zsh bash starship alacritty

# asdfランタイムの確認
asdf current

# 設定の検証（インストール前チェック）
./validate.sh

# インストールテスト（インストール後チェック）
./test_install.sh

# または簡単なエイリアス
dotcheck            # 事前検証（結果のみ）
dottest             # インストール後テスト（サマリー）
dottest-full        # 詳細テスト結果  
dottest-summary     # 成功/失敗一覧
```

## テスト・検証

### 事前検証（インストール前）
```bash
# クイック検証（推奨）
dotcheck

# 詳細検証
dotvalidate

# または直接実行
./validate.sh
```

### 事後テスト（インストール後）
```bash
# クイックテスト（推奨）
dottest

# 詳細テスト
dottest-full

# 問題特定用
dottest-summary
```

### 推奨ワークフロー
```bash
# 1. 設定変更前の事前チェック
dotcheck

# 2. 設定ファイルの編集
vim Brewfile  # または他の設定ファイル

# 3. 変更後の検証  
dotcheck

# 4. 変更適用（必要に応じて）
dotinstall

# 5. 最終確認
dottest
```

### 継続的品質管理
- すべての設定変更後に`dotcheck`→`dottest`の実行を推奨
- `test_results.log`で詳細な履歴を確認可能
- カラーコードなしのクリーンなログファイル
- 事前検証により問題を未然に防止

## 既存設定ファイルの取り扱い

### **自動統合機能**
インストール時に既存の設定ファイルが自動的にdotfilesに取り込まれます：

```bash
# インストール実行時の動作
# 1. .gitconfig.example から個人用 .gitconfig を作成（初回のみ）
# 2. 環境変数があれば自動的に名前・メールを設定
# 3. 既存の ~/.zshrc があれば ~/dotfiles/packages/zsh/.zshrc にコピー  
# 4. シンボリックリンクを作成して dotfiles での管理開始
```

### **利点**
- ✅ **データ損失なし**: 既存設定が完全に保持される
- ✅ **即座に利用可能**: 今の設定のまま dotfiles 管理に移行
- ✅ **段階的カスタマイズ**: 後から徐々に dotfiles の機能を活用可能
- ✅ **プライバシー保護**: 個人情報がリポジトリに記録されない安全な設計

### **確認・編集方法**
```bash
# git設定を確認・編集（個人情報は安全にローカル管理）
cat ~/dotfiles/packages/git/.gitconfig
vim ~/dotfiles/packages/git/.gitconfig

# その他の設定を確認
cat ~/dotfiles/packages/zsh/.zshrc

# 設定をカスタマイズ
vim ~/dotfiles/packages/git/.gitconfig
# 変更は即座に反映される（シンボリックリンクのため）
```

## セキュリティに関する考慮事項

- **個人情報保護**: 
  - `.env`ファイルはgit管理外で個人情報を安全に管理
  - `.gitconfig`は個別作成でリポジトリに個人情報が含まれない
  - `.gitconfig.example`をテンプレートとして提供
- **既存設定の安全性**: 既存設定の自動取り込みによりデータ損失を防止
- **スクリプト検証**: 外部スクリプトは実行前に検証
- **エラーハンドリング**: 部分的なインストールを防止する包括的なエラー処理
- **権限管理**: 必要最小限の権限で実行
