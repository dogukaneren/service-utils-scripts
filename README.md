# service-utils-scripts

Bu repoda, Windows/Linux sistemlerinde hizmet verecek sistem yöneticisi dostu yardımcı scriptler (PowerShell, Bash, Batch) yer almaktadır.

---

## İçerik

### Windows PowerShell / Batch

- `StopAndDisableService.ps1` – Belirtilen servisi durdurur ve devre dışı bırakır.
- `StopAndDisableWorldWideWeb.bat` – IIS üzerindeki WWW servislerini devre dışı bırakır.
- `InstallAndConfigureFileZilla.bat` – FileZilla Server'ı indirip kurar ve yapılandırır.
- `RecursiveRename.ps1` – Dosyaları toplu olarak yeniden adlandırır.
- `PlateHealth.bat` – Sistem donanım sağlık verilerini gösterir (CPU, RAM, Disk).

### Linux Bash

- `mpymove.sh` – Dosyaları belirli kurallara göre taşır.
- `plate-generator.sh` – Rasgele plaka dosyaları oluşturur.
- `random-image-sender.sh` – Belirli dizinden rastgele resim yollar.
- `wipe-tracks.sh` – Kullanıcı izlerini siler (log, bash history).
- `plate-health.sh` – Linux sistem durumu (CPU, load, memory) raporlar.

### Python

- `win-utils.py` – Windows sistem donanım bilgilerini görüntüleyen yardımcı script.

---

## 🔧 Kurulum

> Scriptler çalıştırılmadan önce ilgili sistemde çalıştırma izinlerinin verilmiş olması gerekir.

- Windows PowerShell için:
  ```powershell
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
  ```

- Linux için:
  ```bash
  chmod +x *.sh
  ```

---

## Kullanım Örnekleri

```powershell
# Servisi durdurmak
.\StopAndDisableService.ps1 W3SVC
```

```batch
:: FileZilla kurulumu
InstallAndConfigureFileZilla.bat
```

```bash
# Rasgele plaka oluşturmak
./plate-generator.sh -n 100
```

- Tomcat dizini altında tomcat configürasyonlarını bulabilirsiniz
- Containers dizini altında Docker container için yaml dosyalarını bulabilirsiniz

---

## 🛡 Lisans

MIT Lisansı. Ayrıntılar için `LICENSE` dosyasına bakınız.

---

## 🤝 Katkıda Bulun

1. Forkla ve branch aç
2. Kodunu geliştir
3. Pull Request gönder 🎯
