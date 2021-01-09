using module JtTbl
using module JtInfi
using module JtRep

class JtRep_SoftwareOpsi : JtRep {
    
    JtRep_SoftwareOpsi() : Base("software.opsi") {
        $This.HideSpezial = $True
    }
    
    [JtTblRow]GetJtTblRow([JtInfi]$JtInfi) {
        [JtTblRow]$JtTblRow = $This.GetJtTblRowDefault($JtInfi)
    
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Opsi)
        $JtTblRow.Add($JtInfi.GetJtInf_Win32OperatingSystem().OsCaption)
        $JtTblRow.Add($JtInfi.GetJtInf_Win32OperatingSystem().OsVersion)
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().WinVersion)

        return $JtTblRow
    }
    
}


function New-JtRep_SoftwareOpsi {

    [JtRep_SoftwareOpsi]::new() 

}
