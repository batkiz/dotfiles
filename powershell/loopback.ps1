# a powershell script to enable local loopback for uwp apps

Get-ChildItem "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Mappings" |
ForEach-Object { 
    Write-Host -ForegroundColor Yellow "Enable uwp loopback..." } {
    # $values = Get-ItemProperty $_.PSPath;
    # $uwpDisplayName = $values.DisplayName
    $arr = ($_.Name -split "\\")
    $uwpSid = $arr[$arr.count - 1]
    # $uwpSid
    # Write-Output "$uwpDisplayName  $uwpSid"

    CheckNetIsolation.exe loopbackexempt -a -p="$uwpSid" | Out-Null

} { Write-Host -ForegroundColor Yellow "Finished!" }
