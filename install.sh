#!/bin/bash

# Setup de servidor VNC, Instalacion de Impresoras, modificacion de IP, etc, etc. El punto es dejar una maquina con Minty completamente utilizable.
# Por Leon Collazo Arechaga; p0zzel
# V0.1

# Script start;
# Borrando vino e instalando x11vnc

sudo apt-get -y remove vino
sudo apt-get install -y x11vnc

# Creando las carpetas y el password

sudo mkdir /etc/x11vnc
sudo x11vnc --storepasswd /etc/x11vnc/vncpwd
# Falta ingresar input, Y + ENTER, e ingresar password.


# Creo el servicio para systemd

printf "[Unit]\nDescription=Start x11vnc at startup.\nAfter=multi-user.target\n\n[Service]\n
Type=simple\nExecStart=/usr/bin/x11vnc -auth guess -forever -noxdamage -repeat -rfbauth /etc/x11vnc/vncpwd 
-rfbport 5900 -shared -noxkb -nomodtweak\n\n[Install]\nWantedBy=multi-user.target\n\n" >> /lib/systemd/system/x11vnc.service

# Recarga los servicios

sudo systemctl daemon-reload

# Habilita el servicio x11vnc

sudo systemctl enable x11vnc.service

# Empieza el servicio para evitar reiniciarlo

sudo systemctl start x11vnc.service

# Setup de carpetas, cambio de Hostname, seleccion de IP manual en base al lugar de Instalacion.

sudo mkdir /media/x
sudo mkdir /media/t

printf "//192.$lugar.0.5/factura/ /media/x      cifs    username=tys,password=tys,file_mode=0666,dir_mode=0777\n
//192.$lugar.0.5/temporal /media/t      cifs    username=tys,password=tys,file_mode=0666,dir_mode=0777\n" >> /etc/fstab


# Instalacion de impresoras Hasar, sourced de Mario Palacios, V2.
# Instalacion de aplicaciones y librerias necesarias.
sudo apt-get install cups ia32-libs libcups2:i368 libcupsfilters1:i386 libcupsimage2:i386 -y

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
