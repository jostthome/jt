﻿using module JtIo

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"

Function Test-JtFilename {

    [String]$MyFolderPath_Input = Get-JtFolderPath_Index_Betrag
    [String]$MyYear = "2018"
    [Decimal]$MyBetrag = 3223.29

    Get-JtLabel_Betrag -Betrag $MyBetrag -FolderPath_Input $MyFolderPath_Input -Name "TESTBETRAG1"
    Get-JtLabel_Betrag -Betrag $MyBetrag -FolderPath_Input $MyFolderPath_Input -Name "TESTBETRAG2"
    Get-JtLabel_Betrag_Miete -Betrag $MyBetrag -FolderPath_Input $MyFolderPath_Input -Year $MyYear
    Get-JtLabel_Betrag_Voraus -Betrag $MyBetrag -FolderPath_Input $MyFolderPath_Input -Year $MyYear
    Get-JtLabel_Betrag_Zahlung -Betrag $MyBetrag -FolderPath_Input $MyFolderPath_Input -Year $MyYear

}

Test-JtFilename
