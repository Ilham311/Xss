#!/usr/bin/env bash
set -e

echo "🔄 Updating package lists..."
sudo apt update

echo "⬇ Installing required packages (skipping if unavailable)..."
for pkg in \
libatk1.0-0t64 libatk-bridge2.0-0t64 libcups2t64 libgtk-3-0t64 libglib2.0-0t64 libasound2t64 \
libxcomposite1 libxdamage1 libxfixes3 libxrandr2 libx11-xcb1 libxrender1 libxcb1 libxcb-glx0 libxcb-dri3-0 \
libgbm1 libnss3 libdrm2 libxss1 libpangocairo-1.0-0 libpango-1.0-0 libpangoft2-1.0-0 \
fonts-liberation libu2f-udev libpci3 libxext6 libxau6 libxdmcp6 \
ca-certificates wget curl unzip xauth dbus xdg-utils lsb-release ca-certificates
do
  echo "➡ Installing $pkg..."
  sudo apt install -y "$pkg" || echo "⚠️ Skipping $pkg (not available)"
done

echo "🔧 Setting permissions on xss0r binary..."
sudo chmod 777 xss0r || true

echo "🔧 Setting recursive permissions on current directory..."
sudo chmod -R 777 .

CURRENT_DIR=$(pwd)
echo "📂 Current directory is: $CURRENT_DIR"
echo "🔧 chmod 777 on $CURRENT_DIR..."
sudo chmod 777 "$CURRENT_DIR"
echo "🔧 Changing ownership to www-data:www-data on $CURRENT_DIR..."
sudo chown -R www-data:www-data "$CURRENT_DIR"
echo "🔧 Changing group to www-data on $CURRENT_DIR..."
sudo chgrp -R www-data "$CURRENT_DIR"
echo "🔧 chmod -R 775 on $CURRENT_DIR..."
sudo chmod -R 775 "$CURRENT_DIR"
echo "🔧 chmod -R 777 on $CURRENT_DIR..."
sudo chmod -R 777 "$CURRENT_DIR"
echo "🔧 chmod -R 777 on /root/.config..."
sudo chmod -R 777 /root/.config/
echo "🔧 Changing ownership of /root/.config to $USER..."
sudo chown -R $USER:$USER /root/.config/
if [ "$(whoami)" != "root" ]; then
  echo "🔧 chmod -R 777 on /home/$USER/.config..."
  sudo chmod -R 777 /home/$USER/.config/
  echo "🔧 Changing ownership of /home/$USER/.config to $USER..."
  sudo chown -R $USER:$USER /home/$USER/.config/
fi

echo "✅ All done!"
if [ -x "./xss0r" ]; then
  echo "🚀 Now running xss0r app — please login with your credentials..."
  ./xss0r
else
  echo "⚠️ xss0r binary not found. Skipping execution."
fi
