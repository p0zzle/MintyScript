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
# Borrando vino, instalando x11 y las dependencias de las impresoras

sudo apt-get -y remove vino
sudo apt-get install -y x11vnc cups ia32-libs libcupsimage2:i386

# Creando las carpetas, generando password de x11.

sudo mkdir /etc/x11vnc
sudo x11vnc --storepasswd /etc/x11vnc/vncpwd
sudo mkdir /media/x
sudo mkdir /media/t

# Creo el servicio para systemd

printf "[Unit]\nDescription=Start x11vnc at startup.\nAfter=multi-user.target\n\n[Service]\n
Type=simple\nExecStart=/usr/bin/x11vnc -auth guess -forever -noxdamage -repeat -rfbauth /etc/x11vnc/vncpwd
-rfbport 5900 -shared -noxkb -nomodtweak\n\n[Install]\nWantedBy=multi-user.target\n\n" > /lib/systemd/system/x11vnc.service

# Servicios
sudo systemctl daemon-reload
sudo systemctl enable x11vnc.service
sudo systemctl start x11vnc.service
# Cambio de Hostname, insercion de IP en base a la eleccion original.
echo "$hostn" > /home/tys/Documentos/Proyecto/MintyScript-main/prueba
echo "//192.168.$suc.5/factura/ /media/x      cifs    username=tys,password=tys,file_mode=0666,dir_mode=0777" >> /etc/fstab
printf "\n" >> /etc/fstab
echo "//192.168.$suc.5/temporal /media/t      cifs    username=tys,password=tys,file_mode=0666,dir_mode=0777" >> /etc/fstab

# Instalacion de impresoras Hasar, sourced de Mario Palacios, V2.
# Instalacion de aplicaciones y librerias necesarias.
# Paquetes que dan error! libcups2:i368
# libcups2:i368 no puede ser localizado
# libcupsfilters1:i386 no tiene un candidato para la instalacion


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
# Finalmente montamos la particion

sudo mount -a

printf "La instalacion de las impresoras termino\n"
printf "La instalacion de practicamente todo termino! wow. ※ (^o^)/※\n"
