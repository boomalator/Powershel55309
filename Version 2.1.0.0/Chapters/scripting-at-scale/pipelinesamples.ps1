﻿
#demonstrate pipeline performance differences
return "This is a demo script file."

#region pipeline vs parameter

$names = Get-Service | Select-Object -ExpandProperty name

#57ms
Measure-Command {
 $names | Get-Service
}

#40ms
Measure-Command {
 Get-Service $names
}

$big = $names+$names+$names+$names+$names
#253ms
Measure-Command {
 $big | Get-Service
}

#169ms
Measure-Command {
 Get-Service $big
}

#endregion

#region breakup a command

#861ms
Measure-Command {
$data = Get-ChildItem $env:temp -file -Recurse | 
Group-Object -Property extension |
Sort-Object -Property Count | 
Select-Object -Property Count,Name,
@{Name="Size";Expression = {($_.group | Measure-object -Property length -sum).sum}}
}

#779ms
Measure-Command {
$files = Get-ChildItem $env:temp -file -Recurse
$grouped = $files | Group-Object -Property extension
$sorted = $grouped | Sort-Object -Property Count
$data = $sorted | Select-Object -Property Count,Name,
@{Name="Size";Expression = {($_.group | Measure-Object -Property length -sum).sum}}
}

#endregion

#region ForEach vs Foreach-Object

$n = 1..10000

#51.7ms
Measure-command {
 $a = 0
 foreach ($i in $n) {
   $a+=$i
 }
}

#227ms
Measure-command {

 $n | foreach-object -Begin { $a = 0 } -process {
   $a+=$_
 }

}

#endregion

i z e " ; E x p r e s s i o n   =   { ( $ _ . g r o u p   |   M e a s u r e - o b j e c t   - P r o p e r t y   l e n g t h   - s u m ) . s u m } }  
 }  
  
 # 7 7 9 m s  
 M e a s u r e - C o m m a n d   {  
 $ f i l e s   =   G e t - C h i l d I t e m   $ e n v : t e m p   - f i l e   - R e c u r s e  
 $ g r o u p e d   =   $ f i l e s   |   G r o u p - O b j e c t   - P r o p e r t y   e x t e n s i o n  
 $ s o r t e d   =   $ g r o u p e d   |   S o r t - O b j e c t   - P r o p e r t y   C o u n t  
 $ d a t a   =   $ s o r t e d   |   S e l e c t - O b j e c t   - P r o p e r t y   C o u n t , N a m e ,  
 @ { N a m e = " S i z e " ; E x p r e s s i o n   =   { ( $ _ . g r o u p   |   M e a s u r e - O b j e c t   - P r o p e r t y   l e n g t h   - s u m ) . s u m } }  
 }  
  
 # e n d r e g i o n  
  
 # r e g i o n   F o r E a c h   v s   F o r e a c h - O b j e c t  
  
 $ n   =   1 . . 1 0 0 0 0  
  
 # 5 1 . 7 m s  
 M e a s u r e - c o m m a n d   {  
   $ a   =   0  
   f o r e a c h   ( $ i   i n   $ n )   {  
       $ a + = $ i  
   }  
 }  
  
 # 2 2 7 m s  
 M e a s u r e - c o m m a n d   {  
  
   $ n   |   f o r e a c h - o b j e c t   - B e g i n   {   $ a   =   0   }   - p r o c e s s   {  
       $ a + = $ _  
   }  
  
 }  
  
 # e n d r e g i o n  
  
 