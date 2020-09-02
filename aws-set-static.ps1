#Ben Brouhard
 #set and DHCP address to Static

$profilename = "SEC.UNJSPF.ORG"

#get Current IP address
$wkspIP =  Get-NetIPConfiguration |where {$_.netProfile.name -eq $profilename}
$wkspIP
$adapter = $wkspIP.InterfaceAlias


#Disable-NetAdapter -Name $adapter -Confirm:$false
#enable-NetAdapter -Name $adapter -Confirm:$false

start-sleep -Seconds 20

Remove-NetIPAddress -InterfaceAlias $wkspIP.InterfaceAlias -Confirm:$false

$wkspIP.IPv4Address.IPAddress
$wkspIP.IPv4DefaultGateway.nexthop

Get-NetAdapter -Name $adapter | New-NetIPAddress `
 -AddressFamily "IPv4" `
 -IPAddress $wkspIP.IPv4Address.IPAddress `
 -PrefixLength "24" `
 -DefaultGateway $wkspIP.IPv4DefaultGateway.nexthop

 Get-NetIPConfiguration -InterfaceAlias $adapter
