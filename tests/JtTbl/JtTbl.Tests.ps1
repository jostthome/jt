using module JtCsv
using module JtMd
using module JtTbl

Set-StrictMode -version latest
$ErrorActionPreference = "Stop"

Function Test-JtTblTable {

    
    [JtTblTable]$MyJtTblTable = New-JtTblTable -Label "Test1"
    
    [JtTblRow]$MyJtTblRow = New-JtTblRow
    
    
    [JtFld]$MyJtFld = New-JtFld -Label "Field11" -Value "Value11"
    $MyJtTblRow.Add($MyJtFld)
    
    [JtFld]$MyJtFld = New-JtFld -Label "Field12" -Value "Value12ab"
    $MyJtTblRow.Add($MyJtFld)
    
    [JtFld]$MyJtFld = New-JtFld -Label "Field13" -Value "Value13abc"
    $MyJtTblRow.Add($MyJtFld)
    
    Write-Host "col0"
    $MyJtTblRow.GetValueFromColumnByNumber(0)
    Write-Host "col1"
    $MyJtTblRow.GetValueFromColumnByNumber(1)
    Write-Host "col2"
    $MyJtTblRow.GetValueFromColumnByNumber(2)
    
    $MyJtTblTable.AddRow($MyJtTblRow)
    
    
    [JtTblRow]$MyJtTblRow = New-JtTblRow
    
    [JtFld]$MyJtFld = New-JtFld -Label "Field11" -Value "Value21"
    $MyJtTblRow.Add($MyJtFld)
    
    [JtFld]$MyJtFld = New-JtFld -Label "Field12" -Value "Value22"
    $MyJtTblRow.Add($MyJtFld)
    
    [JtFld]$MyJtFld = New-JtFld -Label "Field13" -Value "Value23"
    $MyJtTblRow.Add($MyJtFld)
    
    $MyJtTblTable.AddRow($MyJtTblRow)
    
    
    [JtTblRow]$MyJtTblRow = New-JtTblRow
    
    [JtFld]$MyJtFld = New-JtFld -Label "Field11" -Value "Value31"
    $MyJtTblRow.Add($MyJtFld)
    
    [JtFld]$MyJtFld = New-JtFld -Label "Field12" -Value "Value32"
    $MyJtTblRow.Add($MyJtFld)
    
    [JtFld]$MyJtFld = New-JtFld -Label "Field13" -Value "Value33"
    $MyJtTblRow.Add($MyJtFld)
    
    $MyJtTblTable.AddRow($MyJtTblRow)
    
  
    # [System.Data.DataTable]$dat = Get-DataTableFromTable -Tbl $MyJtTblTable
    
    
    $D2 = Convert-JtTblTable_To_Datatable -JtTblTable $MyJtTblTable
    $D2
    
   
}
    
Test-JtTblTable


    
    