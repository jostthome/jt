using module JtInfi
using module JtInf_Soft
using module JtRep
using module JtTbl

class JtRep_Software : JtRep {
 
    JtRep_Software () : Base("software") {
        $This.HideSpezial = $False
    }

    [JtTblRow]GetJtTblRow([JtInfi]$JtInfi) {
        [JtTblRow]$JtTblRow = $This.GetJtTblRowDefault($JtInfi)

        [JtInf_Soft]$JtInf_Soft = $JtInfi.GetJtInf_Soft()
        [Object[]]$Fields = $JtInf_Soft.GetFields()

        foreach ($Field in $Fields) {
            [JtFldSoft]$JtFldSoft = $Field

            $JtInf_Soft.($Field.GetLabel())
            
            [String]$MyLabel = $Field.GetLabel()
            [String]$MyValue = $JtInf_Soft.($MyLabel)

            # Write-JtLog (-join("Soft-Label:", $MyLabel))
            # Write-JtLog (-join("Soft-Value:", $MyValue))

            [JtField]$Fld = New-JtField -Label $JtFldSoft.GetLabel() -Value $MyValue
            $JtTblRow.Add($Fld)
            # Write-JtLog("GetJtTblRow-Add")
            # $JtTblRow.Add($JtFldSoft)
        }
        return $JtTblRow
    }
}

function New-JtRep_Software {

    [JtRep_Software]::new() 

}


