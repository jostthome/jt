using module JtColRen

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"

Function Test-JtColRen {

    New-JtColRenInput_Anzahl 
    New-JtColRenInput_Bxh -Label "Label_ColRenInputArea" -Header "Header_ColRenInputArea"
    New-JtColRenInput_Betrag -Label "Label_ColRenInputCurrency" 
    New-JtColRenInput_Betrag
    New-JtColRenInput_Datum
    New-JtColRenInput_MonthId
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