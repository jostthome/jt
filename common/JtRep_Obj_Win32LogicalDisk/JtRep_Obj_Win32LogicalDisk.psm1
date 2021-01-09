using module JtTbl
using module JtInfi
using module JtRep

class JtRep_Obj_Win32LogicalDisk : JtRep {

    JtRep_Obj_Win32LogicalDisk() : Base("obj.win32_logicaldisk") {
        $This.HideSpezial = $True
    }

    [JtTblRow]GetJtTblRow([JtInfi]$JtInfi) {
        [JtTblRow]$JtTblRow = $This.GetJtTblRowDefault($JtInfi)

        $JtTblRow.Add($JtInfi.GetJtInf_Win32LogicalDisk().C) | Out-Null 
        $JtTblRow.Add($JtInfi.GetJtInf_Win32LogicalDisk().C_Capacity) | Out-Null 
        $JtTblRow.Add($JtInfi.GetJtInf_Win32LogicalDisk().C_Free) | Out-Null 
        $JtTblRow.Add($JtInfi.GetJtInf_Win32LogicalDisk().C_FreePercent) | Out-Null 
        # $JtTblRow.Add($JtInfi.GetJtInf_Win32LogicalDisk().Get_C_MediaType()) | Out-Null 
        $JtTblRow.Add($JtInfi.GetJtInf_Win32LogicalDisk().D) | Out-Null 
        $JtTblRow.Add($JtInfi.GetJtInf_Win32LogicalDisk().D_Capacity) | Out-Null 
        $JtTblRow.Add($JtInfi.GetJtInf_Win32LogicalDisk().D_Free) | Out-Null 
        $JtTblRow.Add($JtInfi.GetJtInf_Win32LogicalDisk().D_FreePercent) | Out-Null 
        # $JtTblRow.Add($JtInfi.GetJtInf_Win32LogicalDisk().Get_D_MediaType()) | Out-Null 
        $JtTblRow.Add($JtInfi.GetJtInf_Win32LogicalDisk().E) | Out-Null 
        $JtTblRow.Add($JtInfi.GetJtInf_Win32LogicalDisk().E_Capacity) | Out-Null 
        $JtTblRow.Add($JtInfi.GetJtInf_Win32LogicalDisk().E_Free) | Out-Null 
        $JtTblRow.Add($JtInfi.GetJtInf_Win32LogicalDisk().E_FreePercent) | Out-Null 
        # $JtTblRow.Add($JtInfi.GetJtInf_Win32LogicalDisk().Get_E_MediaType()) | Out-Null 

        return $JtTblRow
    }

}

function New-JtRep_Obj_Win32LogicalDisk {

    [JtRep_Obj_Win32LogicalDisk]::new() 

}


