using module JtTbl
using module JtInf


class JtInf_Win32VideoController : JtInf {

    [JtField]$Grafikkarte
    [JtField]$TreiberVersion

    JtInf_Win32VideoController () {
        $This.Grafikkarte = New-JtField -Label "Grafikkarte"
        $This.TreiberVersion = New-JtField -Label "TreiberVersion"
    }
    
    [JtField]Get_Grafikkarte() {
        return $This.Grafikkarte
    } 

    [JtField]Get_TreiberVersion() {
        return $This.TreiberVersion
    } 
}


Function New-JtInf_Win32VideoController {

    [JtInf_Win32VideoController]::new()
}

Function New-JtInit_Inf_Win32VideoController {
    
    Param (
        [Parameter(Mandatory = $true)]
        [JtIoFolder]$JtIoFolder) 

    [JtInf_Win32VideoController]$JtInf = New-JtInf_Win32VideoController
    [String]$Name = "Win32_VideoController"
    
    [System.Object]$JtObj = Get-JtXmlReportObject -JtIoFolder $JtIoFolder -Name $Name
    
    $JtInf.Grafikkarte.SetValue($JtObj.Description)
    $JtInf.TreiberVersion.SetValue($JtObj.Driverversion)
            
    return [JtInf_Win32VideoController]$JtInf
}
