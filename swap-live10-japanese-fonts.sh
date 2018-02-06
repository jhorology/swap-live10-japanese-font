#!/bin/bash -e

# PWD=`dirname $0`
# cd ${PWD}

# functions
usage_exit() {
    echo
    echo "Usage:"
    echo "  To install: $0 [-e edition] regular_font bold_font [push2_browser_font]" 1>&2
    echo "    edition: beta|lite|intro|standard|suite   default=suite" 1>&2
    echo
    echo "  To uninstall: $0 -u" 1>&2
    echo
    exit 1
}

capitalize_word() {
    echo "$(tr '[:lower:]' '[:upper:]' <<< ${1:0:1})$(tr '[:upper:]' '[:lower:]' <<< ${1:1})"
}

validate_src_font() {
    echo $1
    if [ ! -f "$1" ]; then
        echo "font:$1 does not exit."
        usage_exit
    fi
    FONT_EXT=${1##*.}
    if [ $FONT_EXT = 'ttf' ] || [ $FONT_EXT = 'TTF' ]; then
        true
    elif [ $FONT_EXT = 'otf' ] || [ $FONT_EXT = 'OTF' ]; then
         false
    else
        echo "font:$1 is unsupported file type."
        usage_exit
    fi
}

#  $1: src ttf font file
#  $2: dest otf font file
ttf2otf() {
    fontforge -c '
import fontforge
font = fontforge.open("'"${1}"'")
font.generate("'"${2}"'")
'
}

#  $1: original font path
#  $2: japanese font path
#  $3: save path
merge_font () {
    fontforge -c '
import fontforge
font = fontforge.open("'"${1}"'")
font.mergeFonts("'"${2}"'")
font.generate("'"${3}"'")
'
}

if [ ! "`uname`" = "Darwin" ]; then
    echo
    echo "Unsupported architecture. this script support only macOS."
    echo
    exit 1
fi

num=$(ps aux | grep 'Ableton Live 10' | wc -l)
if [ $num -gt 1 ]; then
    echo
    echo "Ableton Live is running, please close it."
    echo
    exit 1
fi
# options
LIVE10_EDITION='Suite'
UNINSTALL=false
while getopts e:hu OPT
do
    case $OPT in
        e)  LIVE10_EDITION=`capitalize_word $OPTARG`
            ;;
        u)  UNINSTALL=true
            ;;
        h)  usage_exit
            ;;
        \?) usage_exit
            ;;
    esac
done
shift $((OPTIND - 1))
JP_REGULAR_FONT=$1
JP_BOLD_FONT=$2
JP_PUSH2_FONT=$3

LIVE10_FONTS_DIR="/Applications/Ableton Live 10 ${LIVE10_EDITION}.app/Contents/App-Resources/Fonts"
PUSH2_FONTS_DIR="/Applications/Ableton Live 10 ${LIVE10_EDITION}.app/Contents/Push2/Push2DisplayProcess.app/Contents/Push2/qml/Ableton/Appearance/fonts"
LIVE10_REGULAR_OTF=NotoSansCJKjp-Regular.otf
LIVE10_BOLD_OTF=NotoSansCJKjp-Bold.otf
PUSH2_BROWSER_OTF=AbletonSansLight-Regular.otf

# uninstall
if $UNINSTALL ; then
    if [ -f "${LIVE10_FONTS_DIR}/${LIVE10_REGULAR_OTF}.orig" ]; then
        mv -f "${LIVE10_FONTS_DIR}/${LIVE10_REGULAR_OTF}.orig" "${LIVE10_FONTS_DIR}/${LIVE10_REGULAR_OTF}"
    else
        echo -e "\nfile: ${LIVE10_FONTS_DIR}/${LIVE10_REGULAR_OTF}.orig does not exist.\n"
    fi
    if [ -f "${LIVE10_FONTS_DIR}/${LIVE10_BOLD_OTF}.orig" ]; then
        mv -f "${LIVE10_FONTS_DIR}/${LIVE10_BOLD_OTF}.orig" "${LIVE10_FONTS_DIR}/${LIVE10_BOLD_OTF}"
    else
        echo -e "\nfile: ${LIVE10_FONTS_DIR}/${LIVE10_BOLD_OTF}.orig does not exist.\n"
    fi
    if [ -f "${PUSH2_FONTS_DIR}/${PUSH2_BROWSER_OTF}.orig" ]; then
        mv -f "${PUSH2_FONTS_DIR}/${PUSH2_BROWSER_OTF}.orig" "${PUSH2_FONTS_DIR}/${PUSH2_BROWSER_OTF}"
    fi
    exit 0
fi

if [ -z "${JP_REGULAR_FONT}" ]; then
    echo -e "\nregular_font is not specified."
    usage_exit
fi

if [ -z "${JP_BOLD_FONT}" ]; then
    echo -e "\nbold_font is not specified."
    usage_exit
fi

if (validate_src_font "${JP_REGULAR_FONT}"); then
    # TTF Font
    ttf2otf "${JP_REGULAR_FONT}" /tmp/_temporary_live10_jp_regular_font.otf
    JP_REGULAR_FONT=/tmp/_temporary_live10_jp_regular_font.otf
fi
if (validate_src_font "${JP_BOLD_FONT}"); then
    # TTF Font
    ttf2otf "${JP_BOLD_FONT}" /tmp/_temporary_live10_jp_bold_font.otf
    JP_BOLD_FONT=/tmp/_temporary_live10_jp_bold_font.otf
fi
if [ ! -z "${JP_PUSH2_FONT}" ] && (validate_src_font "${JP_BOLD_FONT}"); then
    # TTF Font
    ttf2otf "${JP_PUSH2_FONT}" /tmp/_temporary_push2_jp_browser_font.otf
    JP_PUSH2_FONT=/tmp/_temporary_push2_jp_browser_font.otf
fi

# merge jp font into AbletonSansBook-Regular.otf
if [ -f "${JP_PUSH2_FONT}" ]; then
    ORIG_PUSH2_FONT="${PUSH2_FONTS_DIR}/${PUSH2_BROWSER_OTF}"
    if [ -f "${PUSH2_FONTS_DIR}/${PUSH2_BROWSER_OTF}.orig" ]; then
        ORIG_PUSH2_FONT="${PUSH2_FONTS_DIR}/${PUSH2_BROWSER_OTF}.orig"
    fi
    merge_font "${ORIG_PUSH2_FONT}" "${JP_PUSH2_FONT}" /tmp/_temporary_push2_merged_browser_font.otf
    JP_PUSH2_FONT=/tmp/_temporary_push2_merged_browser_font.otf
fi

# swap Live10 regular font
if [ ! -f "${LIVE10_FONTS_DIR}/${LIVE10_REGULAR_OTF}.orig" ]; then
    mv -f "${LIVE10_FONTS_DIR}/${LIVE10_REGULAR_OTF}" "${LIVE10_FONTS_DIR}/${LIVE10_REGULAR_OTF}.orig"
fi
cp -f "${JP_REGULAR_FONT}" "${LIVE10_FONTS_DIR}/${LIVE10_REGULAR_OTF}"

# swap Live10 bold font
if [ ! -f "${LIVE10_FONTS_DIR}/${LIVE10_BOLD_OTF}.orig" ]; then
    mv -f "${LIVE10_FONTS_DIR}/${LIVE10_BOLD_OTF}" "${LIVE10_FONTS_DIR}/${LIVE10_BOLD_OTF}.orig"
fi
cp -f "${JP_BOLD_FONT}" "${LIVE10_FONTS_DIR}/${LIVE10_BOLD_OTF}"

# swap push2 browser font
if [ -f "${JP_PUSH2_FONT}" ]; then
    if [ ! -f "${PUSH2_FONTS_DIR}/${PUSH2_BROWSER_OTF}.orig" ]; then
        mv -f "${PUSH2_FONTS_DIR}/${PUSH2_BROWSER_OTF}" "${PUSH2_FONTS_DIR}/${PUSH2_BROWSER_OTF}.orig"
    fi
    cp -f "${JP_PUSH2_FONT}" "${PUSH2_FONTS_DIR}/${PUSH2_BROWSER_OTF}"
fi

# cleanup
if [ -f /tmp/_temporary_live10_jp_regular_font.otf ]; then
    rm -f /tmp/_temporary_live10_jp_regular_font.otf
fi
if [ -f /tmp/_temporary_live10_jp_bold_font.otf ]; then
    rm -f /tmp/_temporary_live10_jp_bold_font.otf
fi
if [ -f /tmp/_temporary_push2_jp_browser_font.otf ]; then
    rm -f /tmp/_temporary_push2_jp_browser_font.otf
fi
if [ -f /tmp/_temporary_push2_merged_browser_font.otf ]; then
    rm -f /tmp/_temporary_push2_merged_browser_font.otf
fi
