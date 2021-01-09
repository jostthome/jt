using module JtTbl
using module JtInfi
using module JtRep

class JtRep_Hardware : JtRep {

    JtRep_Hardware() : Base("report.hardware") {
        $This.HideSpezial = $True
    }

    [JtTblRow]GetJtTblRow([JtInfi]$JtInfi) {
        [JtTblRow]$JtTblRow = $This.GetJtTblRowDefault($JtInfi)
        $JtTblRow.Add($JtInfi.GetJtInf_Win32ComputerSystem().Herst) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_Win32ComputerSystem().Modell) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_Win32ComputerSystem().Ram) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_Win32Processor().Cpu) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_Win32Processor().Ghz) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_Win32VideoController().Grafikkarte) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_Win32LogicalDisk().C_MediaType) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_Win32LogicalDisk().C_Capacity) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_Win32LogicalDisk().D_MediaType) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_Win32LogicalDisk().D_Capacity) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_Win32Bios().Sn) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_Win32Bios().BIOSVersion) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_Win32NetworkAdapter().Mac) | Out-Null
        return $JtTblRow
    }
}

function New-JtRep_Hardware {

    [JtRep_Hardware]::new() 

}

