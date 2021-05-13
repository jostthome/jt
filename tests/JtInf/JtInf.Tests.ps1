using module JtIo
using module JtInf

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"


Describe "Get-JtInf_Win32LogicalDisk" {

    It "Should return Inf" {
        $A = Get-JtInf_Win32LogicalDisk -FolderPath "c:\_inventory\report"
        $A | Should -BeOfType JtInf_Win32LogicalDisk
    }

}



