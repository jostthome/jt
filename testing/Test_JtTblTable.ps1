using module JtTbl
using module JtMd

using module JtCsv

Clear-Host

Set-StrictMode -version latest
$ErrorActionPreference = "Stop"

[JtTblTable]$JtTblTable = New-JtTblTable -Label "Test1"
        
[JtTblRow]$JtTblRow = New-JtTblRow


[JtField]$JtField = New-JtField -Label "Field11" -Value "Value11"
$JtTblRow.Add($JtField)

[JtField]$JtField = New-JtField -Label "Field12" -Value "Value12ab"
$JtTblRow.Add($JtField)

[JtField]$JtField = New-JtField -Label "Field13" -Value "Value13abc"
$JtTblRow.Add($JtField)

Write-Host "col0"
$JtTblRow.GetValueFromColumnByNumber(0)
Write-Host "col1"
$JtTblRow.GetValueFromColumnByNumber(1)
Write-Host "col2"
$JtTblRow.GetValueFromColumnByNumber(2)

$JtTblTable.AddRow($JtTblRow)


[JtTblRow]$JtTblRow = New-JtTblRow

[JtField]$JtField = New-JtField -Label "Field11" -Value "Value21"
$JtTblRow.Add($JtField)

[JtField]$JtField = New-JtField -Label "Field12" -Value "Value22"
$JtTblRow.Add($JtField)

[JtField]$JtField = New-JtField -Label "Field13" -Value "Value23"
$JtTblRow.Add($JtField)

$JtTblTable.AddRow($JtTblRow)


[JtTblRow]$JtTblRow = New-JtTblRow

[JtField]$JtField = New-JtField -Label "Field11" -Value "Value31"
$JtTblRow.Add($JtField)

[JtField]$JtField = New-JtField -Label "Field12" -Value "Value32"
$JtTblRow.Add($JtField)

[JtField]$JtField = New-JtField -Label "Field13" -Value "Value33"
$JtTblRow.Add($JtField)

$JtTblTable.AddRow($JtTblRow)


# [MdTable]$MdTable = [MdTable]::new($JtTblTable)
# $MdTable.GetOutput()

Write-Host "Hallo 2222"

# [System.Data.DataTable]$dat = Get-DataTableFromTable -Tbl $JtTblTable


$D2 = Get-JtDataTableFromTable -JtTblTable $JtTblTable
$D2



[JtIoFolder]$OutputFolder = New-JtIoFolder -Path "c:\temp"
New-JtCsvWriteData -Label "hallo" -JtIoFolder $OutputFolder -DataTable $D2




