using module JtTbl
using module JtInf


class JtInf_Win32LogicalDisk : JtInf { 

    [JtField]$C
    [JtField]$C_Capacity
    [JtField]$C_Free
    [JtField]$C_FreePercent
    [JtField]$C_MediaType
    [JtField]$D
    [JtField]$D_Capacity
    [JtField]$D_Free
    [JtField]$D_FreePercent
    [JtField]$D_MediaType
    [JtField]$E
    [JtField]$E_Capacity
    [JtField]$E_Free
    [JtField]$E_FreePercent
    [JtField]$E_MediaType

    JtInf_Win32LogicalDisk() {
        $This.C = New-JtField -Label "C"
        $This.C_Capacity = New-JtField -Label "C_Capacity"
        $This.C_Free = New-JtField -Label "C_Free"
        $This.C_FreePercent = New-JtField -Label "C_FreePercent"
        $This.C_MediaType = New-JtField -Label "C_MediaType"
        $This.D = New-JtField -Label "D"
        $This.D_Capacity = New-JtField -Label "D_Capacity"
        $This.D_Free = New-JtField -Label "D_Free"
        $This.D_FreePercent = New-JtField -Label "D_FreePercent"
        $This.D_MediaType = New-JtField -Label "D_MediaType"
        $This.E = New-JtField -Label "E"
        $This.E_Capacity = New-JtField -Label "E_Capacity"
        $This.E_Free = New-JtField -Label "E_Free"
        $This.E_FreePercent = New-JtField -Label "E_FreePercent"
        $This.E_MediaType = New-JtField -Label "E_MediaType"
    }
    
}
Function New-JtInf_Win32LogicalDisk {
    [JtInf_Win32LogicalDisk]::new()
}



function New-JtInit_Inf_Win32LogicalDisk {

    Param (
        [Parameter(Mandatory = $true)]
        [JtIoFolder]$JtIoFolder) 

    [JtInf_Win32LogicalDisk]$JtInf = New-JtInf_Win32LogicalDisk

    [String]$Name = "Win32_LogicalDisk"
    [System.Object]$JtObj = Get-JtXmlReportObject -JtIoFolder $JtIoFolder -Name $Name
        
    $MyLetters = @("C", "D", "E")
    foreach ($MyLetter in $MyLetters) {
        $MyField1 = $MyLetter
        $MyValue1 = ""
        $MyField2 = -join ($MyLetter, "_", "Capacity")
        $MyValue2 = ""
        $MyField3 = -join ($MyLetter, "_", "Free")
        $MyValue3 = ""
        $MyField4 = -join ($MyLetter, "_", "FreePercent")
        $MyValue4 = ""
        # $MyField5 = -join ($MyLetter, "_", "MediaType")
        # $MyValue5 = ""
        if ($Null -ne $JtObj) {
            try {
                # $JtObj2 = $JtObj | Select-Object -Property DeviceID, VolumeName, @{L = "Capacity"; E = { "{0:N2}" -f ($_.Size / 1GB) } }, @{L = 'FreeSpaceGB'; E = { "{0:N2}" -f ($_.FreeSpace / 1GB) } }, DriveType, MediaType
                $TestValue = -join ($MyLetter, ":")
                $JtObj2 = $JtObj | Where-Object -Property DeviceId -eq -Value $TestValue
                $JtObj3 = $JtObj2 | Select-Object -Property DeviceID, VolumeName, @{L = "Capacity"; E = { "{0:N2}" -f ($_.Size / 1GB) } }, @{L = 'FreeSpaceGB'; E = { "{0:N2}" -f ($_.FreeSpace / 1GB) } }
     
                foreach ($Line in $JtObj3) {
                    $MyDriveLetter = $Line.DeviceID.Replace(":", "")
                    $MyValue1 = $MyDriveLetter
                    $JtInf.$MyField1.SetValue( $MyValue1)
    
                    $Capacity = $line.Capacity
                    $MyValue2 = $Capacity
                    $JtInf.$MyField2.SetValue( $MyValue2)
     
                    $FreeSpaceGB = $line.FreeSpaceGB
                    $MyValue3 = $FreeSpaceGB
                    $JtInf.$MyField3.SetValue( $MyValue3)

                    $MyCapacity = $Capacity.replace(".", "")
                    $MyFreeSpaceGB = $FreeSpaceGB.replace(".", "")
     
                    $Free = $MyFreeSpaceGB / $MyCapacity * 100
                    $MyValue4 = $Free -as [int32]
                    $JtInf.$MyField4.SetValue( $MyValue4)
    
                    # $MediaType = $line.MediaType
                    # $MyValue5 = $MediaType
                    # $JtInf.$MyField5.SetValue($MyValue5)
                } 
            } catch {
                Write-JtError -Text ( -join ("Obj is NULL for letter ", $MyLetter, "  in ", $Name))
            } 
        } 
    }
    return [JtInf_Win32LogicalDisk]$JtInf
} 
