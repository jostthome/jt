using module JtTbl
using module JtInfi
using module JtRep

class JtRep_Obj_Win32VideoController : JtRep {

    JtRep_Obj_Win32VideoController() : Base("obj.win32_videocontroller") {
        $This.HideSpezial = $True
    }

    [JtTblRow]GetJtTblRow([JtInfi]$JtInfi) {
        [JtTblRow]$JtTblRow = $This.GetJtTblRowDefault($JtInfi)

        $JtTblRow.Add($JtInfi.GetJtInf_Win32VideoController().Grafikkarte) | Out-Null 
        $JtTblRow.Add($JtInfi.GetJtInf_Win32VideoController().TreiberVersion) | Out-Null 
        return $JtTblRow
    }


}


function New-JtRep_Obj_Win32VideoController {

    [JtRep_Obj_Win32VideoController]::new() 

}


