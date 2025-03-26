param(
    [string]$oldString,
    [string]$newString,
    [string]$folderPath = (Get-Location).Path
)

if (-not $oldString -or -not $newString) {
    Write-Output "Please provide both the string to replace and the replacement string. Example usage:"
    Write-Output "./script.ps1 -oldString '43015000000' -newString '43111320000' -folderPath 'C:\MyFolder'"
    exit
}

if (-not (Test-Path -Path $folderPath)) {
    Write-Output "Error: The specified folder path does not exist."
    exit
}

Write-Output "Starting to rename files in '$folderPath' replacing '$oldString' with '$newString'..."

Get-ChildItem -Path $folderPath -Filter "*$oldString*" -Recurse | ForEach-Object {
    $newName = $_.Name -replace [regex]::Escape($oldString), $newString
    $newPath = Join-Path $_.DirectoryName $newName
    
    if ($_.Name -ne $newName) {
        Rename-Item -Path $_.FullName -NewName $newName
        Write-Output "Renamed: $($_.FullName) -> $newPath"
    }
}

Write-Output "Operation completed for all files."
