using module JtTbl
using module JtInfi
using module JtRep

class JtRep_Z_Server : JtRep {

    JtRep_Z_Server() : Base("z.server") {
        $This.HideSpezial = $True
    }

    [JtTblRow]GetJtTblRow([JtInfi]$JtInfi) {
        [JtTblRow]$JtTblRow = $This.GetJtTblRowDefault($JtInfi)

        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().WinVersion)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Seadrive)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Seafile)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().ServerViewAgents)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Bacula)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Java)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().AntiVirus)

        return $JtTblRow
    }
}

function new-JtRep_Z_Server {

    [JtRep_Z_Server]::new() 

}



