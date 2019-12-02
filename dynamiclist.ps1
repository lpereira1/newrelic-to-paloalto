<#

.SYNOPSIS
This is a simple Powershell script that intakes the address list from New-Relic Minion address list, strips out the JSON and 
convert it to a simple list which can be use by Palo Alto Firewalls to build dynamic Block lists

.DESCRIPTION
The script itself will intake the IP List mentioned in the New Relic documentation : 
     https://docs.newrelic.com/docs/synthetics/new-relic-synthetics/administration/synthetics-public-minion-ips

     Parse out only locations in the USA and build a list of IPs in a text file which Palo Alto can use as shown in : 
     https://docs.paloaltonetworks.com/pan-os/8-0/pan-os-admin/policy/use-an-external-dynamic-list-in-policy/configure-the-firewall-to-access-an-external-dynamic-list

 The only arguement needed is the "-FilePath" : Location and name of file you want to output to. If no argument exists the file iplist.txt will be created in the directory the
 script exists in.

.EXAMPLE
./dynamiclist.ps1 -FilePath C:\temp\dynamiclist.txt

.NOTES
None

.LINK
Contact : Lazaro Pereira 

#>



Param (
    [string]$FilePath
)

Function CreateDynamicList([string]$FilePath)

{
    if(Test-Path -pathtype Any (Split-Path $FilePath))
    {
    $response = Invoke-RestMethod -Uri "https://s3.amazonaws.com/nr-synthetics-assets/nat-ip-dnsname/production/ip.json" 


    ForEach ($property in $response.PSObject.Properties )
        {
        if($property.Name.Contains("USA")) {
        $property.Value | Out-File -Encoding utf8 $FilePath -Append
        }
    }
 
}else {
    "The File Location does not appear to be Valid : $FilePath"
    }
}

if($args.Count -eq 0) {
    "no Arguments"
    CreateDynamicList('.\iplist.txt')
    return
}

CreateDynamicList($FilePath)