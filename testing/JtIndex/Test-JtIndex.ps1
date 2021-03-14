using module JtIo
using module JtTbl
using module JtTest

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"

Function Test-JtIndex_Zahlung {
    [String]$MyFolderPath_Test = Get-JtFolderPath_Index_Zahlung
    # Convert-JtFolderPath_To_Csv_FileList -FolderPath_Input $MyFolderPath_Test -FileExtensionTemplate $TheExtension
    # New-JtFolder_Zahlung_Abrechung_Md -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
    # Convert-JtFolderPath_To_Meta_Zahlung -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
    New-JtIndex_Zahlung -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 

    # [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $MyFolderPath_Test 
    # Invoke-Item $MyJtIoFolder
}
Test-JtIndex_Zahlung
Return


Function Test-JtIndex_Datatable {
    [String]$MyFolderPath_Test = Get-JtFolderPath_Index_Betrag
    $MyJtTblTable = Convert-JtFolderPath_To_JtTblTable_Files -FolderPath_Input $MyFolderPath_Test 
    $MyDatatable = Convert-JtFolderPath_To_DataTable -JtTblTable $MyJtTblTable 
    $MyDatatable
    
    [String]$MyFolderPath_Test = Get-JtFolderPath_Index_Anzahl
    $MyJtTblTable = Convert-JtFolderPath_To_JtTblTable_Anzahl -FolderPath_Input $MyFolderPath_Test 
    $MyDatatable = Convert-JtFolderPath_To_DataTable -JtTblTable $MyJtTblTable 
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

    # Convert-JtFolderPath_To_Csv_FileList -FolderPath_Input $MyFolderPath_Test -FileExtensionTemplate $TheExtension
    # New-JtFolder_Zahlung_Abrechung_Md -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
    # Convert-JtFolderPath_To_Meta_Zahlung -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
    New-JtIndex_BxH -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
}
Test-JtIndex_BxH

Function Test-JtIndex_Zahlung {
    [String]$MyFolderPath_Test = Get-JtFolderPath_Index_Zahlung
    # Convert-JtFolderPath_To_Csv_FileList -FolderPath_Input $MyFolderPath_Test -FileExtensionTemplate $TheExtension
    # New-JtFolder_Zahlung_Abrechung_Md -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
    # Convert-JtFolderPath_To_Meta_Zahlung -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
    New-JtIndex_Zahlung -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 

    # [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $MyFolderPath_Test 
    # Invoke-Item $MyJtIoFolder
}
Test-JtIndex_Zahlung

