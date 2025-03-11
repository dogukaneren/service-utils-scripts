@echo off
setlocal

set ServiceName=%1

if "%ServiceName%"=="" (
    echo Lutfen bir servis adi girin!
    exit /b
)

sc query "%ServiceName%" > nul 2>&1
if %errorlevel% neq 0 (
    echo Servis bulunamadi: %ServiceName%
    exit /b
)

echo Servis durduruluyor: %ServiceName% ...
sc stop "%ServiceName%" > nul 2>&1

echo Servis devre disi birakiliyor: %ServiceName% ...
sc config "%ServiceName%" start= disabled > nul 2>&1

echo Islemler tamamlandi.
endlocal
