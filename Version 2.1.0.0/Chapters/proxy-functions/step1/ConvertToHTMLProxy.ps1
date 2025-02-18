﻿[CmdletBinding(DefaultParameterSetName='Page', 
HelpUri='http://go.microsoft.com/fwlink/?LinkID=113290', 
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
    [uri]
    ${CssUri},

    [Parameter(ParameterSetName='Fragment')]
    [ValidateNotNullOrEmpty()]
    [switch]
    ${Fragment},

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
        $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Utility\ConvertTo-Html',
        [System.Management.Automation.CommandTypes]::Cmdlet)
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

.ForwardHelpTargetName Microsoft.PowerShell.Utility\ConvertTo-Html
.ForwardHelpCategory Cmdlet

#>
  
  
         [ V a l i d a t e N o t N u l l O r E m p t y ( ) ]  
         [ s t r i n g [ ] ]  
         $ { P r e C o n t e n t } )  
  
 b e g i n  
 {  
         t r y   {  
                 $ o u t B u f f e r   =   $ n u l l  
                 i f   ( $ P S B o u n d P a r a m e t e r s . T r y G e t V a l u e ( ' O u t B u f f e r ' ,   [ r e f ] $ o u t B u f f e r ) )  
                 {  
                         $ P S B o u n d P a r a m e t e r s [ ' O u t B u f f e r ' ]   =   1  
                 }  
                 $ w r a p p e d C m d   =   $ E x e c u t i o n C o n t e x t . I n v o k e C o m m a n d . G e t C o m m a n d ( ' M i c r o s o f t . P o w e r S h e l l . U t i l i t y \ C o n v e r t T o - H t m l ' ,  
                 [ S y s t e m . M a n a g e m e n t . A u t o m a t i o n . C o m m a n d T y p e s ] : : C m d l e t )  
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
 < #  
  
 . F o r w a r d H e l p T a r g e t N a m e   M i c r o s o f t . P o w e r S h e l l . U t i l i t y \ C o n v e r t T o - H t m l  
 . F o r w a r d H e l p C a t e g o r y   C m d l e t  
  
 # >  
 