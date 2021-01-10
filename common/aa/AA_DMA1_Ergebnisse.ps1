using module JtFolderSummary

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"
Function New-JtResultsSummary{

    Param (
        [Parameter()]
        [String]$Label,
        [Parameter()]
        [String]$Path,
        [Parameter()]
        [String]$Sub,
        [Parameter()]
        [String]$Expected
    )

    [String]$MyLabelAll = -join($Label, ".", "all")
    New-JtFolderSummaryAll -Label $MyLabelAll -Path $Path -Sub $Sub -Expected $Expected

    
    [String]$MyLabelExpected = -join($Label, ".", "expected")
    New-JtFolderSummaryExpected -Label $MyLabelExpected -Path $Path -Sub $Sub -Expected $Expected
}


New-JtResultsSummary -Label "aufgabe_0a" -Path "D:\Seafile\al-cad-20w\1.ABGABEN" -Sub "101.AUFGABE_0a\1019.AUFGABE_0A.ERGEBNISSE" -Expected ".pdf"
New-JtResultsSummary -Label "aufgabe_1a" -Path "D:\Seafile\al-cad-20w\1.ABGABEN" -Sub "111.AUFGABE_1a\1119.AUFGABE_1A.ERGEBNISSE" -Expected ".pdf"
New-JtResultsSummary -Label "aufgabe_2a" -Path "D:\Seafile\al-cad-20w\1.ABGABEN" -Sub "121.AUFGABE_2a\1219.AUFGABE_2A.ERGEBNISSE" -Expected ".jpg"
New-JtResultsSummary -Label "aufgabe_2b" -Path "D:\Seafile\al-cad-20w\1.ABGABEN" -Sub "122.AUFGABE_2b\1229.AUFGABE_2B.ERGEBNISSE" -Expected ".pdf,.rfa"
New-JtResultsSummary -Label "aufgabe_2c" -Path "D:\Seafile\al-cad-20w\1.ABGABEN" -Sub "123.AUFGABE_2c\1239.AUFGABE_2C.ERGEBNISSE" -Expected ".pdf"
New-JtResultsSummary -Label "aufgabe_3a" -Path "D:\Seafile\al-cad-20w\1.ABGABEN" -Sub "131.AUFGABE_3a\1319.AUFGABE_3A.ERGEBNISSE" -Expected ".pdf"
New-JtResultsSummary -Label "aufgabe_3b" -Path "D:\Seafile\al-cad-20w\1.ABGABEN" -Sub "132.AUFGABE_3b\1329.AUFGABE_3B.ERGEBNISSE" -Expected ".pdf,.rvt"
New-JtResultsSummary -Label "aufgabe_3c" -Path "D:\Seafile\al-cad-20w\1.ABGABEN" -Sub "133.AUFGABE_3c\1339.AUFGABE_3C.ERGEBNISSE" -Expected ".pdf,.rvt"
New-JtResultsSummary -Label "aufgabe_4a" -Path "D:\Seafile\al-cad-20w\1.ABGABEN" -Sub "141.AUFGABE_4a\1419.AUFGABE_4A.ERGEBNISSE" -Expected ".pdf,.rvt"
New-JtResultsSummary -Label "aufgabe_4b" -Path "D:\Seafile\al-cad-20w\1.ABGABEN" -Sub "142.AUFGABE_4b\1429.AUFGABE_4B.ERGEBNISSE" -Expected ".pdf,.rvt"
New-JtResultsSummary -Label "aufgabe_4c" -Path "D:\Seafile\al-cad-20w\1.ABGABEN" -Sub "143.AUFGABE_4c\1439.AUFGABE_4C.ERGEBNISSE" -Expected ".pdf,.rvt"




