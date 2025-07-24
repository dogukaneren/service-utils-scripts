param(
    [Parameter(Mandatory=$true)]
    [string]$ServiceName
)

$service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

if ($null -eq $service) {
    Write-Host "Servis bulunamadı: $ServiceName"
} else {
    if ($service.Status -ne 'Stopped') {
        Write-Host "Servis durduruluyor..."
        Stop-Service -Name $ServiceName -Force
    }
    Write-Host "Servis siliniyor..."
    sc.exe delete $ServiceName
}
