using module JtTbl
using module JtInf


class JtInf_Win32ComputerSystem : JtInf {


    [JtField]$Modell
    [JtField]$Herst
    [JtField]$Ram
    [JtField]$Computername
    [JtField]$Owner 
    [JtField]$Domain


    JtInf_Win32ComputerSystem () {
        $This.Modell = New-JtField -Label "Modell"
        $This.Herst = New-JtField -Label "Herst"
        $This.Ram = New-JtField -Label "Ram"
        $This.Computername = New-JtField -Label "Computername"
        $This.Owner = New-JtField -Label "Owner"
        $This.Domain = New-JtField -Label "Domain"
    }
    
}

Function New-JtInf_Win32ComputerSystem {

    [JtInf_Win32ComputerSystem]::new()
}


Function New-JtInit_Inf_Win32ComputerSystem {

    Param (
        [Parameter(Mandatory = $true)]
        [JtIoFolder]$JtIoFolder) 

    # [JtInf_Win32ComputerSystem]$JtInf = $This.Cache_JtInf_Win32ComputerSystem
        
    [JtInf_Win32ComputerSystem]$JtInf = New-JtInf_Win32ComputerSystem
    
    [String]$Name = "Win32_ComputerSystem"
    [System.Object]$JtObj = Get-JtXmlReportObject -JtIoFolder $JtIoFolder -Name $Name
        
    $JtInf.Computername.SetValue($JtObj.Name)
    $JtInf.Herst.SetValue($JtObj.Manufacturer)
    $JtInf.Modell.SetValue($JtObj.Model)
        
    [String]$GB = ConvertTo-JtStringToGb($JtObj.TotalPhysicalMemory)
        
    $JtInf.Ram.SetValue($GB)
    $JtInf.Owner.SetValue($JtObj.PrimaryOwnerName)
    $JtInf.Domain.SetValue($JtObj.Domain)
        
    return [JtInf_Win32ComputerSystem]$JtInf
}
    

