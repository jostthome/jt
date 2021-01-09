using module JtTbl
using module JtInf


class JtInf_Win32NetworkAdapter : JtInf {

    [JtField]$Mac
    # [JtField]$Ip
    # [JtField]$Ip3

    JtInf_Win32NetworkAdapter (){
        $This.Mac = New-JtField -Label "Mac"
        # $This.Ip = New-JtField -Label "Ip"
        # $This.Ip3 = New-JtField -Label "Ip3"
    }
}

Function New-JtInf_Win32NetworkAdapter {
    [JtInf_Win32NetworkAdapter]::new()
}


function New-JtInit_Inf_Win32NetworkAdapter {

    Param (
        [Parameter(Mandatory = $false)]
        [JtIoFolder]$JtIoFolder) 
        
    [JtInf_Win32NetworkAdapter]$JtInf = New-JtInf_Win32NetworkAdapter

    [String]$Name = "Win32_NetworkAdapter"

    [System.Object]$JtObj = Get-JtXmlReportObject -JtIoFolder $JtIoFolder -Name $Name
    
    # [String]$Ip = $JtInfi.GetJtInf_AFolder().Ip
 #   [String]$Ip = "130.75.66.999"
    # $JtInf.Ip.SetValue($JtObj.Ip)
    # $JtInf.Ip3.SetValue([JtUtil]::FullIp2IpPart($Ip))

    [String]$Mac = ""
    try {
        $Cons = $JtObj | Where-Object -Property netconnectionstatus -Like "2" 
        $Result = $Cons | Select-Object -Property MACAddress
    
        $Mac = $Result[0].MACAddress 
    }
    catch {
        Write-JtError -Text ( -join ("Field:", "xxxx", ", Error in ", $This.Name))
    }
    $JtInf.Mac.SetValue($Mac)

    return [JtInf_Win32NetworkAdapter]$JtInf
}


