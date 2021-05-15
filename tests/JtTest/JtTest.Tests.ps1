using module JtCsv
using module JtMd
using module JtTbl

Set-StrictMode -version latest
$ErrorActionPreference = "Stop"

Describe "JtTest" {

    It "Should ... path" {

        $MyFolderPath = Get-JtFolderPath_Index_Anzahl
        Test-JtIoFolderPath -FolderPath $MyFolderPath | Should -BeTrue
        $MyFolderPath = Get-JtFolderPath_Index_Betrag
        Test-JtIoFolderPath -FolderPath $MyFolderPath | Should -BeTrue
        $MyFolderPath = Get-JtFolderPath_Index_BxH
        Test-JtIoFolderPath -FolderPath $MyFolderPath | Should -BeTrue
        $MyFolderPath = Get-JtFolderPath_Index_Files
        Test-JtIoFolderPath -FolderPath $MyFolderPath | Should -BeTrue
        $MyFolderPath = Get-JtFolderPath_Index_Stunden
        Test-JtIoFolderPath -FolderPath $MyFolderPath | Should -BeTrue
        $MyFolderPath = Get-JtFolderPath_Index_Zahlung
        Test-JtIoFolderPath -FolderPath $MyFolderPath | Should -BeTrue
    }
}
