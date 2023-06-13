# GhostWire

GhostWire es una aplicación que permite crear un rogue access point y con ello poder esnifar la red, montar un servidor apache, etc. El RogueAP es una red inalámbrica que se configura para parecerse a una red legítima con el objetivo de engañar a los usuarios y hacer que se conecten a dicha red pudiendo así obtener credenciales de las victimas que se conecten.

## Requerimientos

1. Antena inalambrica 
2. VirtualBox o VMware

## Herramientas a utilizar

* Xterm: Es un emulador de terminal para sistemas Unix que proporciona una ventana de terminal para ejecutar comandos en la línea de comandos.
* PostgreSQL: Es un sistema de gestión de bases de datos relacionales de código abierto y gratuito que se utiliza para almacenar y administrar grandes cantidades de datos.
* Metasploit Framework: Es una plataforma de prueba de penetración de código abierto que se utiliza para probar la seguridad de los sistemas informáticos y desarrollar y ejecutar exploits.
* Hostapd: Es un demonio de punto de acceso inalámbrico que se utiliza para crear y administrar puntos de acceso inalámbricos.
* Dnsmasq: Es un servidor de DNS y DHCP que se utiliza para proporcionar servicios de red a dispositivos conectados a una red.
* Sslstrip: Es una herramienta que se utiliza para manipular el tráfico HTTP no seguro y forzar el uso de conexiones HTTPS seguras.
* Driftnet: Es una herramienta que se utiliza para capturar y mostrar imágenes que se transmiten a través de una red.
* Airbase-ng: Es una herramienta que se utiliza para crear puntos de acceso inalámbricos falsos y realizar ataques de MITM (Man-in-the-middle).
* Ettercap: Es una herramienta de prueba de penetración que se utiliza para realizar ataques de MITM en redes.
* Httrack: Es una herramienta de descarga de sitios web que se utiliza para descargar sitios web completos para su uso sin conexión.
* MySQL: Es un sistema de gestión de bases de datos relacionales de código abierto que se utiliza para almacenar y administrar grandes cantidades de datos.
* Gnome-Terminal: Es un emulador de terminal para sistemas Unix que proporciona una ventana de terminal para ejecutar comandos en la línea de comandos.
* Ngrok: Es una herramienta que se utiliza para crear un túnel seguro a través de una red pública para exponer un servidor web localmente en línea.
* Python: lenguaje de programación utilizado para el desarrollo de la aplicación.
Pasos para inicializar la aplicación

## Instalación 

Descargar el repositorio de la aplicación desde GitHub.

```bash
git clone https://github.com/reyerox/Rogueap-eviltwin.git
```
Dentro de la carpeta (Este instalador configura toda la carpeta e instala lo necesario para que la herramienta lleve acabo los procesos pertinentes)
```bash
bash instalador.sh
```
Una vez hechoo esto ya estaria listo para utilizar.

## Pasos a seguir

1.- DoS.py para desautenticar a los usarios de la red inalambrica.
```python
python3 DoS.py
```
2.- Opcional: Crear apk maliciosa con msfvenom.
```bash
./msfvenom.sh
```
3.- Herramienta.sh para crear red inalambrica.
  3.1.- Página web, utilización de sslstrip y ettercap.
  3.2.- Página web conectada a una base de datos.
```bash
./herramienta.sh
```

Para abrir imágenes desde la terminal en sistemas Unix/Linux, puedes utilizar el comando "xdg-open" seguido del nombre de archivo de la imagen. Por ejemplo, si tienes una imagen llamada "imagen.jpg" y se encuentra en tu directorio actual, puedes abrir la imagen con el siguiente comando:

```bash
xdg-open imagen.jpg
```

Para abrir un archivo .cap en Wireshark desde la terminal, debes utilizar el comando wireshark, seguido del nombre del archivo que deseas abrir. Por ejemplo:

```bash
wireshark etter.cap
```

## Contribuyendo

Las solicitudes de extracción son bienvenidas. Para cambios importantes, abra un issue primero para discutir lo que le gustaría cambiar.

Asegúrese de actualizar las pruebas según corresponda.

<br>

**NOTA**: Es importante tener en cuenta que la creación de redes RogueAP y Evil Twin puede ser ilegal y se debe utilizar con fines educativos y de investigación únicamente.
