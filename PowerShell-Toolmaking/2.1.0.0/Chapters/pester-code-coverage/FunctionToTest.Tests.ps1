$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Get-MyServer" {
    Mock Get-CimInstance {
        New-CimInstance -ClientOnly -ClassName Win32_ComputerSystem -Property @{
            Name                = "SERVER1"
            TotalPhysicalMemory = 32GB
            Model               = "BestServerEver"
        }
    } -ParameterFilter {$classname -eq "win32_computersystem"} -Verifiable

    Mock Get-CimInstance {
      New-CimInstance -ClientOnly -ClassName Win32_OperatingSystem -Property @{
          Caption     = "Windows Server"
          BuildNumber = "1234"
      }
    } -ParameterFilter {$classname -eq "win32_operatingsystem"} -Verifiable

    Mock Get-CimInstance {
      New-CimInstance -ClientOnly -ClassName Win32_Processor -Property @{
          Name = "Flux Capacitor 2K"
      }
    } -ParameterFilter {$classname -eq "win32_processor"} -Verifiable

    Mock Resolve-DNSName {
        @{
            Name       = "SERVER1"
            IP4Address = "10.10.10.10"
            Type       = "A"
        }
    } 
 
    $r = Get-MyServer -Computername SERVER1
   
    It "should run Get-CimInstance" {
        Assert-VerifiableMock
    }

    It "should run Get-CimInstance 3 times" {
        Assert-MockCalled Get-Ciminstance -Times 3
    }

    It "The result should have a Computername property of SERVER1" {
        $r.Computername | Should be "SERVER1"
    }

    It "The result should have a Build  property of 1234" {
        $r.build | Should be "1234"
    }
}
