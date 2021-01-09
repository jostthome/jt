using module JtTbl
using module JtInfi
using module JtRep

class JtRep_Obj_Win32Computersystem : JtRep {

    JtRep_Obj_Win32Computersystem() : Base("obj.win32_computersystem") {
        $This.HideSpezial = $True
    }

    [JtTblRow]GetJtTblRow([JtInfi]$JtInfi) {
        [JtTblRow]$JtTblRow = $This.GetJtTblRowDefault($JtInfi)

        $JtTblRow.Add($JtInfi.GetJtInf_Win32OperatingSystem().OsCaption) | Out-Null 
        $JtTblRow.Add($JtInfi.GetJtInf_Win32OperatingSystem().OsManu) | Out-Null 
        $JtTblRow.Add($JtInfi.GetJtInf_Win32OperatingSystem().OsSerial) | Out-Null 
        $JtTblRow.Add($JtInfi.GetJtInf_Win32OperatingSystem().OsVersion) | Out-Null 
        
        $JtTblRow.Add($JtInfi.GetJtInf_Win32ComputerSystem().Herst) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_Win32ComputerSystem().Modell) | Out-Null 
        $JtTblRow.Add($JtInfi.GetJtInf_Win32ComputerSystem().Ram) | Out-Null 
        $JtTblRow.Add($JtInfi.GetJtInf_Win32ComputerSystem().Computername) | Out-Null 
        $JtTblRow.Add($JtInfi.GetJtInf_Win32ComputerSystem().Owner) | Out-Null 
        $JtTblRow.Add($JtInfi.GetJtInf_Win32ComputerSystem().Domain) | Out-Null 

        return $JtTblRow
    }

}

function New-JtRep_Obj_Win32ComputerSystem {

    [JtRep_Obj_Win32ComputerSystem]::new() 

}


