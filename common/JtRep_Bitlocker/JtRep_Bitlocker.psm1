using module JtTbl
using module JtInfi
using module JtRep

class JtRep_Bitlocker : JtRep {

    JtRep_Bitlocker() : Base("report.bitlocker") {
        $This.ClassName = "JtRep_Bitlocker"
        $This.HideSpezial = $True
    }

    [JtTblRow]GetJtTblRow([JtInfi]$JtInfi) {
        [JtTblRow]$JtTblRow = $This.GetJtTblRowDefault($JtInfi)

        $JtTblRow.Add($JtInfi.GetJtInf_Bitlocker().C_CapacityGB)
        $JtTblRow.Add($JtInfi.GetJtInf_Bitlocker().C_VolumeType)
        $JtTblRow.Add($JtInfi.GetJtInf_Bitlocker().C_EncryptionMethod)
        $JtTblRow.Add($JtInfi.GetJtInf_Bitlocker().C_ProtectionStatus)
        $JtTblRow.Add($JtInfi.GetJtInf_Bitlocker().D_CapacityGB)
        $JtTblRow.Add($JtInfi.GetJtInf_Bitlocker().D_VolumeType)
        $JtTblRow.Add($JtInfi.GetJtInf_Bitlocker().D_EncryptionMethod)
        $JtTblRow.Add($JtInfi.GetJtInf_Bitlocker().D_ProtectionStatus)

        return $JtTblRow
    }

}

function New-JtRep_Bitlocker {

    [JtRep_Bitlocker]::new() 

}



