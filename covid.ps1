### program to generate HTML PAGE with related COVID data 
### Data specific to only India / Karnanata/ Bangalore
### Using API to fetch generate data ready with (https://api.covid19india.org/).
### Created by Omkar B 
### Free to use this powershell , free to modify.
### just be thankful
### Version 0.1.1 (beta)

### Thank you https://api.covid19india.org/ Creater , Grateful for your work.
#############-------------------------------------------------------------------------##############

##defining paths of dll if we ever needed 
Add-Type -Path "D:\microsoft.mshtml.dll" #used to for HTML PARSING 
Add-Type -AssemblyName "Microsoft.mshtml"


### defining temp location to store the files ##
$tempfolder = $env:temp


####-----------------Gathering information about covid---------------------############################
$ApiCovidUrl = invoke-webrequest -uri "https://data.gov.in/major-indicator/covid-19-india-data-source-mohfw#tabs-0-00308000-1594571779-3" -UseBasicParsing
## Content store in API COVID URL parsing it top get the links on outHTML, Also the url is the source of truth.
$CovidurlStatus = $ApiCovidUrl.StatusCode
$india_data = invoke-webrequest -uri "https://api.data.gov.in/resource/677ea746-7a41-4a98-9de9-777a2a071d81?limit=1&api-key=579b464db66ec23bdd000001cdc3b564546246a772a26393094f5645&format=json" -UseBasicParsing
    $india_data_sc = $india_data.statuscode
        if($india_data_sc = "200"){
        $india_data_content = $india_data.content | convertfrom-json | Select-Object -Expand Records 
        $india_data_content 
            }else{
                write-host "please check the url of statewisedata"
            }


$state_data = invoke-webrequest -uri "https://api.data.gov.in/resource/cd08e47b-bd70-4efb-8ebc-589344934531?limit=all&api-key=579b464db66ec23bdd000001cdc3b564546246a772a26393094f5645&format=json" -UseBasicParsing
$state_data_StatusCode = $state_data.StatusCode
        if($state_data_StatusCode = "200"){
            $state_data_content = $state_data.content | convertfrom-json | Select-Object -Expand Records | Select-Object * -unique 
            
                }else{
                    write-host "please check the url of statewisedata errorner"
                }


$DistrictTableStatusdata = invoke-webrequest -uri "https://api.covid19india.org/state_district_wise.json" -UseBasicParsing
$DistrictTableStatusdata_Statuscode = $DistrictTableStatusdata.StatusCode
        if($DistrictTableStatusdata_Statuscode = "200"){
            $DistrictTable = $DistrictTableStatusdata.Content | ConvertFrom-Json | Select-Object -expand karnataka | Select-Object -ExpandProperty Districtdata
            $DistrictTable.districtData
            $valuesExcluded = @('Equals','GetHashCode','GetType','ToString')
            $Districtnames = @($DistrictTableStatusdata.Content | convertfrom-json | select -expand karnataka | Select-Object -ExpandProperty Districtdata | GM | Select-Object name 
            where-object{$_ –ne "Equals"})
            $Districtnames = $Districtnames | ? {$_.name -ne 'Equals'} | ? {$_.name -ne 'GetHashCode'} | ? {$_.name -ne 'GetType'} | ? {$_.name -ne 'ToString'} | Select-Object -ExpandProperty name
            $copvid_districttable = @{}
                foreach($districtname in $districtnames){
                $DistrictTable_Value = $DistrictTableStatusdata.Content | ConvertFrom-Json | Select-Object -expand karnataka | Select-Object -ExpandProperty Districtdata | Select-Object -ExpandProperty $districtname
                $DistrictTable_Value =  $DistrictTable_Value -replace "@{notes=;",""
                $DistrictTable_Value =  $DistrictTable_Value -replace "delta=}",""
                #write-host $districtname $DistrictTable_Value
                 [array]$Covid_districttable += New-Object psobject -Property @{
                            Name=$districtname
                            information=$DistrictTable_Value
                            }
            }#endforeach
        $Covid_districttable = $Covid_districttable | Select-Object name,information -Unique
        }else{
            write-host "please check the url of DistrictTableStatusdata erroner"
        }

######-------- needed data to virualise data is just using javascript or in built ones.
######-------- $statewsieTableStatusdata
#####--------- $statewsieTable
#####--------- $Covid_districttable
#####--------- time to create html for this follow data to be helpful.

##Converting tables into HTML 
$india_data_table = $india_data_content | Sort-Object | ConvertTo-Html -Fragment -PreContent "<h2>Covid India informaton</h2>"

$state_Table = $state_data_content | ConvertTo-Html -Fragment -PreContent "<h2>Covid State wise informaton</h2>"

$Covid_districttable = $Covid_districttable | ConvertTo-Html -Fragment -PreContent "<h2>Karnataka district wise informaton</h2>"

################ CSS use it for header 
#CSS codes
$header = @"
<style>

   
    h1 { color: #F0FFFF; font-family: 'Helvetica Neue', sans-serif; font-size: 75px; font-weight: bold; letter-spacing: -1px; line-height: 1; text-align: center; }

    
    h2 {

        font-family: Arial, Helvetica, sans-serif;
        color: #0000ff;
        font-size: 16px;

    }

  body {
	height: 100%;
    text-align:center;
    }

    body {
	    margin: 0;
	    background: linear-gradient(45deg, #49a09d, #5f2c82);
	    font-family: sans-serif;
	    font-weight: 100;
    }

    .container {
	    position: absolute;
	    top: 50%;
	    left: 50%;
	    transform: translate(-50%, -50%);
        
    }

    table {
	    
	    border-collapse: collapse;
	    overflow: hidden;
	    box-shadow: 0 0 20px rgba(0,0,0,0.1);
        text-align:center;
        width:70%; 
        margin-left:15%; 
        margin-right:15%;
    }

    th,
    td {
	    padding: 15px;
	    background-color: rgba(255,255,255,0.2);
	    color: #fff;
    }

    th {
	    text-align: Center;
    }

    thead {
	    th {
		    background-color: #55608f;

	    }
    }

    tbody {
	    tr {
		    &:hover {
			    background-color: rgba(255,255,255,0.3);
		    }
	    }
	    td {
		    position: relative;
		    &:hover {
			    &:before {
				    content: "";
				    position: absolute;
				    left: 0;
				    right: 0;
				    top: -9999px;
				    bottom: -9999px;
				    background-color: rgba(255,255,255,0.2);
				    z-index: -1;
			    }
		    }
	    }
    }
    


    #CreationDate {

        font-family: Arial, Helvetica, sans-serif;
        color: #ff3300;
        font-size: 12px;

    }



</style>
"@


$Title = "<h1>Covid India information</h1>"
$title2 = "<h5> Automated Covid report by using powershell and gov.in api data, creator - Omkar B </h5>"
$title3 = "<h5> 1 day - 1 project mission</h5>"


$report = ConvertTo-HTML -Body "$title $title2 $title3 $india_data_table $Covid_districttable $state_Table" -Head $header -Title "Covid India Information Report" -PostContent "<p id='CreationDate'>Creation Date: $(Get-Date)</p>"
$report | Out-File D:\coviddata\covidpowershell.html
