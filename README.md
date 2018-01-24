## swap-live10-japanese-font
An auto-install script to swap Japanese fonts in Ableton Live 10.

Live 10用日本語フォントを任意のフォントに置き換えるスクリプトです。

### はじめに
Live 10のフォントの日本語部分はNoto Sans CJK JPフォントが使用されていますが、以下の点を改善すべく色々なフォントを試す事を目的としたスクリプトです。
 - 私個人の環境(retina 27inch 5k Liveでのスケール120%)では読み辛い、細すぎ。
 - ブラウザにおいて英字とのバランスが悪く、間延びした感。

幸い日本語/英字で別々のフォントファイルが使用されているため、デバイス、セッション、アレンジビュー等その他のUIに影響を与える事なく日本語部分だけを変更する事が可能なようです。
また日本語フォントファイルはファイル名のみで参照されており容易に置き換え可能でした。

### 実行環境

macOSでの実行をサポートします。Live 10が```/Applications```フォルダにインストールされている必要があります。
また、ttfファイルを使用する場合、fontforgeがインストールされている事を前提とします。

homebrewでのインストール例:
```
brew install fontforge
mkdir -p ~/Library/Python/2.7/lib/python/site-packages
echo 'import site; site.addsitedir("/usr/local/lib/python2.7/site-packages")' >> ~/Library/Python/2.7/lib/python/site-packages/homebrew.pth
```

### フォントのインストール
Liveが閉じている事を確認し、ターミナルでスクリプトを実行してください。
```
./swap-live10-japanese-fonts.sh [-e edition] regular_font bold_font
```
 - -e edition
 Liveアプリケーション名の接尾語(beta|intro|lite|standard|suite)を指定します。省略時デフォルトは"suite"です。
 - regular_font
 Regularフォントのパスを指定します。指定可能なファイルの拡張子は.ttfまたは.otfです。
 - bold_font
 Boldフォントのパスを指定します。指定可能なファイルの拡張子は.ttfまたは.otfです。
 - ttfファイルを指定した場合、otfファイルへ変換を行います。
 - 変更前の元ファイルは.origの拡張子を付け退避します。既に退避したファイルがある場合は上書きしません。

実行例:
```
./swap-live10-japanese-fonts.sh -e beta mgenplus-2cp-medium.ttf mgenplus-2cp-heavy.ttf
```

以下の2ファイルが置き換えられます。
```
/Applications/Ableton Live 10 Beta.app/Contents/App-Resources/Fonts/NotoSansCJKjp-Regular.otf
/Applications/Ableton Live 10 Beta.app/Contents/App-Resources/Fonts/NotoSansCJKjp-Bold.otf
```

### アンインストール
変更前のファイル.origを元に戻します。
```
./swap-live10-japanese-fonts.sh [-e edition] -u
```

### サンプル
#### 変更前 NotoSans CJK JP Regular/Bold
<img src="https://raw.githubusercontent.com/jhorology/swap-live10-japanese-font/img/img/before.png" width="525"/>

#### 変更後 Mgen+ 2cp Medium/HEavy
<img src="https://raw.githubusercontent.com/jhorology/swap-live10-japanese-font/img/img/after.png" width="524"/>

### Notes
 - 本スクリプトおよび生成されたフォントの使用に関連する障害その他一切の責任は使用者が負うものとします。
 - 本スクリプトの改定、配布は自由に行ってください。筆者への連絡不要です。
