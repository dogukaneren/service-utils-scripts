@echo off
rem author Doğukan EREN

echo Slient install starting...

FileZilla_Server.exe /S /user=all

echo Installation complated!

set "FZ_INSTALL_DIR=C:\Program Files (x86)\FileZilla Server"

set "TARGET_CONFIG=%FZ_INSTALL_DIR%\FileZilla Server.xml"
echo %TARGET_CONFIG%
set "CONFIG_FILE=FileZilla Server.xml"

if exist "%CONFIG_FILE%" (
    echo Config found, copying...

    rem Backing up old config file...
    if exist "%TARGET_CONFIG%" (
        echo Eski config dosyası bulundu, renaming as old.xml...
        rename "%TARGET_CONFIG%" "old.xml"
    )

    timeout /t 2 /nobreak > nul
    
    taskkill.exe /F /IM "filezilla*"
    copy /Y "%CONFIG_FILE%" "%FZ_INSTALL_DIR%\FileZilla Server.xml"
    
    timeout /t 3 /nobreak > nul

    echo "Services staring..."
    sc start "FileZilla Server"

    start "" "%FZ_INSTALL_DIR%\FileZilla Server Interface.exe"
    
) else (
    echo No additional config found just installed please configure manually!!
    sleep 5
)
exit
