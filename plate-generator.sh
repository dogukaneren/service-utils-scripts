#!/bin/bash

# Plakalar listesi (buraya alt alta yazılabilir)
plates=(
"06ABC123"
"06ADC234"
)

id=1111111111111111
week_start=$(date -d "monday this week" +%Y-%m-%d)
week_end=$(date -d "sunday this week" +%Y-%m-%d)

echo "Haftanın başlangıcı: $week_start"
echo "Haftanın sonu: $week_end"

for plate in "${plates[@]}"; do
  
  random_day=$(date -d "$week_start +$((RANDOM % 7)) days" +%Y-%m-%d)

  
  hour=$(printf "%02d" $((RANDOM % 24)))
  minute=$(printf "%02d" $((RANDOM % 60)))
  second=$(printf "%02d" $((RANDOM % 60)))
  millisec=$(printf "%03d" $((RANDOM % 1000)))

  
  filename="${plate}_TUR_${id}_${random_day}_${hour}-${minute}-${second}-${millisec}_0_0_0_0_0-0-0-0_0_0_BW.jpg"

  
  touch "$filename"
  echo "Oluşturuldu: $filename"
done
