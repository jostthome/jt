using module JtTbl
using module JtInfi
using module JtRep

class JtRep_Z_Vorwag : JtRep {

    JtRep_Z_Vorwag () : Base("z.vorwag") {
        $This.HideSpezial = $True
    }

    [JtTblRow]GetJtTblRow([JtInfi]$JtInfi) {
        [JtTblRow]$JtTblRow = $This.GetJtTblRowDefault($JtInfi)

        $JtTblRow.Add($JtInfi.GetJtInf_Soft().DellCommand)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().ArchiCAD)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().LibreOffice)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Firefox64)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Thunderbird32)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Thunderbird64)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Flash)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().WibuKey)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().AcrobatReader)

        $JtTblRow.Add($JtInfi.GetJtInf_Win32OperatingSystem().Get_OsCaption())

        return $JtTblRow
    }
}


function New-JtRep_Z_Vorwag {

    [JtRep_Z_Vorwag]::new() 

}

