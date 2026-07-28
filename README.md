# development-bootstrap-macos

Executable notes for preparing a macOS machine for development.

The repository is intentionally conservative:

- `diagnose.sh` changes nothing.
- Each failed check points to one small script.
- Setup scripts avoid overwriting existing configuration.
- Read a script before running it; the script is also the documentation.

## First run

```bash
chmod +x diagnose.sh base/*.sh shell/*.sh ssh/*.sh optional/rancher-desktop/*.sh
./diagnose.sh
```

Then open and run only the scripts referenced by failed checks.

## Coverage

- macOS and CPU architecture
- Xcode Command Line Tools
- Homebrew
- Git and GitHub CLI
- Python, uv, Neovim, Visual Studio Code
- zsh and Homebrew shell initialization
- SSH key, agent configuration, GitHub key registration, authentication test
- Optional Rancher Desktop, Kubernetes CLI tools, and local-cluster verification

## Deliberate boundary

Git identity, Git defaults, repository initialization, and routine Git/GitHub repository operations live in `development-bootstrap-git`.

はい、**HTTPでZIPを取得して一時展開するのが、この場合の正しい「Stage 0」**だと思います。ちょっとしたブートストラップの鶏と卵ですね。

このリポジトリは、まず診断だけを行い、失敗した項目に対応する小さなスクリプトだけを読む・実行する設計です。実際、Command Line Tools用スクリプトは `xcode-select --install` を呼び出すだけで、Gitの導入スクリプトはその後に `brew install git` を実行します。

## 利用方法例

ターミナルから一時ディレクトリへ取得すると、ダウンロードフォルダに残骸が残りません。

```bash
tmpdir="$(mktemp -d)"

curl -fL \
  https://github.com/YoshiyukiKono/development-bootstrap-macos/archive/refs/heads/main.zip \
  -o "$tmpdir/development-bootstrap-macos.zip"

ditto -x -k \
  "$tmpdir/development-bootstrap-macos.zip" \
  "$tmpdir"

cd "$tmpdir/development-bootstrap-macos-main"

chmod +x diagnose.sh base/*.sh shell/*.sh ssh/*.sh \
  optional/rancher-desktop/*.sh
```

`curl` と `ditto` はmacOSに最初からあります。`ditto -x -k` はZIP展開です。

内容を確認します。

```bash
less README.md
less base/install-command-line-tools.sh
less base/install-git.sh
```

そして、まず現在必要なものだけ実行します。

```bash
bash base/install-command-line-tools.sh
```

これはリポジトリ内の内容どおり、実質的には次と同じです。

```bash
xcode-select --install
```

インストール完了後：

```bash
xcode-select -p
brew install git
git --version
```

## ZIP展開物の位置づけ

GitHubからダウンロードしたZIPは、あくまで**ある時点のスナップショット**です。

```text
development-bootstrap-macos-main/
```

の中には、次がありません。

```text
.git/
コミット履歴
remote設定
ブランチ情報
```

したがって、そのフォルダでは通常の意味で、

```bash
git status
git pull
git log
```

は使えません。

今回のZIP展開物は、

```text
内容を読む
↓
Command Line Toolsを導入
↓
Gitを導入
↓
役目を終えたら削除
```

という使い捨てのブートストラップ媒体と考えるのがきれいです。

作業が終わったら、どのディレクトリにいてもよい場所へ移動してから削除します。

```bash
cd ~
rm -rf "$tmpdir"
unset tmpdir
```

`tmpdir` を削除すると、ZIPと展開フォルダの両方が消えます。

## その後、正式にcloneする

Gitを導入できたら、先ほど決めた構成に正式な作業コピーを置きます。

```bash
mkdir -p ~/dev/github.com/YoshiyukiKono
cd ~/dev/github.com/YoshiyukiKono

git clone \
  git@github.com:YoshiyukiKono/development-bootstrap-macos.git
```

まだSSH設定前なら、最初だけHTTPSでも構いません。

```bash
git clone \
  https://github.com/YoshiyukiKono/development-bootstrap-macos.git
```

clone後：

```bash
cd development-bootstrap-macos

chmod +x diagnose.sh base/*.sh shell/*.sh ssh/*.sh \
  optional/rancher-desktop/*.sh

./diagnose.sh
```

これは現在のREADMEに記載された正式な開始手順です。

## ブラウザからダウンロードする場合

GitHubの画面で、

```text
Code
→ Download ZIP
```

を選ぶ方法でも問題ありません。

Safariの設定によっては、自動的に展開されて、

```text
~/Downloads/development-bootstrap-macos-main/
```

だけが残ることがあります。ZIP自体も残る場合は、

```text
development-bootstrap-macos-main.zip
```

と展開フォルダの両方を、Git導入後に削除して構いません。

ただし、ZIP版をそのまま `~/dev/github.com/YoshiyukiKono/` に永続配置するのは避けた方がよいです。後からそれがGit cloneなのか、単なる展開物なのか分かりにくくなります。

## リポジトリに追加する価値がある説明

現在のREADMEは「リポジトリを既に取得している」ことから始まっています。 その前に、次のような章があると、このブートストラップ問題を自分自身で解決できます。

````markdown
## Stage 0: Bootstrap without Git

If Git is not available yet, download a temporary archive using
macOS built-in tools:

```bash
tmpdir="$(mktemp -d)"
curl -fL \
  https://github.com/YoshiyukiKono/development-bootstrap-macos/archive/refs/heads/main.zip \
  -o "$tmpdir/repository.zip"
ditto -x -k "$tmpdir/repository.zip" "$tmpdir"
cd "$tmpdir/development-bootstrap-macos-main"
````

Review and run the required scripts. After Git is installed, delete
this temporary copy and clone the repository normally.

```
**ZIP版は仮設足場、Git clone版が正式な作業コピー**という整理が最も自然です。


