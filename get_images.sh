#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Použitie: $0 URL" >&2
    exit 1
fi

SERVER=$(echo "$1" | cut -d / -f 3)

curl -s "$1" \
    | tr '\n' ' ' \
    | tr '>' '\n' \
    | grep -i '<img' \
    | sed 's/.* src="\([^"]*\)".*/\1/' \
    | while read LINE
do
    if echo "$LINE" | grep '^https:' >/dev/null
    then
        curl -s -O "$LINE"
    elif echo "$LINE" | grep '^/' >/dev/null
    then
        curl -s -O "https://$SERVER$LINE"
    fi
done

