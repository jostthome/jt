using module JtColRen

New-JtColRen -Label "Label_ColRen" -Header "Header_ColRen"
New-JtColRenInputAnzahl 
New-JtColRenInputArea -Label "Label_ColRenInputArea" -Header "Header_ColRenInputArea"
New-JtColRenInputCurrency -Label "Label_ColRenInputCurrency" 
New-JtColRenInputCurrencyBetrag
New-JtColRenInputCurrencyEuro
New-JtColRenInputCurrencyGesamt
New-JtColRenInputCurrencyPreis
New-JtColRenInputDatum
New-JtColRenInputMonthId
New-JtColRenInputStand 
New-JtColRenInputSum 
New-JtColRenInputText   -Label "Label_ColRenInputText" -Header "Header_ColRenInputText" 
New-JtColRenInputTextNr


Write-Host "---"
$t = [JtColRen]::GetJtColRen("LABEL")
$t
