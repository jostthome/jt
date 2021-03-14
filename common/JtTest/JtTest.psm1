Function Get-JtFolderPath_Index_Anzahl {
    [String]$MyFolderPath_Test = "%OneDrive%\jt\testing\1.EXAMPLE\16.DATA.ANZAHL\MU.STE.BEISPIEL1.Anzahl.Rechnung1"
    return $MyFolderPath_Test 
}

Function Get-JtFolderPath_Index_Betrag {
    [String]$MyFolderPath_Test = "%OneDrive%\jt\testing\1.EXAMPLE\17.DATA.BETRAG\MU.STE.BEISPIEL1.BETRAG.Rechnung1.2018"
    return $MyFolderPath_Test 
}

Function Get-JtFolderPath_Index_BxH {
    [String]$MyFolderPath_Test = "%OneDrive%\jt\testing\1.EXAMPLE\14.DATA.POSTER\141.POSTER.Beispiel1"
    return $MyFolderPath_Test 
}

Function Get-JtFolderPath_Index_Zahlung {
    [String]$MyFolderPath_Test = "%OneDrive%\jt\testing\1.EXAMPLE\15.DATA.ZAHLUNG\MU.STE.IMMO.MUST1.Whg2.Zahlung.2018"
    return $MyFolderPath_Test 
}

Export-ModuleMember -Function Get-JtFolderPath_Index_Anzahl
Export-ModuleMember -Function Get-JtFolderPath_Index_Betrag
Export-ModuleMember -Function Get-JtFolderPath_Index_BxH
Export-ModuleMember -Function Get-JtFolderPath_Index_Zahlung