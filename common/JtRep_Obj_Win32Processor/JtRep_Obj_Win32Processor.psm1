using module JtTbl
using module JtInfi
using module JtRep

class JtRep_Obj_Win32Processor : JtRep {

    JtRep_Obj_Win32Processor() : Base("obj.win32_processor") {
        $This.HideSpezial = $True
    }

    [JtTblRow]GetJtTblRow([JtInfi]$JtInfi) {
        [JtTblRow]$JtTblRow = $This.GetJtTblRowDefault($JtInfi)

        $JtTblRow.Add($JtInfi.GetJtInf_Win32Processor().Cpu) | Out-Null 
        $JtTblRow.Add($JtInfi.GetJtInf_Win32Processor().Ghz) | Out-Null 
        $JtTblRow.Add($JtInfi.GetJtInf_Win32Processor().Cores) | Out-Null 
        $JtTblRow.Add($JtInfi.GetJtInf_Win32Processor().CoresH) | Out-Null

        return $JtTblRow
    }
}
function New-JtRep_Obj_Win32Processor {

    [JtRep_Obj_Win32Processor]::new() 

}


