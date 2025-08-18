#!/bin/bash

SERVICE="tomcat9"
LOGFILE="/var/log/${SERVICE}_check.log"

if systemctl is-active --quiet "$SERVICE"; then
    echo "$(date): $SERVICE is running" >> "$LOGFILE"
else
    echo "$(date): $SERVICE is down, RESTARTING..." >> "$LOGFILE"
    systemctl restart "$SERVICE"
fi

# crontab -e ile girilip aşağıdaki gibi eklenirse 15 dakikada bir kontrol sağlanabilir.
# */15 * * * * /path/to/tomcat-check.sh
