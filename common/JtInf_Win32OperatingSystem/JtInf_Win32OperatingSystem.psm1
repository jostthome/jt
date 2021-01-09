using module JtTbl
using module JtInf


class JtInf_Win32OperatingSystem : JtInf {

    [JtField]$OsCaption
    [JtField]$OsManu
    [JtField]$OsSerial
    [JtField]$OsVersion

    JtInf_Win32OperatingSystem() {
        $This.OsCaption = New-JtField -Label "OsCaption"
        $This.OsManu = New-JtField -Label "OsManu"
        $This.OsSerial = New-JtField -Label "OsSerial"
        $This.OsVersion = New-JtField -Label "OsVersion"
    }

}

Function New-JtInf_Win32OperatingSystem {
    [JtInf_Win32OperatingSystem]::new()
}


Function New-JtInit_Inf_Win32OperatingSystem {

    Param (
        [Parameter(Mandatory = $true)]
        [JtIoFolder]$JtIoFolder) 

    [JtInf_Win32OperatingSystem]$JtInf = New-JtInf_Win32OperatingSystem    
    [String]$Name = "Win32_OperatingSystem"

    [System.Object]$JtObj = Get-JtXmlReportObject -JtIoFolder $JtIoFolder -Name $Name

    $JtInf.OSCaption.SetValue($JtObj.Caption)
    $JtInf.OsManu.SetValue($JtObj.Manufacturer)
    $JtInf.OsSerial.SetValue($JtObj.SerialNumber)
    $JtInf.OsVersion.SetValue($JtObj.Version)
        
    return [JtInf_Win32OperatingSystem]$JtInf
}    







