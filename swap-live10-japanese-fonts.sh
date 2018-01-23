#!/bin/bash -e

PWD=`dirname $0`
cd ${PWD}

# functions
usage_exit() {
    echo
    echo "Usage:"
    echo "  To install: $0 [-e edition] regular_font bold_font" 1>&2
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

#  $1: src ttf font filet
#  $2: dest otf font filet
ttf2otf() {
    fontforge -c '
import fontforge
font = fontforge.open("'$1'")
font.generate("'$2'")
'
}

if [ ! "`uname`" = "Darwin" ]; then
    echo
    echo "Unsupported architecture."
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
SRC_REGULAR_FONT=$1
SRC_BOLD_FONT=$2

REGULAR_OTF=NotoSansCJKjp-Regular.otf
BOLD_OTF=NotoSansCJKjp-Bold.otf
LIVE10_FONTS="/Applications/Ableton Live 10 ${LIVE10_EDITION}.app/Contents/App-Resources/Fonts"

# uninstall
if $UNINSTALL ; then
    if [ -f "${LIVE10_FONTS}/${REGULAR_OTF}.orig" ]; then
        mv -f "${LIVE10_FONTS}/${REGULAR_OTF}.orig" "${LIVE10_FONTS}/${REGULAR_OTF}"
    else
        echo -e "\nfile: ${LIVE10_FONTS}/${REGULAR_OTF}.orig does not exit.\n"
        exit 1
    fi
    if [ -f "${LIVE10_FONTS}/${BOLD_OTF}.orig" ]; then
        mv -f "${LIVE10_FONTS}/${BOLD_OTF}.orig" "${LIVE10_FONTS}/${BOLD_OTF}"
    else
        echo -e "\nfile: ${LIVE10_FONTS}/${BOLD_OTF}.orig does not exit.\n"
        exit 1
    fi
    exit 0
fi

if [ -z $SRC_REGULAR_FONT ]; then
    echo -e "\nregular_font is not specified."
    usage_exit
fi

if [ -z $SRC_BOLD_FONT ]; then
    echo -e "\nbold_font is not specified."
    usage_exit
fi

if (validate_src_font $SRC_REGULAR_FONT); then
    # TTF Fonr
    ttf2otf $SRC_REGULAR_FONT $REGULAR_OTF
    SRC_REGULAR_FONT=$REGULAR_OTF
fi
if (validate_src_font $SRC_BOLD_FONT); then
    # TTF Fonr
    ttf2otf $SRC_BOLD_FONT $BOLD_OTF
    SRC_BOLD_FONT=$BOLD_OTF
fi

# swap fonts
if [ ! -f "${LIVE10_FONTS}/${REGULAR_OTF}.orig" ]; then
    mv -f "${LIVE10_FONTS}/${REGULAR_OTF}" "${LIVE10_FONTS}/${REGULAR_OTF}.orig"
fi
mv -f "${SRC_REGULAR_FONT}" "${LIVE10_FONTS}/${REGULAR_OTF}"

if [ ! -f "${LIVE10_FONTS}/${BOLD_OTF}.orig" ]; then
    mv -f "${LIVE10_FONTS}/${BOLD_OTF}" "${LIVE10_FONTS}/${BOLD_OTF}.orig"
fi
mv -f "${SRC_BOLD_FONT}" "${LIVE10_FONTS}/${BOLD_OTF}"
