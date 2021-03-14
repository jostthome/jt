using module JtTbl

Set-StrictMode -version latest
$ErrorActionPreference = "Stop"

Function Test-JtBxH {

    [String]$MyFolderPath_Test = Get-JtFolderPath_Index_BxH
    $MyFolderPath_Test

    [JtTblTable]$MyJtTblTable = Convert-JtFolderPath_To_JtTblTable_BxH -FolderPath_Input $MyFolderPath_Test
    $MyJtTblTable


    Update-JtFolderPath_Md_And_Meta -FolderPath_Input $MyFolderPath_Test

    $MyDataTable = Convert-JtTblTable_To_Datatable -JtTblTable $MyJtTblTable
    $MyDataTable

}

Test-JtBxH


Function Test-JtInvPoster {

    New-JtInvPoster
}

Test-JtInvPoster