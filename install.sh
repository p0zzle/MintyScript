#!/bin/bash

# Setup de servidor VNC, Minty.

# Borrando vino e instalando x11vnc

cd ~
sudo apt-get -y remove vino
sudo apt-get install -y x11vnc

# Creando las carpetas y el password

sudo mkdir /etc/x11vnc
sudo x11vnc --storepasswd /etc/x11vnc/vncpwd
# Falta ingresar input, Y + ENTER, e ingresar password.


# Creo el servicio para systemd

sudo xed /lib/systemd/system/x11vnc.service

echo "[Unit]\n Description=Start x11vnc at startup.\n After=multi-user.target\n\n [Service]\n Type=simple\n ExecStart=/usr/bin/x11vnc -auth guess -forever -noxdamage -repeat -rfbauth /etc/x11vnc/vncpwd -rfbport 5900 -shared -noxkb -nomodtweak \n [Install]\n WantedBy=multi-user.target\n\n" >> /lib/systemd/system/x11vnc.service

# Recarga los servicios

sudo systemctl daemon-reload

# Habilita el servicio x11vnc

sudo systemctl enable x11vnc.service

# Empieza el servicio para evitar reiniciarlo

sudo systemctl start x11vnc.service
