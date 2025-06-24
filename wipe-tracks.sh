#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "You must run this script as root."
  exit 1
fi

echo "Clearing history for all users..."

getent passwd | awk -F: '$3 >= 1000 && $1 != "nobody" { print $1":"$6 }' | while IFS=: read -r user homedir; do
  echo "User: $user (Home: $homedir)"

  for histfile in ".bash_history" ".zsh_history" ".sh_history"; do
    filepath="$homedir/$histfile"
    if [ -f "$filepath" ]; then
      echo " -> Clearing $filepath..."
      cat /dev/null > "$filepath"
      chown "$user":"$user" "$filepath"
    fi
  done
done

echo "Clearing root history..."
cat /dev/null > /root/.bash_history

echo "All history files have been cleared."
