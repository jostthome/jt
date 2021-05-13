Import-Module Jt
Import-Module JtTbl
Import-Module JtColRen

# Set-StrictMode -Version "2.0"
# $ErrorActionPreference = "Stop"



Describe 'Basic Pester Tests' {
    It 'A test that should be true' {
        $False | Should -Be $true
    }
}




Describe "Get-JtVersion" {
    Context "Basic testing" {
        It "Returns JtVersion" {
            $version = Get-JtVersion
            $version | Should -Be "2021-04-27"
        
        }
    }
}


Describe "Test-JtPart_IsValidAs_Betrag" {
    Context "Basic testing" {
        It "Check values" {
            $output = Test-JtPart_IsValidAs_Betrag -Part "Apples"
            $output | Should -Be "0,00"
        }
        It "Check values" {
            $output = Test-JtPart_IsValidAs_Betrag -Part "Apples10"
            $output | Should -Be "0,00"
        }
        It "Check values" {
            $output = Test-JtPart_IsValidAs_Betrag -Part "00000"
            $output | Should -Be "0,00"
        }
        It "Check values" {
            $output = Test-JtPart_IsValidAs_Betrag -Part "2356323"
            $output | Should -Be "0,00"
        }
        It "Check values" {
            $output = Test-JtPart_IsValidAs_Betrag -Part "23563_23"
            $output | Should -Be "23563,23"
        }
    }
}

Return 












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

# $Computers = @("1", "2", "3")
# $Os = $Computers | Get-JtInfo 




Describe "Convert-JtDotter" {
    Context "Basic testing" {
        It "Testing dotter" {
            $MyValue = "_zzz.Das.ist.ein.Testwert.pdf"

            $MyResult = Convert-JtDotter -Text $MyValue -PatternOut "1.2"
            $MyResult | Should -Be "_zzz"
            $MyResult = Convert-JtDotter -Text $MyValue -PatternOut "1.2" -Reverse
            $MyResult | Should -Be "pdf"
        }
    }
}


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
# Test-Jt




