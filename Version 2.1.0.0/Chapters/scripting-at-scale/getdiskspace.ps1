﻿Function Get-DiskSpace {
[cmdletbinding()]
Param(
[Parameter(Position = 0, Mandatory)]
[string[]]$Computername
)

Invoke-Command -scriptblock {
 Get-CimInstance -ClassName win32_logicaldisk -filter "deviceid='c:'" |
 Select-Object -property @{Name="Computername";Expression={$_.SystemName}},
 DeviceID,Size,Freespace,
 @{Name="PctFree";Expression={ "{0:p2}" -f $($_.freespace/$_.size)}}
} -ComputerName $computername -HideComputerName |
Select-Object -Property * -ExcludeProperty RunspaceID
}

#with error handling
Function Get-DiskSpace {
[cmdletbinding()]
Param(
[Parameter(Position = 0, Mandatory)]
[string[]]$Computername
)

foreach ($computer in $computername) {
  Write-Verbose "Querying $computer"
  Try {
    Invoke-Command -scriptblock {
     Get-CimInstance -ClassName win32_logicaldisk -filter "deviceid='c:'" |
     Select-Object -Property @{Name="Computername";Expression={$_.SystemName}},
     DeviceID,Size,Freespace,
     @{Name="PctFree";Expression={ "{0:p2}" -f $($_.freespace/$_.size)}}
    } -ComputerName $computer -HideComputerName -ErrorAction stop  |
     Select-Object -Property * -ExcludeProperty RunspaceID
   }
  Catch {
     Write-Warning "[$($computer.toupper())] $($_.exception.message)"
  }
} #foreach
}

#from the pipeline
Function Get-DiskSpace {
[cmdletbinding()]
Param(
[Parameter(Position = 0, Mandatory, ValueFromPipeline)]
[string[]]$Computername
)

Begin {
    #initialize an array
    $computers=@()
}

Process {
    #add each computer to the array
    $computers+=$Computername
}

End {
    #run the actual command here for all computers
    Invoke-Command -scriptblock {
     Get-CimInstance -ClassName win32_logicaldisk -filter "deviceid='c:'" |
     Select-Object -Property @{Name="Computername";Expression={$_.SystemName}},
     DeviceID,Size,Freespace,
     @{Name="PctFree";Expression={ "{0:p2}" -f $($_.freespace/$_.size)}}
    } -ComputerName $computers -HideComputerName  |
    Select-Object -Property * -ExcludeProperty RunspaceID
}
}

#with jobs
Function Get-DiskSpace {
[cmdletbinding()]
Param(
[Parameter(Position = 0, Mandatory, ValueFromPipeline)]
[string[]]$Computername,
[switch]$AsJob
)

Begin {
    #initialize an array
    $computers=@()
}

Process {
    #add each computer to the array
    $computers+=$Computername
}

End {
    #add a parameter
    $psboundParameters.Add("HideComputername",$True)

    #run the actual command here for all computers
    Invoke-Command -scriptblock {
     Get-CimInstance -ClassName win32_logicaldisk -filter "deviceid='c:'" |
     Select-Object -Property @{Name="Computername";Expression={$_.SystemName}},
     DeviceID,Size,Freespace,
     @{Name="PctFree";Expression={ "{0:p2}" -f $($_.freespace/$_.size)}}
    } @psboundParameters |
     Select-Object -Property * -ExcludeProperty RunspaceID
 }
}

#using runspaces
Function Get-DiskSpace {
[cmdletbinding()]
Param(
[Parameter(Position = 0, Mandatory)]
[string[]]$Computername
)

$rspace = @()

foreach ($computer in $computername) {
Write-Verbose "Creating runspace for $Computer"
  $run = [powershell]::Create()
  [void]$run.AddCommand("Get-CimInstance").addparameter("computername",$computer)
  [void]$run.Commands[0].AddParameter("classname","win32_logicaldisk")
  [void]$run.commands[0].addParameter("filter","deviceid='c:'")
  $handle = $run.beginInvoke()
  #add the handle as a property to make it easier to reference later
  $run | Add-member -MemberType NoteProperty -Name Handle -Value $handle
  $rspace+=$run
} #foreach

#wait for everything to complete
While (-Not $rspace.handle.isCompleted) {
  #an empty loop waiting for everything to complete
}

Write-Verbose "Getting results"
$results=@()
for ($i = 0;$i -lt $rspace.count;$i++) {
  #stop each runspace
  $results+= $rspace[$i].EndInvoke($rspace[$i].handle)
}
Write-Verbose "Cleaning up runspaces"
$rspace.ForEach({$_.dispose()})

Write-Verbose "Process the results"
$Results | 
Select-Object -property @{Name="Computername";Expression={$_.SystemName}},
DeviceID,Size,Freespace,
@{Name="PctFree";Expression={ "{0:p2}" -f $($_.freespace/$_.size)}}

}
i n g ( ) ]  
 P a r a m (  
 [ P a r a m e t e r ( P o s i t i o n   =   0 ,   M a n d a t o r y ,   V a l u e F r o m P i p e l i n e ) ]  
 [ s t r i n g [ ] ] $ C o m p u t e r n a m e ,  
 [ s w i t c h ] $ A s J o b  
 )  
  
 B e g i n   {  
         # i n i t i a l i z e   a n   a r r a y  
         $ c o m p u t e r s = @ ( )  
 }  
  
 P r o c e s s   {  
         # a d d   e a c h   c o m p u t e r   t o   t h e   a r r a y  
         $ c o m p u t e r s + = $ C o m p u t e r n a m e  
 }  
  
 E n d   {  
         # a d d   a   p a r a m e t e r  
         $ p s b o u n d P a r a m e t e r s . A d d ( " H i d e C o m p u t e r n a m e " , $ T r u e )  
  
         # r u n   t h e   a c t u a l   c o m m a n d   h e r e   f o r   a l l   c o m p u t e r s  
         I n v o k e - C o m m a n d   - s c r i p t b l o c k   {  
           G e t - C i m I n s t a n c e   - C l a s s N a m e   w i n 3 2 _ l o g i c a l d i s k   - f i l t e r   " d e v i c e i d = ' c : ' "   |  
           S e l e c t - O b j e c t   - P r o p e r t y   @ { N a m e = " C o m p u t e r n a m e " ; E x p r e s s i o n = { $ _ . S y s t e m N a m e } } ,  
           D e v i c e I D , S i z e , F r e e s p a c e ,  
           @ { N a m e = " P c t F r e e " ; E x p r e s s i o n = {   " { 0 : p 2 } "   - f   $ ( $ _ . f r e e s p a c e / $ _ . s i z e ) } }  
         }   @ p s b o u n d P a r a m e t e r s   |  
           S e l e c t - O b j e c t   - P r o p e r t y   *   - E x c l u d e P r o p e r t y   R u n s p a c e I D  
   }  
 }  
  
 # u s i n g   r u n s p a c e s  
 F u n c t i o n   G e t - D i s k S p a c e   {  
 [ c m d l e t b i n d i n g ( ) ]  
 P a r a m (  
 [ P a r a m e t e r ( P o s i t i o n   =   0 ,   M a n d a t o r y ) ]  
 [ s t r i n g [ ] ] $ C o m p u t e r n a m e  
 )  
  
 $ r s p a c e   =   @ ( )  
  
 f o r e a c h   ( $ c o m p u t e r   i n   $ c o m p u t e r n a m e )   {  
 W r i t e - V e r b o s e   " C r e a t i n g   r u n s p a c e   f o r   $ C o m p u t e r "  
     $ r u n   =   [ p o w e r s h e l l ] : : C r e a t e ( )  
     [ v o i d ] $ r u n . A d d C o m m a n d ( " G e t - C i m I n s t a n c e " ) . a d d p a r a m e t e r ( " c o m p u t e r n a m e " , $ c o m p u t e r )  
     [ v o i d ] $ r u n . C o m m a n d s [ 0 ] . A d d P a r a m e t e r ( " c l a s s n a m e " , " w i n 3 2 _ l o g i c a l d i s k " )  
     [ v o i d ] $ r u n . c o m m a n d s [ 0 ] . a d d P a r a m e t e r ( " f i l t e r " , " d e v i c e i d = ' c : ' " )  
     $ h a n d l e   =   $ r u n . b e g i n I n v o k e ( )  
     # a d d   t h e   h a n d l e   a s   a   p r o p e r t y   t o   m a k e   i t   e a s i e r   t o   r e f e r e n c e   l a t e r  
     $ r u n   |   A d d - m e m b e r   - M e m b e r T y p e   N o t e P r o p e r t y   - N a m e   H a n d l e   - V a l u e   $ h a n d l e  
     $ r s p a c e + = $ r u n  
 }   # f o r e a c h  
  
 # w a i t   f o r   e v e r y t h i n g   t o   c o m p l e t e  
 W h i l e   ( - N o t   $ r s p a c e . h a n d l e . i s C o m p l e t e d )   {  
     # a n   e m p t y   l o o p   w a i t i n g   f o r   e v e r y t h i n g   t o   c o m p l e t e  
 }  
  
 W r i t e - V e r b o s e   " G e t t i n g   r e s u l t s "  
 $ r e s u l t s = @ ( )  
 f o r   ( $ i   =   0 ; $ i   - l t   $ r s p a c e . c o u n t ; $ i + + )   {  
     # s t o p   e a c h   r u n s p a c e  
     $ r e s u l t s + =   $ r s p a c e [ $ i ] . E n d I n v o k e ( $ r s p a c e [ $ i ] . h a n d l e )  
 }  
 W r i t e - V e r b o s e   " C l e a n i n g   u p   r u n s p a c e s "  
 $ r s p a c e . F o r E a c h ( { $ _ . d i s p o s e ( ) } )  
  
 W r i t e - V e r b o s e   " P r o c e s s   t h e   r e s u l t s "  
 $ R e s u l t s   |    
 S e l e c t - O b j e c t   - p r o p e r t y   @ { N a m e = " C o m p u t e r n a m e " ; E x p r e s s i o n = { $ _ . S y s t e m N a m e } } ,  
 D e v i c e I D , S i z e , F r e e s p a c e ,  
 @ { N a m e = " P c t F r e e " ; E x p r e s s i o n = {   " { 0 : p 2 } "   - f   $ ( $ _ . f r e e s p a c e / $ _ . s i z e ) } }  
  
 }  
 