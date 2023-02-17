#!/bin/bash

# version 1.0
# These are awk commands to search for web vulnerabilities (first try),
# if you want to use more certain patterns uncomment the short one and comment the other ,
# add execution permissions to this file with $ sudo chmod +x awk_for_web_attacks.sh ,
# execute with ./awk_for_web_attacks.sh .


function xss {
  
    echo -e '\n->   Test for XSS     \n'; sleep 2
    awk 'tolower($0) ~ /(%3c|<|%253c)(s|%73|%2573)(c|%63|%2563)(r|%72|%2572)(i|%69|%2569)(p|%70|%2570)(t|%74|%2574)[^>]*(>|%3e|%253e)/ || tolower($0) ~ /(%3c|<|%253c)(s|%73|%2573)(c|%63|%2563)(r|%72|%2572)(i|%69|%2569)(p|%70|%2570)(t|%74|%2574)/ || tolower($0) ~ /<\s*script.*?>.*?<\s*\/\s*script\s*>/ {print}' $log_file

}

function sqli {

    echo  -e '\n->   Test for SQLi    \n'; sleep 2
    awk 'tolower($0) ~ /select.*from|insert.*into|update.*set|delete.*from|truncate.*table|union.*select|union.*all.*select|drop.*table|create.*table|xp_cmdshell|exec.*master..*xp_cmdshell|exec.*xp_cmdshell|sp_executesql|sp_oacreate|sp_addextendedproperty|sp_dropextendedproperty|waitfor.*delay|waitfor.*time/ {print}' $log_file
    
}

function path_traversal {

    echo  -e '\n->   Test for path traversal attack   \n'; sleep 2
    awk 'tolower($0) ~ /(\.\.[\/\\])+|([\/\\]\.\.[\/\\])/ {print}' $log_file

}

function command_injection {

    echo -e '\n->   Test for Command Injection Attack   \n'; sleep 2
    awk 'tolower($0) ~ /(\|.*&)|(;.*&)|(&.*&)|(`.*`)|(\$\(.*\))|(\$\{.*\})/ {print}' $log_file
    

}

function xee {

    echo -e '\n->   Test for XML External Entity Attack    \n'; sleep 2
    awk 'tolower($0) ~ /<!\s*\[cdata\s*\[.*\]\s*\]>|<!\s*ENTITY.*SYSTEM\s*".*"\s*>/ {print}' $log_file

}

function brute_force {

    echo -e '\n->   Test for Brute-force Attack    \n'; sleep 2
    awk 'tolower($0) ~ /(?:failed password|authentication failure).*(invalid user|user not known to the underlying authentication module|user unknown|unknown user|illegal user).*(from.*)/ {print}' $log_file

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
