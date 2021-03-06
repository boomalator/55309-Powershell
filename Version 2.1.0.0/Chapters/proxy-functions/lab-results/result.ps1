﻿function Export-TDF {
[CmdletBinding(DefaultParameterSetName='Delimiter',
SupportsShouldProcess=$true,
ConfirmImpact='Medium',
HelpUri='http://go.microsoft.com/fwlink/?LinkID=113299')]
param(
    [Parameter(
      Mandatory=$true,
      ValueFromPipeline=$true,
      ValueFromPipelineByPropertyName=$true
      )]
    [psobject]$InputObject,

    [Parameter(Position=0)]
    [ValidateNotNullOrEmpty()]
    [string]$Path,

    [Alias('PSPath')]
    [ValidateNotNullOrEmpty()]
    [string]$LiteralPath,

    [switch]$Force,

    [Alias('NoOverwrite')]
    [switch]$NoClobber,

    [ValidateSet('Unicode','UTF7','UTF8','ASCII','UTF32',
    'BigEndianUnicode','Default','OEM')]
    [string]$Encoding,

    [switch]$Append,

    [Parameter(ParameterSetName='UseCulture')]
    [switch]$UseCulture,

    [Alias('NTI')]
    [switch]$NoTypeInformation
    )

begin
{
    try {
        $outBuffer = $null
        if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
        {
            $PSBoundParameters['OutBuffer'] = 1
        }
        $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Utility\Export-Csv',
         [System.Management.Automation.CommandTypes]::Cmdlet)
        $PSBoundParameters += @{'Delimiter'="`t"}
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

} #close function
      )  
  
 b e g i n  
 {  
         t r y   {  
                 $ o u t B u f f e r   =   $ n u l l  
                 i f   ( $ P S B o u n d P a r a m e t e r s . T r y G e t V a l u e ( ' O u t B u f f e r ' ,   [ r e f ] $ o u t B u f f e r ) )  
                 {  
                         $ P S B o u n d P a r a m e t e r s [ ' O u t B u f f e r ' ]   =   1  
                 }  
                 $ w r a p p e d C m d   =   $ E x e c u t i o n C o n t e x t . I n v o k e C o m m a n d . G e t C o m m a n d ( ' M i c r o s o f t . P o w e r S h e l l . U t i l i t y \ E x p o r t - C s v ' ,  
                   [ S y s t e m . M a n a g e m e n t . A u t o m a t i o n . C o m m a n d T y p e s ] : : C m d l e t )  
                 $ P S B o u n d P a r a m e t e r s   + =   @ { ' D e l i m i t e r ' = " ` t " }  
                 $ s c r i p t C m d   =   { &   $ w r a p p e d C m d   @ P S B o u n d P a r a m e t e r s   }  
                 $ s t e p p a b l e P i p e l i n e   =   $ s c r i p t C m d . G e t S t e p p a b l e P i p e l i n e ( $ m y I n v o c a t i o n . C o m m a n d O r i g i n )  
                 $ s t e p p a b l e P i p e l i n e . B e g i n ( $ P S C m d l e t )  
         }   c a t c h   {  
                 t h r o w  
         }  
 }  
  
 p r o c e s s  
 {  
         t r y   {  
                 $ s t e p p a b l e P i p e l i n e . P r o c e s s ( $ _ )  
         }   c a t c h   {  
                 t h r o w  
         }  
 }  
  
 e n d  
 {  
         t r y   {  
                 $ s t e p p a b l e P i p e l i n e . E n d ( )  
         }   c a t c h   {  
                 t h r o w  
         }  
 }  
  
 }   # c l o s e   f u n c t i o n  
 