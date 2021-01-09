using module JtTbl
using module JtInfi
using module JtRep

class JtRep_Z_G13 : JtRep {

    JtRep_Z_G13() : Base("z.g13") {
        $This.HideSpezial = $True
    }

    [JtTblRow]GetJtTblRow([JtInfi]$JtInfi) {
        [JtTblRow]$JtTblRow = $This.GetJtTblRowDefault($JtInfi)
        
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().AffinityDesigner)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().AffinityPhoto)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().AffinityPublisher)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Revit_2021)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Office)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Office365)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Seadrive)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Seafile)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().LibreOffice)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Firefox64)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Thunderbird64)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().AcrobatReader)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Inkscape)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().DellCommand)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().DellSuppAs)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().DokanLibrary)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Flash)
        $JtTblRow.Add($JtInfi.GetJtInf_Win32OperatingSystem().OsCaption)
        
        return $JtTblRow
    }
}

function New-JtRep_Z_G13 {

    [JtRep_Z_G13]::new() 

}


