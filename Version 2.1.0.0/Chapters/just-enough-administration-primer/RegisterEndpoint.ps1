﻿#Requires -version 5.1

<#
this needs to be run ON the remote server which means you'll need
to copy .psrc and .pscc files to the server
#>

$s = New-PSSession -ComputerName chi-fp02

#copy the pssc file to C:\ or some remote folder
Copy-Item .\shareadmin.pssc  -Destination C:\ -ToSession $s -force

#copy the module with the role configuration
Copy-Item .\ShareAdmin -Container -Recurse -Destination 'C:\Program Files\WindowsPowerShell\Modules' -ToSession $s -Force

#register everything. WinRM will restart breaking any existing sessions
Invoke-Command {
 Register-PSSessionConfiguration -Path c:\shareadmin.pssc -Name "ShareAdmins"
} -Session $s

#look at the new session configuration
Invoke-Command {
Get-PSSessionConfiguration ShareAdmins | Select-Object -Property *
} -computername chi-fp02

#this won't work in a remoting session without CredSSP
#you would have to run it ON the server to see what the user has access to.
Get-PSSessionCapability -ConfigurationName ShareAdmins -Username company\jshields

#test with a user that is a member of the group
$cred = Get-Credential company\jshields

Enter-PSSession -ComputerName chi-fp02 -ConfigurationName ShareAdmins -Credential $cred

#remove the configuration
Invoke-Command {
 Unregister-PSSessionConfiguration -Name shareadmins
} -computername chi-fp02
  a t   t h e   n e w   s e s s i o n   c o n f i g u r a t i o n  
 I n v o k e - C o m m a n d   {  
 G e t - P S S e s s i o n C o n f i g u r a t i o n   S h a r e A d m i n s   |   S e l e c t - O b j e c t   - P r o p e r t y   *  
 }   - c o m p u t e r n a m e   c h i - f p 0 2  
  
 # t h i s   w o n ' t   w o r k   i n   a   r e m o t i n g   s e s s i o n   w i t h o u t   C r e d S S P  
 # y o u   w o u l d   h a v e   t o   r u n   i t   O N   t h e   s e r v e r   t o   s e e   w h a t   t h e   u s e r   h a s   a c c e s s   t o .  
 G e t - P S S e s s i o n C a p a b i l i t y   - C o n f i g u r a t i o n N a m e   S h a r e A d m i n s   - U s e r n a m e   c o m p a n y \ j s h i e l d s  
  
 # t e s t   w i t h   a   u s e r   t h a t   i s   a   m e m b e r   o f   t h e   g r o u p  
 $ c r e d   =   G e t - C r e d e n t i a l   c o m p a n y \ j s h i e l d s  
  
 E n t e r - P S S e s s i o n   - C o m p u t e r N a m e   c h i - f p 0 2   - C o n f i g u r a t i o n N a m e   S h a r e A d m i n s   - C r e d e n t i a l   $ c r e d  
  
 # r e m o v e   t h e   c o n f i g u r a t i o n  
 I n v o k e - C o m m a n d   {  
   U n r e g i s t e r - P S S e s s i o n C o n f i g u r a t i o n   - N a m e   s h a r e a d m i n s  
 }   - c o m p u t e r n a m e   c h i - f p 0 2  
 