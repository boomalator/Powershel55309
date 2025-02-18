﻿#requires -version 5.0

class TMMachineInfo {

# Properties
[string]$ComputerName
[string]$OSVersion
[string]$OSBuild
[string]$Manufacturer
[string]$Model
[string]$Processors
[string]$Cores
[string]$RAM
[string]$SystemFreeSpace
[string]$Architecture
hidden[datetime]$Date
    
#Methods
[void]Refresh() {
        
    Try {
        $params = @{
                ComputerName  = $this.Computername
                ErrorAction   = 'Stop'
            }

        $session = New-CimSession @params

        #define a hashtable of parameters to splat
        #to Get-CimInstance
        $cimparams = @{
            ClassName  = 'Win32_OperatingSystem'
            CimSession = $session
            ErrorAction = 'stop'
        }
        $os = Get-CimInstance @cimparams

        $cimparams.Classname = 'Win32_ComputerSystem'
        $cs = Get-CimInstance @cimparams

        $cimparams.ClassName  = 'Win32_Processor'  
        $proc = Get-CimInstance @cimparams | Select-Object -first 1

        $sysdrive = $os.SystemDrive
        $cimparams.Classname = 'Win32_LogicalDisk'
        $cimparams.Filter = "DeviceId='$sysdrive'"        
        $drive = Get-CimInstance @cimparams

        $session | Remove-CimSession

        #use the computername from the CIM instance
        $this.ComputerName = $os.CSName
        $this.OSVersion = $os.version
        $this.OSBuild = $os.buildnumber
        $this.Manufacturer = $cs.manufacturer
        $this.Model = $cs.model
        $this.Processors = $cs.numberofprocessors
        $this.Cores = $cs.numberoflogicalprocessors
        $this.RAM = ($cs.totalphysicalmemory / 1GB)
        $this.Architecture = $proc.addresswidth
        $this.SystemFreeSpace = $drive.freespace
        $this.date = Get-Date
    }
    Catch {
        throw "Failed to connect to $this.computername. $($_.Exception.message)"
        } #try/catch
}

# Constructors
TMMachineInfo([string]$ComputerName) {
    $this.ComputerName = $ComputerName
    $this.Refresh()
}
} #class

Function Get-MachineInfo {
    [cmdletbinding()]
    [alias("gmi")]
    Param(
        [Parameter(Position = 0, ValueFromPipeline)]
        [Alias("cn")]
        [ValidateNotNullorEmpty()]
        [string[]]$Computername = $env:COMPUTERNAME
    )

    Begin {
        Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"
    } #begin

    Process {
        foreach ($computer in $computername) {
            Write-Verbose "[PROCESS] Getting machine information from $($computer.toUpper())"
            New-Object -TypeName TMMachineInfo -ArgumentList $computer
        }
    } #process

    End {
        Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
    } #end
}

Function Update-MachineInfo {
    [cmdletbinding()]
    [alias("umi")]
    Param(
        [Parameter(Position = 0, ValueFromPipeline)]
        [ValidateNotNullorEmpty()]
        [TMMachineInfo]$Info,
        [switch]$Passthru
    )

    Begin {
        Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"
    } #begin
    
    Process {
        Write-Verbose "[PROCESS] Refreshing: $(($Info.ComputerName).ToUpper())"
        $info.Refresh()

        if ($Passthru) {
            #write the updated object back to the pipeline
            $info
        }
    } #process

    End {
        Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
    } #end
} F r e e S p a c e   =   $ d r i v e . f r e e s p a c e  
                 $ t h i s . d a t e   =   G e t - D a t e  
         }  
         C a t c h   {  
                 t h r o w   " F a i l e d   t o   c o n n e c t   t o   $ t h i s . c o m p u t e r n a m e .   $ ( $ _ . E x c e p t i o n . m e s s a g e ) "  
                 }   # t r y / c a t c h  
 }  
  
 #   C o n s t r u c t o r s  
 T M M a c h i n e I n f o ( [ s t r i n g ] $ C o m p u t e r N a m e )   {  
         $ t h i s . C o m p u t e r N a m e   =   $ C o m p u t e r N a m e  
         $ t h i s . R e f r e s h ( )  
 }  
 }   # c l a s s  
  
 F u n c t i o n   G e t - M a c h i n e I n f o   {  
         [ c m d l e t b i n d i n g ( ) ]  
         [ a l i a s ( " g m i " ) ]  
         P a r a m (  
                 [ P a r a m e t e r ( P o s i t i o n   =   0 ,   V a l u e F r o m P i p e l i n e ) ]  
                 [ A l i a s ( " c n " ) ]  
                 [ V a l i d a t e N o t N u l l o r E m p t y ( ) ]  
                 [ s t r i n g [ ] ] $ C o m p u t e r n a m e   =   $ e n v : C O M P U T E R N A M E  
         )  
  
         B e g i n   {  
                 W r i t e - V e r b o s e   " [ B E G I N     ]   S t a r t i n g :   $ ( $ M y I n v o c a t i o n . M y c o m m a n d ) "  
         }   # b e g i n  
  
         P r o c e s s   {  
                 f o r e a c h   ( $ c o m p u t e r   i n   $ c o m p u t e r n a m e )   {  
                         W r i t e - V e r b o s e   " [ P R O C E S S ]   G e t t i n g   m a c h i n e   i n f o r m a t i o n   f r o m   $ ( $ c o m p u t e r . t o U p p e r ( ) ) "  
                         N e w - O b j e c t   - T y p e N a m e   T M M a c h i n e I n f o   - A r g u m e n t L i s t   $ c o m p u t e r  
                 }  
         }   # p r o c e s s  
  
         E n d   {  
                 W r i t e - V e r b o s e   " [ E N D         ]   E n d i n g :   $ ( $ M y I n v o c a t i o n . M y c o m m a n d ) "  
         }   # e n d  
 }  
  
 F u n c t i o n   U p d a t e - M a c h i n e I n f o   {  
         [ c m d l e t b i n d i n g ( ) ]  
         [ a l i a s ( " u m i " ) ]  
         P a r a m (  
                 [ P a r a m e t e r ( P o s i t i o n   =   0 ,   V a l u e F r o m P i p e l i n e ) ]  
                 [ V a l i d a t e N o t N u l l o r E m p t y ( ) ]  
                 [ T M M a c h i n e I n f o ] $ I n f o ,  
                 [ s w i t c h ] $ P a s s t h r u  
         )  
  
         B e g i n   {  
                 W r i t e - V e r b o s e   " [ B E G I N     ]   S t a r t i n g :   $ ( $ M y I n v o c a t i o n . M y c o m m a n d ) "  
         }   # b e g i n  
          
         P r o c e s s   {  
                 W r i t e - V e r b o s e   " [ P R O C E S S ]   R e f r e s h i n g :   $ ( ( $ I n f o . C o m p u t e r N a m e ) . T o U p p e r ( ) ) "  
                 $ i n f o . R e f r e s h ( )  
  
                 i f   ( $ P a s s t h r u )   {  
                         # w r i t e   t h e   u p d a t e d   o b j e c t   b a c k   t o   t h e   p i p e l i n e  
                         $ i n f o  
                 }  
         }   # p r o c e s s  
  
         E n d   {  
                 W r i t e - V e r b o s e   " [ E N D         ]   E n d i n g :   $ ( $ M y I n v o c a t i o n . M y c o m m a n d ) "  
         }   # e n d  
 } 