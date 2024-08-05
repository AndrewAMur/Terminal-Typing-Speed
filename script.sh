#!/bin/bash

# Text to be typed
TEXT="The quick brown fox jumps over the lazy dog"

# Display the text
echo -ne "$TEXT\r"

# Hide cursor
tput civis

# Save current terminal settings
stty_orig=$(stty -g)
stty -echo -icanon time 0 min 0

# Start time
start_time=$(date +%s.%N)

# Initialize variables
typed=""
pos=0

# Read input loop
while [ $pos -lt ${#TEXT} ]; do
    # Read single character
    char=$(dd bs=1 count=1 2>/dev/null)

    if [ "$char" ]; then
        if [ "$char" = $'\177' ]; then # Backspace
            if [ $pos -gt 0 ]; then
                ((pos--))
                typed="${typed%?}"
            fi
        else
            typed+="$char"
            ((pos++))
        fi

        # Clear the line and reprint the text with the typed characters
        echo -ne "\r$TEXT\r"
        echo -ne "\033[32m$typed\033[0m"
    fi
done

# End time
end_time=$(date +%s.%N)

# Show cursor
tput cnorm

# Restore original terminal settings
stty "$stty_orig"

# Calculate elapsed time in seconds
elapsed=$(echo "$end_time - $start_time" | bc)

# Calculate words per minute (WPM)
words=$(echo "$typed" | wc -w)
wpm=$(echo "scale=2; $words / ($elapsed / 60)" | bc)

echo -e "\n\nYour typing speed is: $wpm WPM"
