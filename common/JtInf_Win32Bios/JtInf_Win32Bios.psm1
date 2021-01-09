using module JtTbl
using module JtInf

class JtInf_Win32Bios : JtInf {

    [String]$Label_Hersteller = "Hersteller"

    [JtField]$Hersteller
    [JtField]$Sn
    [JtField]$BIOSVersion
    

    JtInf_Win32Bios() {
        $This.Hersteller = New-JtField "Hersteller"
        $This.Sn = New-JtField "Sn"
        $This.BIOSVersion = New-JtField "BIOSVersion"
    }
}

Function New-JtInf_Win32Bios {

    [JtInf_Win32Bios]::new()
}

Function New-JtInit_Inf_Win32Bios {

    Param (
        [Parameter(Mandatory = $true)]
        [JtIoFolder]$JtIoFolder) 

    [JtInf_Win32Bios]$JtInf = New-JtInf_Win32Bios

    [String]$Name = "Win32_Bios"
    [System.Object]$JtObj = Get-JtXmlReportObject -JtIoFolder $JtIoFolder -Name $Name

    $JtInf.Hersteller.SetValue($JtObj.Manufacturer)
    $JtInf.Sn.SetValue($JtObj.SerialNumber)
    $JtInf.BIOSVersion.SetValue($JtObj.SMBIOSBIOSVersion)
        
    return $JtInf
}
