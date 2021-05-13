using module JtIo
using module JtInf

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"

Describe "Get-JtInf_Soft" {

    It "Should return Inf_Soft" {

        [JtIoFolder]$MyJtIoFolder = New-JtIoFolder_Report
        [String]$MyFolderPath = $MyJtIoFolder.GetPath()
        $MyInf = Get-JtInf_Soft -FolderPath $MyFolderPath
        # [JtInf_Soft]$MyJtInf = $MyInf
        
        $MyInf | Should -BeOfType JtInf_Soft
    }
}
    




