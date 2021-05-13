using module JtColRen

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"

Function Test-Get_JtColRen {

    Get-JtColRen -Part "_"
    Get-JtColRen -Part "_____DATUM"
    Get-JtColRen -Part "__MONAT"
    Get-JtColRen -Part "_ART"
    Get-JtColRen -Part "_DATUM"
    Get-JtColRen -Part "_DOKUMENT"
    Get-JtColRen -Part "_LABEL"
    Get-JtColRen -Part "_W"
    Get-JtColRen -Part "ABRECHNUNG"
    Get-JtColRen -Part "ART"
    Get-JtColRen -Part "BEGINN"
    Get-JtColRen -Part "BETRAG"
    Get-JtColRen -Part "BUCHUNG"
    Get-JtColRen -Part "DETAIL"
    Get-JtColRen -Part "ESSEN"
    Get-JtColRen -Part "folder"
    Get-JtColRen -Part "JAHR"
    Get-JtColRen -Part "KAT"
    Get-JtColRen -Part "KONTO"
    Get-JtColRen -Part "LABEL"
    Get-JtColRen -Part "LITER"
    Get-JtColRen -Part "MIETER"
    Get-JtColRen -Part "OBJEKT"
    Get-JtColRen -Part "OBJEKt"
    Get-JtColRen -Part "SOLL"
    Get-JtColRen -Part "STAND"
    Get-JtColRen -Part "THEMA"
    Get-JtColRen -Part "UHR"
    Get-JtColRen -Part "UHRZEIT"
    Get-JtColRen -Part "VEREIN"
    Get-JtColRen -Part "VORAUS"
    Get-JtColRen -Part "WAS"
    Get-JtColRen -Part "WER"
    Get-JtColRen -Part "WHG"
    Get-JtColRen -Part "WO"
    Get-JtColRen -Part "WOHNUNG"
    Get-JtColRen -Part "ZAEHLER"
    Get-JtColRen -Part "ZAHLUNG"
}

Test-Get_JtColRen

Return

Function Test-JtColRen {

    New-JtColRenInput_Betrag -Label "Label_ColRenInputCurrency" 
    New-JtColRenInput_Betrag
    New-JtColRenInput_Datum
    New-JtColRenInput_Stand 
    New-JtColRenInput_Sum 
    New-JtColRenInput_Text   -Label "Label_ColRenInputText" -Header "Header_ColRenInputText" 
    New-JtColRenInput_TextNr
    
    Write-Host "---"
    $t = Get-JtColRen -Part "LABEL"
    $t
    
}

Test-JtColRen


Function Test-JtPreisliste {

    $MyJtPreisliste = New-JtPreisliste_Plotten_2022_01_01
    $MyJtPreisliste = New-JtPreisliste_Plotten_2020_07_01
    
    $MyJtPreisliste.GetDecBasePrice_Paper("90g")
    $MyJtPreisliste.GetDecBasePrice_Ink("90g")
    
    $MyJtPreisliste

}


Test-JtPreisliste