﻿
#Write-Progress demonstrations
return "This is a demo script file."

1..50 | ForEach-Object {
  Write-Progress -Activity "My main activity" -Status "Status here" -CurrentOperation "Working on $_"
  Start-Sleep -Milliseconds 100
}

Get-Process | Where-Object starttime | ForEach-Object {
  Write-Progress -Activity "Get-Process" -status "Calculating process run time" `
    -CurrentOperation "process: $($_.name)"
  $_ | Select-Object ID, Name, StartTime, @{Name = "Runtime"; Expression = {(Get-Date) - $_.starttime}}
  Start-Sleep -Milliseconds 50
}


#calculating time
$i = 20
1..$i | ForEach-Object -Begin {
  [int]$seconds = 21
} -process {

  Write-Progress -Activity "My main activity" -Status "Calculating square roots" `
    -CurrentOperation "processing:  $_" -SecondsRemaining $seconds
  [math]::Sqrt($_)
  Start-Sleep -Seconds 1
  $seconds -= 1
}

#calculating a percent
#you need to know in advance

$i = 20
1..$i | ForEach-Object -Begin {
  [int]$count = 0
} -process {
  #calculate percent complete
  $count++
  $pct = ($count/$i) * 100
  Write-Progress -Activity "My main activity" -Status "Calculating square roots" `
    -CurrentOperation "processing:  $_" -PercentComplete $pct
  [math]::Sqrt($_)
  Start-Sleep -Milliseconds 200

}
 2 1  
 }   - p r o c e s s   {  
  
     W r i t e - P r o g r e s s   - A c t i v i t y   " M y   m a i n   a c t i v i t y "   - S t a t u s   " C a l c u l a t i n g   s q u a r e   r o o t s "   `  
         - C u r r e n t O p e r a t i o n   " p r o c e s s i n g :     $ _ "   - S e c o n d s R e m a i n i n g   $ s e c o n d s  
     [ m a t h ] : : S q r t ( $ _ )  
     S t a r t - S l e e p   - S e c o n d s   1  
     $ s e c o n d s   - =   1  
 }  
  
 # c a l c u l a t i n g   a   p e r c e n t  
 # y o u   n e e d   t o   k n o w   i n   a d v a n c e  
  
 $ i   =   2 0  
 1 . . $ i   |   F o r E a c h - O b j e c t   - B e g i n   {  
     [ i n t ] $ c o u n t   =   0  
 }   - p r o c e s s   {  
     # c a l c u l a t e   p e r c e n t   c o m p l e t e  
     $ c o u n t + +  
     $ p c t   =   ( $ c o u n t / $ i )   *   1 0 0  
     W r i t e - P r o g r e s s   - A c t i v i t y   " M y   m a i n   a c t i v i t y "   - S t a t u s   " C a l c u l a t i n g   s q u a r e   r o o t s "   `  
         - C u r r e n t O p e r a t i o n   " p r o c e s s i n g :     $ _ "   - P e r c e n t C o m p l e t e   $ p c t  
     [ m a t h ] : : S q r t ( $ _ )  
     S t a r t - S l e e p   - M i l l i s e c o n d s   2 0 0  
  
 }  
 