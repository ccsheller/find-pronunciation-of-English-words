#! /bin/bash

ALL_LIST="./all_list.txt"
MISS_LIST="./miss_list.txt"
SRC="src/voice"
ICIBASRC="http://res.iciba.com/resource/amp3/1/0/"
BINGSRC="http://media.engkoo.com:8129/en-us/"
DES="des/voice"

mkdir -p ${DES}
cd ${DES}
for var in `seq 97 122`; do var=$(echo "ibase=10; obase=8; ${var}"|bc);printf "\\${var}"|xargs mkdir; done
cd -

rm ${MISS_LIST}
touch ${MISS_LIST}

function recpword()
{
    local WORD=$1
    local SUB=$2
    local REP=$3
    local NEWWORD=${WORD//$SUB/$REP} 
    local UFIRST=`echo ${WORD:0:1}| tr "[:lower:]" "[:upper:]"`
    local LFIRST=`echo ${UFIRST}| tr "[:upper:]" "[:lower:]"`
    if [ "${NEWWORD}" != "${WORD}" ]; then
        cp -u "${SRC}/${UFIRST}/${NEWWORD}.mp3" "${DES}/${LFIRST}/${NEWWORD}.mp3"
        return $?
    fi
    return 1
}

function checkword()
{
    local WORD=$1
    if [ -f "/tmp/${WORD}.mp3" ]; then
        FILETYPE=`file "/tmp/${WORD}.mp3"|awk '{print $2}'`
        if [ "${FILETYPE}"X == "MPEGX" -o "${FILETYPE}"X == "AudioX" ]; then
            return 0
        fi
    fi
    return 1
}

while read WORD
do
    if [[ ${#WORD} -gt 1 ]]; then
        UFIRST=`echo ${WORD:0:1}| tr "[:lower:]" "[:upper:]"`
        LFIRST=`echo ${UFIRST}| tr "[:upper:]" "[:lower:]"`
        if echo "$UFIRST" |grep -q '^[A-Z]$'; then
            cp -u "${SRC}/${UFIRST}/${WORD}.mp3" "${DES}/${LFIRST}/${WORD}.mp3"
            if [[ $? -ne 0 ]]; then
                recpword "$WORD" " " "-"
                if [[ $? -eq 0 ]]; then 
                    continue
                fi
                recpword "$WORD" "-" " "
                if [[ $? -eq 0 ]]; then 
                    continue
                fi
                if [ -f "${DES}/${LFIRST}/${WORD}.mp3" ]; then
                    continue
                fi
                WORDMD5=`echo -n "$WORD"|md5sum|awk '{print $1}'`
                wget "${ICIBASRC}${WORDMD5:0:2}/${WORDMD5:2:2}/${WORDMD5}.mp3" -O "/tmp/${WORDMD5}.mp3"
                checkword "$WORDMD5"
                if [ $? -eq 0 ]; then
                    mv -f "/tmp/${WORDMD5}.mp3" "${DES}/${LFIRST}/${WORD}.mp3"
                    continue
                fi
                rm -f "/tmp/${WORDMD5}.mp3"
                wget "${BINGSRC}${WORD}.mp3" -O "/tmp/${WORD}.mp3"
                checkword "$WORD"
                if [ $? -eq 0 ]; then
                    mv -f "/tmp/${WORD}.mp3" "${DES}/${LFIRST}/${WORD}.mp3"
                    continue
                fi
                rm -f "/tmp/${WORD}.mp3"
                echo ${WORD} >> ${MISS_LIST}
            fi
        else
            echo ${WORD} >> ${MISS_LIST}
        fi
    fi
done < ${ALL_LIST}

