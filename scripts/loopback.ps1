# a powershell script to enable local loopback for uwp apps

Write-Host "Enable all UWP apps' loopback"

$apps = Get-ChildItem "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Mappings"

$apps | ForEach-Object {
    $arr = ($_.Name -split "\\")
    $uwpSid = $arr[$arr.count - 1]

    CheckNetIsolation.exe loopbackexempt -a -p="$uwpSid" | Out-Null
}

Write-Host "Finished!" 