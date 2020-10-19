Return "This is a snippets file not a script to run."

# json
{
    "Name":  "bits",
    "DisplayName":  "Background Intelligent Transfer Service",
    "Status":  4
}



# more json
[
    {
        "Name":  "BITS",
        "DisplayName":  "Background Intelligent Transfer Service",
        "Status":  4
    },
    {
        "Name":  "Bluetooth Device Monitor",
        "DisplayName":  "Bluetooth Device Monitor",
        "Status":  4
    },
    {
        "Name":  "Bluetooth OBEX Service",
        "DisplayName":  "Bluetooth OBEX Service",
        "Status":  4
    },
    {
        "Name":  "BrokerInfrastructure",
        "DisplayName":  "Background Tasks Infrastructure Service",
        "Status":  4
    },
    {
        "Name":  "Browser",
        "DisplayName":  "Computer Browser",
        "Status":  4
    },
    {
        "Name":  "BthHFSrv",
        "DisplayName":  "Bluetooth Handsfree Service",
        "Status":  1
    },
    {
        "Name":  "bthserv",
        "DisplayName":  "Bluetooth Support Service",
        "Status":  4
    }
]



# nested objects
{
    "Name":  "bits",
    "DisplayName":  "Background Intelligent Transfer Service",
    "Status":  4,
    "RequiredServices":  [
                     {
                         "CanPauseAndContinue":  false,
                         "CanShutdown":  false,
                         "CanStop":  false,
                         "DisplayName":  "Remote Procedure Call (RPC)",
                         "DependentServices":  null,
                         "MachineName":  ".",
                         "ServiceName":  "RpcSs",
                         "ServicesDependedOn":  "DcomLaunch RpcEptMapper",
                         "ServiceHandle":  null,
                         "Status":  4,
                         "ServiceType":  32,
                         "StartType":  2,
                         "Site":  null,
                         "Container":  null
                     },
                     {
                         "CanPauseAndContinue":  false,
                         "CanShutdown":  false,
                         "CanStop":  true,
                         "DisplayName":  "COM+ Event System",
                         "DependentServices":  "igfxCUIService1.0.0.0 
                          COMSysApp SENS BITS",
                         "MachineName":  ".",
                         "ServiceName":  "EventSystem",
                         "ServicesDependedOn":  "rpcss",
                         "ServiceHandle":  null,
                         "Status":  4,
                         "ServiceType":  32,
                         "StartType":  2,
                         "Site":  null,
                         "Container":  null
                     }
                         ]
}



# convert to json
Get-CimInstance win32_computersystem | ConvertTo-Json



# now into a file
Get-CimInstance win32_computersystem | ConvertTo-Json | 
Out-File wmics.json
Get-CimInstance win32_computersystem | ConvertTo-Json | 
Set-Content .\wmics2.json 



# smaller data
Get-CimInstance win32_computersystem | ConvertTo-Json -compress



# filter first
Get-CimInstance win32_computersystem -computername $env:computername | 
Select-Object -property PSComputername,Manufacturer,
@{Name="MemoryGB";Expression={$_.totalPhysicalmemory/1GB -as [int]}},
Number* | ConvertTo-Json



# creates
{
    "PSComputerName":  "CLIENT01",
    "Manufacturer":  "LENOVO",
    "MemoryGB":  8,
    "NumberOfLogicalProcessors":  4,
    "NumberOfProcessors":  1
}



# custom objects
[pscustomobject]@{
  Path = "C:\Scripts"
  LastModified = "6/1/2020"
  Count = 20
  Types = @(".ps1","psm1","psd1","json","xml")
} | ConvertTo-Json 



# creates
{
    "Path":  "C:\\Scripts",
    "LastModified":  "6/1/2020",
    "Count":  20,
    "Types":  [
                  ".ps1",
                  "psm1",
                  "psd1",
                  "json",
                  "xml"
              ]
}


# metadata
[pscustomobject]@{
  Created = (Get-Date)
  Comment = "config data for script tool"
},
[pscustomobject]@{
  Path = "C:\Scripts"
  LastModified = "6/1/2020"
  Count = 20
  Types = @(".ps1","psm1","psd1","json","xml")
} | ConvertTo-Json 



# creates
[
    {
        "Created":  {
                        "value":  "\/Date(1591287561241)\/",
                        "DisplayHint":  2,
                        "DateTime":  "Thursday, June 4, 2020 12:19:21 PM"
                    },
        "Comment":  "config data for script tool"
    },
    {
        "Path":  "C:\\Scripts",
        "LastModified":  "6/1/2020",
        "Count":  20,
        "Types":  [
                      ".ps1",
                      "psm1",
                      "psd1",
                      "json",
                      "xml"
                  ]
    }
]



# slight change
[pscustomobject]@{
  Created = (Get-Date).Tostring()
  Comment = "config data for script tool"
},



# now results
{
    "Created":  "6/4/2020 12:20:33 PM",
    "Comment":  "config data for script tool"
}



# json snippet
{
    "Name":  "wuauserv",
    "DisplayName":  "Windows Update",
    "Status":  1,
    "MachineName":  "chi-dc04",
    "Audit":  "06/04/20"
},



# convert from json
$in = Get-Content .\audit.json | ConvertFrom-Json

$in | Get-Member

$in[0..2] | clip

$in[0..2] | Select-Object -property Name,Displayname,
@{Name="Status";Expression = { $_.Status -as [System.ServiceProcess.ServiceControllerStatus]}},
@{Name="Audit";Expression= { $_.Audit -as [datetime]}},
@{Name="Computername";Expression = {$_.Machinename}}



# again
Get-Content .\audit.json | 
ConvertFrom-Json | Select-Object -property Name,Displayname,
@{Name="Status";Expression = { $_.Status -as [System.ServiceProcess.ServiceControllerStatus]}},
@{Name="Audit";Expression= { $_.Audit -as [datetime]}},
@{Name="Computername";Expression = {$_.Machinename}}



# fix for Windows PowerShell
Get-Content .\audit.json | 
ConvertFrom-Json | 
ForEach-Object { $_ | Select-Object -Property Name,Displayname,
@{Name="Status";Expression = { $_.Status -as [System.ServiceProcess.ServiceControllerStatus]}},
@{Name="Audit";Expression= { $_.Audit -as [datetime]}},
@{Name="Computername";Expression = {$_.Machinename}}
}

#this problem has been fixed in PowerShell 7