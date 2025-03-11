param(
    [string]$ServiceName
)

$service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

if ($service -ne $null) {
    if ($service.Status -ne 'Stopped') {
        Stop-Service -Name $ServiceName -Force -ErrorAction SilentlyContinue
        Write-Output "Servis durduruldu: $ServiceName"
    } else {
        Write-Output "Servis zaten durdurulmus: $ServiceName"
    }

    Set-Service -Name $ServiceName -StartupType Disabled
    Write-Output "Servis devre disi birakildi: $ServiceName"
} else {
    Write-Output "Servis bulunamadi: $ServiceName"
}
