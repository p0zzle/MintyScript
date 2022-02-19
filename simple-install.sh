#!/bin/bash

# Setup de servidor VNC, Instalacion de Impresoras, modificacion de IP, etc, etc. El punto es dejar una maquina con Minty completamente utilizable.

# Autor: Leon Collazo Arechaga
# Github: https://github.com/p0zzle
# Fecha: 17/02/2022

# V0.0.2
# Algunas Variables.
# Script start;
# Corro instalacion/desinstalacion antes de el texto para hacer todo mas streamline
sudo apt-get -y remove vino
sudo apt-get install -y x11vnc iptux chromium
# Mensaje de bienvenida y preguntas para completar algunos temas basicos
printf "Hola!Necesito que me des un poco de informacion sobre la instalacion.\n"
# Sucursales
printf "Primero, donde estas instalandolo?\n0 - Farmatotal - 0\n101 - Centro - 101\n102 - Alem - 102\n103 - Perito - 103\n104 - Kuanip - 104\n105 - Tolhuin - 105\n106 - Farmatotal - 106\n"
read -p "Escribi el numero de la sucursal == " suc
# Hostname
printf "Segundo, cual es el hostname de esta PC?"
read -p " Hostname == " hostn
# Creo la carpeta y genero el password
sudo mkdir /etc/x11vnc
sudo x11vnc --storepasswd /etc/x11vnc/vncpwd
# Creando las carpetas, generando password de x11.
sudo mkdir /media/x
sudo mkdir /media/t
# Creo el servicios de x11vnc para systemd
printf "[Unit]\nDescription=Start x11vnc at startup.\nAfter=multi-user.target\n\n[Service]\n
Type=simple\nExecStart=/usr/bin/x11vnc -auth guess -forever -noxdamage -repeat -rfbauth\n /etc/x11vnc/vncpwd
-rfbport 5900 -shared -noxkb -nomodtweak\n\n[Install]\nWantedBy=multi-user.target\n\n" > /lib/systemd/system/x11vnc.service
# Reinicio y habilito x11vnc
sudo systemctl daemon-reload
sudo systemctl enable x11vnc.service
sudo systemctl start x11vnc.service

# Cambio de Hostname, insercion de IP en base a la eleccion original.
echo "$hostn" > /etc/hostname
# sed en caso de que iptux solucione (o yo entienda) como se crean las configuraciones iniciales.
# sed -i -e "s/\"nick_name\" : \"hostname\"/\"nick_name\" : \"$hostn\"/g" /home/tys/.iptux/config.json
echo "//192.168.$suc.5/factura/ /media/x      cifs    username=tys,password=tys,file_mode=0666,dir_mode=0777" >> /etc/fstab
printf "\n" >> /etc/fstab
echo "//192.168.$suc.5/temporal /media/t      cifs    username=tys,password=tys,file_mode=0666,dir_mode=0777" >> /etc/fstab

sudo mount -a

printf "La instalacion termino! ※ (^o^)/※\n"
printf "Seria una buena idea reiniciar la computadora para aplicar algunos cambios."
