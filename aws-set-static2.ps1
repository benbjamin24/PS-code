#Ben Brouhard
# script to set workspaces IP to static

$profilename = ""

do{
$wkspIP =  Get-NetIPConfiguration |where {$_.netProfile.name -eq $profilename }

$adaptername = $wkspIP.InterfaceAlias
$adapter = Get-NetAdapter $wkspIP.InterfaceAlias
 If (!$adapter){
               Get-NetAdapter |where {$_.interfacedescription -like "*1"} |Set-NetIPInterface -Dhcp Enabled
               }

Get-NetIPConfiguration |where {$_.netProfile.name -eq $profilename }
} while (!$adapter)



$loop=1
$max =5
 
 if ($wkspIP.IPv4Address.IPAddress -like "169.*" ){
 do
 {
   Write-host "attempting to reset $adaptername `n Attempt: $loop of $max"
    if ($loop -gt $max){ Write-Error "Network adpater can not get a valid IP. quiting" -ErrorAction Stop }

    Write-host -ForegroundColor Yellow "..Disable $adaptername"
    Disable-NetAdapter -Name $adaptername -Confirm:$false
    sleep 5
    write-host -ForegroundColor Yellow "...Enable $adaptername"
    enable-NetAdapter -Name $adaptername -Confirm:$false
    write-host "Waiting for adapter to start"
    start-sleep -Seconds 45
  
    write-host -foregroundcolor Green "....Checking IP"
    $wkspIP =  Get-NetIPConfiguration |where {$_.netProfile.name -eq $profilename }
     Get-NetIPConfiguration |where {$_.netProfile.name -eq $profilename }
    $wkspIP
  $loop ++
  }
  while ($wkspIP.IPv4Address.IPAddress -like "169.*")
}

$newIP =$wkspIP.IPv4Address.IPAddress
$newGateway = $wkspIP.IPv4DefaultGateway.nexthop
Remove-NetIPAddress -InterfaceAlias $adaptername -Confirm:$false

 If (($adapter | Get-NetIPConfiguration).Ipv4DefaultGateway) {
 $adapter | Remove-NetRoute -Confirm:$false
 }
#Remove-netroute -InterfaceAlias $adapthername

write-host -foregroundcolor DarkCyan "
            Setting the IP to Static:`n
            IP: $newIP `n 
            Gateway $newGateway"
            

if ($newIP -notlike "169.*"){
$adapter | New-NetIPAddress -AddressFamily "IPv4"  -IPAddress $wkspIP.IPv4Address.IPAddress  -PrefixLength "24"  -DefaultGateway $wkspIP.IPv4DefaultGateway.nexthop 
}

 #Get-NetIPConfiguration -InterfaceAlias $adaptername
 sleep 5
 ipconfig
