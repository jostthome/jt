using module JtIo
using module JtRep
using module JtTbl
using module JtInf


Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"


Function Test-JtRep {

    [String]$MyFolderPath_Input = "c:\_inventory\report"
    [JtInfi]$MyJtInfi = New-JtInfi -FolderPath $MyFolderPath_Input

    [System.Collections.ArrayList]$MyAlJtTblRow = [System.Collections.ArrayList]::new()
    [JtTblRow]$MyJtTblRow = Get-JtRep_Folder -JtInfi $MyJtInfi
    $MyAlJtTblRow.Add($MyJtTblRow)
    [JtTblRow]$MyJtTblRow = Get-JtRep_ObjWin32Bios -JtInfi $MyJtInfi
    $MyAlJtTblRow.Add($MyJtTblRow)
    [JtTblRow]$MyJtTblRow = Get-JtRep_ObjWin32Computersystem -JtInfi $MyJtInfi
    $MyAlJtTblRow.Add($MyJtTblRow)
    [JtTblRow]$MyJtTblRow = Get-JtRep_ObjWin32LogicalDisk -JtInfi $MyJtInfi
    $MyAlJtTblRow.Add($MyJtTblRow)
    [JtTblRow]$MyJtTblRow = Get-JtRep_ObjWin32NetworkAdapter -JtInfi $MyJtInfi
    $MyAlJtTblRow.Add($MyJtTblRow)
    [JtTblRow]$MyJtTblRow = Get-JtRep_ObjWin32OperatingSystem -JtInfi $MyJtInfi
    $MyAlJtTblRow.Add($MyJtTblRow)
    [JtTblRow]$MyJtTblRow = Get-JtRep_ObjWin32Processor -JtInfi $MyJtInfi
    $MyAlJtTblRow.Add($MyJtTblRow)
    [JtTblRow]$MyJtTblRow = Get-JtRep_ObjWin32VideoController -JtInfi $MyJtInfi
    $MyAlJtTblRow.Add($MyJtTblRow)
    # [JtTblRow]$MyJtTblRow = Get-JtRep_InstalledSoftware -JtInfi $MyJtInfi
    # $MyAlJtTblRow.Add($MyJtTblRow)
    [JtTblRow]$MyJtTblRow = Get-JtRep_Bitlocker -JtInfi $MyJtInfi
    $MyAlJtTblRow.Add($MyJtTblRow)
    [JtTblRow]$MyJtTblRow = Get-JtRep_Hardware -JtInfi $MyJtInfi
    $MyAlJtTblRow.Add($MyJtTblRow)
    [JtTblRow]$MyJtTblRow = Get-JtRep_HardwareSn -JtInfi $MyJtInfi
    $MyAlJtTblRow.Add($MyJtTblRow)
    [JtTblRow]$MyJtTblRow = Get-JtRep_Net -JtInfi $MyJtInfi
    $MyAlJtTblRow.Add($MyJtTblRow)
    [JtTblRow]$MyJtTblRow = Get-JtRep_Software -JtInfi $MyJtInfi
    $MyAlJtTblRow.Add($MyJtTblRow)
    [JtTblRow]$MyJtTblRow = Get-JtRep_SoftwareAdobe -JtInfi $MyJtInfi
    $MyAlJtTblRow.Add($MyJtTblRow)
    [JtTblRow]$MyJtTblRow = Get-JtRep_SoftwareMicrosoft -JtInfi $MyJtInfi
    $MyAlJtTblRow.Add($MyJtTblRow)
    [JtTblRow]$MyJtTblRow = Get-JtRep_SoftwareMicrosoftNormal -JtInfi $MyJtInfi
    $MyAlJtTblRow.Add($MyJtTblRow)
    [JtTblRow]$MyJtTblRow = Get-JtRep_SoftwareOpsi -JtInfi $MyJtInfi
    $MyAlJtTblRow.Add($MyJtTblRow)
    [JtTblRow]$MyJtTblRow = Get-JtRep_SoftwareSecurity -JtInfi $MyJtInfi
    $MyAlJtTblRow.Add($MyJtTblRow)
    [JtTblRow]$MyJtTblRow = Get-JtRep_SoftwareSupport -JtInfi $MyJtInfi
    $MyAlJtTblRow.Add($MyJtTblRow)
    [JtTblRow]$MyJtTblRow = Get-JtRep_SoftwareVray -JtInfi $MyJtInfi
    $MyAlJtTblRow.Add($MyJtTblRow)
    [JtTblRow]$MyJtTblRow = Get-JtRep_Timestamps -JtInfi $MyJtInfi
    $MyAlJtTblRow.Add($MyJtTblRow)
    [JtTblRow]$MyJtTblRow = Get-JtRep_Z_G13 -JtInfi $MyJtInfi
    $MyAlJtTblRow.Add($MyJtTblRow)
    [JtTblRow]$MyJtTblRow = Get-JtRep_Z_Iat -JtInfi $MyJtInfi
    $MyAlJtTblRow.Add($MyJtTblRow)
    [JtTblRow]$MyJtTblRow = Get-JtRep_Z_Lab -JtInfi $MyJtInfi
    $MyAlJtTblRow.Add($MyJtTblRow)
    [JtTblRow]$MyJtTblRow = Get-JtRep_Z_Pools -JtInfi $MyJtInfi
    $MyAlJtTblRow.Add($MyJtTblRow)
    [JtTblRow]$MyJtTblRow = Get-JtRep_Z_Server -JtInfi $MyJtInfi
    $MyAlJtTblRow.Add($MyJtTblRow)
    [JtTblRow]$MyJtTblRow = Get-JtRep_Z_Vorwag -JtInfi $MyJtInfi
    $MyAlJtTblRow.Add($MyJtTblRow)
    
    Write-Host "------------------------------------------------------"
    Write-Host "------------------------------------------------------"
    Write-Host "------------------------------------------------------"
    Write-Host "------------------------------------------------------"
    Write-Host "------------------------------------------------------"
    Write-Host "------------------------------------------------------"
    Write-Host "------------------------------------------------------"
    Write-Host "------------------------------------------------------"
    Write-Host "------------------------------------------------------"
    Write-Host "------------------------------------------------------"
    Write-Host "------------------------------------------------------"
    Write-Host "------------------------------------------------------"
    Write-Host "------------------------------------------------------"
    
    # $k = Get-JtAl_Rep_JtTblRow -FolderPath_Input c:\_inventory\report
    # $k 
    
    $i = 0
    foreach($e in $MyAlJtTblRow){
        [JtTblRow]$MyJtTblRow = $e
        Write-Host "------------------------------------------------------"
        Write-Host "nummer $i" 
        $MyJtTblRow.GetLabel()
        $MyJtTblRow.GetType()
        $MyJtTblRow.HashTable
        
        Write-Host "."
        Write-Host "."
        $i ++
    }

}

Test-JtRep

