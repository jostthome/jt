using module JtTbl
using module JtInf


class JtInf_Bitlocker : JtInf {
    
    [JtField]$C_CapacityGB
    [JtField]$C_VolumeType
    [JtField]$C_EncryptionMethod
    [JtField]$C_ProtectionStatus
    [JtField]$D_CapacityGB
    [JtField]$D_VolumeType
    [JtField]$D_EncryptionMethod
    [JtField]$D_ProtectionStatus



    JtInf_Bitlocker () {
        $This.C_CapacityGB = New-JtField -Label "C_CapacityGB"
        $This.C_VolumeType = New-JtField -Label "C_VolumeType"
        $This.C_EncryptionMethod = New-JtField -Label "C_EncryptionMethod"
        $This.C_ProtectionStatus = New-JtField -Label "C_ProtectionStatus"
        $This.D_CapacityGB = New-JtField -Label "D_CapacityGB"
        $This.D_VolumeType = New-JtField -Label "D_VolumeType"
        $This.D_EncryptionMethod = New-JtField -Label "D_EncryptionMethod"
        $This.D_ProtectionStatus = New-JtField -Label "D_ProtectionStatus"
    }
    [JtField]Get_C_CapacityGB() {
        return $This.C_CapacityGB
    } 

    [JtField]Get_C_VolumeType() {
        return $This.C_VolumeType
    } 

    [JtField]Get_C_EncryptionMethod() {
        return $This.C_EncryptionMethod
    } 

    [JtField]Get_C_ProtectionStatus() {
        return $This.C_ProtectionStatus
    } 

    [JtField]Get_D_CapacityGB() {
        return $This.D_CapacityGB
    } 

    [JtField]Get_D_VolumeType() {
        return $This.D_VolumeType

    } 
    [JtField]Get_D_EncryptionMethod() {
        return $This.D_EncryptionMethod
    } 

    [JtField]Get_D_ProtectionStatus() {
        return $This.D_ProtectionStatus
    }
}


Function New-JtInf_Bitlocker {

    [JtInf_Bitlocker]::new()
}

function New-JtInit_Inf_Bitlocker {

    Param (
        [Parameter(Mandatory = $true)]
        [JtIoFolder]$JtIoFolder) 


    [JtInf_Bitlocker]$JtInf = New-JtInf_Bitlocker
    [String]$Name = "Bitlocker"

    [System.Object]$JtObj = Get-JtXmlReportObject -JtIoFolder $JtIoFolder -Name $Name

    foreach ($Element in $JtObj) {
        [String]$DriveLetter = $Element.MountPoint.Replace(":", "")
        [String]$CapacityGB = $Element.CapacityGB
        [String]$VolumeType = $Element.VolumeType
        [String]$EncryptionMethod = $Element.EncryptionMethod
        [String]$ProtectionStatus = $Element.ProtectionStatus 
        if ($DriveLetter -eq "C") {
            $JtInf.C_CapacityGB.SetValue($CapacityGB)
            $JtInf.C_VolumeType.SetValue($VolumeType)
            $JtInf.C_EncryptionMethod.SetValue($EncryptionMethod)
            $JtInf.C_ProtectionStatus.SetValue($ProtectionStatus)
        }
        elseif ($DriveLetter -eq "D") {
            $JtInf.D_CapacityGB.SetValue($CapacityGB)
            $JtInf.D_VolumeType.SetValue($VolumeType)
            $JtInf.D_EncryptionMethod.SetValue($EncryptionMethod)
            $JtInf.D_ProtectionStatus.SetValue($ProtectionStatus)
        }
    }
     
    return [JtInf_Bitlocker]$JtInf 
}
