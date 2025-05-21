#!/bin/bash

SOURCE_DIR="/data/storage/plates"
DEST_DIR="/data/ftp"

show_help() {
    echo "Kullanım: $0 [-c sayı] [-t saniye] | [-r] [-h]"
    echo ""
    echo "  -c <sayı>     Her döngüde taşınacak jpg dosya sayısı"
    echo "  -t <saniye>   Kaç saniyede bir taşıma yapılacağı"
    echo "  -r            Rastgele mod (0-60 saniye, 0-60 dosya)"
    echo "  -h            Yardım bilgisini göster"
    echo ""
    echo "  Not: -r kullanılırsa -c ve -t birlikte kullanılamaz. Aynı şekilde -c ve -t birlikte kullanılmalı ve -r kullanılmamalıdır."
}

random_mode=false
count=""
time_interval=""

while getopts ":c:t:rh" opt; do
    case ${opt} in
        c)
            count="$OPTARG"
            ;;
        t)
            time_interval="$OPTARG"
            ;;
        r)
            random_mode=true
            ;;
        h)
            show_help
            exit 0
            ;;
        \?)
            echo "Hatalı parametre: -$OPTARG" >&2
            show_help
            exit 1
            ;;
        :)
            echo "Eksik parametre değeri: -$OPTARG" >&2
            show_help
            exit 1
            ;;
    esac
done

if $random_mode && { [ -n "$count" ] || [ -n "$time_interval" ]; }; then
    echo "Hata: -r parametresi -c veya -t ile birlikte kullanılamaz."
    show_help
    exit 1
fi

if ! $random_mode && { [ -z "$count" ] || [ -z "$time_interval" ]; }; then
    echo "Hata: -c ve -t birlikte kullanılmalı veya sadece -r kullanılmalı."
    show_help
    exit 1
fi

while true; do
    if $random_mode; then
        count=$((RANDOM % 61))
        time_interval=$((RANDOM % 61))
    fi

    find "$SOURCE_DIR" -maxdepth 1 -type f -iname "*.jpg" | head -n "$count" | while read -r file; do
        mv "$file" "$DEST_DIR"
    done

    sleep "$time_interval"
done
