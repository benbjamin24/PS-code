#Ben Brouhard
 #set and DHCP address to Static

$profilename = "SEC.UNJSPF.ORG"




#get Current IP address
$wkspIP =  Get-NetIPConfiguration |where {$_.netProfile.name -eq $profilename}
$wkspIP
$adapter = $wkspIP.InterfaceAlias

#Disable-NetAdapter -Name $adapter -Confirm:$false

#enable-NetAdapter -Name $adapter -Confirm:$false



Remove-NetIPAddress -InterfaceAlias $wkspIP.InterfaceAlias -Confirm:$false

$wkspIP.IPv4Address.IPAddress
$wkspIP.IPv4DefaultGateway.nexthop

$adapter | New-NetIPAddress `
 -AddressFamily "IPv4" `
 -IPAddress $wkspIP.IPv4Address.IPAddress `
 -PrefixLength "24" `
 -DefaultGateway $wkspIP.IPv4DefaultGateway.nexthop

 Get-NetIPConfiguration -InterfaceAlias $adapter
