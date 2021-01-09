using module JtTbl
using module JtInfi
using module JtRep

class JtRep_Folder : JtRep {

    JtRep_Folder () : Base("report.folders") {
        $This.HideSpezial = $False
    }

    [JtTblRow]GetJtTblRow([JtInfi]$JtInfi) {
        [JtTblRow]$JtTblRow = New-JtTblRow
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().SystemId) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().Org) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().Org1) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().Org2) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().Type) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().Computername) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().Alias) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().Name) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().LabelC) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().DaysAgo) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().JtVersion) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().Timestamp) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().WinVersion) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().WinGen) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().WinBuild) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().KlonVersion) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().Ip) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().Timestamp) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().User) | Out-Null
        return $JtTblRow
    }
}


function New-JtRep_Folder {

    [JtRep_Folder]::new() 

}
