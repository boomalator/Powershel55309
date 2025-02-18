﻿function Get-FileContents {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory,ValueFromPipeline)]
        [string[]]$Path
    )
    PROCESS {
        foreach ($folder in $path) {

            Write-Verbose "Path is $folder"
            $folder = $folder -replace "/","\"
            $segments = $folder -split "\\"
            $last = $segments[-1]
            Write-Verbose "Last path is $last"
            $filename = Join-Path $folder $last
            $filename += ".txt"
            Get-Content $filename

        } #foreach folder
    } #process
}
