

<#PSScriptInfo
.DESCRIPTION 
    Sync all host DRS rules to backup-mgmt db using PowerCLI
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

#import-module -name DRSRule
function import-drsAFrules {
    

    Foreach ($cluster in get-cluster) {  
        Write-CustomOut "Checking $cluster"
        foreach ($drsafrule in get-drsrule -cluster $cluster ) {
            write-host $drsafrule.name
            write-host $drsafrule.Enabled
            write-host $drsafrule.type
            if ($drsafrule.Enabled -eq "true") { $enabled = 1}
            else {$enabled = 0}
            $drsafrulename = $drsafrule.name.Replace("'", "")
            ##instert in backup-mgmt db. 
            $DRSAFinsertQS = "	INSERT INTO vmware.vm_drsrules
	                        (Cluster, Ruletype, Enabled, RuleName)
	                        VALUES ('$cluster','$($drsafrule.type)','$enabled','$drsafrulename')"
	

            $DSinsertQS
            BGMGT-querysql $DRSAFinsertQS
	
            #end insert foreach
        }
		


    }
    Write-Host " "
}
 
Function import-drsclustergroups {
    foreach ($drsgroup in Get-DrsClusterGroup ) {
        write-host $drsgroup.name
        write-host $drsgroup.Cluster
        write-host $drsgroup.grouptype
        if ($drsafrule.Enabled -eq "true") { $enabled = 1}
        else {$enabled = 0}
        $drsgroupname = $drsgroup.name.Replace("'", "")
        ##instert in backup-mgmt db. 
        $DRSAFinsertQS = "	INSERT INTO vmware.vm_drsrules
	                        (Cluster, Ruletype,  RuleName)
	                        VALUES ('$($drsgroup.Cluster)','$($drsgroup.grouptype)','$drsgroupname')"
	

        $DSinsertQS
        BGMGT-querysql $DRSAFinsertQS
	
        #end insert foreach
    }
		


}


#import-drsclustergroups
function import-drsmembers {
    foreach ($drsgroup in Get-DrsClusterGroup ) {
        foreach ($member in $drsgroup.member) {
            write-host $drsgroup.Name
            write-host $member
            write-host ""

            $drsgroupname = $drsgroup.name.Replace("'", "")

            ##instert in backup-mgmt db. 
            $DRSmembersinsertQS = "	INSERT INTO vmware.vm_drsrules_members
    (Member, RuleName)
    VALUES ('$member','$drsgroupname')"


            $DRSmembersinsertQS

            BGMGT-querysql $DRSmembersinsertQS


        }

    }
}
import-drsmembers