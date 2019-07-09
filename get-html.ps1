# Requiring a space makes things legible and prevents confusion.
# Writing comments one-per line makes them stand out more in the console.

<#
    .SYNOPSIS
       Downloading the HTML file and saving it to a tmp folder, with log system for each process
    .DESCRIPTION
        Downloading the HTML file and saving it to a tmp folder, with log system for each process
    .Example
        get-Html -url "www.idk.com" -ouput "<path to save>"
#>

function write-log{
    param (
        # Parameter help description
        [Parameter(Position = 0)]$type,
        [Parameter(Position = 1)]$Message
  
   )

   $date_time = Get-date -format "yyyy-mm-dd HH:mm:ss"
   $LogFile = "C:\Log_files\Htmloutput.log"
   $string = "$date_time : $type : $Message"
   write-host $string
   $string | Out-File -FilePath $LogFile -Force -Append
}

### Check for Url is reachable and download the string in out put file.
function get-htmlfile{
 param(
     # Parameter help description
     [Parameter(Position = 0)]$url,
     [Parameter(Position = 1)]$output
  
   )
   $geturl = Invoke-WebRequest $url
   $statuscode = $geturl | Select-Object -expand statuscode
   if($statuscode -eq "200"){
    ##downloading the file content
    write-log "status" "200"
      if(!$output){

        Invoke-WebRequest -uri $url -outfile "C:\temp\file"
        write-log "$url" "C:\temp\file" 
      } else {

        Invoke-WebRequest -uri $url -outfile $output
        write-log "$url" "$output"
      }
   }
}


#get-htmlfile -url "www.google.com" -output "C:\temp\google.html"