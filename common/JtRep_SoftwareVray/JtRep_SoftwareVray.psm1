using module JtTbl
using module JtInfi
using module JtRep

class JtRep_SoftwareVray : JtRep {

    JtRep_SoftwareVray() : Base("software.vray") {
        $This.HideSpezial = $False
    }

    [JtTblRow]GetJtTblRow([JtInfi]$JtInfi) {
        [JtTblRow]$JtTblRow = $This.GetJtTblRowDefault($JtInfi)

        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Max_2021)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().vRay3ds)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Revit_2021)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().vRayRevit)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Rhino_6)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().vRayRhino)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Sketchup)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().vRaySketchup)

        return $JtTblRow
    }
}

function New-JtRep_SoftwareVray {

    [JtRep_SoftwareVray]::new() 

}


