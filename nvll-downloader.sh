#!/bin/bash
# NVLL Downloader — Vanille Systems
# Estilo: Minimal Mint / Silent Operator
# Autor: Vanille

# ===========================
#   CONFIGURACIÓN
# ===========================
DOWNLOAD_DIR="/storage/emulated/0/NVLL"
CONFIG_FILE="$HOME/.nvll_config"
VERSION="2.0"
JS_SCRIPT="libs/cxjsglrn/uiclmnkb/tqexnato/mjitgims/hpwsjtlb/gvgpzdji/qdcutqht/jhdhslzm/arndbqee/dzmflool/oigicmvc/glmgndsk/xihhhtuc/qbshieui/cwpyoaek/mesaedeu/ekwfvutu/bcsxmrhh/gqqdfxcj/dcafmqrn/qcoibkwc/afpztoqe/deugrwmb/oukkypyh/uuagpfcq/wmajddjq/wtzmpftk/pvlceulb/ryggtvzl/syfwectj/jxjtvemk/zwcvsvmt/ttnxvcua/vkjwkama/pzdbhssg/fywqgpfg/hmjiabux/xrfzqwst/aujgiqvc/lvkqlxtj/djssrtfs/ccpvgwvu/xchufmjh/gzcujbow/axbjvrgd/ktzociji/gxjwyvcy/niikohvy/adekjghc/ovgtyfqr/fnczjpsm/nnkxtzxh/eryeijpx/wwjyhjyv/becptvfp/vjijirlq/ssfxegkd/sdgpxatp/hvqakwmg/rgugdchy/haumvrbo/jsqhuoqa/bhncoxre/disxebir/sllmvbge/hrvxjqqm/xbvxwnku/ksxwaryl/mfrzeeks/zrlfohrl/tqvlbbim/mgqmxjyn/usycjpdv/laeaecmx/lkknhrki/oinqtvbx/dcwyroec/ibhlytkd/pimypcvy/emmytxmb/qmessedw/raileuow/nutlfoyt/hmycuxas/fozanmuo/edxpxmdb/cnraopfv/zbnjbzwa/uqrudkvh/wcznzoun/kzzlxvnt/turbkwqs/ushmmczt/obqhovnk/gdtqxphs/acchjzxm/kotkyzdi/fkonezaa/gbflyuov/iormyhfz/mesaedeu.js"

# Paleta Vanille Mint
MINT="\033[1;36m"
GRAY="\033[1;30m"
WHITE="\033[1;37m"
NC="\033[0m"

CURRENT_LANG="es"

declare -A LANG

# ===========================
#   IDIOMAS
# ===========================
load_lang() {
    case "$CURRENT_LANG" in
        "es")
            LANG=(
                ["title"]="NVLL Downloader"
                ["welcome"]="Acceso concedido — Vanille Systems"
                ["option"]="Selecciona una operación:"
                ["download"]="Descargar"
                ["lang"]="Idioma"
                ["exit"]="Salir"
                ["enter_url"]="Introduce URL:"
                ["format"]="Formato:"
                ["mp3"]="MP3 (Audio)"
                ["mp4"]="MP4 (Video)"
                ["processing"]="Procesando…"
                ["invalid"]="URL inválida"
                ["done"]="Descarga finalizada"
            )
        ;;
        "en")
            LANG=(
                ["title"]="NVLL Downloader"
                ["welcome"]="Access granted — Vanille Systems"
                ["option"]="Select an operation:"
                ["download"]="Download"
                ["lang"]="Language"
                ["exit"]="Exit"
                ["enter_url"]="Enter URL:"
                ["format"]="Format:"
                ["mp3"]="MP3 (Audio)"
                ["mp4"]="MP4 (Video)"
                ["processing"]="Processing…"
                ["invalid"]="Invalid URL"
                ["done"]="Download complete"
            )
        ;;
    esac
}

# ===========================
#   CONFIG
# ===========================
load_config() {
    [[ -f "$CONFIG_FILE" ]] && CURRENT_LANG=$(grep LANG "$CONFIG_FILE" | cut -d= -f2)
    load_lang
}

save_config() {
    echo "LANG=$CURRENT_LANG" > "$CONFIG_FILE"
}

# ===========================
#   HEADER VANILLE
# ===========================
header() {
    clear
    echo -e "${MINT}╔════════ NVLL Downloader ════════╗${NC}"
    echo -e "${GRAY}          Vanille Systems${NC}"
    echo
}

# ===========================
#   VALIDACIONES
# ===========================
ensure_dir() {
    [[ ! -d "$DOWNLOAD_DIR" ]] && mkdir -p "$DOWNLOAD_DIR"
}

check_node() {
    command -v node &>/dev/null || {
        echo -e "${WHITE}Node.js requerido.${NC}"
        exit 1
    }
}

# ===========================
#   DESCARGA
# ===========================
download_engine() {
    local url="$1"
    local format="$2"

    ensure_dir
    check_node

    [[ ! -f "$JS_SCRIPT" ]] && {
        echo -e "${WHITE}Engine no encontrado.${NC}"
        exit 1
    }

    local dl
    dl=$(node "$JS_SCRIPT" "$url" "$format")

    [[ -z "$dl" ]] && {
        echo -e "${WHITE}${LANG[invalid]}${NC}"
        return
    }

    local name=$(basename "$dl" | cut -d'?' -f1)
    local out="$DOWNLOAD_DIR/$name"

    curl -s -L -o "$out" "$dl"

    echo -e "${MINT}${LANG[done]} → ${WHITE}$out${NC}"
}

# ===========================
#   MENÚS
# ===========================
menu_lang() {
    header
    echo -e "${WHITE}1) Español"
    echo -e "2) English${NC}"
    echo
    read -p "> " opt

    case $opt in
        1) CURRENT_LANG="es" ;;
        2) CURRENT_LANG="en" ;;
    esac

    save_config
    load_lang
}

menu_download() {
    header
    echo -e "${WHITE}${LANG[enter_url]}${NC}"
    read -p "> " url

    [[ ! "$url" =~ youtube.com|youtu.be ]] && {
        echo -e "${WHITE}${LANG[invalid]}${NC}"
        sleep 1
        return
    }

    echo
    echo -e "${WHITE}${LANG[format]}${NC}"
    echo -e "${MINT}1)${WHITE} ${LANG[mp3]}"
    echo -e "${MINT}2)${WHITE} ${LANG[mp4]}${NC}"
    read -p "> " fch

    case $fch in
        1) format="mp3" ;;
        2) format="mp4" ;;
        *) format="mp3" ;;
    esac

    echo -e "${GRAY}${LANG[processing]}${NC}"
    download_engine "$url" "$format"
    read -p "..."
}

menu_main() {
    while true; do
        header
        echo -e "${WHITE}${LANG[welcome]}${NC}"
        echo
        echo -e "${MINT}1)${WHITE} ${LANG[download]}"
        echo -e "${MINT}2)${WHITE} ${LANG[lang]}"
        echo -e "${MINT}0)${WHITE} ${LANG[exit]}${NC}"
        echo
        read -p "> " op

        case $op in
            1) menu_download ;;
            2) menu_lang ;;
            0) exit 0 ;;
        esac
    done
}

# ===========================
#   MAIN
# ===========================
load_config
menu_main
