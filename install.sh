#!/bin/bash

# Setup de servidor VNC, Instalacion de Impresoras, modificacion de IP, etc, etc. El punto es dejar una maquina con Minty completamente utilizable.
# Por Leon Collazo Arechaga; p0zzel
# V0.0.2
# Algunas Variables.
# Script start;

# Mensaje de bienvenida y preguntas para completar algunos temas basicos
printf "Hola! Necesito que me des un poco de informacion sobre la instalacion.\n"
#printf "Te dejo las opciones numericas para hacerlo relativamente mas facil\n"
printf "Primero, donde estas instalandolo?\n0 - Farmatotal - 0\n101 - Centro - 101\n102 - Alem - 102\n103 - Perito - 103\n104 - Kuanip - 104\n105 - Tolhuin - 105\n106 - Farmatotal - 106\n"
read -p "Escribi el numero de la sucursal == " suc

printf "Segundo, cual es el hostname de esta PC?"
read -p " Hostname == " hostn

# Borrando vino e instalando x11vnc

sudo apt-get -y remove vino
sudo apt-get install -y x11vnc

# Creando las carpetas y el password

sudo mkdir /etc/x11vnc
sudo x11vnc --storepasswd /etc/x11vnc/vncpwd

# Creo el servicio para systemd

printf "[Unit]\nDescription=Start x11vnc at startup.\nAfter=multi-user.target\n\n[Service]\n
Type=simple\nExecStart=/usr/bin/x11vnc -auth guess -forever -noxdamage -repeat -rfbauth /etc/x11vnc/vncpwd
-rfbport 5900 -shared -noxkb -nomodtweak\n\n[Install]\nWantedBy=multi-user.target\n\n" > /lib/systemd/system/x11vnc.service

# Recarga los servicios

sudo systemctl daemon-reload

# Habilita el servicio x11vnc

sudo systemctl enable x11vnc.service

# Empieza el servicio para evitar reiniciarlo

sudo systemctl start x11vnc.service

# Setup de carpetas, cambio de Hostname, seleccion de IP manual en base al lugar de Instalacion.
# variables, elif de la IP.

sudo mkdir /media/x
sudo mkdir /media/t
sudo mount -a

echo "$hostn" > /home/tys/Documentos/Proyecto/MintyScript-main/prueba

echo "//192.168.$suc.5/factura/ /media/x      cifs    username=tys,password=tys,file_mode=0666,dir_mode=0777" >> /etc/fstab
printf "\n" >> /etc/fstab
echo "//192.168.$suc.5/temporal /media/t      cifs    username=tys,password=tys,file_mode=0666,dir_mode=0777" >> /etc/fstab

# Instalacion de impresoras Hasar, sourced de Mario Palacios, V2.
# Instalacion de aplicaciones y librerias necesarias.
# Paquetes que dan error! libcups2:i368
# libcups2:i368 no puede ser localizado
# libcupsfilters1:i386 no tiene un candidato para la instalacion
sudo apt-get install cups ia32-libs libcupsimage2:i386 -y

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

printf "La instalacion de las impresoras termino\n"
printf "La instalacion de practicamente todo termino! wow. ※ (^o^)/※\n"
echo "$varIp"
echo "$suc"
