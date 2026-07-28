**「再インストールが必要」とはまだ言えません。**
正確には、現在の `diagnose.sh` では **Command Line Toolsが存在することしか確認しておらず、バージョンや互換性までは診断できていない**、です。

現在の判定は実質これだけです。

```bash
if xcode-select -p >/dev/null 2>&1; then
    OK
fi
```

そのため、古いCommand Line Toolsでもパスが存在すれば `OK` になります。

## まず現在の状態を確認

次を順に実行するのがよいです。

```bash
pkgutil --pkg-info=com.apple.pkg.CLTools_Executables

xcrun --find clang
xcrun --sdk macosx --show-sdk-version

softwareupdate --list
```

Apple自身も、macOSのメジャーアップグレード後はCommand Line Toolsの更新を確認するよう案内しています。インストール済みバージョンは `pkgutil` で確認し、互換性のある更新は「ソフトウェアアップデート」または `softwareupdate` から入れるのが標準です。([Apple Developer][1])

判定は次のようになります。

```text
softwareupdateにCommand Line Toolsが表示される
→ 更新する。削除・再インストールは不要

更新が表示されない
＋ xcrunが正常
＋ brew doctorでCLT警告なし
→ 現在のままでよい

xcrunが失敗する
またはbrew doctorが不整合を報告する
→ 修復として再インストールを検討
```

再インストールは最後の手段です。

```bash
sudo rm -rf /Library/Developer/CommandLineTools
xcode-select --install
```

Appleもこの削除・再導入手順を案内していますが、正常に動いている環境で予防的に行う必要はありません。([Apple Developer][1])

## むしろHomebrew自体が古い可能性がある

先ほどHomebrewは、

```text
macOS 26
pre-release version
Tier 2
```

と表示していました。しかし、現在のHomebrew公式文書では、Apple Silicon上のmacOS Tahoe 26はTier 1に分類されています。([Homebrew Documentation][2])

したがってこれは、Command Line Toolsよりも、**放置されていたHomebrew本体が古い**可能性を示しています。まずこちらを更新した方がよいです。

```bash
brew update
brew config
brew doctor
```

その後に、

```bash
brew install git
```

を再実行してください。

## このリポジトリには、もう一つ判定上の穴がある

現在の診断は、

```bash
command -v git
```

が成功すれば `Git: OK` とします。

しかし、Command Line Toolsを入れるとApple提供のGitが、

```text
/usr/bin/git
```

として使えるようになります。そのため、**Homebrew版Gitが未導入でもOK判定になる**可能性があります。

インストールスクリプト側も、Gitが一つでも存在すれば終了するため、同じ問題があります。

現在の実体は次で確認できます。

```bash
type -a git
git --version
brew list --versions git
```

例えば、

```text
/usr/bin/git
```

だけならApple版です。

Homebrew版を入れた後は、通常Apple Silicon Macでは、

```text
/opt/homebrew/bin/git
/usr/bin/git
```

の順に見えるのが期待値です。

## `printf` エラーは別件

冒頭の、

```text
printf: --: invalid option
```

はCommand Line Toolsとは関係ありません。

区切り線を、

```bash
printf '----------\n'
```

としているため、先頭の `--` がオプションのように解釈されています。次のどちらかに修正できます。

```bash
printf -- '----------\n'
```

より移植性を意識するなら、こちらがきれいです。

```bash
printf '%s\n' '----------'
```

今回見つかった改善点は、少なくとも次の3つです。

```text
1. Command Line Toolsの存在だけでなく、バージョン・動作を確認する
2. Apple GitとHomebrew Gitを区別する
3. ハイフンから始まるprintf書式を修正する
```

現時点では、**CLTを再インストールする前に `softwareupdate --list`、`brew update`、`brew doctor` を実行する**のが正しい順序です。

[1]: https://developer.apple.com/documentation/xcode/installing-the-command-line-tools/?utm_source=chatgpt.com "Installing the command-line tools | Apple Developer Documentation"
[2]: https://docs.brew.sh/Support-Tiers?utm_source=chatgpt.com "Homebrew Documentation: Support Tiers"

```bash
yoshiyuki.kono@mbp development-bootstrap-macos-main % pkgutil --pkg-info=com.apple.pkg.CLTools_Executables

No receipt for 'com.apple.pkg.CLTools_Executables' found at '/'.
yoshiyuki.kono@mbp development-bootstrap-macos-main % xcrun --find clang

xcrun: error: invalid active developer path (/Library/Developer/CommandLineTools), missing xcrun at: /Library/Developer/CommandLineTools/usr/bin/xcrun
yoshiyuki.kono@mbp development-bootstrap-macos-main % xcrun --sdk macosx --show-sdk-version

xcrun: error: invalid active developer path (/Library/Developer/CommandLineTools), missing xcrun at: /Library/Developer/CommandLineTools/usr/bin/xcrun
yoshiyuki.kono@mbp development-bootstrap-macos-main % softwareupdate --list
Software Update Tool

Finding available software
Software Update found the following new or updated software:
* Label: macOS Tahoe 26.6-25G72
	Title: macOS Tahoe 26.6, Version: 26.6, Size: 3829595KiB, Recommended: YES, Action: restart, 
yoshiyuki.kono@mbp development-bootstrap-macos-main %
```

はい、ここまでの結果なら、**Command Line Toolsは再インストールが必要な状態**と判断できます。

単に古いというより、

```text
/Library/Developer/CommandLineTools
```

というディレクトリだけが残り、**パッケージ本体が欠落・破損している状態**です。

根拠はこの2点です。

```text
No receipt for 'com.apple.pkg.CLTools_Executables' found
```

これは、macOSがCommand Line Toolsを正規にインストール済みとして管理していないことを示します。

```text
missing xcrun at:
/Library/Developer/CommandLineTools/usr/bin/xcrun
```

こちらは決定的で、ツールチェーンの中心となる `xcrun` が存在しません。Appleの正規のCommand Line Toolsはこの場所にインストールされ、`pkgutil` でパッケージ情報を確認できるのが正常です。([Apple Developer][1])

## おすすめの順序

現在、macOS 26.6も提示されています。先にOSを26.6へ更新し、その後に26.6と互換性のあるCommand Line Toolsを入れるのがきれいです。AppleもmacOSアップグレード後には、対応するCommand Line Toolsの更新確認を求めています。([Apple Developer][1])

### 1. macOS 26.6へ更新

GUIから、

```text
システム設定
→ 一般
→ ソフトウェアアップデート
```

で更新して再起動します。

今回は約3.8GBのメジャーなパッチなので、ターミナルよりGUIで進める方が状態を把握しやすいでしょう。

### 2. 壊れたCommand Line Toolsを削除

再起動後、次を実行します。

```bash
sudo rm -rf /Library/Developer/CommandLineTools
```

これはAppleが案内しているCommand Line Toolsの正式なアンインストール方法です。([Apple Developer][1])

今回、パッケージレシートは存在しないので、

```bash
sudo pkgutil --forget com.apple.pkg.CLTools_Executables
```

は不要です。

続けて、壊れた選択情報をリセットします。

```bash
sudo xcode-select --reset
```

### 3. Command Line Toolsを再インストール

```bash
xcode-select --install
```

ダイアログが表示されたら、インストールを完了させます。

ダイアログが表示されない、または対応版が見つからない場合は、Apple Developerのダウンロードページから、macOS 26.6に対応するCommand Line Tools for Xcode 26系を手動で導入します。Appleはコマンド経由とダウンロードパッケージ経由の両方を正式な方法として案内しています。([Apple Developer][1])

## インストール後の検証

次をまとめて実行します。

```bash
xcode-select -p
pkgutil --pkg-info=com.apple.pkg.CLTools_Executables
xcrun --find clang
xcrun --sdk macosx --show-sdk-version
clang --version
git --version
```

期待する状態は、おおむね次です。

```text
xcode-select -p
→ /Library/Developer/CommandLineTools

pkgutil
→ package-id、version、install-timeなどが表示される

xcrun --find clang
→ /Library/Developer/CommandLineTools/usr/bin/clang

SDK version
→ 26.x

git --version
→ git version ...
```

必要なら選択先を明示できます。

```bash
sudo xcode-select --switch /Library/Developer/CommandLineTools
```

AppleもこのパスをCommand Line Toolsの選択先として案内しています。([Apple Developer][2])

その後に、

```bash
brew update
brew doctor
brew install git
```

と進めます。Homebrewの正式サポート環境には、正常で最新のCommand Line Toolsが必要です。([Homebrew Documentation][3])

## 今回の診断スクリプトが見逃した理由

現在のリポジトリは、

```bash
if xcode-select -p >/dev/null 2>&1; then
    ok
fi
```

という判定なので、

```text
パスが設定されている
```

ことしか見ていません。

今回の状態は、

```text
パスはある
ディレクトリもある
しかし中身とパッケージ情報が壊れている
```

なので、誤って `OK` になりました。

Gitも同じです。現在の診断は `command -v git` が成功すればOKですが、macOSの `/usr/bin/git` はCommand Line Toolsを呼び出す入口だけ存在する場合があります。そのため、実際に `git --version` が成功するかまで判定すべきです。

診断としては、少なくとも次の確認が必要です。

```bash
xcode-select -p >/dev/null 2>&1 &&
pkgutil --pkg-info=com.apple.pkg.CLTools_Executables >/dev/null 2>&1 &&
xcrun --find clang >/dev/null 2>&1 &&
xcrun --sdk macosx --show-sdk-version >/dev/null 2>&1
```

つまり今回発見したのは、単なる「陳腐化チェック不足」より一段深く、

> **存在確認では、壊れたインストールを正常と誤判定する**

という診断設計上の欠陥です。OS 26.6更新後にCLTを再導入し、正式にcloneできるようになった段階で、このチェックをリポジトリへ反映する価値があります。

[1]: https://developer.apple.com/documentation/xcode/installing-the-command-line-tools/?utm_source=chatgpt.com "Installing the command-line tools | Apple Developer Documentation"
[2]: https://developer.apple.com/documentation/xcode/configuring-command-line-tools-settings?changes=_8&utm_source=chatgpt.com "Configuring command-line tools settings | Apple Developer Documentation"
[3]: https://docs.brew.sh/Installation?utm_source=chatgpt.com "Homebrew Documentation: Installation"
