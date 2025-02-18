﻿#WPF Demonstration using a stack panel

#add the assembly
Add-Type -AssemblyName PresentationFramework

#create the form
$form = New-Object System.Windows.Window

#define what it looks like
$form.Title = "Services"
$form.Height = 200
$form.Width = 300

#create the stack panel
$stack = New-Object System.Windows.Controls.StackPanel

#create a label and assign properties
$label = New-Object System.Windows.Controls.Label
$label.HorizontalAlignment = "Left"
$label.Content = "Enter a Computer name:"

#add to the stack
$stack.AddChild($label)

#create a text box and assign properties
$TextBox = New-Object System.Windows.Controls.TextBox
$TextBox.Width = 115
$TextBox.HorizontalAlignment = "Left"

#set a default value
$TextBox.Text = $env:COMPUTERNAME

#add to the stack
$stack.AddChild($TextBox)

#create a button and assign properties
$btn = New-Object System.Windows.Controls.Button
$btn.Content = "_OK"
$btn.Width = 75
$btn.VerticalAlignment = "Bottom"
$btn.HorizontalAlignment = "Center"

#this will sort of work
$OK = {
  Write-Host "Getting services from $($textbox.Text)" -ForegroundColor Green
  Get-Service -ComputerName $textbox.Text | Where-Object status -eq 'running'
}

#add an event handler
$btn.Add_click($OK)

#add to the stack
$stack.AddChild($btn)

#add the stack to the form
$form.AddChild($stack)

#show the form
$form.ShowDialog()
i g n m e n t   =   " L e f t "  
  
 # s e t   a   d e f a u l t   v a l u e  
 $ T e x t B o x . T e x t   =   $ e n v : C O M P U T E R N A M E  
  
 # a d d   t o   t h e   s t a c k  
 $ s t a c k . A d d C h i l d ( $ T e x t B o x )  
  
 # c r e a t e   a   b u t t o n   a n d   a s s i g n   p r o p e r t i e s  
 $ b t n   =   N e w - O b j e c t   S y s t e m . W i n d o w s . C o n t r o l s . B u t t o n  
 $ b t n . C o n t e n t   =   " _ O K "  
 $ b t n . W i d t h   =   7 5  
 $ b t n . V e r t i c a l A l i g n m e n t   =   " B o t t o m "  
 $ b t n . H o r i z o n t a l A l i g n m e n t   =   " C e n t e r "  
  
 # t h i s   w i l l   s o r t   o f   w o r k  
 $ O K   =   {  
     W r i t e - H o s t   " G e t t i n g   s e r v i c e s   f r o m   $ ( $ t e x t b o x . T e x t ) "   - F o r e g r o u n d C o l o r   G r e e n  
     G e t - S e r v i c e   - C o m p u t e r N a m e   $ t e x t b o x . T e x t   |   W h e r e - O b j e c t   s t a t u s   - e q   ' r u n n i n g '  
 }  
  
 # a d d   a n   e v e n t   h a n d l e r  
 $ b t n . A d d _ c l i c k ( $ O K )  
  
 # a d d   t o   t h e   s t a c k  
 $ s t a c k . A d d C h i l d ( $ b t n )  
  
 # a d d   t h e   s t a c k   t o   t h e   f o r m  
 $ f o r m . A d d C h i l d ( $ s t a c k )  
  
 # s h o w   t h e   f o r m  
 $ f o r m . S h o w D i a l o g ( )  
 