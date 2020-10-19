#requires -version 5.0
#requires -module Plaster

#this function assumes you have git installed and configured

Function New-Scaffold {
    [cmdletbinding(SupportsShouldProcess)]
    Param(
        [Parameter(
            Mandatory,
            HelpMessage = "Enter the name of your new module."
            )]
        [ValidateNotNullorEmpty()]
        [string]$ModuleName,
        [Parameter(
            Mandatory,
            HelpMessage = "The folder name for your new module. The top level name should match the module name"
            )]
        [ValidateNotNullorEmpty()]
        [string]$DestinationPath,
        [Parameter(
            Mandatory,
            HelpMessage = "Enter a brief description about your project"
         )]
        [ValidateNotNullorEmpty()]
        [string]$Description,
        [Parameter(HelpMessage ="The module version")]
        [string]$Version = "0.1.0",
        [Parameter(HelpMessage ="The module author which should be your git user name")]
        [string]$ModuleAuthor = $(git config --get user.name),
        [ValidateSet("none", "VSCode")]
        [Parameter(HelpMessage = "Do you want to include VSCode settings?")]
        [string]$Editor = "VSCode",
        [Parameter(HelpMessage = "The minimum required version of PowerShell for your module")]
        [string]$PSVersion = "5.0",
        [Parameter(HelpMessage = "The path to the Plaster template")]
        [ValidateNotNullorEmpty()]
        [ValidateScript({ Test-Path $_ })]
        [string]$TemplatePath = "C:\Program Files\WindowsPowerShell\Modules\myTemplates\myProject\"
    )

    if (-Not (Test-PlasterManifest -Path $TemplatePath\plastermanifest.xml)) {
        write-Warning "Failed to find a valid plastermanifest.xml file in $TemplatePath"
        #bail out
        return
    }
    if (-Not $PSBoundParameters.ContainsKey("templatePath")) {
        $PSBoundParameters["TemplatePath"] = $TemplatePath
    }
    if (-not $PSBoundParameters.ContainsKey("version")) {
        $PSBoundParameters["version"] = $version
    }
    if (-not $PSBoundParameters.ContainsKey("ModuleAuthor")) {
        $PSBoundParameters["ModuleAuthor"] = $ModuleAuthor
    }
    if (-not $PSBoundParameters.ContainsKey("Editor")) {
        $PSBoundParameters["editor"] = $editor
    }
    if (-not $PSBoundParameters.ContainsKey("PSVersion")) {
        $PSBoundParameters["PSVersion"] = $PSVersion
    }

    $PSBoundParameters | Out-String | Write-Verbose
    Invoke-Plaster @PSBoundParameters

    if ($PSCmdlet.ShouldProcess($DestinationPath)) {
        Write-Host "Initializing $DestinationPath for git" -ForegroundColor cyan
        Set-Location $DestinationPath
        git init
        Write-Host "Adding initial files to first commit" -ForegroundColor cyan
        git add .
        git commit -m "initial files"
        Write-Host "Switching to Dev branch" -ForegroundColor cyan
        git branch dev
        git checkout dev
    }
    Write-Host "Scaffolding complete" -ForegroundColor green
}   