$WirelessSSIDs = (netsh wlan show profiles | Select-String ': ' ) -replace ".*:\s+"
$WifiInfo = foreach($SSID in $WirelessSSIDs) {
    $Password = (netsh wlan show profiles name=$SSID key=clear | Select-String 'Key Content') -replace ".*:\s+"
        New-Object -TypeName psobject -Property @{"SSID"=$SSID;"Password"=$Password}

}  
$WifiInfo | ConvertTo-Json
