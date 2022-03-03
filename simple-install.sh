#!/bin/bash

# Setup de servidor VNC, Instalacion de Impresoras,
# modificacion de IP, etc, etc.
# El punto es dejar una maquina con Minty completamente utilizable.


# Autor: Leon Collazo Arechaga
# Github: https://github.com/p0zzle
# Fecha: 17/02/2022
# Ultima actualizacion: 22/02/2022
# simple-install-V1.0.0


# Script start;
# Mensaje de bienvenida y preguntas para completar algunos temas basicos

printf "Hola!Necesito que me des un poco de informacion sobre la instalacion.\n"
printf "Primero, donde estas instalandolo?\n0 - Farmatotal - 0\n101 - Centro - 101\n102 - Alem - 102\n103 - Perito - 103\n104 - Kuanip - 104\n105 - Tolhuin - 105\n106 - Farmatotal - 106\n"
read -p "Escribi el numero de la sucursal == " suc
printf "Segundo, cual es el hostname de esta PC?"
read -p " Hostname == " hostn

# Borrando vino, instalando x11 y iptux
sudo apt-get update
sudo apt-get -y remove vino
sudo apt-get install -y x11vnc chromium lm-sensors hddtemp

# Creando las carpetas, generando password de x11.

sudo mkdir /etc/x11vnc
sudo x11vnc --storepasswd /etc/x11vnc/vncpwd
sudo mkdir /media/x
sudo mkdir /media/t

# Creo el servicios de x11vnc para systemd

printf "[Unit]
Description=Start x11vnc at startup.
After=multi-user.target\n
[Service]
Type=simple
ExecStart=/usr/bin/x11vnc -auth guess -forever -noxdamage -repeat -rfbauth /etc/x11vnc/vncpwd -rfbport 5900 -shared -noxkb -nomodtweak
Restart=on-failure
RestartSec=5s\n
[Install]
WantedBy=multi-user.target" > /lib/systemd/system/x11vnc.service

# Reinicio y habilito x11vnc

sudo systemctl daemon-reload
sudo systemctl enable x11vnc.service
sudo systemctl start x11vnc.service

# Cambio de Hostname, insercion de IP en base a la eleccion original.

echo "$hostn" > /etc/hostname
echo "//192.168.$suc.5/factura/ /media/x      cifs    username=tys,password=tys,file_mode=0666,dir_mode=0777" >> /etc/fstab
printf "\n" >> /etc/fstab
echo "//192.168.$suc.5/temporal /media/t      cifs    username=tys,password=tys,file_mode=0666,dir_mode=0777" >> /etc/fstab

# Instalacion de impresoras Hasar, sourced de Mario Palacios, V2.
# Instalacion de aplicaciones y librerias necesarias.
# Paquetes que dan error! libcups2:i368
# libcups2:i368 no puede ser localizado
# libcupsfilters1:i386 no tiene un candidato para la instalacion
# Posibles paquetes; libcups2, libcupsfilters1.

sudo apt install cups ia32-libs libcupsimage2:i386 -y

# Las Hasar 250 pueden llegar a no instalarse correctamente el driver, hay que copiar las bibliotecas de las mismas.

sudo cp /usr/lib/x86_64-linux-gnu/libcups.so.2 /usr/lib/x86_64-linux-gnu/libcups.so
sudo cp /usr/lib/x86_64-linux-gnu/libcupsimage.so.2 /usr/lib/x86_64-linux-gnu/libcupsimage.so
sudo cp /usr/lib/i386-linux-gnu/libcups.so.2 /usr/lib/i386-linux-gnu/libcups.so
sudo cp /usr/lib/i386-linux-gnu/libcupsimage.so.2 /usr/lib/i386-linux-gnu/libcupsimage.so

tar -xzvf hasar.tar.gz
cd 250
sudo ./setup
cd ..
cd 1000
sudo ./setup
cd ..

# Finalmente montamos las particiones

sudo mount -a

printf "La instalacion termino! ※ (^o^)/※\n"
printf "Seria una buena idea reiniciar la computadora."
