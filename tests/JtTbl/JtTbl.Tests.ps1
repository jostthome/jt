using module JtCsv
using module JtMd
using module JtTbl

Set-StrictMode -version latest
$ErrorActionPreference = "Stop"

Describe "JtTblTable" {

    It "Should ... JtTblTable" {

        [JtTblTable]$MyJtTblTable = New-JtTblTable -Label "Test1"
        $MyJtTblTable | Should -BeOfType JtTblTable
    }
}


Describe "JtTblRow" {

    It "Should ... JtTblRow" {
        [JtTblRow]$MyJtTblRow = New-JtTblRow
    
        [String]$MyValue1 = "Value11"
        [JtFld]$MyJtFld = New-JtFld -Label "Field11" -Value $MyValue1
        $MyJtTblRow.Add($MyJtFld)
    
    
        [String]$MyValue2 = "Value11"
        [JtFld]$MyJtFld = New-JtFld -Label "Field12" -Value $MyValue2
        $MyJtTblRow.Add($MyJtFld)
        
        [String]$MyValue3 = "Value11"
        [JtFld]$MyJtFld = New-JtFld -Label "Field13" -Value $MyValue3
        $MyJtTblRow.Add($MyJtFld)
        
        
        $MyJtTblRow.GetValueFromColumnByNumber(0) | Should -Be $MyValue1

        $MyJtTblRow.GetValueFromColumnByNumber(1) | Should -Be $MyValue2
        $MyJtTblRow.GetValueFromColumnByNumber(2) | Should -Be $MyValue3
    }
}
    
    
   


    
    