#!/usr/bin

# Colors
red='\e[1;31m'
default='\e[0m'
yellow='\e[0;33m'
orange='\e[38;5;166m'
green='\033[92m'
# Location
path=$(pwd)
# Check root 
if [ "$(id -u)" != "0" ] > /dev/null 2>&1; then
echo -e "\n$red[x] Este script necesita permisos root." 1>&2
exit
fi

# Banner 
clear
sleep 2
echo -e "$yellow  ___                 __         .__  .__                            "
echo -e "$yellow |   | ____   _______/  |______  |  | |  |   ___________             "    
echo -e "$yellow |   |/    \ /  ___/\   __\__  \ |  | |  | _/ __ \_  __ \            "    
echo -e "$yellow |   |   |  \___  \  |  |  / __ \|  |_|  |_\  ___/|  | \/            "    
echo -e "$yellow |___|___|  /____  > |__| (____  /____/____/\___  >__|   /\  /\  /\  "
echo -e "$yellow          \/     \/            \/               \/       \/  \/  \/  "
echo -e "                                                                            "
echo -e "$orange                        Setup Reyerox v1.3.2                         "
echo -e "                                                                            "
echo -e "$orange                             By:Daniel                               "

# Check if there is an internet connection
ping -c 1 google.com > /dev/null 2>&1
if [[ "$?" == 0 ]]; then
echo ""
echo -e "$green[✔][Internet Connection]............[ OK ]"
sleep 1.5
else
echo ""
echo -e "$red[!][Internet Connection].........[ NOT FOUND ]"
echo ""
exit
fi

# Check dependencies
echo -e $yellow
echo -n [*] Chequeando dependencias...= ;
sleep 3 & while [ "$(ps a | awk '{print $1}' | grep $!)" ] ; do for X in '-' '\' '|' '/'; do echo -en "\b$X"; sleep 0.1; done; done
echo ""

echo -e "\n$yellow[!][Apt update...]"

sudo apt update > /dev/null 2>&1



# Check if xterm exists
which xterm > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
echo ""
echo -e "$green[✔][Xterm]..........................[ OK ]"
sleep 1.5
else
echo ""
echo -e "$red[x][Xterm].......................[ NOT FOUND ]"
sleep 1.5
echo -e "$yellow[!][Installing Xterm...]"
sudo apt-get install -y xterm > /dev/null
fi

# Check if postgresql exists
which /etc/init.d/postgresql > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
echo -e "$green[✔][Postgresql].....................[ OK ]"
sleep 1.5
else
echo -e "$red[x][Postgresql]..................[ NOT FOUND ]"
sleep 1.5
echo -e "$yellow[!][Installing Postgresql...]"
xterm -T "INSTALLER POSTGRESQL" -geometry 100x30 -e "sudo apt-get install -y postgresql"
fi

# Check if metasploit framework exists 
which msfconsole > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
echo -e "$green[✔][Metasploit Framework]...........[ OK ]"
sleep 1.5
else
echo -e "$red[x][Metasploit Framework]........[ NOT FOUND ]"
sleep 1.5
echo -e "$yellow[!][Installing Metasploit-Framework...]"
xterm -T "INSTALLER METASPLOIT FRAMEWORK" -geometry 100x30 -e "curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall && sudo apt-get update && apt-get upgrade"
fi
#
## Check if apktool exists 
#which apktool > /dev/null 2>&1
#if [ "$?" -eq "0" ]; then
#echo -e "$green[✔][Apktool]........................[ OK ]"
#sleep 1.5
#else
#echo -e "$red[x][Apktool].....................[ NOT FOUND ]"
#sleep 1.5
#echo -e "$yellow[!][Installing Apktool...]"
#xterm -T "INSTALLER APKTOOL" -geometry 100x30 -e "wget -O apktool.jar https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.4.0.jar && wget https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool && mv apktool* /usr/local/bin && chmod +x /usr/local/bin/apktool*"
#fi
#
## Check if aapt exists
#which aapt > /dev/null 2>&1
#if [ "$?" -eq "0" ]; then
#echo -e "$green[✔][Aapt]...........................[ OK ]"
#sleep 1.5
#else
#echo -e "$red[x][Aapt]........................[ NOT FOUND ]"
#sleep 1.5
#echo -e "$yellow[!][Installing Aapt...]"
#xterm -T "INSTALLER AAPT" -geometry 100x30 -e "sudo apt-get install -y aapt && sudo apt-get install -y android-framework-res"
#fi
#
## Check if jarsigner exists
#which jarsigner > /dev/null 2>&1
#if [ "$?" -eq "0" ]; then
#echo -e "$green[✔][Jarsigner]......................[ OK ]"
#sleep 1.5
#else
#echo -e "$red[x][Jarsigner]...................[ NOT FOUND ]"
#sleep 1.5
#echo -e "$yellow[!][Installing Jarsigner...]"
#xterm -T "INSTALLER JARSIGNER" -geometry 100x30 -e "sudo apt-get install -y default-jdk"
#fi
#
## Check if zipalign exists
#which zipalign > /dev/null 2>&1
#if [ "$?" -eq "0" ]; then
#echo -e "$green[✔][Zipalign].......................[ OK ]"
#sleep 1.5
#else
#echo -e "$red[x][Zipalign]....................[ NOT FOUND ]"
#sleep 1.5
#echo -e "$yellow[!][Installing Zipalign...]"
#xterm -T "INSTALLER ZIPALIGN" -geometry 100x30 -e "sudo apt-get install -y zipalign"
#fi
#
## Check if pwgen exists
#which pwgen > /dev/null 2>&1
#if [ "$?" -eq "0" ]; then
#echo -e "$green[✔][Pwgen]..........................[ OK ]"
#sleep 1.5
#else
#echo -e "$red[x][Pwgen].......................[ NOT FOUND ]"
#sleep 1.5
#echo -e "$yellow[!][Installing Pwgen...]"
#xterm -T "INSTALLER PWGEN" -geometry 100x30 -e "sudo apt-get install pwgen"
#fi

# Check if hostapd exists
which hostapd > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
echo -e "$green[✔][Hostapd]........................[ OK ]"
sleep 1.5
else
echo -e "$red[x][Hostapd]...................[ NOT FOUND ]"
sleep 1.5
echo -e "$yellow[!][Installing Hostapd...]"
xterm -T "INSTALLER HOSTAPD" -geometry 100x30 -e "sudo apt-get install hostapd"
fi

# Check if dnsmasq exists
which dnsmasq > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
echo -e "$green[✔][dnsmasq]........................[ OK ]"
sleep 1.5
else
echo -e "$red[x][dnsmasq]...................[ NOT FOUND ]"
sleep 1.5
echo -e "$yellow[!][Installing dnsmasq...]"
xterm -T "INSTALLER DNSMASQ" -geometry 100x30 -e "sudo apt-get install dnsmasq"
fi

# Check if sslstrip exists
which sslstrip > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
echo -e "$green[✔][sslstrip].......................[ OK ]"
sleep 1.5
else
echo -e "$red[x][sslstrip]...................[ NOT FOUND ]"
sleep 1.5
echo -e "$yellow[!][Installing sslstrip...]"
xterm -T "INSTALLER SSLESTRIP" -geometry 100x30 -e "sudo apt-get install sslstrip"
fi

# Check if driftnet exists
which driftnet > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
echo -e "$green[✔][driftnet].......................[ OK ]"
sleep 1.5
else
echo -e "$red[x][driftnet]...................[ NOT FOUND ]"
sleep 1.5
echo -e "$yellow[!][Installing driftnet...]"
xterm -T "INSTALLER DRIFTNET" -geometry 100x30 -e "sudo apt-get install driftnet"
fi

# Check if airbase-ng exists
which airbase-ng > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
echo -e "$green[✔][airbase-ng].....................[ OK ]"
sleep 1.5
else
echo -e "$red[x][airbase-ng]...................[ NOT FOUND ]"
sleep 1.5
echo -e "$yellow[!][Installing airbase-ng...]"
xterm -T "INSTALLER AIRBASE-NG" -geometry 100x30 -e "sudo apt-get install airbase-ng"
fi

# Check if ettercap exists
which ettercap > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
echo -e "$green[✔][ettercap].......................[ OK ]"
sleep 1.5
else
echo -e "$red[x][ettercap]...................[ NOT FOUND ]"
sleep 1.5
echo -e "$yellow[!][Installing ettercap...]"
xterm -T "INSTALLER ETTERCAP" -geometry 100x30 -e "sudo apt-get install ettercap"
fi

# Check if httrack exists
which httrack > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
echo -e "$green[✔][httrack]........................[ OK ]"
sleep 1.5
else
echo -e "$red[x][httrack]...................[ NOT FOUND ]"
sleep 1.5
echo -e "$yellow[!][Installing httrack...]"
xterm -T "INSTALLER HTTRACK" -geometry 100x30 -e "sudo apt-get install httrack"
fi

# Check if mysql exists
which mysql > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
echo -e "$green[✔][mysql]..........................[ OK ]"
sleep 1.5
else
echo -e "$red[x][mysql]...................[ NOT FOUND ]"
sleep 1.5
echo -e "$yellow[!][Installing mysql...]"
xterm -T "INSTALLER MYSQL" -geometry 100x30 -e "sudo apt-get install mysql"
fi

# Check if gnome-terminal exists
which gnome-terminal > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
echo -e "$green[✔][gnome-terminal].................[ OK ]"
sleep 1.5
else
echo -e "$red[x][gnome-terminal]...................[ NOT FOUND ]"
sleep 1.5
echo -e "$yellow[!][Installing gnome-terminal...]"
xterm -T "INSTALLER GNOME-TERMINAL" -geometry 100x30 -e "sudo apt-get install gnome-terminal"
fi

# Check if jq exists
which jq > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
echo -e "$green[✔][jq].................[ OK ]"
sleep 1.5
else
echo -e "$red[x][jq]...................[ NOT FOUND ]"
sleep 1.5
echo -e "$yellow[!][Installing jq...]"
xterm -T "INSTALLER GNOME-TERMINAL" -geometry 100x30 -e "sudo apt-get install jq -y"
fi

# Check if ngrok exists
arch=`arch`
if [ -f "ngrok" ]; then
echo -e "$green[✔][Ngrok]..........................[ OK ]"
sleep 1.5
else
echo -e "$red[x][Ngrok]........................[ NOT FOUND ]"
sleep 1.5
echo -e "$yellow[!][Downloading ngrok...]"
if [ "$arch" ==  "x86_64" ]; then
xterm -T "DOWNLOAD NGROK" -geometry 100x30 -e "wget https://bin.equinox.io/a/kpRGfBMYeTx/ngrok-2.2.8-linux-amd64.zip && unzip ngrok-2.2.8-linux-amd64.zip"
rm ngrok-2.2.8-linux-amd64.zip
else
xterm -T "DOWNLOAD NGROK" -geometry 100x30 -e "wget https://bin.equinox.io/a/4hREUYJSmzd/ngrok-2.2.8-linux-386.zip && unzip ngrok-2.2.8-linux-386.zip"
rm ngrok-2.2.8-linux-386.zip
fi

fi

# Configuring folders
#echo -e $yellow
#echo -n [*] Configurando carpetas...= ;
#sleep 3 & while [ "$(ps a | awk '{print $1}' | grep $!)" ] ; do for X in '-' '\' '|' '/'; do echo -en "\b$X"; sleep 0.1; done; done
#echo ""
#echo -e $green
#
#if [ -d tools/Android ]; then
#echo -e "[✔]Ya existe $path/tools/Android"
#sleep 0.2
#else
#mkdir -p tools/Android
#echo -e "[✔]$path/tools/Android"
#sleep 0.2
#fi


# Configurando la carpeta
echo -e $yellow
echo -n [*] Configurando carpeta...= ;
sleep 3 & while [ "$(ps a | awk '{print $1}' | grep $!)" ] ; do for X in '-' '\' '|' '/'; do echo -en "\b$X"; sleep 0.1; done; done
echo ""
echo -e $green
dos2unix *.sh > /dev/null 2>&1
dos2unix utilities/*.sh > /dev/null 2>&1

echo -e "$green[✔][Concediendo permisos............[ OK ]"
chmod +x *.sh > /dev/null 2>&1
chmod +x utilities/*.sh > /dev/null 2>&1
mkdir colorlib > /dev/null 2>&1
sleep 1.5

dir="/home/kali/Desktop/GhostWire/colorlib"

if [ "$(ls -A $dir)" ]; then
    echo -e "$green[✔][Página colorlib.com clonado......[ OK ]"
else
    echo -e "$red[x][Página colorlib.com no clonada]..........[ NOT FOUND ]"
    sleep 1.5
    echo -e "$yellow[!][Clonando página web...]"
    httrack https://colorlib.com/etc/lf/Login_v5/index.html -O /home/kali/Desktop/GhostWire/colorlib > /dev/null 2>&1
fi


# Installing requirements
echo -e $yellow
echo -n [*] Instalando requerimientos de python...= ;
sleep 3 & while [ "$(ps a | awk '{print $1}' | grep $!)" ] ; do for X in '-' '\' '|' '/'; do echo -en "\b$X"; sleep 0.1; done; done
echo ""
echo -e $green
pip3 install requests
pip3 install py-getch
apt-get install python3-tk -y
pip3 install pathlib
pip3 install zenipy
pip3 install pgrep
apt-get install libatk-adaptor libgail-common
sudo apt-get purge fcitx-module-dbus

sleep 2
echo -e $green
echo -e "╔──────────────────────────╗"
echo -e "|[✔] Installation complete.|"
echo -e "┖──────────────────────────┙"

exit
