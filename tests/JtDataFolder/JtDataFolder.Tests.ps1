using module JtColRen

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"

Function Test-JtDataFolder {

    [String]$MyFolderPath_Input = Get-JtFolderPath_Index_Betrag

    [JtDataFolder]$MyJtDataFolder = Get-JtDataFolder -FolderPath $MyFolderPath_Input
    $MyJtDataFolder.DoCheck("c:\_inventory\out")
}

# Test-JtDataFolder


Function Test-JtDataRepository {

    [String]$MyFolderPath_Input = "$env:OneDrive\DATA"

    [JtDataRepository]$MyJtDataRepository = Get-JtDataRepository -FolderPath $MyFolderPath_Input
    $MyJtDataRepository.DoReportProblems("C:\_inventory\out")
}

Test-JtDataRepository
