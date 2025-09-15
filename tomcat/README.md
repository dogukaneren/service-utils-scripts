## Tomcat 80 portunda çalışabilmesi için setcapd izin komutu:
``` bash
sudo setcap 'cap_net_bind_service=+ep' $(readlink -f $(which java))
```
