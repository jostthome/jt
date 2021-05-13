using module JtTbl

Set-StrictMode -version latest
$ErrorActionPreference = "Stop"

Function Test-JtBxH {

    [String]$MyFolderPath_Test = Get-JtFolderPath_Index_BxH

    [JtTblTable]$MyJtTblTable = Convert-JtFolderPath_To_JtTblTable_BxH -FolderPath_Input $MyFolderPath_Test
    $MyJtTblTable

    Update-JtFolderPath_Md_And_Meta -FolderPath_Input $MyFolderPath_Test

    $MyDataTable = Convert-JtTblTable_To_Datatable -JtTblTable $MyJtTblTable
    $MyDataTable
}

Test-JtBxH

Return


Function Test-JtInvPoster {

    New-JtInvPoster
}

Test-JtInvPoster