using module Jt
using module JtIo 
using module JtInf
using module JtTbl
# using module JtInv 

Function Get-JtAl_Rep_JtTblRow {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input
    )

    [String]$MyFolderPath_Input = $FolderPath_Input
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
    [JtTblRow]$MyJtTblRow = Get-JtRep_Bitlocker -JtInfi $MyJtInfi
    $MyAlJtTblRow.Add($MyJtTblRow)
    [JtTblRow]$MyJtTblRow = Get-JtRep_Hardware -JtInfi $MyJtInfi
    $MyAlJtTblRow.Add($MyJtTblRow)
    [JtTblRow]$MyJtTblRow = Get-JtRep_HardwareSn -JtInfi $MyJtInfi
    $MyAlJtTblRow.Add($MyJtTblRow)
    [JtTblRow]$MyJtTblRow = Get-JtRep_Logins -JtInfi $MyJtInfi
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
    
    return , $MyAlJtTblRow
}

Function Get-JtTblRowDefault {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtInfi]$JtInfi,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Label
    )

    [String]$MyFunctionName = "Get-JtTblRowDefault"
    [String]$MyLabel = $MyFunctionName

    if ($Label) {
        $MyLabel = $Label
    }
    
    [JtInfi]$MyJtInfi = $JtInfi
    
    # [Boolean]$BlnHideSpezial = $True

    [JtTblRow]$MyJtTblRow = New-JtTblRow -Label $MyLabel
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().SystemId) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Org1) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Org2) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Type) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Computername) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().LabelC) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().DaysAgo) | Out-Null
    #        $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Alias) | Out-Null
    return $MyJtTblRow
}


Function Get-JtRep_Bitlocker {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtInfi]$JtInfi
    )

    [String]$MyFunctionName = "Get-JtRep_Bitlocker"

    [JtInfi]$MyJtInfi = $JtInfi

    # [Boolean]$BlnHideSpezial = $True
    [JtTblRow]$MyJtTblRow = Get-JtTblRowDefault -JtInfi $MyJtInfi -Label $MyFunctionName

    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Bitlocker().C_CapacityGB)
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Bitlocker().C_VolumeType)
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Bitlocker().C_EncryptionMethod)
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Bitlocker().C_ProtectionStatus)
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Bitlocker().D_CapacityGB)
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Bitlocker().D_VolumeType)
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Bitlocker().D_EncryptionMethod)
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Bitlocker().D_ProtectionStatus)

    return , $MyJtTblRow
}


Function Get-JtRep_Folder {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtInfi]$JtInfi
    )

    [String]$MyFunctionName = "Get-JtRep_Folder"

    [JtInfi]$MyJtInfi = $JtInfi

    # [Boolean]$BlnHideSpezial = $True
    [JtTblRow]$MyJtTblRow = Get-JtTblRowDefault -JtInfi $MyJtInfi -Label $MyFunctionName
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().SystemId) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Org) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Org1) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Org2) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Type) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Computername) | Out-Null
    # $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Alias) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Name) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().LabelC) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().DaysAgo) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().JtVersion) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Timestamp) | Out-Null
    # $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().WinVersion) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Win1) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Win2) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Win3) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Win4) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().KlonVersion) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Ip) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Timestamp) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().User) | Out-Null
    return , $MyJtTblRow
}



Function Get-JtRep_Hardware {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtInfi]$JtInfi
    )
    
    [String]$MyFunctionName = "Get-JtRep_Hardware"

    [JtInfi]$MyJtInfi = $JtInfi

    # [Boolean]$BlnHideSpezial = $True
    [JtTblRow]$MyJtTblRow = Get-JtTblRowDefault -JtInfi $MyJtInfi -Label $MyFunctionName
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32ComputerSystem().Herst) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32ComputerSystem().Modell) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32ComputerSystem().Ram) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32Processor().Cpu) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32Processor().Ghz) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32VideoController().Grafikkarte) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32LogicalDisk().C_Capacity) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32LogicalDisk().D_Capacity) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32Bios().Sn) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32Bios().BIOSVersion) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32NetworkAdapter().Mac) | Out-Null
    return , $MyJtTblRow
}

Function Get-JtRep_HardwareSn {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtInfi]$JtInfi
    )

    [String]$MyFunctionName = "Get-JtRep_HardwareSn"

    [JtInfi]$MyJtInfi = $JtInfi

    # [Boolean]$BlnHideSpezial = $True
    [JtTblRow]$MyJtTblRow = New-JtTblRow -Label $MyFunctionName
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32Bios().Sn) | Out-Null
        
    [JtTblRow]$MyJtTblRowDefault = Get-JtTblRowDefault -JtInfi $MyJtInfi -Label $MyFunctionName
    $MyJtTblRow.Join($MyJtTblRowDefault)

    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32ComputerSystem().Herst) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32ComputerSystem().Modell) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32ComputerSystem().Ram) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32Processor().Ghz) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32VideoController().Grafikkarte) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32LogicalDisk().C_Capacity) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32LogicalDisk().D_Capacity) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32Bios().BIOSVersion) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32NetworkAdapter().Mac) | Out-Null
    return , $MyJtTblRow
}

Function Get-JtRep_Net {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtInfi]$JtInfi
    )
    
    [String]$MyFunctionName = "Get-JtRep_Net"

    [JtInfi]$MyJtInfi = $JtInfi

    # [Boolean]$BlnHideSpezial = $True
    [JtTblRow]$MyJtTblRow = Get-JtTblRowDefault -JtInfi $MyJtInfi -Label $MyFunctionName
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Ip) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Ip3) | Out-Null
    # $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32NetworkAdapter().Ip3)
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32NetworkAdapter().Mac) | Out-Null
    return , $MyJtTblRow
}

Function Get-JtRep_ObjWin32Bios {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtInfi]$JtInfi
    )
    
    [String]$MyFunctionName = "Get-JtRep_ObjWin32Bios"

    [JtInfi]$MyJtInfi = $JtInfi

    # [Boolean]$BlnHideSpezial = $True
    [JtTblRow]$MyJtTblRow = Get-JtTblRowDefault -JtInfi $MyJtInfi -Label $MyFunctionName
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32Bios().Hersteller) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32Bios().Sn) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32Bios().BIOSVersion) | Out-Null 
    return , $MyJtTblRow
}


Function Get-JtRep_ObjWin32Computersystem {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtInfi]$JtInfi
    )

    [String]$MyFunctionName = "Get-JtRep_ObjWin32Computersystem"

    [JtInfi]$MyJtInfi = $JtInfi

    # [Boolean]$BlnHideSpezial = $True
    [JtTblRow]$MyJtTblRow = Get-JtTblRowDefault -JtInfi $MyJtInfi -Label $MyFunctionName
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32OperatingSystem().OsCaption) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32OperatingSystem().OsManu) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32OperatingSystem().OsSerial) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32OperatingSystem().OsVersion) | Out-Null 
        
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32ComputerSystem().Herst) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32ComputerSystem().Modell) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32ComputerSystem().Ram) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32ComputerSystem().Computername) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32ComputerSystem().Owner) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32ComputerSystem().Domain) | Out-Null 
    return , $MyJtTblRow
}



Function Get-JtRep_ObjWin32LogicalDisk {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtInfi]$JtInfi
    )

    [String]$MyFunctionName = "Get-JtRep_ObjWin32LogicalDisk"

    [JtInfi]$MyJtInfi = $JtInfi

    # [Boolean]$BlnHideSpezial = $True
    [JtTblRow]$MyJtTblRow = Get-JtTblRowDefault -JtInfi $MyJtInfi -Label $MyFunctionName
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32LogicalDisk().C) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32LogicalDisk().C_Capacity) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32LogicalDisk().C_Free) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32LogicalDisk().C_FreePercent) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32LogicalDisk().D) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32LogicalDisk().D_Capacity) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32LogicalDisk().D_Free) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32LogicalDisk().D_FreePercent) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32LogicalDisk().E) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32LogicalDisk().E_Capacity) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32LogicalDisk().E_Free) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32LogicalDisk().E_FreePercent) | Out-Null 
    return , $MyJtTblRow
}

Function Get-JtRep_ObjWin32NetworkAdapter {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtInfi]$JtInfi
    )

    [String]$MyFunctionName = "Get-JtRep_ObjWin32NetworkAdapter"

    [JtInfi]$MyJtInfi = $JtInfi

    # [Boolean]$BlnHideSpezial = $True
    [JtTblRow]$MyJtTblRow = Get-JtTblRowDefault -JtInfi $MyJtInfi -Label $MyFunctionName
    # $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32NetworkAdapter().Ip) | Out-Null 
    # $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32NetworkAdapter().Ip3) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32NetworkAdapter().MAC) | Out-Null 
    return , $MyJtTblRow
}

Function Get-JtRep_ObjWin32OperatingSystem {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtInfi]$JtInfi
    )

    [String]$MyFunctionName = "Get-JtRep_ObjWin32OperatingSystem"

    [JtInfi]$MyJtInfi = $JtInfi

    # [Boolean]$BlnHideSpezial = $True
    [JtTblRow]$MyJtTblRow = Get-JtTblRowDefault -JtInfi $MyJtInfi -Label $MyFunctionName
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32OperatingSystem().OsCaption) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32OperatingSystem().OsManu) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32OperatingSystem().OsSerial) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32OperatingSystem().OsVersion) | Out-Null 
    return , $MyJtTblRow
}

Function Get-JtRep_ObjWin32Processor {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtInfi]$JtInfi
    )

    [String]$MyFunctionName = "Get-JtRep_ObjWin32Processor"

    [JtInfi]$MyJtInfi = $JtInfi

    # [Boolean]$BlnHideSpezial = $True
    [JtTblRow]$MyJtTblRow = Get-JtTblRowDefault -JtInfi $MyJtInfi -Label $MyFunctionName
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32Processor().Cpu) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32Processor().Ghz) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32Processor().Cores) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32Processor().CoresH) | Out-Null
    return , $MyJtTblRow
}


Function Get-JtRep_ObjWin32VideoController {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtInfi]$JtInfi
    )

    [String]$MyFunctionName = "Get-JtRep_ObjWin32VideoController"

    [JtInfi]$MyJtInfi = $JtInfi

    # [Boolean]$BlnHideSpezial = $True
    [JtTblRow]$MyJtTblRow = Get-JtTblRowDefault -JtInfi $MyJtInfi -Label $MyFunctionName
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32VideoController().Grafikkarte) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32VideoController().TreiberVersion) | Out-Null 
    return , $MyJtTblRow
}

Function Get-JtRep_Software {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtInfi]$JtInfi
    )

    [String]$MyFunctionName = "Get-JtRep_Software"

    [JtInfi]$MyJtInfi = $JtInfi

    # [Boolean]$BlnHideSpezial = $True
    [JtTblRow]$MyJtTblRow = Get-JtTblRowDefault -JtInfi $MyJtInfi -Label $MyFunctionName

    [JtInf_Soft]$MyJtInf_Soft = $MyJtInfi.GetJtInf_Soft()
    [Object[]]$MyAlFields = $MyJtInf_Soft.GetFields()

    foreach ($Field in $MyAlFields) {
        [JtFldSoft]$MyJtFldSoft = $Field
        # $MyJtInf_Soft.($MyJtFldSoft.GetLabel())
            
        [String]$MyLabel = $MyJtFldSoft.GetLabel()
        [String]$MyValue = $MyJtInf_Soft.($MyLabel)

        [JtFld]$MyFld = New-JtFld -Label $MyLabel -Value $MyValue
        $MyJtTblRow.Add($MyFld) | Out-Null 
    }
    return , $MyJtTblRow
}


Function Get-JtRep_SoftwareAdobe {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtInfi]$JtInfi
    )

    [String]$MyFunctionName = "Get-JtRep_SoftwareAdobe"

    [JtInfi]$MyJtInfi = $JtInfi

    # [Boolean]$BlnHideSpezial = $True
    [JtTblRow]$MyJtTblRow = Get-JtTblRowDefault -JtInfi $MyJtInfi -Label $MyFunctionName
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().CreativeSuite_CS6) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Acrobat_DC) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Photoshop_CC) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Indesign_CC) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Illustrator_CC) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().AfterEffects_CC) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Flash) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Air) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().AcrobatReader) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32OperatingSystem().OsCaption) | Out-Null 
    return , $MyJtTblRow
}

Function Get-JtRep_SoftwareMicrosoft {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtInfi]$JtInfi
    )

    [String]$MyFunctionName = "Get-JtRep_SoftwareMicrosoft"

    [JtInfi]$MyJtInfi = $JtInfi

    # [Boolean]$BlnHideSpezial = $True
    [JtTblRow]$MyJtTblRow = Get-JtTblRowDefault -JtInfi $MyJtInfi -Label $MyFunctionName
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32OperatingSystem().OsCaption) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32OperatingSystem().OsVersion) | Out-Null 
    # $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().WinVersion) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Win1) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Win2) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Win3) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Win4) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Office) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Office365) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().OfficeTxt) | Out-Null 
    return , $MyJtTblRow
}

Function Get-JtRep_SoftwareMicrosoftNormal {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtInfi]$JtInfi
    )

    [String]$MyFunctionName = "Get-JtRep_SoftwareMicrosoftNormal"

    [JtInfi]$MyJtInfi = $JtInfi

    # [Boolean]$BlnHideSpezial = $True
    [JtTblRow]$MyJtTblRow = Get-JtTblRowDefault -JtInfi $MyJtInfi -Label $MyFunctionName
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32OperatingSystem().OsCaption) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32OperatingSystem().OsVersion) | Out-Null 
    # $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().WinVersion) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Win1) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Win2) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Win3) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Win4) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Office) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Office365) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().OfficeTxt) | Out-Null 
    return , $MyJtTblRow
}

Function Get-JtRep_SoftwareOpsi {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtInfi]$JtInfi
    )

    [String]$MyFunctionName = "Get-JtRep_SoftwareOpsi"

    [JtInfi]$MyJtInfi = $JtInfi

    # [Boolean]$BlnHideSpezial = $True
    [JtTblRow]$MyJtTblRow = Get-JtTblRowDefault -JtInfi $MyJtInfi -Label $MyFunctionName
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Opsi) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32OperatingSystem().OsCaption) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32OperatingSystem().OsVersion) | Out-Null 
    # $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().WinVersion) | Out-Null 
    return , $MyJtTblRow
}
    
Function Get-JtRep_SoftwareSecurity {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtInfi]$JtInfi
    )
    
    [String]$MyFunctionName = "Get-JtRep_SoftwareSecurity"

    [JtInfi]$MyJtInfi = $JtInfi

    # [Boolean]$BlnHideSpezial = $True
    [JtTblRow]$MyJtTblRow = Get-JtTblRowDefault -JtInfi $MyJtInfi -Label $MyFunctionName
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().WinVersion) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Flash) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Java) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Opsi) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().AntiVirus) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().CiscoAnyConnect) | Out-Null 
    return , $MyJtTblRow
}


Function Get-JtRep_SoftwareSupport {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtInfi]$JtInfi
    )
    
    [String]$MyFunctionName = "Get-JtRep_SoftwareSupport"

    [JtInfi]$MyJtInfi = $JtInfi

    # [Boolean]$BlnHideSpezial = $True
    [JtTblRow]$MyJtTblRow = Get-JtTblRowDefault -JtInfi $MyJtInfi -Label $MyFunctionName
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32ComputerSystem().Herst) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32ComputerSystem().Modell) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Win3) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Win4) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Opsi) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().LenovoSysUp) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().DellCommand) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().DellSuppAs) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Seadrive) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Seafile) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().CiscoAnyConnect) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().DokanLibrary) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32OperatingSystem().OsCaption) | Out-Null 
    # $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32OperatingSystem().OsVersion) | Out-Null 
    # $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().WinVersion) | Out-Null 
    return , $MyJtTblRow
}

Function Get-JtRep_SoftwareVray {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtInfi]$JtInfi
    )
    
    [String]$MyFunctionName = "Get-JtRep_SoftwareVray"

    [JtInfi]$MyJtInfi = $JtInfi

    # [Boolean]$BlnHideSpezial = $True
    [JtTblRow]$MyJtTblRow = Get-JtTblRowDefault -JtInfi $MyJtInfi -Label $MyFunctionName
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Max_2021) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().vRay3ds) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Revit_2022) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().vRayRevit) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Rhino_6) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Rhino_7) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().vRayRhino) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Sketchup) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().vRaySketchup) | Out-Null 
    return , $MyJtTblRow
}


Function Get-JtRep_Logins {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtInfi]$JtInfi
    )

    [String]$MyFunctionName = "Get-JtRep_Logins"

    [JtInfi]$MyJtInfi = $JtInfi

    # [Boolean]$BlnHideSpezial = $True
    [JtTblRow]$MyJtTblRow = Get-JtTblRowDefault -JtInfi $MyJtInfi -Label $MyFunctionName
    [JtIoFolder]$MyJtIoFolder = $MyJtInfi.GetJtIoFolder()
    [String]$MyExtension2 = [JtIo]::FileExtension_Meta_Report
    [String]$MyPrefix = [JtIo]::FilePrefix_Report
    [String]$MyFilter = -join ($MyPrefix, ".", "login_", "*", $MyExtension2)

    $MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder -Filter $MyFilter

    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().SystemId) | Out-Null
    ForEach ($i in 0..5) {

        [String]$MyLabel1 = "User$i"
        [String]$MyLabel2 = "Date$i"
        [Int16]$MyIntNr = $i + 1
        [String]$MyValue1 = "---"
        [String]$MyValue2 = "---"
        if ($i -lt $MyAlJtIoFiles.Count) {
            [JtIoFile]$MyJtIoFile = $MyAlJtIoFiles[$i]
            [String]$MyFilename = $MyJtIoFile.GetName()
            [String]$MyValue1 = Convert-JtDotter -Text $MyFilename -PatternOut "2"
            [String]$MyValue2 = Convert-JtDotter -Text $MyFilename -PatternOut "3"
        }
        $MyJtTblRow.Add($MyLabel1, $MyValue1) | Out-Null
        $MyJtTblRow.Add($MyLabel2, $MyValue2) | Out-Null
    }
        
    return , $MyJtTblRow
}



Function Get-JtRep_Timestamps {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtInfi]$JtInfi
    )

    [String]$MyFunctionName = "Get-JtRep_Timestamps"

    [JtInfi]$MyJtInfi = $JtInfi

    # [Boolean]$BlnHideSpezial = $True
    [JtTblRow]$MyJtTblRow = Get-JtTblRowDefault -JtInfi $MyJtInfi -Label $MyFunctionName
    [JtIoFolder]$MyJtIoFolder = $MyJtInfi.GetJtIoFolder()
    [JtIoFolder]$MyJtIoFolder_Timestamp = $MyJtIoFolder.GetJtIoFolder_Sub("timestamp")
    if (!($MyJtIoFolder_Timestamp.IsExisting())) {
        Write-JtLog_Error -Where $MyFunctionName -Text "FOLDER timestamp is missing."
        return $Null
    }
    [String]$MyExtension2 = [JtIo]::FileExtension_Meta_Time
    [String]$MyFilter = -join ("*", $MyExtension2)

    $MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder_Timestamp -Filter $MyFilter

    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().SystemId) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().JtVersion) | Out-Null

    ForEach ($i in 0..5) {
        [Int16]$MyIntNr = $i + 1
        [String]$MyLabel1 = -join ("FldDate", $MyIntNr)
        [String]$MyLabel2 = -join ("FldTime", $MyIntNr)
        [String]$MyLabel_Step = -join ("Step", $MyIntNr)
        [String]$MyValue1 = ""
        [String]$MyValue2 = ""
        [String]$MyValue_Step = ""
        if ($i -lt $MyAlJtIoFiles.Count) {
            [JtIoFile]$MyJtIoFile = $MyAlJtIoFiles[$i]
            [String]$MyFilename = $MyJtIoFile.GetName()
            [String]$MyValue = Convert-JtDotter -Text $MyFilename -PatternOut "2"
            [String]$MyValue_Helper = $MyValue.Replace("_", ".")
            [String]$MyValue1 = Convert-JtDotter -Text $MyValue_Helper -PatternOut "1"
            [String]$MyValue2 = Convert-JtDotter -Text $MyValue_Helper -PatternOut "2"


            [String]$MyValue_Step = Convert-JtDotter -Text $MyFilename -PatternOut "3"
        }
        $MyJtTblRow.Add($MyLabel_Step, $MyValue_Step) | Out-Null
        $MyJtTblRow.Add($MyLabel1, $MyValue1) | Out-Null
        $MyJtTblRow.Add($MyLabel2, $MyValue2) | Out-Null
    }
        
    [String]$MyLabel = "Errors"
    [String]$MyErrors = $MyJtInfi.GetJtInf_AFolder().Errors
    [String]$MyValue = $MyErrors
    $MyJtTblRow.Add($MyLabel, $MyValue) | Out-Null
    return , $MyJtTblRow
}

Function Get-JtRep_Z_G13 {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtInfi]$JtInfi
    )
    
    [String]$MyFunctionName = "Get-JtRep_Z_G13"

    [JtInfi]$MyJtInfi = $JtInfi

    # [Boolean]$BlnHideSpezial = $True
    [JtTblRow]$MyJtTblRow = Get-JtTblRowDefault -JtInfi $MyJtInfi -Label $MyFunctionName
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().AffinityDesigner) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().AffinityPhoto) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().AffinityPublisher) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Revit_2022) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Office) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Office365) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Seadrive) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Seafile) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Powertoys) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().LibreOffice) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Firefox64) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Thunderbird64) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().AcrobatReader) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Inkscape) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().DellCommand) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().DellSuppAs) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Flash) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32OperatingSystem().OsCaption) | Out-Null 
    return , $MyJtTblRow
}



Function Get-JtRep_Z_Iat {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtInfi]$JtInfi
    )

    [String]$MyFunctionName = "Get-JtRep_Z_Iat"

    [JtInfi]$MyJtInfi = $JtInfi

    # [Boolean]$BlnHideSpezial = $True
    [JtTblRow]$MyJtTblRow = Get-JtTblRowDefault -JtInfi $MyJtInfi -Label $MyFunctionName
    # $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().WinVersion) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().CreativeSuite_CS6) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Photoshop_CC) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Office) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Rhino_6) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Rhino_7) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().SketchUp) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().vRay3ds) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().vRayRevit) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().vRayRhino) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().vRaySketchup) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().LenovoSysUp) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().AutoCAD_2021) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Max_2021) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Revit_2021) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Revit_2022) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().ArchiCAD) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Vectorworks) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Cinema4D) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().GoogleEarth) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Unity) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().UnityHub) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Arduino) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().LibreOffice) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().AcrobatReader) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().AntiVirus) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Chrome) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Firefox64) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Java) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().PDF24) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().DellCommand) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().DellSuppAs) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Seadrive) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Seafile) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Sumatra) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().VLC) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().WibuKey) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Zip7) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32OperatingSystem().OsCaption) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32OperatingSystem().OsVersion) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32VideoController().Grafikkarte) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32VideoController().TreiberVersion) | Out-Null 
    return , $MyJtTblRow
}

Function Get-JtRep_Z_Lab {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtInfi]$JtInfi
    )
    
    [String]$MyFunctionName = "Get-JtRep_Z_Lab"

    [JtInfi]$MyJtInfi = $JtInfi

    # [Boolean]$BlnHideSpezial = $True
    [JtTblRow]$MyJtTblRow = Get-JtTblRowDefault -JtInfi $MyJtInfi -Label $MyFunctionName
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Unity) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().UnityHub) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Office) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().CreativeSuite_CS6) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().AutoCAD_2021) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Max_2021) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Revit_2021) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Revit_2022) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().ArchiCAD) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Vectorworks) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Cinema4D) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().SketchUp) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Rhino_6) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Rhino_7) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().vRay3ds) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().vRayRevit) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().vRayRhino) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().vRaySketchup) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().GoogleEarth) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Arduino) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().LibreOffice) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().AcrobatReader) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().AntiVirus) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Chrome) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Firefox64) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Java) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().PDF24) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().DellCommand) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().DellSuppAs) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Seafile) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Seadrive) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Sumatra) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().VLC) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().WibuKey) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Zip7) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32OperatingSystem().OsCaption) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32OperatingSystem().OsVersion) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32VideoController().Grafikkarte) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32VideoController().TreiberVersion) | Out-Null 
    return , $MyJtTblRow
}

Function Get-JtRep_Z_Pools {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtInfi]$JtInfi
    )
    
    [String]$MyFunctionName = "Get-JtRep_Z_Pools"

    [JtInfi]$MyJtInfi = $JtInfi

    # [Boolean]$BlnHideSpezial = $True
    [JtTblRow]$MyJtTblRow = Get-JtTblRowDefault -JtInfi $MyJtInfi -Label $MyFunctionName

    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().Timestamp) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().KlonVersion) | Out-Null
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_AFolder().JtVersion) | Out-Null

    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Office) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().OfficeStandard) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().CreativeSuite_CS6) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().AutoCAD_2021) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Max_2021) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Revit_2022) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Allplan_2019) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().ArchiCAD) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Vectorworks) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Cinema4D) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().SketchUp) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Rhino_7) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().vRay3ds) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().vRayRhino) | Out-Null 
    # $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().BkiKosten) | Out-Null 
    # $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().BkiPos) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().IbpHighend) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Orca) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().GoogleEarth) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Arduino) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().RawTherapee) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().LibreOffice) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().AcrobatReader) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().AntiVirus) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Chrome) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Chromium) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Firefox64) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Java) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Krita) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().PDF24) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().DellCommand) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().DellSuppAs) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Sumatra) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().VLC) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().WibuKey) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Zip7) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32VideoController().Grafikkarte) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32VideoController().TreiberVersion) | Out-Null 
    return , $MyJtTblRow
}

Function Get-JtRep_Z_Server {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtInfi]$JtInfi
    )
    
    [String]$MyFunctionName = "Get-JtRep_Z_Server"

    [JtInfi]$MyJtInfi = $JtInfi

    # [Boolean]$BlnHideSpezial = $True
    [JtTblRow]$MyJtTblRow = Get-JtTblRowDefault -JtInfi $MyJtInfi -Label $MyFunctionName
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Seadrive) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Seafile) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().ServerViewAgents) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Bacula) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Java) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().AntiVirus) | Out-Null 
    return  , $MyJtTblRow
}

Function Get-JtRep_Z_Vorwag {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtInfi]$JtInfi
    )
    
    [String]$MyFunctionName = "Get-JtRep_Z_Vorwag"

    [JtInfi]$MyJtInfi = $JtInfi

    # [Boolean]$BlnHideSpezial = $True
    [JtTblRow]$MyJtTblRow = Get-JtTblRowDefault -JtInfi $MyJtInfi -Label $MyFunctionName
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().DellCommand) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().ArchiCAD) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().LibreOffice) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Firefox64) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Thunderbird32) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Thunderbird64) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().Flash) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().WibuKey) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Soft().AcrobatReader) | Out-Null 
    $MyJtTblRow.Add($MyJtInfi.GetJtInf_Win32OperatingSystem().Get_OsCaption()) | Out-Null 
    return , $MyJtTblRow
}

Export-ModuleMember -Function Get-JtAl_Rep_JtTblRow
Export-ModuleMember -Function Get-JtRep_Software_Row

Export-ModuleMember -Function Get-JtRep_Bitlocker
Export-ModuleMember -Function Get-JtRep_Folder
Export-ModuleMember -Function Get-JtRep_Hardware
Export-ModuleMember -Function Get-JtRep_HardwareSn
Export-ModuleMember -Function Get-JtRep_Logins
Export-ModuleMember -Function Get-JtRep_Net
Export-ModuleMember -Function Get-JtRep_ObjWin32Bios
Export-ModuleMember -Function Get-JtRep_ObjWin32ComputerSystem
Export-ModuleMember -Function Get-JtRep_ObjWin32LogicalDisk
Export-ModuleMember -Function Get-JtRep_ObjWin32NetworkAdapter
Export-ModuleMember -Function Get-JtRep_ObjWin32OperatingSystem
Export-ModuleMember -Function Get-JtRep_ObjWin32Processor
Export-ModuleMember -Function Get-JtRep_ObjWin32VideoController
Export-ModuleMember -Function Get-JtRep_Software
Export-ModuleMember -Function Get-JtRep_SoftwareAdobe
Export-ModuleMember -Function Get-JtRep_SoftwareMicrosoft
Export-ModuleMember -Function Get-JtRep_SoftwareMicrosoftNormal
Export-ModuleMember -Function Get-JtRep_SoftwareOpsi
Export-ModuleMember -Function Get-JtRep_SoftwareSecurity
Export-ModuleMember -Function Get-JtRep_SoftwareSupport
Export-ModuleMember -Function Get-JtRep_SoftwareVray
Export-ModuleMember -Function Get-JtRep_Timestamps
Export-ModuleMember -Function Get-JtRep_Z_G13
Export-ModuleMember -Function Get-JtRep_Z_Iat
Export-ModuleMember -Function Get-JtRep_Z_Lab
Export-ModuleMember -Function Get-JtRep_Z_Pools
Export-ModuleMember -Function Get-JtRep_Z_Server
Export-ModuleMember -Function Get-JtRep_Z_Vorwag