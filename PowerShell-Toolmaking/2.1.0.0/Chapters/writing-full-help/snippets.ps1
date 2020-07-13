Return "This is a snippets file not a script to run."

# install module
Install-Module platyps



# view help file info
Get-Command get-service | Select-Object HelpFile



# small chunk of XML help
<?xml version="1.0" encoding="utf-8"?>
<helpItems xmlns="http://msh" schema="maml">
  <!-- Updatable Help Version 5.0.7.0 -->
  <command:command xmlns:maml="http://schemas.microsoft.com/maml/2004/10"
xmlns:command="http://schemas.microsoft.com/ma
ml/dev/command/2004/10" xmlns:dev="http://schemas.microsoft.com/maml/dev/
2004/10" xmlns:MSHelp="http://msdn.microsoft.co
m/mshelp">
    <command:details>
      <command:name>Add-Computer</command:name>
      <maml:description>
        <maml:para>Add the local computer to a domain or workgroup.
</maml:para>
      </maml:description>
      <maml:copyright>
        <maml:para />
      </maml:copyright>
      <command:verb>Add</command:verb>
      <command:noun>Computer</command:noun>
      <dev:version />
    </command:details>
    <maml:description>
      <maml:para>The Add-Computer cmdlet adds the local computer or remote
computers to a domain or workgroup, or moves
them from one domain to another. It also creates a domain account if the
computer is added to the domain without an account.</maml:para>
      <maml:para>You can use the parameters of this cmdlet to specify an
organizational unit (OU) and domain controller or to perform an unsecure
join.</maml:para>
      <maml:para>To get the results of the command, use the Verbose and
PassThru parameters.</maml:para>
    </maml:description>
    <command:syntax>
      <command:syntaxItem>
        <maml:name>Add-Computer</maml:name>
        <command:parameter required="true" variableLength="false"
globbing="false" pipelineInput="false" position="1" aliases="DN,Domain">
          <maml:name>DomainName</maml:name>
          <maml:description>
            <maml:para>Specifies the domain to which the computers are
added. This parameter is required when adding the  computers to a domain.
</maml:para>
          </maml:description>
          <command:parameterValue required="true" variableLength="false">
String</command:parameterValue>




# assumes you're in sample code folder
mkdir Docs



# import module
Import-Module .\PSJsonCredential



# create help
New-Markdownhelp -Module PSJsonCredential -OutputFolder .\Docs\ -withModulePage



# markdown to add to Related Links
[Get-Credential]()

[ConvertFrom-SecureString]()

[Import-PSCredentialFromJson](Import-PSCredentialFromJson.md)

[Get-PSCredentialFromJson](Get-PSCredentialFromJson.md)

[https://msdn.microsoft.com/en-us/library/system.management.automation.
pscredential(v=vs.85).aspx]()



# complete markdown example
---
Module Name: PSJsonCredential
Module Guid: a582b122-80fd-4fcb-8c01-5520737530c9
Download Help Link: {{Please enter FwLink manually}}
Help Version: {{Please enter version of help manually (X.X.X.X) format}}
Locale: en-US
---

# PSJsonCredential Module
## Description
{{Manually Enter Description Here}}

## PSJsonCredential Cmdlets
### [Export-PSCredentialToJson](Export-PSCredentialToJson.md)
{{Manually Enter Export-PSCredentialToJson Description Here}}

### [Get-PSCredentialFromJson](Get-PSCredentialFromJson.md)
{{Manually Enter Get-PSCredentialFromJson Description Here}}

### [Import-PSCredentialFromJson](Import-PSCredentialFromJson.md)
{{Manually Enter Import-PSCredentialFromJson Description Here}}



# example
New-MarkdownHelp -Module PSJsonCredential -OutputFolder d:\temp `
-WithModulePage -HelpVersion 1.0.0.0 `
-fwlink http://mywebserver/help -force
copy D:\temp\PSJsonCredential.md -destination c:\psjsoncredential\docs



# produces
---
Module Name: PSJsonCredential
Module Guid: a582b122-80fd-4fcb-8c01-5520737530c9
Download Help Link: http://mywebserver/help
Help Version: 1.0.0.0
Locale: en-US
---

# PSJsonCredential Module
## Description
{{Manually Enter Description Here}}

## PSJsonCredential Cmdlets
### [Export-PSCredentialToJson](Export-PSCredentialToJson.md)
{{Manually Enter Export-PSCredentialToJson Description Here}}

### [Get-PSCredentialFromJson](Get-PSCredentialFromJson.md)
{{Manually Enter Get-PSCredentialFromJson Description Here}}

### [Import-PSCredentialFromJson](Import-PSCredentialFromJson.md)
{{Manually Enter Import-PSCredentialFromJson Description Here}}




# in help folder...
mkdir en-us



# or...
mkdir (Get-Culture).name



# run platyps
New-ExternalHelp -Path .\Docs\ `
-OutputPath .\en-US\ -Force



# preview
Get-HelpPreview -Path .\en-US\PSJsonCredential-help.xml



# online help
help get-ciminstance -online



# how to point to online help
Function Get-PSCredentialFromJson {

[cmdletbinding(HelpUri="http://bit.ly/Get-PSCredentialJson")]



# Markdown for related links
## RELATED LINKS
[http://bit.ly/Get-PScredentialJson]()



# creating "about" help
New-MarkdownAboutHelp -OutputFolder .\Docs\ -AboutName PSJsonCredential



