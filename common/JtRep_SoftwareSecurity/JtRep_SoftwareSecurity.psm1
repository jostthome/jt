using module JtTbl
using module JtInfi
using module JtRep

class JtRep_SoftwareSecurity : JtRep {

    JtRep_SoftwareSecurity() : Base("software.security") {
        $This.HideSpezial = $False
    }

    [JtTblRow]GetJtTblRow([JtInfi]$JtInfi) {
        [JtTblRow]$JtTblRow = $This.GetJtTblRowDefault($JtInfi)

        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().WinVersion)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Flash)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Java)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Opsi)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().AntiVirus)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().CiscoAnyConnect)

        return $JtTblRow
    }
}


function New-JtRep_SoftwareSecurity {

    [JtRep_SoftwareSecurity]::new() 

}


