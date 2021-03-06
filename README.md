## swap-live10-japanese-font
An auto-install script to swap Japanese fonts in Ableton Live 10.

Live 10用日本語フォントを任意のフォントに置き換えるスクリプトです。

### はじめに
Live 10のフォントの日本語部分はNoto Sans CJK JPフォントが使用されていますが、以下の点を改善すべく色々なフォントを試す事を目的としたスクリプトです。
 - 私個人の環境(retina 27inch 5k Liveでのスケール120%)では読み辛い、細すぎ。
 - ブラウザにおいてカタカナが等幅なため英字とのバランスが悪く、間延びした感。
 - なぜかPush2用の日本語フォントはインストールされておらず、おそらくQtのfallbackでOSのフォントが使用されておりWindowsとmacOSで違うフォントが使われるという...

幸いLive10では日本語/英字で別々のフォントファイルが使用されているため、デバイス、セッション、アレンジビュー等その他のUIに影響を与える事なく日本語部分だけを変更する事が可能なようです。
また日本語フォントファイルはファイル名のみで参照されており容易に置き換え可能でした。Push2用のフォントは日本語フォントをオリジナルフォントにマージしています。

### 実行環境

macOSおよびcygwinでの実行をサポートします。Live 10が標準のフォルダにインストールされている必要があります。
また、ttfファイルを使用する場合とPush2用のフォントを指定する場合、fontforgeがインストールされている事を前提とします。

homebrewでのインストール例:
```
brew install fontforge
mkdir -p ~/Library/Python/2.7/lib/python/site-packages
echo 'import site; site.addsitedir("/usr/local/lib/python2.7/site-packages")' >> ~/Library/Python/2.7/lib/python/site-packages/homebrew.pth
```

### フォントのインストール
Liveが閉じている事を確認し、ターミナルでスクリプトを実行してください。
```
swap-live10-japanese-fonts.sh [-v version] [-e edition] [-s scale_ratio] regular_font bold_font [push2_browser_font]
```
 - -e edition
 
 Liveアプリケーション名の接尾語(beta|intro|lite|standard|suite)を指定します。省略時デフォルトは"suite"です。
 
 - -v version
 
 Liveアプリケーション名に含まれるバージョンを指定します。省略時デフォルトは"10.1"です。
 
 - -s scale_ratio
 
 push2_browser_fontの日本語フォント/オリジナルフォントの比率をパーセンテージで指定します。省略時デフォルトは100です。"オーディオエフェクト"長すぎ！

- regular_font
 
 Live10で使用する日本語Regularフォントのパスを指定します。指定可能なファイルの拡張子は.ttfまたは.otfです。
指定したフォントをNotoSansCJKjp-Regular.otfに置き換えます。

- bold_font

Live10で使用する日本語Boldフォントのパスを指定します。指定可能なファイルの拡張子は.ttfまたは.otfです。
指定したフォントをNotoSansCJKjp-Bold.otfに置き換えます。

- push2_browser_font オプショナル

Push2のブラウザで使用する日本語フォントのパスを指定します。指定可能なファイルの拡張子は.ttfまたは.otfです。
指定したフォントをオリジナルのAbletonSansLight-Regular.otfとマージし置き換えます。

- ttfファイルを指定した場合、otfファイルへ変換を行います。

- 変更前の元フォントファイルは.origの拡張子を付け退避します。既に退避したファイルがある場合は上書きしません。

実行例:
```
swap-live10-japanese-fonts.sh -e suite -s 80 mgenplus-2cp-medium.ttf mgenplus-2cp-heavy.ttf　mgenplus-2cp-regular.ttf
```
```
# This is my best settings.
swap-live10-japanese-fonts.sh -v 10.1 -e beta -s 90 Yu\ Gothic\ UI\ Semibold.ttf Yu\ Gothic\ UI\ Bold.ttf Yu\ Gothic\ UI\ Regular.ttf
```

以下の2ファイルとオプションでpush2用の1ファイルが置き換えられます。
```
/Applications/Ableton Live ${LIVE10_VERSION} ${LIVE10_EDITION}.app/Contents/App-Resources/Fonts/NotoSansCJKjp-Regular.otf
/Applications/Ableton Live ${LIVE10_VERSION} ${LIVE10_EDITION}.app/Contents/App-Resources/Fonts/NotoSansCJKjp-Bold.otf
/Applications/Ableton Live ${LIVE10_VERSION} ${LIVE10_EDITION}.app/Contents/Push2/Push2DisplayProcess.app/Contents/Push2/qml/Ableton/Appearance/fonts/AbletonSansLight-Regular.otf
```

### アンインストール
変更前のファイル.origを元に戻します。
```
swap-live10-japanese-fonts.sh [-v version] [-e edition] -u
```

### サンプル
#### 変更前 NotoSans CJK JP Regular/Bold Retina Display Scale 120%
<img src="https://raw.githubusercontent.com/jhorology/swap-live10-japanese-font/img/img/before.png" width="525"/>

#### 変更例 Mgen+ 2cp Medium/Heavy Retina Display Scale 120%
<img src="https://raw.githubusercontent.com/jhorology/swap-live10-japanese-font/img/img/mgenplus.png" width="524"/>

#### 変更例 GenEi Gothic P SemiBold/Heavy Retina Display Scale 120%
<img src="https://raw.githubusercontent.com/jhorology/swap-live10-japanese-font/img/img/genei.png" width="525"/>

### Notes
 - Push2用フォントのマージにおいて指定するフォントによってはうまくいかずfontoforgeが落ちます(GenEiGothicP等)。
 - 本スクリプトおよび生成されたフォントの使用に関連する障害その他一切の責任は使用者が負うものとします。
 - 本スクリプトの改定、配布は自由に行ってください。筆者への連絡不要です。
