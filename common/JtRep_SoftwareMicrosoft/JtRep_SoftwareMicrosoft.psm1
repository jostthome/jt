using module JtTbl
using module JtInfi
using module JtRep

class JtRep_SoftwareMicrosoft : JtRep {
    
    JtRep_SoftwareMicrosoft () : Base("software.microsoft") {
        $This.HideSpezial = $False
    }

    [JtTblRow]GetJtTblRow([JtInfi]$JtInfi) {
        [JtTblRow]$JtTblRow = $This.GetJtTblRowDefault($JtInfi)
    
        $JtTblRow.Add($JtInfi.GetJtInf_Win32OperatingSystem().OsCaption)
        $JtTblRow.Add($JtInfi.GetJtInf_Win32OperatingSystem().OsVersion)
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().WinVersion)
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().WinGen)
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().WinBuild)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Office)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Office365)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().OfficeTxt)
        return $JtTblRow
    }
    
}


function New-JtRep_SoftwareMicrosoft {

    [JtRep_SoftwareMicrosoft]::new() 

}


