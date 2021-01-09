using module JtTbl
using module JtInfi
using module JtRep

class JtRep_SoftwareAdobe : JtRep {

    JtRep_SoftwareAdobe () : Base("software.adobe") {
        $This.HideSpezial = $True
    }

    [JtTblRow]GetJtTblRow([JtInfi]$JtInfi) {
        [JtTblRow]$JtTblRow = $This.GetJtTblRowDefault($JtInfi)

        $JtTblRow.Add($JtInfi.GetJtInf_Soft().CreativeSuite_CS6)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Acrobat_DC)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Photoshop_CC)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Indesign_CC)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Illustrator_CC)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().AfterEffects_CC)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Flash)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Air)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().AcrobatReader)
        
        $JtTblRow.Add($JtInfi.GetJtInf_Win32OperatingSystem().OsCaption)

        return $JtTblRow
    }
}


function New-JtRep_SoftwareAdobe {

    [JtRep_SoftwareAdobe]::new() 

}


