Function New-DiskReport {
  [cmdletbinding()]
  Param(
      [Parameter(Mandatory)]
      [string]$Computername,

      [Parameter(Mandatory)]
      [ValidatePattern("\.htm(l)?$")]
      [string]$Path
  )

  $cimparams = @{
      ClassName    = 'Win32_logicaldisk'
      filter       = "drivetype=3"
      ComputerName = $Computername
  }
    
  $data = Get-CimInstance @cimparams | Select-Object -property DeviceID,
  VolumeName,
  @{Name="SizeGB";Expression={$_.size / 1gb -as [int32]}},
  @{Name="FreeGB";Expression={[math]::Round($_.freespace/1gb,4)}},
  @{Name="PctFree";Expression={[math]::Round(($_.freespace /$_.size) * 100,2)}}

  $htmlParams = @{
   Title = "$($Computername.toUpper()) Disk Report" 
   PreContent = "<H1>$($Computername.toUpper())</H1>"
  }

  $html = $data | ConvertTo-Html @htmlParams

  Set-Content -Value $html -Path $Path
} #end function

Describe New-DiskReport {

    Mock Get-CimInstance {
        return @{
            DeviceID   = "C:"
            Size       = 200GB
            Free       = 100GB
            VolumeName = "System"
        }

    } -ParameterFilter {$classname -eq 'win32_logicaldisk' -AND `
    $filter -eq "drivetype=3" -AND $computername -eq 'FOO'} -Verifiable


    New-DiskReport -Computername FOO -Path TESTDRIVE:\foo.html
    It "Should call Get-CimInstance" {
      Assert-VerifiableMock 
    }

    It "Should create a file" {
      Test-Path -Path TESTDRIVE:\foo.html | Should be $True
    }

    It "Should throw an error with an invalid file extension" {
      {New-Diskreport -computername FOO -Path TESTDRIVE:\foo.ht} | Should Throw
    }
}