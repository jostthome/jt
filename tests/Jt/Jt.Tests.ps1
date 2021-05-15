Import-Module Jt
Import-Module JtTbl
Import-Module JtColRen

# Set-StrictMode -Version "2.0"
# $ErrorActionPreference = "Stop"




Describe "Get-JtVersion" {
    It "Returns JtVersion" {
        $version = Get-JtVersion
        $version | Should -Be "2021-05-12"
        
    }
}


Describe "Convert-JtPart_To_DecBetrag" {
    It "Check values" {
        $output = Convert-JtPart_To_DecBetrag -Part "Apples"
        $output | Should -Be 999999
    }
    It "Check values" {
        $output = Convert-JtPart_To_DecBetrag -Part "Apples10"
        $output | Should -Be 999999
    }
    It "Check values" {
        $output = Convert-JtPart_To_DecBetrag -Part "00000"
        $output | Should -Be 999999
    }
    It "Check values" {
        $output = Convert-JtPart_To_DecBetrag -Part "2356323"
        $output | Should -Be 999999
    }
    It "Check values" {
        $output = Convert-JtPart_To_DecBetrag -Part "23563_23"
        $output | Should -Be 23563.23
    }
}

Describe "Test-JtPart_IsValidAs_Betrag" {
    It "Check values" {
        $output = Test-JtPart_IsValidAs_Betrag -Part "Apples"
        $output | Should -BeFalse
    }
    It "Check values" {
        $output = Test-JtPart_IsValidAs_Betrag -Part "Apples10"
        $output | Should -BeFalse
    }
    It "Check values" {
        $output = Test-JtPart_IsValidAs_Betrag -Part "00000"
        $output | Should -BeFalse
    }
    It "Check values" {
        $output = Test-JtPart_IsValidAs_Betrag -Part "2356323"
        $output | Should -BeFalse
    }
    It "Check values" {
        $output = Test-JtPart_IsValidAs_Betrag -Part "23563_23"
        $output | Should -BeTrue
    }
}



Describe "Convert-JtDotter" {
    It "Testing dotter" {
        $MyValue = "_zzz.Das.ist.ein.Testwert.pdf"

        $MyResult = Convert-JtDotter -Text $MyValue -PatternOut "1"
        $MyResult | Should -Be "_zzz"

        $MyResult = Convert-JtDotter -Text $MyValue -PatternOut "1.2"
        $MyResult | Should -Be "_zzz.Das"

        $MyResult = Convert-JtDotter -Text $MyValue -PatternOut "1" -Reverse
        $MyResult | Should -Be "pdf"

        $MyResult = Convert-JtDotter -Text $MyValue -PatternOut "2.1" -Reverse
        $MyResult | Should -Be "Testwert.pdf"

        $MyResult = Convert-JtDotter -Text $MyValue -PatternOut "1.2" -Reverse
        $MyResult | Should -Be "pdf.Testwert"
    }
}


Describe "Convert-JtFilename_To_Jahr" {

    It "Should ... jahr" {
        Convert-JtFilename_To_Jahr -Filename "2012.Hallo Welt" | Should -Be "2012"
        Convert-JtFilename_To_Jahr -Filename "2005-12-23" | Should -Be "2005"
    }
}

Describe "Convert-JtFilename_To_IntAlter" {
    
    It "Should ... alter Test 1" {
        [String]$MyFilename = "2012.Hallo Welt" 
        [Int32]$MyIntYear = 2012
        [Int32]$MyIntShould = (Get-Date).Year - $MyIntYear 
        Convert-JtFilename_To_IntAlter -Filename $MyFilename | Should -Be $MyIntShould
    }
    
    It "Should ... alter Test 2" {
        [String]$MyFilename = "2005-12-23.hallo.label.pdf" 
        [Int32]$MyIntYear = 2005
        [Int32]$MyIntShould = (Get-Date).Year - $MyIntYear 
        Convert-JtFilename_To_IntAlter -Filename $MyFilename | Should -Be $MyIntShould
    }

}


Describe "Convert-JtFilename_To_DecQm" {

    It "Should .... qm" {
        $MyVar = @{
            "halllo"                   = 999
            "mustermann.500x1000.pdf"  = 0.5
            "mustermann.1000x1000.pdf" = 1
            "mustermann.210x297.pdf"   = 0.0624
            "mustermann.297x420.pdf"   = 0.1247
        }   

        ForEach ($Element in $MyVar.Keys) {
            $MyResult = Convert-JtFilename_To_DecQm -Filename $Element
            $MyShould = $MyVar.$Element
            $MyResult | Should -Be $MyShould
        }

    }

}
# Test-Jt




