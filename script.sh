#!/bin/bash

TEXT="The quick brown fox jumps over the lazy dog"
echo -e "\nType the following text as quickly and accurately as you can:\n"
echo -e "\033[33m$TEXT\033[0m\n"

tput civis

stty_orig=$(stty -g)
stty -echo -icanon time 0 min 0

start_time=$(date +%s.%N)

typed=""
pos=0

while [ $pos -lt ${#TEXT} ]; do
    char=$(dd bs=1 count=1 2>/dev/null)

    if [ "$char" ]; then
        if [ "$char" = $'\177' ]; then # Backspace
            if [ $pos -gt 0 ]; then
                ((pos--))
                typed="${typed%?}"
            fi
        elif [ "$char" = "${TEXT:$pos:1}" ]; then
            typed+="$char"
            ((pos++))
        fi

        # Clear the line and reprint the text with the typed characters
        echo -ne "\r$TEXT\r"
        echo -ne "\033[32m$typed\033[0m"
    fi
done

end_time=$(date +%s.%N)

tput cnorm

stty "$stty_orig"

elapsed=$(echo "$end_time - $start_time" | bc)

words=$(echo "$typed" | wc -w)
wpm=$(echo "scale=2; $words / ($elapsed / 60)" | bc)

# Calculate accuracy
correct_chars=$(comm -12 <(echo "$TEXT" | fold -w1) <(echo "$typed" | fold -w1) | wc -l)
accuracy=$(echo "scale=2; $correct_chars / ${#TEXT} * 100" | bc)

echo -e "\n\nYour typing speed is: $wpm WPM"
echo -e "Your accuracy is: $accuracy%"
