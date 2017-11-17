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


##list all clusters and DRSrules
Function get-alldrsrules {
    foreach ($cluster in get-cluster) {
        Write-Host "$cluster"
        Get-DrsRule -Cluster $cluster
        Get-DrsVMGroup -Cluster $cluster
        Get-DrsVMToVMHostRule -Cluster $cluster
        Get-DrsVMToVMRule -Cluster $cluster
        Write-Host " "
    } 
}

function export-alldrsrules {
    foreach ($cluster in get-cluster) {
        Export-DrsRule -Cluster $cluster -Path C:\temp\$cluster-export.json
    }
}

$DRShostrulesquery = "select * from vm_drsrules
where Ruletype = 'ClusterHostGroup'"

$DRSHOSTGROUPS = BGMGT-querysql $DRShostrulesquery

foreach ($HOSTGROUP in $DRSHOSTGROUPS ) { 
    if (!(Get-DrsVMHostGroup -Name $HOSTGROUP.RuleName)) {
        $DRShostmemberquery = "select member from vm_drsrules_members
        where RuleName = '$($HOSTGROUP.RuleName)'"
        $DRSHOSTMEMBERS = BGMGT-querysql $DRShostmemberquery
            foreach ($MEMBERS in $DRSHOSTMEMBERS){
                $MEMBER += $MEMBERS.Member
            }

        New-DrsVMHostGroup -Name $HOSTGROUP.RuleName  -VMHost $MEMBER -Cluster $HOSTGROUP.cluster
    }
}

#export-alldrsrules