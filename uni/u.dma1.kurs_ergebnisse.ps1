using module JtCsv

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"
Function New-JtResultsSummary{

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Label,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Sub,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Expected
    )

    [String]$MyLabelAll = -join($Label, ".", "all")
    New-JtCsvFolderSummaryAll -Label $MyLabelAll -FolderPath $FolderPath -Sub $Sub -Expected $Expected

    [String]$MyLabelExpected = -join($Label, ".", "expected")
    New-JtCsvFolderSummaryExpected -Label $MyLabelExpected -FolderPath $FolderPath -Sub $Sub -Expected $Expected
}

New-JtResultsSummary -Label "aufgabe_4c" -FolderPath "D:\Seafile\al-cad-20w\1.ABGABEN" -Sub "143.AUFGABE_4c" -Expected ".pdf,.rvt"
New-JtResultsSummary -Label "aufgabe_4b" -FolderPath "D:\Seafile\al-cad-20w\1.ABGABEN" -Sub "142.AUFGABE_4b" -Expected ".pdf,.rvt"
New-JtResultsSummary -Label "aufgabe_4a" -FolderPath "D:\Seafile\al-cad-20w\1.ABGABEN" -Sub "141.AUFGABE_4a" -Expected ".pdf,.rvt"
New-JtResultsSummary -Label "aufgabe_3c" -FolderPath "D:\Seafile\al-cad-20w\1.ABGABEN" -Sub "133.AUFGABE_3c" -Expected ".pdf,.rvt"
New-JtResultsSummary -Label "aufgabe_3b" -FolderPath "D:\Seafile\al-cad-20w\1.ABGABEN" -Sub "132.AUFGABE_3b" -Expected ".pdf,.rvt"
New-JtResultsSummary -Label "aufgabe_3a" -FolderPath "D:\Seafile\al-cad-20w\1.ABGABEN" -Sub "131.AUFGABE_3a" -Expected ".pdf"
New-JtResultsSummary -Label "aufgabe_2c" -FolderPath "D:\Seafile\al-cad-20w\1.ABGABEN" -Sub "123.AUFGABE_2c" -Expected ".pdf"
New-JtResultsSummary -Label "aufgabe_2b" -FolderPath "D:\Seafile\al-cad-20w\1.ABGABEN" -Sub "122.AUFGABE_2b" -Expected ".pdf,.rfa"
New-JtResultsSummary -Label "aufgabe_2a" -FolderPath "D:\Seafile\al-cad-20w\1.ABGABEN" -Sub "121.AUFGABE_2a" -Expected ".jpg"
New-JtResultsSummary -Label "aufgabe_1a" -FolderPath "D:\Seafile\al-cad-20w\1.ABGABEN" -Sub "111.AUFGABE_1a" -Expected ".pdf"
New-JtResultsSummary -Label "aufgabe_0a" -FolderPath "D:\Seafile\al-cad-20w\1.ABGABEN" -Sub "101.AUFGABE_0a" -Expected ".pdf"




