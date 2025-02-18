﻿#Requires -version 5.0

Add-Type -AssemblyName PresentationFramework

#create a window form
$form = New-Object System.Windows.Window

#define what it looks like
$form.Title = "Hello WPF"
$form.Height = 200
$form.Width = 300

#create a button
$btn = New-Object System.Windows.Controls.Button
$btn.Content = "_OK"

#define what it looks like
$btn.Width = 65
$btn.HorizontalAlignment = "Center"
$btn.VerticalAlignment = "Center"

#add an event handler
$btn.Add_click({
 $msg = "Hello, World and $env:username!"
 Write-Host $msg -ForegroundColor Green
 
 #alternate command to test
 #Write-Output $msg
})

#add the button to the form
$form.AddChild($btn)

#show the form
$form.ShowDialog() | Out-Null
   =   6 5  
 $ b t n . H o r i z o n t a l A l i g n m e n t   =   " C e n t e r "  
 $ b t n . V e r t i c a l A l i g n m e n t   =   " C e n t e r "  
  
 # a d d   a n   e v e n t   h a n d l e r  
 $ b t n . A d d _ c l i c k ( {  
   $ m s g   =   " H e l l o ,   W o r l d   a n d   $ e n v : u s e r n a m e ! "  
   W r i t e - H o s t   $ m s g   - F o r e g r o u n d C o l o r   G r e e n  
    
   # a l t e r n a t e   c o m m a n d   t o   t e s t  
   # W r i t e - O u t p u t   $ m s g  
 } )  
  
 # a d d   t h e   b u t t o n   t o   t h e   f o r m  
 $ f o r m . A d d C h i l d ( $ b t n )  
  
 # s h o w   t h e   f o r m  
 $ f o r m . S h o w D i a l o g ( )   |   O u t - N u l l  
 