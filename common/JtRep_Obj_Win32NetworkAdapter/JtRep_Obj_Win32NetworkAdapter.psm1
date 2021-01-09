using module JtTbl
using module JtInfi
using module JtRep

class JtRep_Obj_Win32NetworkAdapter : JtRep {

    JtRep_Obj_Win32NetworkAdapter() : Base("obj.win32_networkadapter") {
        $This.HideSpezial = $False
    }

    [JtTblRow]GetJtTblRow([JtInfi]$JtInfi) {
        [JtTblRow]$JtTblRow = $This.GetJtTblRowDefault($JtInfi)

        # $JtTblRow.Add($JtInfi.GetJtInf_Win32NetworkAdapter().Ip) | Out-Null 
        # $JtTblRow.Add($JtInfi.GetJtInf_Win32NetworkAdapter().Ip3) | Out-Null 
        $JtTblRow.Add($JtInfi.GetJtInf_Win32NetworkAdapter().MAC) | Out-Null 
        return $JtTblRow
    }
}


function New-JtRep_Obj_Win32NetworkAdapter {

    [JtRep_Obj_Win32NetworkAdapter]::new() 

}


