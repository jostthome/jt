using module JtTbl

Set-StrictMode -version latest
$ErrorActionPreference = "Stop"

Describe "Convert-JtFolderPath_To_JtTblTable_BxH" {

    It "Should ... JtTblTable_BxH" {

        [String]$MyFolderPath_Test = Get-JtFolderPath_Index_BxH
        
        [JtTblTable]$MyJtTblTable = Convert-JtFolderPath_To_JtTblTable_BxH -FolderPath_Input $MyFolderPath_Test
        $MyJtTblTable | Should -BeOfType JtTblTable
    }
}

Describe "Update-JtFolderPath_Md_And_Meta" {

    It "Should ..." {

        [String]$MyFolderPath_Output = -join ((Get-JtFolderPath_TestsOutput), "\", "Update-JtFolderPath_Md_And_Meta")
        [String]$MyFolderPath_Test = Get-JtFolderPath_Index_BxH
        Update-JtFolderPath_Md_And_Meta -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Output
    }
}

Describe "New-JtInvPoster" {

    It "Should ... poster" {

        New-JtInvPoster
    }

}
