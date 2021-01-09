using module JtClass
using module JtIo
using module JtUtil
using module JtPreisliste

class JtColRen : JtClass {

    [String]$Label = ""
    [String]$Header = ""

    static [JtColRen]GetJtColRen([String]$Part) {
        [JtColRen]$JtColRen = New-JtColRenInputText -Label $Part
        if ($Part.ToLower() -eq "preis") {
            $JtColRen = New-JtColRenInputCurrencyPreis
        }
        elseif ($Part.ToLower() -eq "_____datum") {
            $JtColRen = New-JtColRenInputDatum 
        }
        elseif ($Part.ToLower() -eq "breitexhoehe") {
            $JtColRen = New-JtColRenInputText -Label "B x H"
        } 
        elseif ($Part.ToLower() -eq "_nachname") {
            $JtColRen = New-JtColRenInputText -Label "NACHNAME"
        } 
        elseif ($Part.ToLower() -eq "bxh") {
            $JtColRen = New-JtColRenInputText -Label "bxh" -Header "B x H"
        }         
        elseif ($Part.ToLower() -eq "anzahl") {
            $JtColRen = New-JtColRenInputAnzahl 
        }
        elseif ($Part.ToLower() -eq "betrag") {
            $JtColRen = New-JtColRenInputCurrencyBetrag
        }
        elseif ($Part.ToLower() -eq "gesamt") {
            $JtColRen = New-JtColRenInputCurrency -Label "GESAMT"
        }
        elseif ($Part.ToLower() -eq "miete") {
            $JtColRen = New-JtColRenInputCurrency -Label "MIETE"
        }
        elseif ($Part.ToLower() -eq "nebenkosten") {
            $JtColRen = New-JtColRenInputCurrency -Label "NEBENKOSTEN"
        }
        elseif ($Part.ToLower() -eq "stand") {
            $JtColRen = New-JtColRenInputStand
        }
        elseif ($Part.ToLower() -eq "euro") {
            $JtColRen = New-JtColRenInputCurrencyEuro
        }
        elseif ($Part.ToLower() -eq "0000-00") {
            $JtColRen = New-JtColRenInputMonthId
        }
        return $JtColRen
    }

    static [String]GetOutput_Betrag([String]$Value) {
        [String]$Result = $Value

        $Result = $Result.Replace("_", "")
        $Result = $Result.Replace(".", "")
        $Result = $Result.Replace(",", "")

        try {
            [Int32]$Inti = [Decimal]$Result
            [Decimal]$Decimal = $Inti / 100
            [String]$Result = $Decimal.ToString("N2")
        }
        catch {
            Write-JtError -Text ( -join ("GetOutput_Betrag; Convert problem. Value:", $Value))
            return [String]"0,00".ToString()
        }
        return $Result
    }

    JtColRen([String]$MyLabel) {
        $This.ClassName = "JtColRen"
        $This.Label = $MyLabel
        $This.Header = $MyLabel
    }

    JtColRen([String]$MyLabel, [String]$MyHeader) {
        $This.ClassName = "JtColRen"
        $This.Label = $MyLabel
        $This.Header = $MyHeader
        if ($Null -eq $MyHeader) {
            $This.Header = $MyLabel
        }
    }

    [Boolean]CheckValid([String]$Value) {
        return $True
    }


    [String]GetHeader() {
        return $This.Header
    }

    [String]GetLabel() {
        return $This.Label
    }

    [String]GetName() {
        return $This.ClassName
    }

    [String]GetOutput([String]$MyValue) {
        return $MyValue
    }


    
    [Boolean]IsEqual([JtColRen]$JtColRen) {
        [Boolean]$Result = $false
        $TheLabel = $JtColRen.GetLabel()
        if ($TheLabel.Equals($This.GetLabel())) {
            return $True
        }
        else {
            return $Result
        }
    }

    [Boolean]IsSummable() {
        return $False
    }
}

class JtColRenFileDim : JtColRen {

    JtColRenFileDim() : base("DIM")  {
        $This.ClassName = "JtColRenFileDim"
    }


    [String]GetOutput([String]$Path) {
        [JtIoFile]$JtIoFile = New-JTIoFile -Path $Path

        [String]$Result = $JtIoFile.GetInfoFromFileName_Dim()
        return $Result
    }

    [Boolean]IsSummable() {
        return $True
    }
}


Function New-JtColRenFileDim {
    
    [JtColRenFileDim]::new()
}

































class JtColRenFileAge : JtColRen {

    JtColRenFileAge() : Base("ALTER") {
        $This.ClassName = "JtColRenFileAge"
    }

    [String]GetOutput([String]$Path) {
        [JtIoFile]$JtIoFile = New-JTIoFile -Path $Path
        [String]$Result = $JtIoFile.GetInfoFromFileName_Age()
        return $Result
    }

    [Boolean]IsSummable() {
        return $False
    }
}


Function New-JtColRenFileAge {
    

    [JtColRenFileAge]::new()
}


class JtColRenFileAnzahl : JtColRen {

    JtColRenFileAnzahl() : Base("ANZAHL")  {
        $This.ClassName = "JtColRenFileAnzahl"
    }

    [String]GetOutput([String]$Path) {
        [JtIoFile]$JtIoFile = New-JTIoFile -Path $Path
        [String]$Result = $JtIoFile.GetInfoFromFileName_Count()
        return $Result
    }

    [Boolean]IsSummable() {
        return $False
    }

}

Function New-JtColRenFileAnzahl {

    [JtColRenFileAnzahl]::new()
}


class JtColRenFileArea : JtColRen {

    
    JtColRenFileArea() : base("DIM") {
        $This.ClassName = "JtColRenFileArea"
    }

    [String]GetOutput([String]$Path) {
        [JtIoFile]$JtIoFile = New-JTIoFile -Path $Path
        [String]$FileName = $JtIoFile.GetName()

        [String]$Result = ConvertTo-JtFileNameToArea $FileName
        return $Result
    }

    [Boolean]IsSummable() {
        return $False
    }
}

Function New-JtColRenFileArea {
    [JtColRenFileArea]::new()
}



class JtColRenFileEuro : JtColRen {


    JtColRenFileEuro() : Base("EURO") {
        $This.ClassName = "JtColRenFileEuro"
    }


    [String]GetOutput([String]$Path) {
        [JtIoFile]$JtIoFile = New-JTIoFile -Path $Path
        [String]$Result = $JtIoFile.GetInfoFromFileName_Euro()
        return $Result
    }

    [Boolean]IsSummable() {
        return $True
    }

}

Function New-JtColRenFileEuro {
    
    [JtColRenFileEuro]::new()
}

class JtColRenFileName : JtColRen {

    JtColRenFileName() : base ("FILE") {
        $This.ClassName = "JtColRenFileName"
    }


    [String]GetOutput([String]$Path) {
        [JtIoFile]$JtIoFile = New-JTIoFile -Path $Path
        [String]$Result = $JtIoFile.GetName()
        return $Result
    }

    [Boolean]IsSummable() {
        return $False
    }
}

Function New-JtColRenFileName {
    
    [JtColRenFileName]::new()
}




class JtColRenFilePath : JtColRen {

    JtColRenFilePath() : base ("PATH") {
        $This.ClassName = "JtColRenFilePath"
    }

    [String]GetOutput([String]$Path) {
        [JtIoFile]$JtIoFile = New-JTIoFile -Path $Path
        [String]$Result = $JtIoFile.GetPath()
        return $Result
    }

    [Boolean]IsSummable() {
        return $False
    }
}


Function New-JtColRenFilePath {
    
    [JtColRenFilePath]::new()
}



class JtColRenFileJtPreisliste : JtColRen {

    [JtPreisliste]$JtPreisliste
    
    JtColRenFileJtPreisliste([JtPreisliste]$MyJtPreisliste, [String]$Label) : Base($Label)  {
        # Label = "PREISE"
        $This.ClassName = "JtColRenFileJtPreisliste"
        $This.JtPreisliste = $MyJtPreisliste
    }

    hidden [String]GetPaper([JtIoFile]$JtIoFile) {

        [String]$Paper = $JtIoFile.GetInfoFromFileName_Paper()
        return $Paper
    }

    hidden [String]GetArea([JtIoFile]$JtIoFile) {
        [String]$Filename = $JtIoFile.GetName()
        [String]$Area = ConvertTo-JtFilenameToArea($Filename) 
        return $Area
    }

    [String]GetOutput([String]$Path) {
        [JtIoFile]$JtIoFile = New-JTIoFile -Path $Path
        [String]$Area = $This.GetArea($JtIoFile)
        [String]$Paper = $This.Paper($JtIoFile)

        [String]$GrundpreisPapier = $This.JtPreisliste.GetPapierGrundpreis($Paper)

        [String]$Result = -join($Area, " x ", $GrundpreisPapier)
        return $Result
    }

    [Boolean]IsSummable() {
        return $False
    }

}



Function New-JtColRenFileJtPreisliste {
    
    Param (
        [Parameter(Mandatory=$true)]
        [JtPreisliste]$JtPreisliste
    )

    [JtColRenFileJtPreisliste]::new($JtPreisliste)
}

class JtColRenFileJtPreisliste_Ink : JtColRenFileJtPreisliste {

    JtColRenFileJtPreisliste_Ink([JtPreisliste]$MyJtPreisliste) : Base($MyJtPreisliste, "TINT.") {
        $This.ClassName = "JtColRenFileJtPreisliste_Ink"
    }

    [String]GetOutput([String]$Path) {
        [JtIoFile]$JtIoFile = New-JTIoFile -Path $Path
        [String]$Area = $This.GetArea($JtIoFile)
        [String]$Paper = $This.GetPaper($JtIoFile)

        [String]$PriceInk = $This.JtPreisliste.GetTinteGrundpreis($Paper)

        [Decimal]$DecArea = ConvertTo-JtStringToDecimal $Area
        [Decimal]$DecPriceInk = ConvertTo-JtStringToDecimal $PriceInk

        [Decimal]$DecResult = ($DecArea * $DecPriceInk)
        
        [String]$Result = ConvertTo-JtDecimalToString2 $DecResult
        return $Result
    }

    [Boolean]IsSummable() {
        return $False
    }
}



Function New-JtColRenFileJtPreisliste_Ink {
    
    Param (
        [Parameter(Mandatory=$true)]
        [JtPreisliste]$JtPreisliste
    )

    [JtColRenFileJtPreisliste_Ink]::new($JtPreisliste)
}


class JtColRenFileJtPreisliste_Paper : JtColRenFileJtPreisliste {
    
    JtColRenFileJtPreisliste_Paper([JtPreisliste]$MyJtPreisliste) : Base($MyJtPreisliste, "PAP.") {
        $This.ClassName = "JtColRenFileJtPreisliste_Paper"
    }

    [String]GetOutput([String]$Path) {
        [JtIoFile]$JtIoFile = New-JTIoFile -Path $Path
        [String]$Area = $This.GetArea($JtIoFile)
        [String]$Paper = $This.GetPaper($JtIoFile)

        [String]$PricePaper = $This.JtPreisliste.GetPapierGrundpreis($Paper)

        [Decimal]$DecArea = ConvertTo-JtStringToDecimal $Area
        [Decimal]$DecPricePaper = ConvertTo-JtStringToDecimal $PricePaper

        [Decimal]$DecResult = $DecPricePaper * $DecArea

        # [String]$Result = -join($Area, " x ", $Price, " = ", ($DecPrice * $DecArea))

        [String]$Result = ConvertTo-JtDecimalToString2 $DecResult
        return $Result
    }

    [Boolean]IsSummable() {
        return $False
    }

}


Function New-JtColRenFileJtPreisliste_Paper {
    
    Param (
        [Parameter(Mandatory=$true)]
        [JtPreisliste]$JtPreisliste
    )

    [JtColRenFileJtPreisliste_Paper]::new($JtPreisliste)
}


class JtColRenFileJtPreisliste_Price : JtColRenFileJtPreisliste {
    
    JtColRenFileJtPreisliste_Price([JtPreisliste]$MyJtPreisliste) : Base($MyJtPreisliste, "PREIS") {
        $This.ClassName = "JtColRenFileJtPreisliste_Price"
    }

    [String]GetOutput([String]$Path) {
        [JtIoFile]$JtIoFile = New-JTIoFile -Path $Path
        [String]$Area = $This.GetArea($JtIoFile)
        [String]$Paper = $This.GetPaper($JtIoFile)

        [String]$PricePaper = $This.JtPreisliste.GetPapierGrundpreis($Paper)
        [String]$PriceInk = $This.JtPreisliste.GetTinteGrundpreis($Paper)

        [Decimal]$DecArea = ConvertTo-JtStringToDecimal $Area
        [Decimal]$DecPricePaper = ConvertTo-JtStringToDecimal $PricePaper
        [Decimal]$DecPriceInk = ConvertTo-JtStringToDecimal $PriceINk
      
        [Decimal]$DecResult = ($DecArea * $DecPriceInk) + ($DecArea * $DecPricePaper)
        
        [String]$Result = ConvertTo-JtDecimalToString2 $DecResult
        return $Result
    }
    
    [Boolean]IsSummable() {
        return $False
    }
}


Function New-JtColRenFileJtPreisliste_Price {
    
    Param (
        [Parameter(Mandatory=$true)]
        [JtPreisliste]$JtPreisliste
    )

    [JtColRenFileJtPreisliste_Price]::new($JtPreisliste)
}



class JtColRenFileYear : JtColRen {

    JtColRenFileYear() : Base("JAHR")  {
        $This.ClassName = "JtColRenFileYear"
    }


    [String]GetOutput([String]$Path) {
        [JtIoFile]$JtIoFile = New-JTIoFile -Path $Path
        [String]$Result = $JtIoFile.GetInfoFromFilename_Year()
        return $Result
    }

    [Boolean]IsSummable() {
        return $False
    }
}


Function New-JtColRenFileYear {
    
    [JtColRenFileYear]::new()
}







class JtColRenInputAnzahl : JtColRen {
    
    
    JtColRenInputAnzahl() : Base() {
        $This.Label = "Anzahl"
        $This.Header = "Anzahl"
    }
    
    [Boolean]IsSummable() {
        return $True
    }


    [String]GetOutput([String]$Value) {
        [String]$Result = $Value
        return $Result
    }
}


Function New-JtColRenInputAnzahl {

    [JtColRenInputText]::new("Anzahl", "Anzahl")
}


class JtColRenInputArea : JtColRen {


    JtColRenInputArea() : Base("BREITExHOEHE") {
        $This.ClassName = "JtColRenInputArea"
    }

    [Boolean]CheckValid([String]$Value) {
        return $True
    }

    [String]GetOutput([String]$Value) {
        return $Value
    }
    

    
    [Boolean]IsSummable() {
        return $False
    }
}

Function New-JtColRenInputArea {

    [JtColRenInputArea]::new()
}




class JtColRenInputCurrency : JtColRen {

    JtColRenInputCurrency([String]$MyLabel) : Base($MyLabel) {
        $This.ClassName = "JtColRenInputCurrency"
    }


    [Boolean]CheckValid([String]$Value) {
        [String]$WithoutUnderscore = $Value.Replace("_", "")
        try {
            [Int32]$IntValue = [Int32]$WithoutUnderscore
        }
        catch {
            Write-JtError -Text ( -join ("Value is not valid (int check). Value:", $Value))
            return $False
        }
        try {
            [String]$MyValue = $Value
            $MyValue = $MyValue.Replace("_", ".")
            [Decimal]$DecValue = [Decimal]$MyValue
        }
        catch {
            Write-JtError -Text ( -join ("Value is not valid (decimal check). Value:", $Value))
            return $False
        }
        try {
            [String]$MyValue = $Value
            $MyValue = $MyValue.Replace("_", ".")
            [Decimal]$DecValue = [Decimal]$MyValue
            [Int32]$IntValue = [Int32]$WithoutUnderscore
            [Decimal]$MyValueThroughInt = $IntValue / 100
            if (0 -ne ($MyValueThroughInt - $DecValue)) {
                Write-JtError -Text ( -join ("Value is not valid (comma check). Value:", $Value))
                return $False
            }
        }
        catch {
            Write-JtError -Text ( -join ("Value is not valid (decimal check). Value:", $Value))
            return $False
        }
        return $True
    }


    [Boolean]DoTest() {
        [Boolean]$TestOk = $True

        [String[]]$TestValues = @('Apples', 'Apples10', '00000', '2356323', '2323_23', '2323.23')
        [String[]]$TestOutputs = @('0,00', '0,00', '0,00', '23.563,23', '2.323,23', '2.323,23')

        for ([Int32]$i = 0; $i -lt $TestValues.Length; $i = $i + 1) {
            [String]$Test = $TestValues[$i]
            [String]$Should = $TestOutputs[$i]
            [String]$Is = $This.GetOutput($Test)

            $Test
            $Should
            $Is
            
            if ($Should -ne $Is) {
                Write-JtError -Text ( -join ("Result is not ok for value. Value:", $Test, " - Should be:", $Should, " - Is:", $Is))
                $TestOk = $False
            }
            else {
                Write-JtLog -Text ( -join ("Result is OK for value. _____ Value:", $Test, " - Should be:", $Should, " - Is:", $Is))
            }
        }
        return $TestOk
    }



    [String]GetOutput([String]$Value) {
        return [JtColRen]::GetOutput_Betrag($Value)
    }


    [Boolean]IsSummable() {
        return $True
    }
}



Function New-JtColRenInputCurrency {

    Param (
        [Parameter(Mandatory = $true)]
        [String]$Label
    )

    [JtColRenInputCurrency]::new($Label)
}

Function New-JtColRenInputCurrencyBetrag {
    New-JtColRenInputCurrency -Label "BETRAG"
}



Function New-JtColRenInputCurrencyEuro {

    [JtColRenInputCurrency]::new("EURO")
}

Function New-JtColRenInputCurrencyPreis {

    [JtColRenInputCurrency]::new("PREIS")
}

Function New-JtColRenInputCurrencyGesamt {

    [JtColRenInputCurrency]::new("GESAMT")
}



class JtColRenInputDatum : JtColRen {

    JtColRenInputDatum() : Base("Datum") {
        $This.ClassName = "JtColRenInputDatum"
    }

    [Boolean]CheckValid([String]$Value) {
        return $True
    }

    [String]GetOutput([String]$Value) {
        return $Value
    }

    [Boolean]IsSummable() {
        return $False
    }
}


Function New-JtColRenInputDatum {

    [JtColRenInputDatum]::new()
}


class JtColRenInputPrice: JtColRen {

    JtColRenInputPrice([String]$MyLabel) : Base($MyLabel) {
        $This.ClassName = "JtColRenInputPrice"
        $This.Header = "Preis"
    }

    [Boolean]DoTest() {
        [Boolean]$TestOk = $True

        [String[]]$TestValues = @('Apples', 'Apples10', '00000', '2356323', '2323_23', '2323.23')
        [String[]]$TestOutputs = @('0,00', '0,00', '0,00', '23.563,23', '2.323,23', '2.323,23')

        for ([Int32]$i = 0; $i -lt $TestValues.Length; $i = $i + 1) {
            [String]$Test = $TestValues[$i]
            [String]$Should = $TestOutputs[$i]
            [String]$Is = $This.GetOutput($Test)

            $Test
            $Should
            $Is
            
            if ($Should -ne $Is) {
                Write-JtError -Text ( -join ("Result is not ok for value. Value:", $Test, " - Should be:", $Should, " - Is:", $Is))
                $TestOk = $False
            }
            else {
                Write-JtLog -Text ( -join ("Result is OK for value. _____ Value:", $Test, " - Should be:", $Should, " - Is:", $Is))
            }
        }
        return $TestOk
    }

    [String]GetOutput([String]$Value) {
        [String]$Result = $Value

        $Result = $Result.Replace("_", "")
        $Result = $Result.Replace(".", "")
        $Result = $Result.Replace(",", "")

        try {
            [Int32]$Inti = [Decimal]$Result
            # [Decimal]$Decimal = $Inti / 100
            [Decimal]$Decimal = $Inti
            [String]$Result = $Decimal.ToString("N2")
        }
        catch {
            Write-JtError -Text ( -join ("Convert problem. Value:", $Value))
            return [String]"0,00".ToString()
        }
        return $Result
    }

    [Boolean]IsSummable() {
        return $True
    }


}







class JtColRenInputStand : JtColRen {

    JtColRenInputStand() : Base("Stand") {
        $This.ClassName = "JtColRenInputStand"
    }

    [Boolean]CheckValid([String]$Value) {
        [String]$WithoutUnderscore = $Value.Replace("_", "")
        try {
            [Int32]$IntValue = [Int32]$WithoutUnderscore
        }
        catch {
            Write-JtError -Text ( -join ("Value is not valid (int check). Value:", $Value))
            return $False
        }
        try {
            [String]$MyValue = $Value
            $MyValue = $MyValue.Replace("_", ".")
            [Decimal]$DecValue = [Decimal]$MyValue
        }
        catch {
            Write-JtError -Text ( -join ("Value is not valid (decimal check). Value:", $Value))
            return $False
        }
        try {
            [String]$MyValue = $Value
            $MyValue = $MyValue.Replace("_", ".")
            [Decimal]$DecValue = [Decimal]$MyValue
            [Int32]$IntValue = [Int32]$WithoutUnderscore
            [Decimal]$MyValueThroughInt = $IntValue / 1000
            if (0 -ne ($MyValueThroughInt - $DecValue)) {
                Write-JtError -Text ( -join ("Value is not valid (comma check). Value:", $Value))
                return $False
            }

        }
        catch {
            Write-JtError -Text ( -join ("Value is not valid (decimal check). Value:", $Value))
            return $False
        }
        return $True
    }



    [String]GetOutput([String]$Value) {
        [String]$Result = $Value

        $Result = $Result.Replace("_", "")
        $Result = $Result.Replace(".", "")
        $Result = $Result.Replace(",", "")

        try {
            [Int32]$Inti = [Decimal]$Result
            [Decimal]$Decimal = $Inti / 1000
            [String]$Result = $Decimal.ToString("N3")
        }
        catch {
            Write-JtError -Text ( -join ("JtColRenInputStand.GetOutput; Convert problem. Value:", $Value))
            return [String]"0,00".ToString()
        }
        return $Result
    }

    
    [Boolean]DoTest() {
        [Boolean]$TestOk = $True

        [String[]]$TestValues = @('Apples', 'Apples10', '00000', '2356323', '2323_23', '2323.23')
        [String[]]$TestOutputs = @('0,000', '0,000', '0,000', '23.563,230', '2.323,230', '2.323,230')

        for ([Int32]$i = 0; $i -lt $TestValues.Length; $i = $i + 1) {
            [String]$Test = $TestValues[$i]
            [String]$Should = $TestOutputs[$i]
            [String]$Is = $This.GetOutput($Test)

            $Test
            $Should
            $Is
            
            if ($Should -ne $Is) {
                Write-JtError -Text ( -join ("Result is not ok for value. Value:", $Test, " - Should be:", $Should, " - Is:", $Is))
                $TestOk = $False
            }
            else {
                Write-JtLog -Text ( -join ("Result is OK for value. _____ Value:", $Test, " - Should be:", $Should, " - Is:", $Is))
            }
        }
        return $TestOk
    }


    [Boolean]IsSummable() {
        return $True
    }
}


class JtColRenInputSum : JtColRen {
    
    
    JtColRenInputSum() : Base("Summe") {
        $This.ClassName = "JtColRenInputSum"
    }


    [String]GetOutput([String]$Value) {
        [String]$MyDec = ConvertTo-JtDecimalToString2 $Value
        [String]$Result = $MyDec.Replace(",", "_")
        return $Result
    }

    [Boolean]IsSummable() {
        return $False
    }

}


Function New-JtColRenInputSum {
    
    [JtColRenInputSum]::new()
}


class JtColRenInputText : JtColRen {

    [String] hidden $Label

    JtColRenInputText([String]$MyLabel) : Base($MyLabel) {
        $This.ClassName = "JtColRenInputText"
    }

    JtColRenInputText([String]$MyLabel, [String]$MyHeader) : Base($MyLabel, $MyHeader) {
        $This.ClassName = "JtColRenInputText"
    }

    [String]GetOutput([String]$MyValue) {
        return $MyValue
    }

    [Boolean]IsSummable() {
        return $False
    }

}


Function New-JtColRen {
    Param (
        [Parameter(Mandatory = $true)]
        [String]$Label,
        [Parameter(Mandatory = $false)]
        [String]$Header
    )

    [JtColRen]::new($Label, $Header)
}



Function New-JtColRenInputText {
    Param (
        [Parameter(Mandatory = $true)]
        [String]$Label,
        [Parameter(Mandatory = $false)]
        [String]$Header
    )

    [String]$MyHeader = $Label
    if (!($Header)) {
    }
    else {
        $MyHeader = $Header
    }
    [JtColRenInputText]::new($Label, $MyHeader)
}

Function New-JtColRenInputTextNr {

    [JtColRenInputText]::new("NR", "NR")
}

Function New-JtColRenInputMonthId {

    [JtColRenInputText]::new("Monat", "Monat")
}

Function New-JtColRenInputStand {

    [JtColRenInputStand]::new()
}
