**今のVS Codeをそのまま使い、`code` コマンドだけ有効化するのがよいです。**
Homebrew版を重ねて入れる必要はありません。

現在の状態は、

```text
/Applications/Visual Studio Code.app  ← 既にある
code コマンド                         ← PATHにない
```

というだけです。リポジトリの `install-vscode.sh` も、この状態では再インストールせず、VS Code内から `code` コマンドを有効化する設計になっています。

## 推奨手順

VS Codeを開き、`Command + Shift + P` でコマンドパレットを開きます。

次を検索して実行します。

```text
Shell Command: Install 'code' command in PATH
```

日本語UIでも、`shell command` や `code` で検索すれば見つかるはずです。これはmacOSにおけるVS Code公式の方法です。実行後、新しいターミナルを開き直します。([Visual Studio Code][1])

確認：

```bash
command -v code
code --version
```

期待値は通常、

```text
/usr/local/bin/code
```

または環境によって別のPATH上のリンクと、VS Codeのバージョンです。

さらに、

```bash
cd ~/dev
code .
```

で、現在のフォルダをVS Codeで開ければ完了です。

## Homebrew版へ入れ直す意味はあるか

Homebrew Cask版は、

```bash
brew install --cask visual-studio-code
```

で導入できます。([Homebrew Formulae][2])

ただし、すでに `/Applications/Visual Studio Code.app` がある場合、Homebrew管理へ移すためだけに再インストールする利益は大きくありません。既存アプリとの衝突や上書き確認が発生する可能性もあるため、今回は避ける方が素直です。

Homebrew管理に統一するなら、

```text
既存VS Codeを削除
→ brew install --cask visual-studio-code
```

という移行になりますが、VS Codeには自身の自動更新機能もあるため、現在のインストール方式のままでも問題ありません。([Visual Studio Code][1])

## 今回の診断結果の意味

```text
MISSING Visual Studio Code is installed, but the 'code' command is not on PATH
```

は、「VS Codeが欠けている」という意味ではありません。

```text
GUIアプリ：OK
CLI連携：未設定
```

という診断です。したがって、リポジトリの案内どおり、`install-vscode.sh` を読むだけでもよく、実際の作業はコマンドパレットからの有効化です。

結論として、**brew版は入れず、既存VS Codeで `Shell Command: Install 'code' command in PATH` を実行**するのが今回の最適解です。

[1]: https://code.visualstudio.com/docs/setup/mac?...=&utm_source=chatgpt.com "Visual Studio Code on macOS"
[2]: https://formulae.brew.sh/cask/visual-studio-code?utm_source=chatgpt.com "Homebrew Formulae: visual-studio-code"
