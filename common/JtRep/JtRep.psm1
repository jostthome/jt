using module JtClass
using module JtTbl
using module JtInfi
using module JtTime

class JtRep : JtClass {

    hidden [JtTimeStop]$Uhr
    hidden [String]$Label
    hidden [Boolean]$HideSpezial = $False

    JtRep([String]$Label) {
        $This.ClassName = $Label
        $This.Label = $Label
        
        $This.HideSpezial = $True
        $This.Uhr = [JtTimeStop]::new()
    }

    
    [JtTblRow]GetJtTblRow([JtInfi]$JtInfi) {
        Throw "This should not happen! Should be 'GetJtTblRow' overwritten!!!!"
        return $Null
    }

    [JtTblRow]GetJtTblRowDefault([JtInfi]$JtInfi) {
        [JtTblRow]$JtTblRow = New-JtTblRow
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().SystemId) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().Org1) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().Org2) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().Type) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().Computername) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().LabelC) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().DaysAgo) | Out-Null
        #        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().Alias) | Out-Null
        
        return $JtTblRow
    }

    [String]GetCsvFileName() {
        [String]$Result = -join ($This.Label, ".csv")
        Return $Result
    }

    [String]GetLabel() {
        return $This.Label
    }

}
