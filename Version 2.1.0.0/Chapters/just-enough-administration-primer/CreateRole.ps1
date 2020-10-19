#Requires -version 5.1

<#
SYNTAX
  New-PSRoleCapabilityFile [-Path] <String> [-AliasDefinitions <IDictionary[]>]
  [-AssembliesToLoad <String[]>] [-Author <String>] [-CompanyName <String>]
  [-Copyright <String>] [-Description <String>] [-EnvironmentVariables <IDictionary>]
  [-FormatsToProcess <String[]>] [-FunctionDefinitions <IDictionary[]>]
  [-Guid <Guid>] [-ModulesToImport <Object[]>] [-ScriptsToProcess <String[]>]
  [-TypesToProcess <String[]>] [-VariableDefinitions <Object>] [-VisibleAliases
  <String[]>] [-VisibleCmdlets <Object[]>] [-VisibleExternalCommands <String[]>]
  [-VisibleFunctions <Object[]>] [-VisibleProviders <String[]>] [<CommonParameters>]
#>

$params = @{
    Path             = ".\ShareAdmins.psrc"
    Description      = "Share Admin"
    VisibleFunctions = @("Get-SMBShare", "Get-SMBShareAccess", "Get-ShareSize")
    VisibleAliases   = "gcim"
    ModulesToImport  = "ShareAdmin"
    VisibleCmdlets   = @{Name = "Get-CimInstance"; Parameters = @{ Name = 'classname';
            ValidateSet                                               = 'win32_share'
        }, @{Name = "filter"}
    }
}
New-PSRoleCapabilityFile @params

#region copy to module

# Create a folder for the module
$modulename = "ShareAdmin"
#the path could also be a directory in $env:psmodulepath
$modulePath = Join-Path -path . -ChildPath $modulename
New-Item -ItemType Directory -Path $modulePath

<# Create an empty script module and module manifest. At least one file in the
module folder must have the same name as the folder itself.
#>
$path = (Join-Path -path $modulePath -ChildPath "$modulename.psm1")
New-Item -ItemType File -Path $path
$manifest = (Join-Path -path $modulePath -ChildPath "$modulename.psd1")
New-ModuleManifest -Path $manifest -RootModule "$modulename.psm1"

# Create the RoleCapabilities folder and copy in the PSRC file
$rcFolder = Join-Path -path $modulePath -ChildPath "RoleCapabilities"
New-Item -ItemType Directory $rcFolder
Copy-Item -Path .\ShareAdmins.psrc -Destination $rcFolder -PassThru -Force

#endregion