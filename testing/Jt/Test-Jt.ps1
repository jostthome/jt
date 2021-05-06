using module Jt
using module JtTbl
using module JtColRen

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"

Function Get-JtInfo {

    [CmdletBinding()]

    Param(

        [Parameter(Mandatory = $True, ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True)]
        
        [string[]]$computername

        # [string]$logfile = "c:\temp\retries.txt"
    )

    BEGIN {
        # Remove-Item $logfile -erroraction silentlycontinue
    }

    PROCESS {
        $obj = New-Object -typename PSObject

        $obj | Add-Member -membertype NoteProperty -name ComputerName -value ("hallo1") -passthru |
        Add-Member -membertype NoteProperty -name OSVersion -value ("hallo2") -passthru |
        Add-Member -membertype NoteProperty -name OSBuild -value ("hallo3") -passthru |
        Add-Member -membertype NoteProperty -name BIOSSerial -value ("hallo4") -passthru |
        Add-Member -membertype NoteProperty -name SPVersion -value ("hallo5")   

        
        Write-Output $obj
    }
}

$Computers = @("1", "2", "3")
$Os = $Computers | Get-JtInfo 




Function Test-JtVal {

    [String]$MyFunctionName = "Test-JtVal"
    
    [JtTblTable]$MyJtTblTable = New-JtTblTable -Label "Test-JtVal"

    [String]$MyLabelExpected = "expected"
    [String]$MyLabelValue = "value"

    [JtTblRow]$MyJtTblRow = New-JtTblRow
    $MyJtTblRow.Add($MyLabelValue, "0_00")
    $MyJtTblRow.Add($MyLabelExpected, "0,00")
    $MyJtTblTable.AddRow($MyJtTblRow)

    $MyJtTblRow.Add($MyLabelValue, "0_1")
    $MyJtTblRow.Add($MyLabelExpected, "999999")
    $MyJtTblTable.AddRow($MyJtTblRow)


    ForEach ($Obj in $MyJtTblTable.GetObjects()) {
        $MyValue = $Obj.($MyLabelValue)
        $MyExpected = $Obj.($MyLabelExpected)

        $MyResult = Convert-JtPart_To_DecBetrag -Part $MyValue

        if ($MyResult -ne $MyExpected) {
            Write-JtLog_Error -Where $MyFunctionName -Text "MyValue: $MyValue - MyExpected: $MyExpected - MyResult: $MyResult"
            Throw "Error"
        }

    }
}
Test-JtVal


Return






Function Test-JtDotter {

    $MyValue = "_zzz.Das.ist.ein.Testwert.pdf"

    $MyResult = Convert-JtDotter -Text $MyValue -PatternOut "1.2"
    $MyResult
    $MyResult = Convert-JtDotter -Text $MyValue -PatternOut "1.2" -Reverse
    $MyResult
}
Test-JtDotter

Function Test-Jt {
    $MyVar = @{
        "2012.Hallo Welt" = "2012"
        "2005-12-23"      = "2005"
    }    

    ForEach ($Element in $MyVar.Keys) {
        $MyCheck = "Convert-JtFilename_To_Jahr"
        $MyResult = Convert-JtFilename_To_Jahr -Filename $Element
        $MyValue = $MyVar.$Element
        Write-JtLog -Text "MyCheck: $MyCheck ... MyValue: $MyValue ...  MyResult: $MyResult"
    }

    ForEach ($Element in $MyVar.Keys) {
        $MyCheck = "Convert-JtFilename_To_IntAlter"
        $MyResult = Convert-JtFilename_To_IntAlter -Filename $Element
        $MyValue = $MyVar.$Element
        Write-JtLog -Text "MyCheck: $MyCheck ... MyValue: $MyValue ...  MyResult: $MyResult"
    }

    $MyVar = @{
        "halllo"                   = 0
        "mustermann.500x1000.pdf"  = 0.5
        "mustermann.1000x1000.pdf" = 1
        "mustermann.210x297.pdf"   = 0.0625
        "mustermann.297x420.pdf"   = 0.125
    }    

    ForEach ($Element in $MyVar.Keys) {
        $MyCheck = "Convert-JtFilename_To_DecQm"
        $MyResult = Convert-JtFilename_To_DecQm -Filename $Element
        $MyValue = $MyVar.$Element
        Write-JtLog -Text "MyCheck: $MyCheck ... MyValue: $MyValue ...  MyResult: $MyResult"
    }
}
Test-Jt


Function Test-JtValid {
    [String]$MyFunctionName = "Test-JtValid"
    [Boolean]$MyTestOk = $True

    [String[]]$MyTestValues = @('Apples', 'Apples10', '00000', '2356323', '2323_23', '2323.23')
    [String[]]$MyTestOutputs = @('0,00', '0,00', '0,00', '23.563,23', '2.323,23', '2.323,23')

    for ([Int32]$i = 0; $i -lt $MyTestValues.Length; $i = $i + 1) {
        [String]$MyTest = $MyTestValues[$i]
        [String]$MyShould = $MyTestOutputs[$i]

        [JtColRen]$MyJtColRen = New-JtColRenInput_Betrag
        [String]$MyIs = $MyJtColRen.GetOutput($MyTest)
        [Boolean]$MyBlnValid = Test-JtPart_IsValidAs_Betrag -Text $MyTest

        Write-Host "$MyFunctionName"
        Write-Host "Input:      $MyTest"
        Write-Host "MyIs:       $MyIs"
        Write-Host "MyShould:   $MyShould"
        Write-Host "MyBlnValid: $MyBlnValid"
            
        if ($MyShould -ne $MyIs) {
            Write-JtLog_Error -Where $MyFunctionName -Text "Result is not ok for value. Value: $MyTest - Should be: $MyShould - Is: $MyIs"
            $MyTestOk = $False
        }
        else {
            Write-JtLog -Where $MyFunctionName -Text "Result is OK for value. _____ Value: $MyTest - Should be: $MyShould - Is: $MyIs"
        }
    }
    return $MyTestOk
}
Test-JtValid


