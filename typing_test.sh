#!/bin/bash

WORDLIST_FILE="5664-freq-treegle-may.txt"
DEFAULT_NUM_WORDS=10
SHOW_TIMER=true
ALLOW_MISTAKES=false

reset_terminal() {
    tput cnorm
    stty "$stty_orig"
}

trap reset_terminal EXIT

while getopts "n:t:m:" opt; do
    case $opt in
        n) NUM_WORDS=$OPTARG ;;
        t) SHOW_TIMER=$OPTARG ;;
        m) ALLOW_MISTAKES=$OPTARG ;;
        *) echo "Usage: $0 [-n num_words] [-t 0|1] [-m 0|1]" >&2
           exit 1 ;;
    esac
done

NUM_WORDS=${NUM_WORDS:-$DEFAULT_NUM_WORDS}
SHOW_TIMER=${SHOW_TIMER:-true}
ALLOW_MISTAKES=${ALLOW_MISTAKES:-false}

generate_random_sentence() {
    if [ ! -f "$WORDLIST_FILE" ]; then
        echo "Wordlist file not found!"
        exit 1
    fi

    mapfile -t words < <(tail -n +4 "$WORDLIST_FILE" | cut -d, -f2)

    if [ ${#words[@]} -lt $NUM_WORDS ]; then
        echo "Not enough words in the wordlist!"
        exit 1
    fi

    selected_words=($(printf "%s\n" "${words[@]}" | shuf -n $NUM_WORDS))
    sentence=$(printf "%s " "${selected_words[@]}")
    sentence=$(echo "$sentence" | sed 's/ $//')

    echo "$sentence"
}

run_typing_test() {
    local sentence="$1"

    clear
    echo -e "Type the following text as quickly and accurately as you can:\n"
    echo -e "\033[33m$sentence\033[0m\n"

    tput civis

    stty_orig=$(stty -g)
    stty -echo -icanon time 0 min 0

    start_time=$(date +%s.%N)
    local typing_start_time=$(date +%s)

    typed=""
    pos=0
    length=${#sentence}

    while [ $pos -lt $length ]; do
        char=$(dd bs=1 count=1 2>/dev/null)

        if [ "$char" ]; then
            if [ "$char" = $'\177' ]; then
                if [ "$ALLOW_MISTAKES" = "1" ] && [ $pos -gt 0 ]; then
                    ((pos--))
                    typed="${typed%?}"
                fi
            elif [ "$char" = "${sentence:$pos:1}" ] || [ "$ALLOW_MISTAKES" = "1" ]; then
                typed+="$char"
                ((pos++))
            fi

            tput sc
            tput cup 4 0
            echo -e "Type the following text as quickly and accurately as you can:\n"
            echo -e "\033[33m${sentence:0:$pos}\033[32m${sentence:$pos:1}\033[33m${sentence:$((pos + 1))}\033[0m"
            tput cup 6 0
            echo -e "\033[32m$typed\033[0m"
            tput rc

            if [ "$SHOW_TIMER" != "0" ]; then
                current_time=$(date +%s)
                elapsed_time=$((current_time - typing_start_time))
                tput cup 8 0
                printf "Elapsed time: %02d:%02d" $((elapsed_time / 60)) $((elapsed_time % 60))
            fi
        fi
    done

    end_time=$(date +%s.%N)

    elapsed=$(echo "$end_time - $start_time" | bc)
    words=$(echo "$typed" | wc -w)
    wpm=$(echo "scale=2; $words / ($elapsed / 60)" | bc)

    tput cup 10 0
    echo -e "\nYour typing speed is: $wpm WPM"
}

random_sentence=$(generate_random_sentence)
run_typing_test "$random_sentence"
