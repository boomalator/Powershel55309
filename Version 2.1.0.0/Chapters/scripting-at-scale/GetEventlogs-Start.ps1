﻿#Requires -version 5.0

[cmdletbinding()]
Param(
    [Parameter(Position = 0, Mandatory)]
    [ValidateNotNullorEmpty()]
    [string[]]$Computername,

    [ValidateSet("Error", "Warning", "Information", "SuccessAudit", "FailureAudit")]
    [string[]]$EntryType = @("Error", "Warning"),

    [ValidateSet("System", "Application", "Security",
        "Active Directory Web Services", "DNS Server")]
    [string]$Logname = "System",

    [datetime]$After = (Get-Date).AddHours(-24),

    [Alias("path")]
    [string]$OutputPath = "c:\work"
)

#get log data
Write-Host "Gathering $($EntryType -join ",") entries from $logname after $after from $($computername -join ",")"  -ForegroundColor cyan

$logParams = @{
    Computername = $Computername
    EntryType    = $EntryType
    Logname      = $Logname
    After        = $After
}

$data = Get-EventLog @logParams

#create html report
$fragments = @()
$fragments += "<H1>Summary from $After</H1>"
$fragments += "<H2>Count by server</H2>"
$fragments += $data | Group-Object -Property Machinename |
Sort-Object -property Count -Descending | Select-Object -property Count, Name |
ConvertTo-Html -As table -Fragment
$fragments += "<H2>Count by source</H2>"
$fragments += $data | Group-Object -Property source |
Sort-Object Count -Descending | Select-Object -property Count, Name |
ConvertTo-Html -As table -Fragment

$fragments += "<H2>Detail</H2>"
$fragments += $data | Select-Object -property Machinename, TimeGenerated, Source, EntryType, Message |
ConvertTo-Html -as Table -Fragment

$head = @"
<Title>Event Log Summary</Title>
<style>
h2 {
width:95%;
background-color:#7BA7C7;
font-family:Tahoma;
font-size:10pt;
font-color:Black;
}
body { background-color:#FFFFFF;
       font-family:Tahoma;
       font-size:10pt; }
td, th { border:1px solid black;
         border-collapse:collapse; }
th { color:white;
     background-color:black; }
table, tr, td, th { padding: 2px; margin: 0px }
tr:nth-child(odd) {background-color: lightgray}
table { width:95%;margin-left:5px; margin-bottom:20px;}
</style>
"@

$html = ConvertTo-Html -Body $fragments -PostContent "<h6>$(Get-Date)</h6>" -Head $head

#save results to a file
$filename = Join-Path -Path $OutputPath -ChildPath "$(Get-Date -UFormat '%Y%m%d_%H%M')_EventlogReport.htm"
Write-Host "Saving file to $filename" -ForegroundColor Cyan

Set-Content -Path $filename -Value $html -Encoding Ascii

#end of script r a g m e n t s   + =   $ d a t a   |   G r o u p - O b j e c t   - P r o p e r t y   s o u r c e   |  
 S o r t - O b j e c t   C o u n t   - D e s c e n d i n g   |   S e l e c t - O b j e c t   - p r o p e r t y   C o u n t ,   N a m e   |  
 C o n v e r t T o - H t m l   - A s   t a b l e   - F r a g m e n t  
  
 $ f r a g m e n t s   + =   " < H 2 > D e t a i l < / H 2 > "  
 $ f r a g m e n t s   + =   $ d a t a   |   S e l e c t - O b j e c t   - p r o p e r t y   M a c h i n e n a m e ,   T i m e G e n e r a t e d ,   S o u r c e ,   E n t r y T y p e ,   M e s s a g e   |  
 C o n v e r t T o - H t m l   - a s   T a b l e   - F r a g m e n t  
  
 $ h e a d   =   @ "  
 < T i t l e > E v e n t   L o g   S u m m a r y < / T i t l e >  
 < s t y l e >  
 h 2   {  
 w i d t h : 9 5 % ;  
 b a c k g r o u n d - c o l o r : # 7 B A 7 C 7 ;  
 f o n t - f a m i l y : T a h o m a ;  
 f o n t - s i z e : 1 0 p t ;  
 f o n t - c o l o r : B l a c k ;  
 }  
 b o d y   {   b a c k g r o u n d - c o l o r : # F F F F F F ;  
               f o n t - f a m i l y : T a h o m a ;  
               f o n t - s i z e : 1 0 p t ;   }  
 t d ,   t h   {   b o r d e r : 1 p x   s o l i d   b l a c k ;  
                   b o r d e r - c o l l a p s e : c o l l a p s e ;   }  
 t h   {   c o l o r : w h i t e ;  
           b a c k g r o u n d - c o l o r : b l a c k ;   }  
 t a b l e ,   t r ,   t d ,   t h   {   p a d d i n g :   2 p x ;   m a r g i n :   0 p x   }  
 t r : n t h - c h i l d ( o d d )   { b a c k g r o u n d - c o l o r :   l i g h t g r a y }  
 t a b l e   {   w i d t h : 9 5 % ; m a r g i n - l e f t : 5 p x ;   m a r g i n - b o t t o m : 2 0 p x ; }  
 < / s t y l e >  
 " @  
  
 $ h t m l   =   C o n v e r t T o - H t m l   - B o d y   $ f r a g m e n t s   - P o s t C o n t e n t   " < h 6 > $ ( G e t - D a t e ) < / h 6 > "   - H e a d   $ h e a d  
  
 # s a v e   r e s u l t s   t o   a   f i l e  
 $ f i l e n a m e   =   J o i n - P a t h   - P a t h   $ O u t p u t P a t h   - C h i l d P a t h   " $ ( G e t - D a t e   - U F o r m a t   ' % Y % m % d _ % H % M ' ) _ E v e n t l o g R e p o r t . h t m "  
 W r i t e - H o s t   " S a v i n g   f i l e   t o   $ f i l e n a m e "   - F o r e g r o u n d C o l o r   C y a n  
  
 S e t - C o n t e n t   - P a t h   $ f i l e n a m e   - V a l u e   $ h t m l   - E n c o d i n g   A s c i i  
  
 # e n d   o f   s c r i p t 