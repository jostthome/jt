Function Get-JtFolderPath_Example {
    [String]$MyFolderPath_Test = "%OneDrive%\jt\1.EXAMPLE"
    return $MyFolderPath_Test 
}

Function Get-JtFolderPath_Index_Anzahl {
    [String]$MyFolderPath_Test = "%OneDrive%\jt\1.EXAMPLE\11.DATA.ANZAHL\MU.STE.BEISPIEL1.Anzahl.Rechnung1"
    return $MyFolderPath_Test 
}

Function Get-JtFolderPath_Index_Betrag {
    [String]$MyFolderPath_Test = "%OneDrive%\jt\1.EXAMPLE\12.DATA.BETRAG\MU.STE.BEISPIEL1.TEST.Rechnung.jahr.betrag"
    return $MyFolderPath_Test 
}

Function Get-JtFolderPath_Index_BxH {
    [String]$MyFolderPath_Test = "%OneDrive%\jt\1.EXAMPLE\13.DATA.BxH\131.BxH.Beispiel1"
    return $MyFolderPath_Test 
}

Function Get-JtFolderPath_Index_Files {
    [String]$MyFolderPath_Test = "%OneDrive%\jt\1.EXAMPLE\12.DATA.BETRAG\MU.STE.BEISPIEL1.TEST.Rechnung.jahr.betrag"
    return $MyFolderPath_Test 
}

Function Get-JtFolderPath_Index_Stunden {
    [String]$MyFolderPath_Test = "%OneDrive%\jt\1.EXAMPLE\15.DATA.STUNDEN\THOME.2020-09.2021-03.20_00.270_00"
    return $MyFolderPath_Test 
}

Function Get-JtFolderPath_Index_Zahlung {
    [String]$MyFolderPath_Test = "%OneDrive%\jt\1.EXAMPLE\16.DATA.MONAT\MU.TES.IMMO.MUSTER.w1_erd.miete.2018.monat"
    return $MyFolderPath_Test 
}


Export-ModuleMember -Function Get-JtFolderPath_Example
Export-ModuleMember -Function Get-JtFolderPath_Index_Anzahl
Export-ModuleMember -Function Get-JtFolderPath_Index_Betrag
Export-ModuleMember -Function Get-JtFolderPath_Index_BxH
Export-ModuleMember -Function Get-JtFolderPath_Index_Files
Export-ModuleMember -Function Get-JtFolderPath_Index_Stunden
Export-ModuleMember -Function Get-JtFolderPath_Index_Zahlung