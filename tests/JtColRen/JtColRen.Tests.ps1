using module JtColRen

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"

Describe "Get-JtColRen" {

    It "Should be ... ColRen" {

        Get-JtColRen -Part "_" | Should -BeOfType JtColRen
        Get-JtColRen -Part "_____DATUM" | Should -BeOfType JtColRen
        Get-JtColRen -Part "__MONAT" | Should -BeOfType JtColRen
        Get-JtColRen -Part "_ART" | Should -BeOfType JtColRen
        Get-JtColRen -Part "_DATUM" | Should -BeOfType JtColRen
        Get-JtColRen -Part "_DOKUMENT" | Should -BeOfType JtColRen
        Get-JtColRen -Part "_LABEL" | Should -BeOfType JtColRen
        Get-JtColRen -Part "_W" | Should -BeOfType JtColRen
        Get-JtColRen -Part "ABRECHNUNG" | Should -BeOfType JtColRen
        Get-JtColRen -Part "ART" | Should -BeOfType JtColRen
        Get-JtColRen -Part "BEGINN" | Should -BeOfType JtColRen
        Get-JtColRen -Part "BETRAG" | Should -BeOfType JtColRen
        Get-JtColRen -Part "BUCHUNG" | Should -BeOfType JtColRen
        Get-JtColRen -Part "DETAIL" | Should -BeOfType JtColRen
        Get-JtColRen -Part "ESSEN" | Should -BeOfType JtColRen
        Get-JtColRen -Part "folder" | Should -BeOfType JtColRen
        Get-JtColRen -Part "JAHR" | Should -BeOfType JtColRen
        Get-JtColRen -Part "KAT" | Should -BeOfType JtColRen
        Get-JtColRen -Part "KONTO" | Should -BeOfType JtColRen
        Get-JtColRen -Part "LABEL" | Should -BeOfType JtColRen
        Get-JtColRen -Part "LITER" | Should -BeOfType JtColRen
        Get-JtColRen -Part "MIETER" | Should -BeOfType JtColRen
        Get-JtColRen -Part "OBJEKT" | Should -BeOfType JtColRen
        Get-JtColRen -Part "OBJEKt" | Should -BeOfType JtColRen
        Get-JtColRen -Part "SOLL" | Should -BeOfType JtColRen
        Get-JtColRen -Part "STAND" | Should -BeOfType JtColRen
        Get-JtColRen -Part "THEMA" | Should -BeOfType JtColRen
        Get-JtColRen -Part "UHR" | Should -BeOfType JtColRen
        Get-JtColRen -Part "UHRZEIT" | Should -BeOfType JtColRen
        Get-JtColRen -Part "VEREIN" | Should -BeOfType JtColRen
        Get-JtColRen -Part "VORAUS" | Should -BeOfType JtColRen
        Get-JtColRen -Part "WAS" | Should -BeOfType JtColRen
        Get-JtColRen -Part "WER" | Should -BeOfType JtColRen
        Get-JtColRen -Part "WHG" | Should -BeOfType JtColRen
        Get-JtColRen -Part "WO" | Should -BeOfType JtColRen
        Get-JtColRen -Part "WOHNUNG" | Should -BeOfType JtColRen
        Get-JtColRen -Part "ZAEHLER" | Should -BeOfType JtColRen
        Get-JtColRen -Part "ZAHLUNG" | Should -BeOfType JtColRen
    }
}
    
Describe "New-JtColRenInput_Betrag" {

    It "Should be ... betrag" {
        New-JtColRenInput_Betrag -Label "Label_ColRenInputCurrency" | Should -BeOfType JtColRen

        New-JtColRenInput_Betrag | Should -BeOfType JtColRen
    }

}

Describe "New-JtColRenInput_Datum" {

    It "Should be ... betrag" {

    New-JtColRenInput_Datum | Should -BeOfType JtColRen
    }
}

Describe "New-JtColRenInput_Stand" {

    It "Should be ... stand" {
        New-JtColRenInput_Stand | Should -BeOfType JtColRen 
    }
}

Describe "New-JtColRenInput_Text" {

    It "Should be ... JtColRen" {

        New-JtColRenInput_Text   -Label "Label_ColRenInputText" -Header "Header_ColRenInputText" | Should -BeOfType JtColRen
    }
}

Describe "New-JtColRenInput_TextNr" {

    It "Should be ... JtColRen" {

        New-JtColRenInput_TextNr | Should -BeOfType JtColRen
    }

}


Describe "New-JtPreisliste_Plotten_2022_01_01" {

    It "Should be ... preis" {
        $MyJtPreisliste = New-JtPreisliste_Plotten_2022_01_01
        $MyJtPreisliste.GetDecBasePrice_Paper("90g") | Should -Be 1.25
        $MyJtPreisliste.GetDecBasePrice_Ink("90g") | Should -Be 7.5
    }
}

Describe "New-JtPreisliste_Plotten_2020_07_01" {
    It "Should be ... preis" {
        $MyJtPreisliste = New-JtPreisliste_Plotten_2020_07_01
        $MyJtPreisliste.GetDecBasePrice_Paper("90g") | Should -Be 1.25
        $MyJtPreisliste.GetDecBasePrice_Ink("90g") | Should -Be 6.5
    }
}