Function Get-JtFolderPath_Index_Anzahl {
    [String]$MyFolderPath_Test = "%OneDrive%\jt\1.EXAMPLE\16.DATA.ANZAHL\MU.STE.BEISPIEL1.Anzahl.Rechnung1"
    return $MyFolderPath_Test 
}

Function Get-JtFolderPath_Index_Betrag {
    [String]$MyFolderPath_Test = "%OneDrive%\jt\1.EXAMPLE\17.DATA.BETRAG\MU.STE.BEISPIEL1.BETRAG.Rechnung1.2018"
    return $MyFolderPath_Test 
}

Function Get-JtFolderPath_Index_BxH {
    [String]$MyFolderPath_Test = "%OneDrive%\jt\1.EXAMPLE\14.DATA.POSTER\141.POSTER.Beispiel1"
    return $MyFolderPath_Test 
}
Function Get-JtFolderPath_Index_Stunden {
    [String]$MyFolderPath_Test = "%OneDrive%\jt\1.EXAMPLE\18.DATA.STUNDEN\THOME.2020-09.2021-03.20_00.270_00"
    return $MyFolderPath_Test 
}

Function Get-JtFolderPath_Index_Zahlung {
    [String]$MyFolderPath_Test = "%OneDrive%\jt\1.EXAMPLE\15.DATA.ZAHLUNG\MU.STE.IMMO.MUST1.Whg2.Zahlung.2018"
    return $MyFolderPath_Test 
}


Export-ModuleMember -Function Get-JtFolderPath_Index_Anzahl
Export-ModuleMember -Function Get-JtFolderPath_Index_Betrag
Export-ModuleMember -Function Get-JtFolderPath_Index_BxH
Export-ModuleMember -Function Get-JtFolderPath_Index_Stunden
Export-ModuleMember -Function Get-JtFolderPath_Index_Zahlung