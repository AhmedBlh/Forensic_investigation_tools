#!/bin/bash

# version 1.0 
# These are grep commands to search for web vulnerabilities (first try),
# if you want to use more certain patterns uncomment the short one and comment the other ,
# add execution permissions to this file with $ sudo chmod +x grep_for_web_attacks.sh ,
# execute with ./grep_for_web_attacks.sh .


function xss {

    echo -e '\n#   Test for XSS   \n'; sleep 2
    grep -i -E '(<|&lt;)(script|iframe)(>|&gt;)|(%3c|%253c)(script|iframe)(%3e|%253e)' $log_file

}

function sqli {
    
    echo -e '\n->   Test for SQLi    \n'; sleep 2
    grep -i -E "(union|select|sleep|benchmark|load_file)\W|\b(hex|ascii)\W*\([^)]*\)" $log_file

}

function path_traversal {

    echo  -e '\n->   Test for path traversal attack   \n'; sleep 2
    grep -i -E "\.\./|\.\%2f|\.\%255c" $log_file

}

function command_injection {

    echo -e '\n->   Test for Command Injection Attack   \n'; sleep 2
    grep -i -E '(\||;|\$|`|\\\|&&)\s*[^#\n]*\b(bash|sh|curl|wget|nc|python|perl)\b' $log_file

}

function xee {

    echo -e '\n->   Test for XML External Entity Attack    \n'; sleep 2
    grep -i -E "<\!DOCTYPE\s+[^>]*ENTITY[^>]*\s+SYSTEM" $log_file

}

function brute_force {

    echo -e '\n->   Test for Brute-force Attack    \n'; sleep 2
    grep "authentication failure" $log_file | grep -Eo "([0-9]{1,3}\.){3}[0-9]{1,3}|[Uu][Ss][Ee][Rr][Nn][Aa][Mm][Ee]=|&[Pp][Aa][Ss][Ss][Ww][Oo][Rr][Dd]=|%[55uU]|[Uu]nion" | sort | uniq -c | awk '$1>5 {print $2}'

}

echo -e "\nInsert the full path of the log file:  "

while true; do

    read log_file
    if test -f "$log_file"; then
        echo -e "\n\n(1- XSS | 2- SQLi | 3- Path Traversal | 4- Command Injection | 5- XEE | 6- Brute-Force | 0- ALL \n \n\nInsert the attack type you want to test for:   "
        read OPTION
        if [[ $OPTION =~ ^[0-6]$ ]]; then
            if [[ $OPTION -eq 1 ]]; then

                xss

            elif [[ $OPTION -eq 2 ]]; then

                sqli

            elif [[ $OPTION -eq 3 ]]; then

                path_traversal

            elif [[ $OPTION -eq 4 ]]; then

                command_injection

            elif [[ $OPTION -eq 5 ]]; then

                xee

            elif [[ $OPTION -eq 6 ]]; then

                brute_force

            elif [[ $OPTION -eq 0 ]]; then

                xss;  sqli;  path_traversal;  command_injection;  xee;  brute_force;

            fi
        else
            echo  -e " \nInvalid input. Please enter a valid option:   "
        fi
        break
    else
        echo -e "\nPlease enter a valid file path:   "
    fi
done
