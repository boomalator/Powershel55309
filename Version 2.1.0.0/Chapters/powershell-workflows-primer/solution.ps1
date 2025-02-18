﻿#Requires -version 5.0

<#
- Create a local user account called ITApp with a default password.
- Create a folder called C:\ITApp and share it as ITApp giving Everyone ReadAccess 
  and the ITApp user full control.
- Under C:\ITApp create folders Test_1 to Test_10
- Set the Remote Registry service to auto start
- Log each step to a text file called C:\ITAppWF.txt
#>

Workflow ITAppSetup {

Param(
[Parameter(Mandatory)]
[string]$Password,
[string]$Log = "c:\ITAppWF.txt"
)

Set-Content -Value "[$((Get-Date).timeofDay)] Starting Setup" -Path $log

Add-Content -Value "[$((Get-Date).timeofDay)] Configuring Remote Registry service" -Path $log
Set-Service -Name RemoteRegistry -StartupType Automatic

Sequence {
    Add-Content -Value "[$((Get-Date).timeofDay)] Creating local user" -Path $log
    net user ITApp $Password /add
}

Sequence {
    Add-Content -Value "[$((Get-Date).timeofDay)] Testing for C:\ITApp folder" -Path $log
    if (Test-Path -Path "C:\ITApp") {
        Add-Content -Value "[$((Get-Date).timeofDay)] Folder already exists." -Path $log
        $folder = Get-Item -Path "C:\ITApp"
    }
    else {
        Add-Content -Value "[$((Get-Date).timeofDay)] Creating C:\ITApp folder" -Path $log
        $folder = New-Item -Path C:\ -Name ITApp -ItemType Directory
        Add-Content -Value "[$((Get-Date).timeofDay)] Created $($folder.fullname)" -Path $log
    }

    Add-Content -Value "[$((Get-Date).timeofDay)] Testing for ITApp share" -Path $log
    if (Get-SmbShare ITApp -ErrorAction SilentlyContinue) {
        Add-Content -Value "[$((Get-Date).timeofDay)] File share already exists" -Path $log
    }
    else {
      Add-Content -Value "[$((Get-Date).timeofDay)] Creating file share" -Path $log
      New-SmbShare -Name ITApp -Path $folder.FullName -Description "ITApp data" -FullAccess "$($env:computername)\ITApp" -ReadAccess Everyone
    }

    Add-Content -Value "[$((Get-Date).timeofDay)] Creating subfolders" -Path $log
    foreach -parallel ($i in (1..10)) {
        $path = Join-Path -Path $folder.FullName -ChildPath "Test_$i"
        #add a random offset to avoid contention for the log file
        $offset = Get-Random -Minimum 500 -Maximum 2000
        Start-Sleep -Milliseconds $offset
        Add-Content -Value "[$((Get-Date).timeofDay)] Creating $path" -Path $log
        $out = New-Item -Path $folder.FullName -Name "Test_$i" -ItemType Directory 
    }
}
 Add-Content -Value "[$((Get-Date).timeofDay)] Setup complete" -Path $log

} #close workflow

<#
#Undo
net user itapp /del
remove-smbshare ITApp -force
del c:\itapp -recurse
del c:\itappwf.txt
#>n t e n t   - V a l u e   " [ $ ( ( G e t - D a t e ) . t i m e o f D a y ) ]   C r e a t e d   $ ( $ f o l d e r . f u l l n a m e ) "   - P a t h   $ l o g  
         }  
  
         A d d - C o n t e n t   - V a l u e   " [ $ ( ( G e t - D a t e ) . t i m e o f D a y ) ]   T e s t i n g   f o r   I T A p p   s h a r e "   - P a t h   $ l o g  
         i f   ( G e t - S m b S h a r e   I T A p p   - E r r o r A c t i o n   S i l e n t l y C o n t i n u e )   {  
                 A d d - C o n t e n t   - V a l u e   " [ $ ( ( G e t - D a t e ) . t i m e o f D a y ) ]   F i l e   s h a r e   a l r e a d y   e x i s t s "   - P a t h   $ l o g  
         }  
         e l s e   {  
             A d d - C o n t e n t   - V a l u e   " [ $ ( ( G e t - D a t e ) . t i m e o f D a y ) ]   C r e a t i n g   f i l e   s h a r e "   - P a t h   $ l o g  
             N e w - S m b S h a r e   - N a m e   I T A p p   - P a t h   $ f o l d e r . F u l l N a m e   - D e s c r i p t i o n   " I T A p p   d a t a "   - F u l l A c c e s s   " $ ( $ e n v : c o m p u t e r n a m e ) \ I T A p p "   - R e a d A c c e s s   E v e r y o n e  
         }  
  
         A d d - C o n t e n t   - V a l u e   " [ $ ( ( G e t - D a t e ) . t i m e o f D a y ) ]   C r e a t i n g   s u b f o l d e r s "   - P a t h   $ l o g  
         f o r e a c h   - p a r a l l e l   ( $ i   i n   ( 1 . . 1 0 ) )   {  
                 $ p a t h   =   J o i n - P a t h   - P a t h   $ f o l d e r . F u l l N a m e   - C h i l d P a t h   " T e s t _ $ i "  
                 # a d d   a   r a n d o m   o f f s e t   t o   a v o i d   c o n t e n t i o n   f o r   t h e   l o g   f i l e  
                 $ o f f s e t   =   G e t - R a n d o m   - M i n i m u m   5 0 0   - M a x i m u m   2 0 0 0  
                 S t a r t - S l e e p   - M i l l i s e c o n d s   $ o f f s e t  
                 A d d - C o n t e n t   - V a l u e   " [ $ ( ( G e t - D a t e ) . t i m e o f D a y ) ]   C r e a t i n g   $ p a t h "   - P a t h   $ l o g  
                 $ o u t   =   N e w - I t e m   - P a t h   $ f o l d e r . F u l l N a m e   - N a m e   " T e s t _ $ i "   - I t e m T y p e   D i r e c t o r y    
         }  
 }  
   A d d - C o n t e n t   - V a l u e   " [ $ ( ( G e t - D a t e ) . t i m e o f D a y ) ]   S e t u p   c o m p l e t e "   - P a t h   $ l o g  
  
 }   # c l o s e   w o r k f l o w  
  
 < #  
 # U n d o  
 n e t   u s e r   i t a p p   / d e l  
 r e m o v e - s m b s h a r e   I T A p p   - f o r c e  
 d e l   c : \ i t a p p   - r e c u r s e  
 d e l   c : \ i t a p p w f . t x t  
 # > 