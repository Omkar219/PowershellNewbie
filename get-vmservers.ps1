# Requiring a space makes things legible and prevents confusion.
# Writing comments one-per line makes them stand out more in the console.

<#
    .SYNOPSIS
       Using vmware module to pull out the report of the servers with memory drive and mac list.
    .DESCRIPTION
      Using vmware module to pull out the report of the servers with memory drive and mac list.
    .Example
        get-vmservers -url "www.idk.com" -ouput "<path to save>"
#>

## adding addsnapin vmware.
asnp vmware* -ErrorAction SilentlyContinue

Connect-VIServer -server "taspukvca101.cernuk.com" -User "cernuk\ob051251" -Password "Jacob@2025"
$vmserver = Read-Host "Enter the VM you wanna get the details of" 

$networkdetails = Get-NetworkAdapter $vmserver -ErrorAction SilentlyContinue | select-object -expand type,macaddress


