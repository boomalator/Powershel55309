﻿Function Get-TMComputerStatus {
 
[cmdletbinding()]
Param(
    [Parameter(ValueFromPipeline, Mandatory)]
    [ValidateNotNullorEmpty()]
    [Alias("CN", "Machine", "Name")]
    [string[]]$Computername,
    [string]$ErrorLog,
    [switch]$ErrorAppend
)

BEGIN {
    Write-Verbose "Starting $($myinvocation.mycommand)"
}

PROCESS {
  foreach ($computer in $Computername) {
     Write-Verbose "Querying $($computer.toUpper())"

     Try {
         $params = @{
          Classname    = "Win32_OperatingSystem"
          Computername = $computer
          ErrorAction  = "Stop"
        }
        $OS = Get-CimInstance @params

        $params.ClassName = "Win32_Processor"
        $cpu = Get-CimInstance @params

        $params.className = "Win32_logicalDisk"
        $vol = Get-CimInstance @params -filter "DeviceID='c:'"
        
        $OK = $True
     }
     Catch {
         $OK = $False
         $msg = "Failed to get system information from $computer. $($_.Exception.Message)"
         Write-Warning $msg
         if ($ErrorLog) {
             Write-Verbose "Logging errors to $ErrorLog. Append = $ErrorAppend"
            "[$(Get-Date)] $msg" | Out-File -FilePath $ErrorLog -Append:$ErrorAppend
         }
     }
     if ($OK) {
        #only continue if successful
        $obj = [pscustomobject]@{
          Computername = $os.CSName
          TotalMem     = $os.TotalVisibleMemorySize
          FreeMem      = $os.FreePhysicalMemory
          Processes    = $os.NumberOfProcesses
          PctFreeMem   = ($os.FreePhysicalMemory/$os.TotalVisibleMemorySize)*100
          Uptime       = (Get-Date) - $os.lastBootUpTime
          CPULoad      = $cpu.LoadPercentage
          PctFreeC     = ($vol.FreeSpace/$vol.size)*100
        }
         # create a default display property set
        [string[]]$props = 'ComputerName','Uptime','PctFreeMem','PctFreeC'
        $ddps = New-Object -TypeName System.Management.Automation.PSPropertySet DefaultDisplayPropertySet, $props
        $pssm = [System.Management.Automation.PSMemberInfo[]]$ddps
        $obj | Add-Member -MemberType MemberSet -Name PSStandardMembers -Value $pssm

        #add a property set
        $obj | Add-Member -MemberType PropertySet -Name Mem -Value 'Computername','TotalMem','FreeMem','PctFreeMem'

        #adding an alias
        $obj | Add-Member -MemberType AliasProperty -Name Memory -Value TotalMem

        #adding a script method
        $obj | Add-Member -MemberType ScriptMethod -Name Ping -Value { Test-NetConnection $this.computername }

        #adding a script property
        $obj | Add-Member -MemberType ScriptProperty -Name TopProcesses  -Value { 
            Get-Process -ComputerName $this.computername |
            Sort-Object -Property WorkingSet -Descending |
            Select-Object -first 5
            }
        $obj
     } #if OK
    } #foreach $computer
}
END {
    Write-Verbose "Starting $($myinvocation.mycommand)"
}
} #Get-TMComputerStatus

Get-TMComputerStatus $env:computername