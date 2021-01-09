using module JtTbl
using module JtInfi
using module JtRep

class JtRep_Net : JtRep {

    JtRep_Net() : Base("report.net") {
        $This.HideSpezial = $True
    }

    [JtTblRow]GetJtTblRow([JtInfi]$JtInfi) {
        [JtTblRow]$JtTblRow = $This.GetJtTblRowDefault($JtInfi)
        
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().Ip)
        # $JtTblRow.Add($JtInfi.GetJtInf_Win32NetworkAdapter().Ip3)
        $JtTblRow.Add($JtInfi.GetJtInf_Win32NetworkAdapter().Mac)

        return $JtTblRow
    }

}



function New-JtRep_Net {

    [JtRep_Net]::new() 

}
