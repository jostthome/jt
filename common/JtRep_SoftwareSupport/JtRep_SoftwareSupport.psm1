using module JtTbl
using module JtInfi
using module JtRep

class JtRep_SoftwareSupport : JtRep {

    JtRep_SoftwareSupport() : Base("software.support") {
        $This.HideSpezial = $False
    }

    [JtTblRow]GetJtTblRow([JtInfi]$JtInfi) {
        [JtTblRow]$JtTblRow = $This.GetJtTblRowDefault($JtInfi)

        $JtTblRow.Add($JtInfi.GetJtInf_Win32ComputerSystem().Herst)
        $JtTblRow.Add($JtInfi.GetJtInf_Win32ComputerSystem().Modell)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().LenovoSysUp)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().DellCommand)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().DellSuppAs)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Opsi)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Seadrive)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Seafile)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().DokanLibrary)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().CiscoAnyConnect)
        $JtTblRow.Add($JtInfi.GetJtInf_Win32OperatingSystem().OsCaption)
        $JtTblRow.Add($JtInfi.GetJtInf_Win32OperatingSystem().OsVersion)
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().WinVersion)

        return $JtTblRow
    }

}


function New-JtRep_SoftwareSupport {

    [JtRep_SoftwareSupport]::new() 

}

