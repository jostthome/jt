using module JtTbl
using module JtInf


class JtInf_Win32Processor : JtInf {

    [JtField]$Cpu
    [JtField]$Ghz
    [JtField]$Cores
    [JtField]$CoresH

    JtInf_Win32Processor () {
        $This.Cpu = New-JtField -Label "Cpu"
        $This.Ghz = New-JtField -Label "Ghz"
        $This.Cores = New-JtField -Label "Cores"
        $This.CoresH = New-JtField -Label "CoresH"
    }
}

Function New-JtInf_Win32Processor {
    [JtInf_Win32Processor]::new()
}

Function New-JtInit_Inf_Win32Processor {

    Param (
        [Parameter(Mandatory = $false)]
        [JtIoFolder]$JtIoFolder = $Null) 

    [JtInf_Win32Processor]$JtInf = New-JtInf_Win32Processor
    [String]$Name = "Win32_Processor"

    $JtIoFolder = New-JtIoFolderReport
    [System.Object]$JtObj = Get-JtXmlReportObject -JtIoFolder $JtIoFolder -Name $Name
    # $JtObj
    $JtInf.Cpu.SetValue($JtObj.Name)
    # [String]$MaxClockSpeed = $JtObj.Get_MaxClockSpeed.ToString("0,0")
    # $JtInf.SetObjValue($JtObj, $JtInf.Get_Ghz(), $MaxClockSpeed )
    $JtInf.Ghz.SetValue($JtObj.MaxClockSpeed)   
    $JtInf.Cores.SetValue($JtObj.NumberOfCores)
    $JtInf.CoresH.SetValue($JtObj.NumberOfLogicalProcessors)
                
    return [JtInf_Win32Processor]$JtInf
}



