using module JtIo
using module JtInf

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"

Function Test-JtInf_Soft {

    [JtIoFolder]$MyJtIoFolder = New-JtIoFolder_Report
    [String]$MyFolderPath = $MyJtIoFolder.GetPath()
    $MyInf = Get-JtInf_Soft -FolderPath $MyFolderPath
    # [JtInf_Soft]$MyJtInf = $MyInf

    $MyInf

}


Test-JtInf_Soft


