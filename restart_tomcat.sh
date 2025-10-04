#!/bin/bash

# ==============================
# Tomcat Restart Script
# ==============================

# TOMCAT SERVICE NAME (örnek: tomcat9, tomcat, tomcat10 vs.)
TOMCAT_SERVICE="tomcat9"

echo "=============================="
echo " TOMCAT SERVİSİ YENİDEN BAŞLATILIYOR "
echo "=============================="
echo

# 1. Servisi durdur
echo "[1/4] Tomcat servisini durduruluyor..."
sudo systemctl stop $TOMCAT_SERVICE
sleep 3

# 2. Tomcat ile ilgili kalan Java processlerini bul ve öldür
echo "[2/4] Kalan Java processleri kontrol ediliyor..."
PIDS=$(ps aux | grep '[j]ava' | grep tomcat | awk '{print $2}')

if [ -n "$PIDS" ]; then
  echo "Aşağıdaki Tomcat/Java processleri sonlandırılacak:"
  echo "$PIDS"
  for PID in $PIDS; do
    sudo kill -9 $PID 2>/dev/null && echo "Process $PID öldürüldü."
  done
else
  echo "Tomcat ile ilgili aktif java processi bulunamadı."
fi

# 3. Biraz bekle
sleep 2

# 4. Servisi yeniden başlat
echo "[3/4] Tomcat servisi başlatılıyor..."
sudo systemctl start $TOMCAT_SERVICE
sleep 3

# 5. Durum kontrolü
echo "[4/4] Servis durumu kontrol ediliyor..."
sudo systemctl status $TOMCAT_SERVICE --no-pager

echo
echo "Tomcat başarıyla yeniden başlatıldı."
