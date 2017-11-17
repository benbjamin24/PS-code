<#PSScriptInfo
.DESCRIPTION 
    List all host DRS rules using PowerCLI
.VERSION 
    0.0.1

.AUTHOR 
    Ben Brouhard @benbjamin24
.TAGS 
    VMware PowerCLI  
.Dependency 
DRSRules module
https://github.com/PowerCLIGoodies/DRSRule/b
#>



foreach ($cluster in get-cluster){
   Write-Host "$cluster"
    Get-DrsRule -Cluster $cluster
    Get-DrsVMGroup -Cluster $cluster
    Get-DrsVMToVMHostRule -Cluster $cluster
    Get-DrsVMToVMRule -Cluster $cluster
    Write-Host " "
} 