Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"


Function Test-JtFolder_Csv_Files {
    [String]$MyFolderPath_Test = Get-JtFolderPath_Index_Anzahl
    Convert-JtFolderPath_To_Csv_FileList -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
    
    [String]$MyFolderPath_Test = Get-JtFolderPath_Index_BxH
    Convert-JtFolderPath_To_Csv_FileList -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
}
Test-JtFolder_Csv_Files


Function Test-JtFolder_Csv_Files_Alter {
    [String]$MyFolderPath_Test = Get-JtFolderPath_Index_Anzahl
    Convert-JtFolderPath_To_Csv_FileList_Alter -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
    
    [String]$MyFolderPath_Test = "%OneDrive%\jt\testing\1.EXAMPLE\11.DATA\111.XXX.JAHR.Anzahl_Rechnung1"
    Convert-JtFolderPath_To_Csv_FileList_Alter -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
}
Test-JtFolder_Csv_Files_Alter



Function Test-JtFolder_Anzahl {
    [String]$MyFolderPath_Test = Get-JtFolderPath_Index_Anzahl
    # New-JtFolder_Anzahl_Md -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
    Convert-JtFolderPath_To_Meta_Anzahl -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
    # New-JtIndex_Anzahl -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
}
Test-JtFolder_Anzahl
Function Test-JtFolder_Betrag {
    [String]$MyFolderPath_Test = Get-JtFolderPath_Index_Betrag
    # New-JtFolder_Betrag_Md -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
    Convert-JtFolderPath_To_Meta_Betrag -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
    # New-JtIndex_Betrag -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
}
Test-JtFolder_Betrag


Function Test-JtFolder_BxH {
    [String]$MyFolderPath_Test = Get-JtFolderPath_Index_BxH
    
    # Convert-JtFolderPath_To_Csv_FileList -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
    Convert-JtFolderPath_To_Md_BxH -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
    Convert-JtFolderPath_To_Meta_BxH -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
    #    New-JtIndex_BxH -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
}
Test-JtFolder_BxH


Function Test-JtFolder_Zahlung {
    [String]$MyFolderPath_Test = Get-JtFolderPath_Index_Zahlung
    # Convert-JtFolderPath_To_Csv_FileList -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
    Convert-JtFolderPath_To_Md_Zahlung -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
    Convert-JtFolderPath_To_Meta_Zahlung -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
    # New-JtIndex_Zahlung -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
}
Test-JtFolder_Zahlung


