using module JtIo
using module JtTbl
using module JtTest

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"

# Convert-JtFolderPath_To_Decimal_Betrag_BxH -FolderPath_Input C:\Users\jostt\OneDrive\jt\testing\1.EXAMPLE\14.DATA.POSTER\141.POSTER.Beispiel1

Function Test-JtIndex_Datatable {
    [String]$MyFolderPath_Test = Get-JtFolderPath_Index_Betrag
    $MyJtTblTable = Convert-JtFolderPath_To_JtTblTable_Files -FolderPath_Input $MyFolderPath_Test 
    $MyDatatable = Convert-JtTblTable_To_DataTable -JtTblTable $MyJtTblTable 
    $MyDatatable

    [String]$MyFolderPath_Test = Get-JtFolderPath_Index_Anzahl
    $MyJtTblTable = Convert-JtFolderPath_To_JtTblTable_Anzahl -FolderPath_Input $MyFolderPath_Test 
    $MyDatatable = Convert-JtTblTable_To_DataTable -JtTblTable $MyJtTblTable 
    $MyDatatable
    
    [String]$MyFolderPath_Test = Get-JtFolderPath_Index_BxH
    $MyJtTblTable = Convert-JtFolderPath_To_JtTblTable_BxH -FolderPath_Input $MyFolderPath_Test 
    $MyDatatable = Convert-JtTblTable_To_DataTable -JtTblTable $MyJtTblTable
    $MyDatatable
    
    [String]$MyFolderPath_Test = Get-JtFolderPath_Index_Zahlung
    $MyJtTblTable = Convert-JtFolderPath_To_JtTblTable_Zahlung -FolderPath_Input $MyFolderPath_Test 
    $MyDatatable = Convert-JtTblTable_To_DataTable -JtTblTable $MyJtTblTable
    $MyDatatable

    Write-Host "Hello world"
}
Test-JtIndex_Datatable

Function Test-JtIndex_Anzahl {
    [String]$MyFolderPath_Test = Get-JtFolderPath_Index_Anzahl
    New-JtIndex_Anzahl -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
}
Test-JtIndex_Anzahl

Function Test-JtIndex_Betrag {
    [String]$MyFolderPath_Test = Get-JtFolderPath_Index_Betrag
    New-JtIndex_Betrag -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
}
Test-JtIndex_Betrag

Function Test-JtIndex_BxH {
    [String]$MyFolderPath_Test = Get-JtFolderPath_Index_BxH
    New-JtIndex_BxH -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
}
Test-JtIndex_BxH

Function Test-JtIndex_Stunden {
    [String]$MyFolderPath_Test = Get-JtFolderPath_Index_Stunden
    New-JtIndex_Stunden -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
}
Test-JtIndex_Stunden

Function Test-JtIndex_Zahlung {
    [String]$MyFolderPath_Test = Get-JtFolderPath_Index_Zahlung
    New-JtIndex_Zahlung -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 

    # [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $MyFolderPath_Test 
    # Invoke-Item $MyJtIoFolder
}
Test-JtIndex_Zahlung

