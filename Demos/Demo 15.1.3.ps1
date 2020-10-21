<#
Save as C:\Program Files\WindowsPowerShell\Modules\Proxies\Proxies.psm1
Then in a console run:
Help Export-HTML

Then remove the comments from the end of this function, re-save
as Proxies.psm1, and in a console run:
Remove-Module Proxies
Help Export-HTML
#>

function Export-HTML {
    [CmdletBinding(DefaultParameterSetName='Page', 
                   RemotingCapability='None')]
    param(
        [Parameter(ValueFromPipeline=$true)]
        [psobject]
        ${InputObject},

        [Parameter(Position=0)]
        [System.Object[]]
        ${Property},

        [Parameter(ParameterSetName='Page', Position=3)]
        [string[]]
        ${Body},

        [Parameter(ParameterSetName='Page', Position=1)]
        [string[]]
        ${Head},

        [Parameter(ParameterSetName='Page', Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]
        ${Title},

        [ValidateNotNullOrEmpty()]
        [ValidateSet('Table','List')]
        [string]
        ${As},

        [Parameter(ParameterSetName='Page')]
        [Alias('cu','uri')]
        [ValidateNotNullOrEmpty()]
        [System.Uri]
        ${CssUri},

        [ValidateNotNullOrEmpty()]
        [string[]]
        ${PostContent},

        [ValidateNotNullOrEmpty()]
        [string[]]
        ${PreContent})

    begin
    {
        try {
            $outBuffer = $null
            if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
            {
                $PSBoundParameters['OutBuffer'] = 1
            }
            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('ConvertTo-Html', [System.Management.Automation.CommandTypes]::Cmdlet)
            $scriptCmd = {& $wrappedCmd @PSBoundParameters }
            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($PSCmdlet)
        } catch {
            throw
        }
    }

    process
    {
        try {
            $steppablePipeline.Process($_)
        } catch {
            throw
        }
    }

    end
    {
        try {
            $steppablePipeline.End()
        } catch {
            throw
        }
    }
    <#

    .ForwardHelpTargetName ConvertTo-Html
    .ForwardHelpCategory Cmdlet

    #>
}
