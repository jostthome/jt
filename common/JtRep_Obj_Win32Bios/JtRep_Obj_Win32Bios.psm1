using module JtTbl
using module JtInfi
using module JtRep

class JtRep_Obj_Win32Bios : JtRep {

    JtRep_Obj_Win32Bios() : Base("obj.win32_bios") {
        $This.HideSpezial = $True
    }

    [JtTblRow]GetJtTblRow([JtInfi]$JtInfi) {
        [JtTblRow]$JtTblRow = $This.GetJtTblRowDefault($JtInfi)

        $JtTblRow.Add($JtInfi.GetJtInf_Win32Bios().Hersteller) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_Win32Bios().Sn) | Out-Null 
        $JtTblRow.Add($JtInfi.GetJtInf_Win32Bios().BIOSVersion) | Out-Null 
        return $JtTblRow
    }

}


function New-JtRep_Obj_Win32Bios {

    [JtRep_Obj_Win32Bios]::new() 

}

