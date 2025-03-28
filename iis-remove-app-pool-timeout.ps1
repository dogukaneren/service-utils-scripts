param (
    [string]$AppPoolName,
    [string]$IdleTimeout = "00:00:00"
)

Import-Module WebAdministration

$AppPoolPath = "IIS:\AppPools\$AppPoolName"

if (Test-Path $AppPoolPath) {
    Write-Host "Mevcut Idle Time-out Suresi: " -NoNewline
    (Get-ItemProperty $AppPoolPath -Name processModel).idleTimeout

    Set-ItemProperty $AppPoolPath -Name processModel.idleTimeout -Value $IdleTimeout

    Write-Host "Yeni Idle Time-out Suresi: " -NoNewline
    (Get-ItemProperty $AppPoolPath -Name processModel).idleTimeout

    Restart-WebAppPool -Name $AppPoolName
    Write-Host "Uygulama havuzu '$AppPoolName' yeniden baslatildi."
} else {
    Write-Host "Hata: '$AppPoolName' adli uygulama havuzu bulunamadi!" -ForegroundColor Red
}
