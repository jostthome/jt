using module Jt 
using module JtIo

Function Get-JtPreisliste {
    return  New-JtPreisliste_Plotten_2020_07_01
}




class JtColRen : JtClass {

    [String]$Label = ""
    [String]$Header = ""


    JtColRen([String]$TheLabel) {
        $This.ClassName = "JtColRen"
        $This.Label = $TheLabel
        $This.Header = $TheLabel
    }

    JtColRen([String]$TheLabel, [String]$TheHeader) {
        $This.ClassName = "JtColRen"
        $This.Label = $TheLabel
        $This.Header = $TheHeader
        if (!($TheHeader)) {
            $This.Header = $TheLabel
        }
    }

    [Boolean]CheckValid([String]$TheValue) {
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

    [String]GetOutput([String]$TheValue) {
        return $TheValue
    }


    
    [Boolean]IsEqual([JtColRen]$TheJtColRen) {
        [Boolean]$MyResult = $False
        $MyLabel = $TheJtColRen.GetLabel()
        if ($MyLabel.Equals($This.GetLabel())) {
            return $True
        }
        else {
            return $MyResult
        }
    }

    [Boolean]IsSummable() {
        return $False
    }
}

class JtColRenFileDim : JtColRen {

    JtColRenFileDim() : base("DIM") {
        $This.ClassName = "JtColRenFileDim"
    }

    [String]GetOutput([String]$TheFilePath) {
        [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $TheFilePath

        [String]$MyFilename = $MyJtIoFile.GetName()
        [String]$MyResult = Convert-JtFilename_To_Dim -Filename $MyFilename
        return $MyResult
    }

    [Boolean]IsSummable() {
        return $True
    }
}

Function Get-JtColRen {
    
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Name
    )
    
    [String]$MyPart = $Name
    $MyPart = $MyPart.Replace("_", "")
    $MyPart = $MyPart.Replace(" ", "")
    [JtColRen]$MyJtColRen = New-JtColRenInput_Text -Label $MyPart
    if ($MyPart.ToLower() -eq "preis") {
        $MyJtColRen = New-JtColRenInput_CurrencyPreis
    }
    elseif ($MyPart.ToLower() -eq "anzahl") {
        $MyJtColRen = New-JtColRenInput_Anzahl 
    }
    elseif ($MyPart.ToLower() -eq "datum") {
        $MyJtColRen = New-JtColRenInput_Datum 
    }
    elseif ($MyPart.ToLower() -eq "nachname") {
        $MyJtColRen = New-JtColRenInput_Text -Label "NACHNAME"
    } 
    elseif ($MyPart.ToLower() -eq "vorname") {
        $MyJtColRen = New-JtColRenInput_Text -Label "VORNAME"
    } 
    elseif ($MyPart.ToLower() -eq "bxh") {
        $MyJtColRen = New-JtColRenInput_BxH
    }         
    elseif ($MyPart.ToLower() -eq "betrag") {
        $MyJtColRen = New-JtColRenInput_CurrencyBetrag
    }
    elseif ($MyPart.ToLower() -eq "gesamt") {
        $MyJtColRen = New-JtColRenInput_Currency -Label "GESAMT"
    }
    elseif ($MyPart.ToLower() -eq "miete") {
        $MyJtColRen = New-JtColRenInput_Currency -Label "MIETE"
    }
    elseif ($MyPart.ToLower() -eq "org") {
        $MyJtColRen = New-JtColRenInput_Text -Label "ORG"
    } 
    elseif ($MyPart.ToLower() -eq "voraus") {
        $MyJtColRen = New-JtColRenInput_Currency -Label "VORAUS"
    }
    elseif ($MyPart.ToLower() -eq "stand") {
        $MyJtColRen = New-JtColRenInput_Stand
    }
    elseif ($MyPart.ToLower() -eq "euro") {
        $MyJtColRen = New-JtColRenInput_CurrencyEuro
    }
    elseif ($MyPart.ToLower() -eq "0000-00") {
        $MyJtColRen = New-JtColRenInput_MonthId
    }
    elseif ($MyPart.ToLower() -eq "zahlung") {
        $MyJtColRen = New-JtColRenInput_Currency -Label "ZAHLUNG"
    }
    return $MyJtColRen
}

Function New-JtColRenFileDim {
    
    [JtColRenFileDim]::new()
}

class JtColRenFileAge : JtColRen {

    JtColRenFileAge() : Base("ALTER") {
        $This.ClassName = "JtColRenFileAge"
    }

    [String]GetOutput([String]$TheFilePath) {
        [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $TheFilePath
        [String]$MyFilename = $MyJtIoFile.GetName()
        [String]$MyResult = Convert-JtFilename_To_IntAlter -Filename $MyFilename
        return $MyResult
    }

    [Boolean]IsSummable() {
        return $False
    }
}


Function New-JtColRenFileAge {
    [JtColRenFileAge]::new()
}


class JtColRenFileAnzahl : JtColRen {

    JtColRenFileAnzahl() : Base("ANZAHL") {
        $This.ClassName = "JtColRenFileAnzahl"
    }

    [String]GetOutput([String]$TheFilePath) {
        [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $TheFilePath
        [String]$MyFilename = $MyJtIoFile.GetName()
        [String]$MyResult = Convert-JtFilename_To_IntAnzahl -Filename $MyFilename
        return $MyResult
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

    [String]GetOutput([String]$TheFilePath) {
        [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $TheFilePath
        [String]$MyFilename = $MyJtIoFile.GetName()

        [String]$MyResult = Convert-JtFilename_To_DecQm -Filename $MyFilename
        return $MyResult
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

    [String]GetOutput([String]$TheFilePath) {
        [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $TheFilePath
        [String]$MyFilename = $MyJtIoFile.GetName()
        [String]$MyResult = Convert-JtFilename_To_DecBetrag -Filename $MyFilename
        return $MyResult
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

    [String]GetOutput([String]$TheFilePath) {
        [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $TheFilePath
        [String]$MyResult = $MyJtIoFile.GetName()
        return $MyResult
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

    [String]GetOutput([String]$TheFilePath) {
        [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $TheFilePath
        [String]$MyResult = $MyJtIoFile.GetPath()
        return $MyResult
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
    
    JtColRenFileJtPreisliste([JtPreisliste]$TheJtPreisliste, [String]$TheLabel) : Base($TheLabel) {
        # Label = "PREISE"
        $This.ClassName = "JtColRenFileJtPreisliste"
        $This.JtPreisliste = $TheJtPreisliste
    }

    hidden [String]GetPaper([String]$TheFilename) {
        [String]$MyFilename = $TheFilename

        [String]$MyPaper = Convert-JtFilename_To_Papier -Filename $MyFilename
        return $MyPaper
    }

    hidden [Decimal]GetDecArea([String]$TheFilename) {
        [String]$MyFilename = $TheFilename
        
        [Decimal]$MyDecArea = Convert-JtFilename_To_DecQm -Filename $MyFilename
        return $MyDecArea
    }

    [String]GetOutput([String]$TheFilePath) {
        [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $TheFilePath
        [String]$MyFilename = $MyJtIoFile.GetName()

        [Decimal]$MyDecQm = $This.GetDecArea($MyFilename)
        [String]$MyPaper = $This.GetPaper($MyFilename)

        [Decimal]$MyDecBasePrice_Paper = $This.JtPreisliste.GetDecBasePrice_Paper($MyPaper)

        [String]$MyResult = -join ($MyDecQm, " x ", $MyDecBasePrice_Paper)
        return $MyResult
    }

    [Boolean]IsSummable() {
        return $False
    }
}

Function New-JtColRenFileJtPreisliste {
    
    [JtPreisliste]$MyJtPreisliste = Get-JtPreisliste
    [JtColRenFileJtPreisliste]::new($MyJtPreisliste)
}

class JtColRenFileJtPreisliste_Ink : JtColRenFileJtPreisliste {

    JtColRenFileJtPreisliste_Ink([JtPreisliste]$TheJtPreisliste) : Base($TheJtPreisliste, "TINT.") {
        $This.ClassName = "JtColRenFileJtPreisliste_Ink"
    }

    [String]GetOutput([String]$TheFilePath) {
        [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $TheFilePath
        [String]$MyFilename = $MyJtIoFile.GetName()

        [String]$MyPaper = $This.GetPaper($MyFilename)
        [Decimal]$MyDecBasePrice_Ink = $This.JtPreisliste.GetDecBasePrice_Ink($MyPaper)
        [Decimal]$MyDecArea = $This.GetDecArea($MyFilename)

        [Decimal]$MyDecResult = $MyDecArea * $MyDecBasePrice_Ink

        [String]$MyResult = Convert-JtDecimal_To_String2 -Decimal $MyDecResult
        return $MyResult
    }

    [Boolean]IsSummable() {
        return $False
    }
}

Function New-JtColRenFileJtPreisliste_Ink {
    
    [JtPreisliste]$MyJtPreisliste = Get-JtPreisliste
    [JtColRenFileJtPreisliste_Ink]::new($MyJtPreisliste)
}

class JtColRenFileJtPreisliste_Paper : JtColRenFileJtPreisliste {
    
    JtColRenFileJtPreisliste_Paper([JtPreisliste]$TheJtPreisliste) : Base($TheJtPreisliste, "PAP.") {
        $This.ClassName = "JtColRenFileJtPreisliste_Paper"
    }

    [String]GetOutput([String]$TheFilePath) {
        [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $TheFilePath
        [String]$MyFilename = $MyJtIoFile.GetName()

        [String]$MyPaper = $This.GetPaper($MyFilename)
        
        [Decimal]$MyDecArea = $This.GetDecArea($MyFilename)
        [Decimal]$MyDecBasePrice_Paper = $This.JtPreisliste.GetDecBasePrice_Paper($MyPaper)


        [Decimal]$MyDecResult = $MyDecBasePrice_Paper * $MyDecArea

        # [String]$MyResult = -join($Area, " x ", $Price, " = ", ($DecPrice * $DecArea))

        [String]$MyResult = Convert-JtDecimal_To_String2 -Decimal $MyDecResult
        return $MyResult
    }

    [Boolean]IsSummable() {
        return $False
    }
}

Function New-JtColRenFileJtPreisliste_Paper {
    
    [JtPreisliste]$MyJtPreisliste = Get-JtPreisliste
    [JtColRenFileJtPreisliste_Paper]::new($MyJtPreisliste)
}

class JtColRenFileJtPreisliste_Price : JtColRenFileJtPreisliste {
    
    JtColRenFileJtPreisliste_Price([JtPreisliste]$TheJtPreisliste) : Base($TheJtPreisliste, "PREIS") {
        $This.ClassName = "JtColRenFileJtPreisliste_Price"
    }

    [String]GetOutput([String]$TheFilePath) {
        [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $TheFilePath
        [String]$MyFilename = $MyJtIoFile.GetName()

        [String]$MyPaper = $This.GetPaper($MyFilename)
        [Decimal]$MyDecArea = $This.GetDecArea($MyFilename)
        [Decimal]$MyDecBasePrice_Paper = $This.JtPreisliste.GetDecBasePrice_Paper($MyPaper)
        [Decimal]$MyDecBasePrice_Ink = $This.JtPreisliste.GetDecBasePrice_Ink($MyPaper)
        
        Write-JtLog -Where $This.ClassName -Text "MyPaper: $MyPaper - MyDecArea: $MyDecArea - MyDecBasePrice_Paper: $MyDecBasePrice_Paper MyDecBasePrice_Ink: $MyDecBasePrice_Ink"
        [Decimal]$MyDecResult = ($MyDecArea * $MyDecBasePrice_Ink) + ($MyDecArea * $MyDecBasePrice_Paper)
        
        [String]$MyResult = Convert-JtDecimal_To_String2 -Decimal $MyDecResult
        Write-JtLog -Where $This.ClassName -Text "MyDecResult: $MyDecResult - MyResult: $MyResult"
        return $MyResult
    }
    
    [Boolean]IsSummable() {
        return $False
    }
}

Function New-JtColRenFileJtPreisliste_Price {
    
    [JtPreisliste]$MyJtPreisliste = Get-JtPreisliste
    [JtColRenFileJtPreisliste_Price]::new($MyJtPreisliste)
}

class JtColRenFileYear : JtColRen {

    JtColRenFileYear() : Base("JAHR") {
        $This.ClassName = "JtColRenFileYear"
    }

    [String]GetOutput([String]$TheFilePath) {
        [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $TheFilePath
        [String]$MyFilename = $MyJtIoFile.GetName()
        [String]$MyResult = Convert-JtFilename_To_Jahr -Filename $MyFilename
        return $MyResult
    }

    [Boolean]IsSummable() {
        return $False
    }
}

Function New-JtColRenFileYear {
    
    [JtColRenFileYear]::new()
}

class JtColRenInputAnzahl : JtColRen {
    
    JtColRenInputAnzahl() : Base("ANZAHL", "ANZAHL") {
        $This.ClassName = "JtColRenInputAnzahl"
    }

    [String]GetOutput([String]$TheValue) {
        [String]$MyResult = $TheValue
        return $MyResult
    }

    [Boolean]IsSummable() {
        return $True
    }
}


Function New-JtColRenInput_Anzahl {
    [JtColRenInputText]::new("Anzahl", "Anzahl")
}


class JtColRenInput_Bxh : JtColRen {

    JtColRenInput_Bxh() : Base("BxH") {
        $This.ClassName = "JtColRenInput_Bxh"
    }

    [Boolean]CheckValid([String]$TheValue) {
        return $True
    }

    [String]GetOutput([String]$TheValue) {
        return $TheValue
    }

    [Boolean]IsSummable() {
        return $False
    }
}

Function New-JtColRenInput_Bxh {
    [JtColRenInput_Bxh]::new()
}

class JtColRenInputCurrency : JtColRen {

    JtColRenInputCurrency([String]$TheLabel) : Base($TheLabel) {
        $This.ClassName = "JtColRenInputCurrency"
    }

    [Boolean]CheckValid([String]$TheValue) {
        return Test-JtIsValid_Betrag -Text $TheValue
    }

    [String]GetOutput([String]$TheValue) {
        return Convert-JtString_To_Betrag -Text $TheValue
    }

    [Boolean]IsSummable() {
        return $True
    }
}


Function New-JtColRenInput_Currency {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Label
    )

    [JtColRenInputCurrency]::new($Label)
}

Function New-JtColRenInput_CurrencyBetrag {
    New-JtColRenInput_Currency -Label "BETRAG"
}

Function New-JtColRenInput_CurrencyEuro {
    [JtColRenInputCurrency]::new("EURO")
}    

Function New-JtColRenInput_CurrencyGesamt {
    [JtColRenInputCurrency]::new("GESAMT")
}

Function New-JtColRenInput_CurrencyPreis {
    [JtColRenInputCurrency]::new("PREIS")
}    


class JtColRenInputDatum : JtColRen {
    
    JtColRenInputDatum() : Base("DATUM") {
        $This.ClassName = "JtColRenInputDatum"
    }
    
    [Boolean]CheckValid([String]$TheValue) {
        return $True
    }
    
    [String]GetOutput([String]$TheValue) {
        return $TheValue
    }
    
    [Boolean]IsSummable() {
        return $False
    }
}

Function New-JtColRenInput_Datum {
    [JtColRenInputDatum]::new()
}

class JtColRen_Input_Betrag : JtColRen {
    
    JtColRen_Input_Betrag([String]$TheLabel) : Base($TheLabel) {
        $This.ClassName = "JtColRen_Input_Betrag"
        $This.Header = "Preis"
    }
   
    [String]GetOutput([String]$TheValue) {
        [String]$MyResult = $TheValue
        
        $MyResult = $MyResult.Replace("_", "")
        $MyResult = $MyResult.Replace(".", "")
        $MyResult = $MyResult.Replace(",", "")
        
        try {
            [Int32]$MyInti = [Decimal]$MyResult
            # [Decimal]$Decimal = $Inti / 100
            [Decimal]$Decimal = $MyInti
            [String]$MyResult = $Decimal.ToString("N2")
        }
        catch {
            Write-JtLog_Error -Where $This.ClassName -Text "Convert problem. TheValue: $TheValue"
            return [String]"0,00".ToString()
        }
        return $MyResult
    }
    
    [Boolean]IsSummable() {
        return $True
    }
}

class JtColRen_Input_Stand : JtColRen {
    
    JtColRen_Input_Stand() : Base("STAND") {
        $This.ClassName = "JtColRen_Input_Stand"
    }
    
    [Boolean]CheckValid([String]$TheValue) {
        [String]$MyValue = $TheValue
        [String]$MyWithoutUnderscore = $MyValue.Replace("_", "")
        try {
            [Int32]$IntValue = $MyWithoutUnderscore
        }
        catch {
            Write-JtLog_Error -Where $This.ClassName -Text "CheckValid. Value is not valid (int check). MyValue: $MyValue"
            return $False
        }

        try {
            $MyValue = $MyValue.Replace("_", ".")
            [Decimal]$MyDecValue = [Decimal]$MyValue
        }
        catch {
            Write-JtLog_Error -Where $This.ClassName -Text "CheckValid. Value is not valid (decimal check). MyValue: $MyValue"
            return $False
        }

        try {
            $MyValue = $MyValue.Replace("_", ".")
            [Decimal]$MyDecValue = [Decimal]$MyValue
            # [Int32]$MyIntValue = [Int32]$MyWithoutUnderscore
            # [Decimal]$MyValueThroughInt = $MyIntValue / 1000
            # if (0 -ne ($MyValueThroughInt - $MyDecValue)) {
            #     Write-JtLog_Error -Where $This.ClassName -Text "CheckValid. Value is not valid (comma check). MyValue: $MyValue"
            #     return $False
            # }
            
        }
        catch {
            Write-JtLog_Error -Where $This.ClassName -Text "CheckValid. Value is not valid (decimal check). MyValue: $MyValue"
            return $False
        }
        return $True
    }
    
    [String]GetOutput([String]$TheValue) {
        [String]$MyValue = $TheValue
        [String]$MyResult = $MyValue
        return $MyResult
    }
    
    [Boolean]IsSummable() {
        return $True
    }
}


class JtColRenInputSum : JtColRen {
    
    JtColRenInputSum() : Base("SUMME") {
        $This.ClassName = "JtColRenInputSum"
    }
    
    [String]GetOutput([String]$TheValue) {
        [String]$MyValue = $TheValue
        [String]$MyResult = $MyValue
        return $MyResult
    }
    
    [Boolean]IsSummable() {
        return $False
    }
}

Function New-JtColRenInput_MonthId {
    [JtColRenInputText]::new("Monat", "Monat")
}

Function New-JtColRenInput_Sum {
    [JtColRenInputSum]::new()
}

class JtColRenInputText : JtColRen {
    
    [String] hidden $Label
    
    JtColRenInputText([String]$TheLabel) : Base($TheLabel) {
        $This.ClassName = "JtColRenInputText"
    }

    JtColRenInputText([String]$TheLabel, [String]$TheHeader) : Base($TheLabel, $TheHeader) {
        $This.ClassName = "JtColRenInputText"
    }

    [String]GetOutput([String]$TheValue) {
        return $TheValue
    }

    [Boolean]IsSummable() {
        return $False
    }
}

Function New-JtColRen {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Label,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Header
    )

    [String]$MyLabel = $Label
    [String]$MyHeader = $Label
    if ($Header) {
        $MyHeader = $Header
    }

    [JtColRen]::new($MyLabel, $MyHeader)
}

Function New-JtColRenInput_Text {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Label,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Header
    )

    [String]$MyLabel = $Label
    [String]$MyHeader = $Label
    if ($Header) {
        $MyHeader = $Header
    }
    [JtColRenInputText]::new($MyLabel, $MyHeader)
}

Function New-JtColRenInput_TextNr {
    [JtColRenInputText]::new("NR", "NR")
}

Function New-JtColRenInput_Stand {
    [JtColRen_Input_Stand]::new()
}

Function Convert-JtFolderPath_To_JtTblTable_Anzahl {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "Convert-JtFolderPath_To_JtTblTable_Anzahl"

    Write-JtLog -Where $MyFunctionName -Text "Start..."

    [String]$MyFolderPath_Input = $FolderPath_Input
    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input
    [JtTemplateFile]$MyJtTemplateFile = Get-JtTemplateFile -FolderPath_Input $MyFolderPath_Input

    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder_Input -Normal
    [System.Collections.ArrayList]$MyAlJtColRens = $MyJtTemplateFile.GetJtColRens()
    
    if ($Null -eq $MyAlJtColRens) {
        Write-JtLog -Where $MyFunctionName -Text "MyAlJtColRens is NULL. MyJtIoFolder_Input: $MyJtIoFolder_Input"
        return $Null
    }
    
    [JtTblTable]$MyJtTblTable = New-JtTblTable -Label $MyFunctionName
    
    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder_Input -Normal
    foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File
        [String]$MyFilename = $MyJtIoFile.GetName()
        Write-JtLog -Where $MyFunctionName -Text "______FileName: $MyFilename"
    
        $MyFilenameParts = $MyFilename.Split(".")
        [JtTblRow]$MyJtTblRow = New-JtTblRow
        for ([Int32]$j = 0; $j -lt $MyFilenameParts.Count; $j++) {
            [JtColRen]$MyJtColRen = $MyAlJtColRens[$j]
            [String]$MyHeader = $MyJtColRen.GetHeader()
            [String]$MyLabel = $MyJtColRen.GetLabel()
            # $MyDataTable.Columns.Add($MyLabel, "String")
            [String]$MyValue = $MyAlJtColRens[$j].GetOutput($MyFilenameParts[$j])

            $MyJtTblRow.Add($MyLabel, $MyValue)
        }

        [JtColRen]$MyJtColRen = New-JtColRenFileYear
        [String]$MyHeader = $MyJtColRen.GetHeader()
        [String]$MyLabel = $MyJtColRen.GetLabel()
        [String]$MyValue = $MyJtColRen.GetOutput($MyJtIoFile.GetPath())
        $MyJtTblRow.Add($MyLabel, $MyValue)

        [JtColRen]$MyJtColRen = New-JtColRenFileAge
        [String]$MyHeader = $MyJtColRen.GetHeader()
        [String]$MyLabel = $MyJtColRen.GetLabel()
        [String]$MyValue = $MyJtColRen.GetOutput($MyJtIoFile.GetPath())
        $MyJtTblRow.Add($MyLabel, $MyValue)


        $MyJtTblTable.AddRow($MyJtTblRow)
    }
    return , $MyJtTblTable
}



Function Convert-JtFolderPath_To_JtTblTable_BxH {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input
    )

    [String]$MyFunctionName = "Convert-JtFolderPath_To_JtTblTable_BxH"

    Write-JtLog -Where $MyFunctionName -Text "Start..."

    [String]$MyFolderPath_Input = $FolderPath_Input

    [JtTemplateFile]$MyJtTemplateFile = Get-JtTemplateFile -FolderPath $MyFolderPath_Input
    [String]$MyFilename_Template = $MyJtTemplateFile.GetName()
    $MyAlTemplateParts = $MyFilename_Template.Split(".")
   
    [JtTblTable]$MyJtTblTable = New-JtTblTable -Label "JtTblTable_BxH"
    
    [Int32]$MyIntLine = 1
    
    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyFolderPath_Input -Normal
    foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File
        [String]$MyFilename = $MyJtIoFile.GetName()
        [String]$MyPath = $MyJtIoFile.GetPath()
        
        [JtTblRow]$MyJtTblRow = New-JtTblRow 
        
        [JtColRen]$MyJtColRen = New-JtColRenInput_TextNr
        [String]$MyLabel = $MyJtColRen.GetLabel()
        [String]$MyValue = $MyIntLine
        $MyJtTblRow.Add($MyLabel, $MyValue) | Out-NUll
        
        
        [JtColRen]$MyJtColRen = New-JtColRenFileJtPreisliste_Price
        [String]$MyLabel = $MyJtColRen.GetLabel()
        [String]$MyPath = $MyJtIoFile.GetPath()
        [String]$MyValue = $MyJtColRen.GetOutput($MyPath)
        $MyJtTblRow.Add($MyLabel, $MyValue) | Out-NUll
        
        $MyAlFilenameParts = $MyFilename.Split(".")
        for ($IntI = 0; $IntI -lt ($MyAlTemplateParts.Count - 1); $IntI ++) {
            [String]$MyLabel = $MyAlTemplateParts[$IntI]
            $MyLabel = $MyLabel.Replace("_", "")
            [JtColRen]$MyJtColRen = New-JtColRenInput_Text -Label $MyLabel
            [String]$MyValue = $MyAlFilenameParts[$IntI]
            $MyValue = $MyJtColRen.GetOutput($MyValue)
            $MyJtTblRow.Add($MyLabel, $MyValue) | Out-NUll
        }
        
        [JtColRen]$MyJtColRen = New-JtColRenFileArea
        [String]$MyLabel = $MyJtColRen.GetLabel()
        [String]$MyValue = $MyJtColRen.GetOutput($MyPath)
        $MyJtTblRow.Add($MyLabel, $MyValue) | Out-NUll
        
        [JtColRen]$MyJtColRen = New-JtColRenFileJtPreisliste_Paper
        [String]$MyLabel = $MyJtColRen.GetLabel()
        [String]$MyValue = $MyJtColRen.GetOutput($MyPath)
        $MyJtTblRow.Add($MyLabel, $MyValue) | Out-NUll
        
        [JtColRen]$MyJtColRen = New-JtColRenFileJtPreisliste_Ink
        [String]$MyLabel = $MyJtColRen.GetLabel()
        [String]$MyValue = $MyJtColRen.GetOutput($MyPath)
        $MyJtTblRow.Add($MyLabel, $MyValue) | Out-NUll
        
        $MyJtTblTable.AddRow($MyJtTblRow) | Out-Null
        $MyIntLine = $MyIntLine + 1
    }
    
    [JtTblRow]$MyJtTblRow = New-JtTblRow
    
    [JtColRen]$MyJtColRen = New-JtColRenInput_TextNr
    [String]$MyLabel = $MyJtColRen.GetLabel()
    [String]$MyValue = "SUM:"
    $MyJtTblRow.Add($MyLabel, $MyValue) | Out-NUll
    
    [JtColRen]$MyJtColRen = New-JtColRenFileJtPreisliste_Price
    [String]$MyLabel = $MyJtColRen.GetLabel()
    [String]$MyValue = Convert-JtFolderPath_To_Value_Betrag_BxH -FolderPath_Input $MyFolderPath_Input
    $MyJtTblRow.Add($MyLabel, $MyValue) | Out-NUll
    
    [JtColRen]$MyJtColRen = New-JtColRenFileJtPreisliste_Paper
    [String]$MyValue = ""
    [String]$MyLabel = $MyJtColRen.GetLabel()
    $MyJtTblRow.Add($MyLabel, $MyValue) | Out-NUll
    
    [JtColRen]$MyJtColRen = New-JtColRenFileJtPreisliste_Ink
    [String]$MyLabel = $MyJtColRen.GetLabel()
    [String]$MyValue = ""
    $MyJtTblRow.Add($MyLabel, $MyValue) | Out-NUll

    $MyJtTblTable.AddRow($MyJtTblRow) | Out-Null

    return $MyJtTblTable
}

Function Convert-JtFolderPath_To_JtTblTable_Files {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input
    )

    [String]$MyFunctionName = "Convert-JtFolderPath_To_JtTblTable_Files"

    [String]$MyFolderPath_Input = $FolderPath_Input
    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input
    [JtTemplateFile]$MyJtTemplateFile = Get-JtTemplateFile -FolderPath_Input $MyFolderPath_Input
    
    [System.Collections.ArrayList]$MyAlJtColRens = $MyJtTemplateFile.GetJtColRens()
    if (!($MyAlJtColRens)) {
        Write-JtLog -Where $MyFunctionName -Text "MyAlJtColRens is NULL. MyJtIoFolder_Input: $MyJtIoFolder_Input"
        return $Null
    }
    
    [JtTblTable]$MyJtTblTable = New-JtTblTable -Label $MyFunctionName
    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyFolderPath_Input -Normal
    foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File
        [Boolean]$MyBlnFileValid = Test-JtFolder_File -FolderPath_Input $MyJtIoFile

        if ($MyBlnFileValid) {
            [String]$MyFilename = $MyJtIoFile.GetName()
            Write-JtLog -Where $MyFunctionName -Text "______ MyFileName: $MyFilename"
  
            [JtTblRow]$MyJtTblRow = New-JtTblRow 

            [Int16]$MyIntPos = 1
            ForEach ($ColRen in $MyAlJtColRens) {
                [JtColRen]$MyJtColRen = $ColRen
                [String]$MyHeader = $MyJtColRen.GetHeader()
                [String]$MyLabel = $MyJtColRen.GetLabel()
            
                [String]$MyPart = Convert-JtDotter -Text $MyFilename -PatternOut $MyIntPos
            
                [String]$MyValue = $MyJtColRen.GetOutput($MyPart)
            
                $MyJtTblRow.Add($MyLabel, $MyValue)
                $MyIntPos ++
            }

            [JtColRen]$MyJtColRen = New-JtColRenFileYear
            [String]$MyHeader = $MyJtColRen.GetHeader()
            [String]$MyLabel = $MyJtColRen.GetLabel()
            [String]$MyValue = $MyJtColRen.GetOutput($MyJtIoFile.GetPath())
            $MyJtTblRow.Add($MyLabel, $MyValue)

            [JtColRen]$MyJtColRen = New-JtColRenFileAge
            [String]$MyHeader = $MyJtColRen.GetHeader()
            [String]$MyLabel = $MyJtColRen.GetLabel()
            [String]$MyValue = $MyJtColRen.GetOutput($MyJtIoFile.GetPath())
            $MyJtTblRow.Add($MyLabel, $MyValue)
        
            $MyJtTblTable.AddRow($MyJtTblRow)
        } else {
            Write-JtLog_Folder_Error -Where $MyFunctionName -Text "File is not valid." -FilePath $MyJtIoFile
        }
    }
    return , $MyJtTblTable
}





Function Convert-JtFolderPath_To_JtTblTable_Zahlung {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input
    )

    [String]$MyFunctionName = "Convert-JtFolderPath_To_JtTblTable_Zahlung"

    [String]$MyFolderPath_Input = $FolderPath_Input
    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyFolderPath_Input -Normal
    
    [JtTemplateFile]$MyJtTemplateFile = Get-JtTemplateFile -FolderPath_Input $MyFolderPath_Input
    [System.Collections.ArrayList]$MyAlJtColRens = $MyJtTemplateFile.GetJtColRens()
    
    [Int32]$MyIntLine = 1

    [JtTblTable]$MyJtTblTable = New-JtTblTable -Label $MyFunctionName
    [JtTblRow]$MyJtTblRow = New-JtTblRow
    foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File
        [String]$MyFilePath_Input = $MyJtIoFile.GetPath()
        [Boolean]$MyBlnFileOk = Test-JtFolder_File -FilePath_Input $MyFilePath_Input
        if ($MyBlnFileOk) {
            [String]$MyFilename = $MyJtIoFile.GetName()
            [String]$MyValue = ""
        
            $MyAlFilenameParts = $MyFilename.Split(".")
            [JtColRen]$MyJtColRen = New-JtColRenInput_TextNr
            $MyJtTblRow.Add("NR", $MyIntLine)
        
            for ([Int32]$j = 0; $j -lt ($MyAlFilenameParts.Count - 1); $j++) {
                [String]$MyFilename_Part = $MyAlFilenameParts[$j]
                [JtColRen]$MyJtColRen = $MyAlJtColRens[$j]
                [String]$MyHeader = $MyJtColRen.GetHeader()
                [String]$MyLabel = $MyJtColRen.GetLabel()
                $MyValue = $MyAlJtColRens[$j].GetOutput($MyFilename_Part)
                $MyJtTblRow.Add($MyLabel, $MyValue) | Out-Null
            }
            $MyJtTblTable.AddRow($MyJtTblRow) | Out-Null
            $MyIntLine = $MyIntLine + 1
        }
        else {
            Write-JtLog_Folder_Error -Where $MyFunctionName -Text "Problem with file." -FilePath $MyJtIoFile
        }
    }

    [JtTblRow]$MyJtTblRow_Footer = New-JtTblRow
        
    [JtColRen]$MyJtColRen = New-JtColRenInput_TextNr
    [String]$MyLabel = $MyJtColRen.GetLabel()
    $MyJtTblRow_Footer.Add($MyLabel, "SUM:") | Out-Null
        
    [Int32]$j = 0
    [JtColRen]$MyJtColRen = $MyAlJtColRens[$j]
    [String]$MyLabel = $MyJtColRen.GetLabel()
    $MyJtTblRow_Footer.Add($MyLabel, "(Monat)") | Out-Null

    [Int32]$j = 1
    [JtColRen]$MyJtColRen = $MyAlJtColRens[$j]
    [String]$MyLabel = $MyJtColRen.GetLabel()
    $MyJtTblRow_Footer.Add($MyLabel, "(Art)") | Out-Null

    [Int32]$j = 2
    [JtColRen]$MyJtColRen = $MyAlJtColRens[$j]
    [String]$MyLabel = $MyJtColRen.GetLabel()
    $MyJtTblRow_Footer.Add($MyLabel, "(Objekt)") | Out-Null
        
    [Int32]$j = 3
    [JtColRen]$MyJtColRen = $MyAlJtColRens[$j]
    [String]$MyLabel = $MyJtColRen.GetLabel()
    $MyJtTblRow_Footer.Add($MyLabel, "(Mieter)") | Out-Null

    [Int32]$j = 4
    [String]$MyPart = "MIETE"
    [Decimal]$MyDecBetrag = Convert-JtFolderPath_To_Value_Betrag_Part -FolderPath_Input $MyFolderPath_Input -PartName $MyPart
    [String]$MyValue = Convert-JtDecimal_To_String2 -Decimal $MyDecBetrag
    $MyJtTblRow_Footer.Add($MyPart, $MyValue) | Out-Null
        
    [Int32]$j = 5
    [String]$MyPart = "VORAUS"
    [Decimal]$MyDecBetrag = Convert-JtFolderPath_To_Value_Betrag_Part -FolderPath_Input $MyFolderPath_Input -PartName $MyPart
    [String]$MyValue = Convert-JtDecimal_To_String2 -Decimal $MyDecBetrag
    $MyJtTblRow_Footer.Add($MyPart, $MyValue) | Out-Null
        
    [Int32]$j = 6
    [String]$MyPart = "ZAHLUNG"
    [Decimal]$MyDecBetrag = Convert-JtFolderPath_To_Value_Betrag_Part -FolderPath_Input $MyFolderPath_Input -PartName $MyPart
    [String]$MyValue = Convert-JtDecimal_To_String2 -Decimal $MyDecBetrag
    $MyJtTblRow_Footer.Add($MyPart, $MyValue)

    $MyJtTblTable.AddRow($MyJtTblRow_Footer) | Out-Null

    return , $MyJtTblTable
}


class JtPreisliste : JtClass {

    [System.Data.Datatable]$DataTable = $Null
    
    [String]$Title = ""
    [String]$ColId_Price = "PREIS_ID"
    [String]$ColLabel_Paper = "PAPIER"
    [String]$ColLabel_Ink = "TINTE"
    [String]$ColBasePrice_Ink = "BASIS_TINTE"
    [String]$ColBasePrice_Paper = "BASIS_PAPIER"

    JtPreisliste([String]$MyTitle) {
        $This.ClassName = "JtPreisliste"
        $This.Title = $MyTitle

        $This.DataTable = New-Object System.Data.Datatable

        $This.DataTable.Columns.Add($This.ColId_Price, "String")
        $This.DataTable.Columns.Add($This.ColLabel_Paper, "String")
        $This.DataTable.Columns.Add($This.ColLabel_Ink, "String")
        $This.DataTable.Columns.Add($This.ColBasePrice_Paper, "String")
        $This.DataTable.Columns.Add($This.ColBasePrice_Ink, "String")
    }

    AddRow([String]$PreisId, [String]$PapierLabel, [String]$TinteLabel, [String]$PapierGrundpreis, [String]$TinteGrundpreis) {
        $Row = $This.DataTable.NewRow()

        [String]$Label = ""
        [String]$MyValue = ""

        $Label = $This.ColId_Price
        $MyValue = $PreisId
        $Row.($Label) = $MyValue

        $Label = $This.ColLabel_Paper
        $MyValue = $PapierLabel
        $Row.($Label) = $MyValue

        $Label = $This.ColLabel_Ink
        $MyValue = $TinteLabel
        $Row.($Label) = $MyValue

        $Label = $This.ColBasePrice_Paper
        $MyValue = $PapierGrundpreis
        $Row.($Label) = $MyValue

        $Label = $This.ColBasePrice_Ink
        $MyValue = $TinteGrundpreis
        $Row.($Label) = $MyValue

        $This.DataTable.Rows.Add($Row)
    }

    [String]GetTitle() {
        return $This.Title
    }

    [System.Object]GetRow([String]$TheLabel) {
        [String]$MyLabel = $TheLabel
        [System.Data.DataRow]$MyRow = $This.DataTable.Rows | Where-Object { $_.PREIS_ID -eq $MyLabel }

        if ($Null -eq $MyRow) {
            return $Null
        }
        else {
            return $MyRow
        }
    }

    [Decimal]GetDecBasePrice_Paper([String]$TheLabel) {
        [String]$MyLabel = $TheLabel
        [System.Object]$MyRow = $This.GetRow($MyLabel)

        if ($Null -eq $MyRow) {
            Write-JtLog_Error -Where $This.ClassName -Text "GetDecBasePrice_Paper. MyRow is NULL for MyLabel $MyLabel"
            return 999
        }

        
        [String]$MyValue = $MyRow.($This.ColBasePrice_Paper)
            
        [Decimal]$MyDecValue = Convert-JtString_To_Decimal -Text $MyValue
        return $MyDecValue
        
    }
    
    [Decimal]GetDecBasePrice_Ink([String]$TheLabel) {
        [String]$MyLabel = $TheLabel
        [System.Object]$MyRow = $This.GetRow($MyLabel)
        
        if ($Null -eq $MyRow) {
            Write-JtLog_Error -Where $This.ClassName -Text "GetDecBasePrice_Ink. MyRow is NULL for MyLabel $MyLabel"
            return 999
        }
         
        [String]$MyValue = $MyRow.($This.ColBasePrice_Ink)
            
        [Decimal]$MyDecValue = Convert-JtString_To_Decimal -Text $MyValue
        return $MyDecValue
    }
}


Function New-JtPreisliste_Plotten_2020_07_01 {

    [Decimal]$MyDecTarif_Papier_Normal = 1.25
    [Decimal]$MyDecTarif_Papier_Spezial = 2.50

    [Decimal]$MyDecTarif_Tinte_Normal = 6.50
    [Decimal]$MyDecTarif_Tinte_Minimal = 1.00

    [JtPreisliste]$MyJtPreisliste = [JtPreisliste]::new("Plotten_2020_07_01")

    $MyJtPreisliste.AddRow("fabriano", "FABRIANO", "NORMAL", $MyDecTarif_Papier_Spezial, $MyDecTarif_Tinte_Normal)
    $MyJtPreisliste.AddRow("fabriano_minimal", "FABRIANO", "MINIMAL", $MyDecTarif_Papier_Spezial, $MyDecTarif_Tinte_Minimal)

    $MyJtPreisliste.AddRow("semi", "Fotopapier, matt", "NORMAL", $MyDecTarif_Papier_Spezial, $MyDecTarif_Tinte_Normal)
    $MyJtPreisliste.AddRow("semi_minimal", "Fotopapier, matt", "MINIMAL", $MyDecTarif_Papier_Spezial, $MyDecTarif_Tinte_Minimal)

    $MyJtPreisliste.AddRow("glossy", "Fotopapier, glanz", "NORMAL", $MyDecTarif_Papier_Spezial, $MyDecTarif_Tinte_Normal)
    $MyJtPreisliste.AddRow("glossy_minimal", "Fotopapier, glanz", "MINIMAL", $MyDecTarif_Papier_Spezial, $MyDecTarif_Tinte_Minimal)

    $MyJtPreisliste.AddRow("trans", "Transparent-Papier", "NORMAL", $MyDecTarif_Papier_Spezial, $MyDecTarif_Tinte_Normal)
    $MyJtPreisliste.AddRow("trans_minimal", "Transparent-Papier", "MINIMAL", $MyDecTarif_Papier_Spezial, $MyDecTarif_Tinte_Minimal)

    $MyJtPreisliste.AddRow("180g", "180g-Papier", "NORMAL", $MyDecTarif_Papier_Spezial, $MyDecTarif_Tinte_Normal)
    $MyJtPreisliste.AddRow("180g_minimal", "180g-Papier", "MINIMAL", $MyDecTarif_Papier_Spezial, $MyDecTarif_Tinte_Minimal)

    $MyJtPreisliste.AddRow("90g", "90g-Papier", "NORMAL", $MyDecTarif_Papier_Normal, $MyDecTarif_Tinte_Normal)
    $MyJtPreisliste.AddRow("90g_minimal", "90g-Papier", "MINIMAL", $MyDecTarif_Papier_Normal, $MyDecTarif_Tinte_Minimal)

    $MyJtPreisliste.AddRow("own", "Eigenes Papier", "NORMAL", $MyDecTarif_Papier_Normal, $MyDecTarif_Tinte_Normal)
    $MyJtPreisliste.AddRow("own_minimal", "Eigenes Papier", "MINIMAL", $MyDecTarif_Papier_Normal, $MyDecTarif_Tinte_Minimal)
    [JtPreisliste]$MyJtPreisliste
}


Function New-JtPreisliste_Plotten_2022_01_01 {

    [Decimal]$MyDecTarif_Papier_Normal = 1.25
    [Decimal]$MyDecTarif_Papier_Spezial = 3.00

    [Decimal]$MyDecTarif_Tinte_Normal = 7.50
    [Decimal]$MyDecTarif_Tinte_Minimal = 1.00

    [JtPreisliste]$MyJtPreisliste = [JtPreisliste]::new("Plotten_2021_01_01")

    $MyJtPreisliste.AddRow("fabriano", "FABRIANO", "NORMAL", $MyDecTarif_Papier_Spezial, $MyDecTarif_Tinte_Normal)
    $MyJtPreisliste.AddRow("fabriano_minimal", "FABRIANO", "MINIMAL", $MyDecTarif_Papier_Spezial, $MyDecTarif_Tinte_Minimal)

    $MyJtPreisliste.AddRow("semi", "Fotopapier, matt", "NORMAL", $MyDecTarif_Papier_Spezial, $MyDecTarif_Tinte_Normal)
    $MyJtPreisliste.AddRow("semi_minimal", "Fotopapier, matt", "MINIMAL", $MyDecTarif_Papier_Spezial, $MyDecTarif_Tinte_Minimal)

    $MyJtPreisliste.AddRow("glossy", "Fotopapier, glanz", "NORMAL", $MyDecTarif_Papier_Spezial, $MyDecTarif_Tinte_Normal)
    $MyJtPreisliste.AddRow("glossy_minimal", "Fotopapier, glanz", "MINIMAL", $MyDecTarif_Papier_Spezial, $MyDecTarif_Tinte_Minimal)

    $MyJtPreisliste.AddRow("trans", "Transparent-Papier", "NORMAL", $MyDecTarif_Papier_Spezial, $MyDecTarif_Tinte_Normal)
    $MyJtPreisliste.AddRow("trans_minimal", "Transparent-Papier", "MINIMAL", $MyDecTarif_Papier_Spezial, $MyDecTarif_Tinte_Minimal)

    $MyJtPreisliste.AddRow("180g", "180g-Papier", "NORMAL", $MyDecTarif_Papier_Spezial, $MyDecTarif_Tinte_Normal)
    $MyJtPreisliste.AddRow("180g_minimal", "180g-Papier", "MINIMAL", $MyDecTarif_Papier_Spezial, $MyDecTarif_Tinte_Minimal)

    $MyJtPreisliste.AddRow("90g", "90g-Papier", "NORMAL", $MyDecTarif_Papier_Normal, $MyDecTarif_Tinte_Normal)
    $MyJtPreisliste.AddRow("90g_minimal", "90g-Papier", "MINIMAL", $MyDecTarif_Papier_Normal, $MyDecTarif_Tinte_Minimal)

    $MyJtPreisliste.AddRow("own", "Eigenes Papier", "NORMAL", $MyDecTarif_Papier_Normal, $MyDecTarif_Tinte_Normal)
    $MyJtPreisliste.AddRow("own_minimal", "Eigenes Papier", "MINIMAL", $MyDecTarif_Papier_Normal, $MyDecTarif_Tinte_Minimal)
    [JtPreisliste]$MyJtPreisliste
}



class JtTemplateFile : JtClass {

    [JtIoFile]$JtIoFile
    [JtIoFolder]$JtIoFolder
    [String]$FilenameTemplate
    [Boolean]$Valid = $True

    JtTemplateFile([JtIoFolder]$TheJtIoFolder) {
        $This.ClassName = "JtTemplateFile"
        
        [JtIoFolder]$MyJtIoFolder = $TheJtIoFolder
        # Write-JtLog -Where $This.ClassName -Text "DoInit. Path: $FolderPath"
        $This.JtIoFile = $null
        
        [String]$MyExtension = [JtIo]::FileExtension_Folder
        [String]$MyFilter = -join ("*", $MyExtension)
        [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder -Filter $MyFilter
        if ($MyAlJtIoFiles.Count -gt 0) {
            $This.JtIoFile = $MyAlJtIoFiles[0]
            $This.Valid = $True
            $This.FilenameTemplate = $This.JtIoFile.GetName()
        }
        else {
            $This.Valid = $False
            Write-JtLog_Error -Where $This.ClassName -Text "Template file is missing. MyJtIoFolder: $MyJtIoFolder - MyFilter: $MyFilter"
        }
        $This.JtIoFolder = $MyJtIoFolder
    }

    [Boolean]IsValid() {
        return $This.Valid
    }
    
    [JtColRen]GetJtColRenForColumnNumber([Int16]$IntCol) {
        [System.Collections.ArrayList]$MyAlJtColRens = $This.GetJtColRens()
        if ($IntCol -lt $MyAlJtColRens.Count) {
            return $MyAlJtColRens[$IntCol]
        }
        else {
            [String]$MyLabel = -join ("Column_Number_", $IntCol)
            [JtColRen]$MyJtColRen = New-JtColRenInput_Text -Label $MyLabel
            Write-JtLog_Error -Where $This.ClassName -Text "Problem with column number: $IntCol"
        }
        return $MyJtColRen
    }

    [System.Collections.ArrayList]GetJtColRens() {
        [System.Collections.ArrayList]$MyAlJtColRens = [System.Collections.ArrayList]::new()
        if (!($This.Valid)) {
            [JtIoFolder]$MyJtIoFolder = $This.JtIoFolder
            Write-JtLog_Error -Where $This.ClassName -Text "GetJtColRens. Not VALID; returning NULL at PATH: $MyJtIoFolder"
            return $Null
        }

        [String]$MyFilename_Template = $This.FilenameTemplate
        
        $MyAlTemplateParts = $MyFilename_Template.Split(".")
        foreach ($Part in $MyAlTemplateParts) {
            [String]$MyPart = $Part
            # Write-JtLog -Where $This.ClassName -Text "GetJtColRens. MyFilename_Template: $MyFilename_Template"
            [JtColRen]$MyJtColRen = Get-JtColRen -Name $MyPart
            $MyAlJtColRens.Add($MyJtColRen)
        }
        return $MyAlJtColRens
    }

    [Int16]GetJtColRensCount() {
        [System.Collections.ArrayList]$MyAlJtColRens = $This.GetJtColRens()
        [Int32]$NumTemplateParts = $MyAlJtColRens.Count
        return $NumTemplateParts
    }

    [JtIoFolder]GetJtIoFolder() {
        return [JtIoFolder]$This.JtIoFolder
    }

    [Boolean]GetHasColumnForAnzahl() {
        [JtColRen]$MyColCompare = New-JtColRenInput_Anzahl
        return $This.GetHasColumnOfType($MyColCompare)
    }
    
    [Boolean]GetHasColumnForArea() {
        [JtColRen]$MyColCompare = New-JtColRenInput_Bxh
        return $This.GetHasColumnOfType($MyColCompare)
    }
    
    [Boolean]GetHasColumnForEuro() {
        [JtColRen]$MyColCompare = New-JtColRenInput_CurrencyEuro
        return $This.GetHasColumnOfType($MyColCompare)
    }

    [Boolean]GetHasColumnOfType([JtColRen]$MyJtColRen) {
        [Boolean]$MyResult = $False
        [System.Collections.ArrayList]$MyAlJtColRens = $This.GetJtColRens()
        
        [JtColRen]$MyColCompare = $MyJtColRen
        foreach ($MyJtColRen in $MyAlJtColRens) {
            [JtColRen]$MyJtColRen = $MyJtColRen
            if ($MyColCompare -eq $MyJtColRen) {
                $MyResult = $True
                return $MyResult
            }
        }
        return $MyResult
    }

    [String]GetName() {
        return $This.FilenameTemplate
    }
}


Function Get-JtTemplateFile {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input
    )

    [String]$MyFolderPath_Input = $FolderPath_Input
        
    [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $MyFolderPath_Input
    [JtTemplateFile]::new($MyJtIoFolder)
}

Export-ModuleMember -Function Convert-JtFolderPath_To_JtTblTable_Anzahl
Export-ModuleMember -Function Convert-JtFolderPath_To_JtTblTable_Files
Export-ModuleMember -Function Convert-JtFolderPath_To_JtTblTable_BxH
Export-ModuleMember -Function Convert-JtFolderPath_To_JtTblTable_Zahlung


Export-ModuleMember -Function Get-JtColRen
Export-ModuleMember -Function Get-JtTemplateFile
Export-ModuleMember -Function Get-JtPreisliste

Export-ModuleMember -Function New-JtPreisliste_Plotten_2022_01_01 
Export-ModuleMember -Function New-JtPreisliste_Plotten_2020_07_01


Export-ModuleMember -Function New-JtColRenFileAge
Export-ModuleMember -Function New-JtColRenFileAnzahl
Export-ModuleMember -Function New-JtColRenFileArea
Export-ModuleMember -Function New-JtColRenFileDim
Export-ModuleMember -Function New-JtColRenFileEuro
Export-ModuleMember -Function New-JtColRenFileName
Export-ModuleMember -Function New-JtColRenFilePath
Export-ModuleMember -Function New-JtColRenFileJtPreisliste
Export-ModuleMember -Function New-JtColRenFileJtPreisliste_Ink
Export-ModuleMember -Function New-JtColRenFileJtPreisliste_Paper
Export-ModuleMember -Function New-JtColRenFileJtPreisliste_Price
Export-ModuleMember -Function New-JtColRenFileYear
Export-ModuleMember -Function New-JtColRenInput_Anzahl
Export-ModuleMember -Function New-JtColRenInput_Bxh
Export-ModuleMember -Function New-JtColRenInput_Currency
Export-ModuleMember -Function New-JtColRenInput_CurrencyBetrag
Export-ModuleMember -Function New-JtColRenInput_CurrencyEuro
Export-ModuleMember -Function New-JtColRenInput_CurrencyPreis
Export-ModuleMember -Function New-JtColRenInput_CurrencyGesamt
Export-ModuleMember -Function New-JtColRenInput_Datum
Export-ModuleMember -Function New-JtColRenInput_Stand
Export-ModuleMember -Function New-JtColRenInput_Sum
Export-ModuleMember -Function New-JtColRenInput_Text
Export-ModuleMember -Function New-JtColRenInput_TextNr
Export-ModuleMember -Function New-JtColRenInput_MonthId

