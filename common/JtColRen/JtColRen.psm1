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


Function Get-JtColRen {
    
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Name
    )
    
    [String]$MyPart = $Name
    $MyPart = $MyPart.Replace("_", "")
    $MyPart = $MyPart.Replace(" ", "")
    [JtColRen]$MyJtColRen = New-JtColRenInput_Text -Label $MyPart
    if ($MyPart.ToLower() -eq "preis") {
        $MyJtColRen = New-JtColRenInput_Betrag -Label "PREIS"
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
        $MyJtColRen = New-JtColRenInput_Betrag
    }
    elseif ($MyPart.ToLower() -eq "gesamt") {
        $MyJtColRen = New-JtColRenInput_Betrag -Label "GESAMT"
    }
    elseif ($MyPart.ToLower() -eq "miete") {
        $MyJtColRen = New-JtColRenInput_Betrag -Label "MIETE"
    }
    elseif ($MyPart.ToLower() -eq "org") {
        $MyJtColRen = New-JtColRenInput_Text -Label "ORG"
    } 
    elseif ($MyPart.ToLower() -eq "voraus") {
        $MyJtColRen = New-JtColRenInput_Betrag -Label "VORAUS"
    }
    elseif ($MyPart.ToLower() -eq "stand") {
        $MyJtColRen = New-JtColRenInput_Stand
    }
    elseif ($MyPart.ToLower() -eq "euro") {
        $MyJtColRen = New-JtColRenInput_Betrag -Label "EURO"
    }
    elseif ($MyPart.ToLower() -eq "0000-00") {
        $MyJtColRen = New-JtColRenInput_MonthId
    }
    elseif ($MyPart.ToLower() -eq "zahlung") {
        $MyJtColRen = New-JtColRenInput_Betrag -Label "ZAHLUNG"
    }
    return $MyJtColRen
}


class JtColRenFile_Age : JtColRen {

    JtColRenFile_Age() : Base("ALTER") {
        $This.ClassName = "JtColRenFile_Age"
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


Function New-JtColRenFile_Age {
    [JtColRenFile_Age]::new()
}


class JtColRenFile_Anzahl : JtColRen {

    JtColRenFile_Anzahl() : Base("ANZAHL") {
        $This.ClassName = "JtColRenFile_Anzahl"
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

Function New-JtColRenFile_Anzahl {
    [JtColRenFile_Anzahl]::new()
}


class JtColRenFile_Area : JtColRen {

    JtColRenFile_Area() : base("DIM") {
        $This.ClassName = "JtColRenFile_Area"
    }

    [String]GetOutput([String]$TheFilePath) {
        [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $TheFilePath
        [String]$MyFilename = $MyJtIoFile.GetName()

        [Decimal]$MyDecResult = Convert-JtFilename_To_DecQm -Filename $MyFilename
        [String]$MyResult = Convert-JtDecimal_To_String3 -Decimal $MyDecResult
        return $MyResult
    }

    [Boolean]IsSummable() {
        return $False
    }
}

Function New-JtColRenFile_Area {
    [JtColRenFile_Area]::new()
}


class JtColRenFile_Dim : JtColRen {

    JtColRenFile_Dim() : base("DIM") {
        $This.ClassName = "JtColRenFile_Dim"
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

Function New-JtColRenFile_Dim {
    [JtColRenFile_Dim]::new()
}


class JtColRenFile_Euro : JtColRen {

    JtColRenFile_Euro() : Base("EURO") {
        $This.ClassName = "JtColRenFile_Euro"
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

Function New-JtColRenFile_Euro {
    [JtColRenFile_Euro]::new()
}

class JtColRenFile_Name : JtColRen {

    JtColRenFile_Name() : base ("FILE") {
        $This.ClassName = "JtColRenFile_Name"
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

Function New-JtColRenFile_Name {
    [JtColRenFile_Name]::new()
}

class JtColRenFile_Path : JtColRen {

    JtColRenFile_Path() : base ("PATH") {
        $This.ClassName = "JtColRenFile_Path"
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

Function New-JtColRenFile_Path {
    [JtColRenFile_Path]::new()
}

class JtColRenFile_JtPreisliste : JtColRen {

    [JtPreisliste]$JtPreisliste
    
    JtColRenFile_JtPreisliste([JtPreisliste]$TheJtPreisliste, [String]$TheLabel) : Base($TheLabel) {
        $This.ClassName = "JtColRenFile_JtPreisliste"
        $This.JtPreisliste = $TheJtPreisliste
    }


    [String]GetOutput([String]$TheFilePath) {
        [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $TheFilePath
        [String]$MyFilename = $MyJtIoFile.GetName()

        [Decimal]$MyDecQm = Convert-JtFilename_To_DecQm -Filename $MyFilename
        [String]$MyPaper = Convert-JtFilename_To_Papier -Filename $MyFilename

        [Decimal]$MyDecBasePrice_Paper = $This.JtPreisliste.GetDecBasePrice_Paper($MyPaper)

        [String]$MyResult = -join ($MyDecQm, " x ", $MyDecBasePrice_Paper)
        return $MyResult
    }

    [Boolean]IsSummable() {
        return $False
    }
}

Function New-JtColRenFile_JtPreisliste {
    
    [JtPreisliste]$MyJtPreisliste = Get-JtPreisliste
    [JtColRenFile_JtPreisliste]::new($MyJtPreisliste)
}

class JtColRenFile_JtPreisliste_Ink : JtColRenFile_JtPreisliste {

    JtColRenFile_JtPreisliste_Ink([JtPreisliste]$TheJtPreisliste) : Base($TheJtPreisliste, "TINT.") {
        $This.ClassName = "JtColRenFile_JtPreisliste_Ink"
    }

    [String]GetOutput([String]$TheFilePath) {
        [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $TheFilePath
        [String]$MyFilename = $MyJtIoFile.GetName()

        [String]$MyPaper = Convert-JtFilename_To_Papier -Filename $MyFilename
        [Decimal]$MyDecBasePrice_Ink = $This.JtPreisliste.GetDecBasePrice_Ink($MyPaper)
        [Decimal]$MyDecArea = Convert-JtFilename_To_DecQm -Filename $MyFilename

        [Decimal]$MyDecResult = $MyDecArea * $MyDecBasePrice_Ink

        [String]$MyResult = Convert-JtDecimal_To_String2 -Decimal $MyDecResult
        return $MyResult
    }

    [Boolean]IsSummable() {
        return $False
    }
}

Function New-JtColRenFile_JtPreisliste_Ink {
    
    [JtPreisliste]$MyJtPreisliste = Get-JtPreisliste
    [JtColRenFile_JtPreisliste_Ink]::new($MyJtPreisliste)
}

class JtColRenFile_JtPreisliste_Paper : JtColRenFile_JtPreisliste {
    
    JtColRenFile_JtPreisliste_Paper([JtPreisliste]$TheJtPreisliste) : Base($TheJtPreisliste, "PAP.") {
        $This.ClassName = "JtColRenFile_JtPreisliste_Paper"
    }

    [String]GetOutput([String]$TheFilePath) {
        [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $TheFilePath
        [String]$MyFilename = $MyJtIoFile.GetName()

        [String]$MyPaper = Convert-JtFilename_To_Papier -Filename $MyFilename
        
        [Decimal]$MyDecArea = Convert-JtFilename_To_DecQm -Filename $MyFilename
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

Function New-JtColRenFile_JtPreisliste_Paper {
    
    [JtPreisliste]$MyJtPreisliste = Get-JtPreisliste
    [JtColRenFile_JtPreisliste_Paper]::new($MyJtPreisliste)
}

class JtColRenFile_JtPreisliste_Price : JtColRenFile_JtPreisliste {
    
    JtColRenFile_JtPreisliste_Price([JtPreisliste]$TheJtPreisliste) : Base($TheJtPreisliste, "PREIS") {
        $This.ClassName = "JtColRenFile_JtPreisliste_Price"
    }

    [String]GetOutput([String]$TheFilePath) {
        [String]$MyFilePath_Input = $TheFilePath
        [JtPreisliste]$MyJtPreisliste = $This.JtPreisliste
        [Decimal]$MyDecPrice = Convert-JtFilePath_To_Decimal_JtPreisliste_Preis -FilePath_Input $MyFilePath_Input -JtPreisliste $MyJtPreisliste
        
        [String]$MyResult = Convert-JtDecimal_To_String2 -Decimal $MyDecPrice
        Write-JtLog -Where $This.ClassName -Text "MyDecPrice: $MyDecPrice - MyResult: $MyResult"
        return $MyResult
    }
    
    [Boolean]IsSummable() {
        return $False
    }
}

Function New-JtColRenFile_JtPreisliste_Price {
    
    [JtPreisliste]$MyJtPreisliste = Get-JtPreisliste
    [JtColRenFile_JtPreisliste_Price]::new($MyJtPreisliste)
}

class JtColRenFile_Year : JtColRen {

    JtColRenFile_Year() : Base("JAHR") {
        $This.ClassName = "JtColRenFile_Year"
    }

    [String]GetOutput([String]$TheFilePath) {
        [String]$MyFilePath = $TheFilePath
        [String]$MyFilename = Convert-JtFilePath_To_Filename -FilePath $MyFilePath
        [String]$MyResult = Convert-JtFilename_To_Jahr -Filename $MyFilename
        return $MyResult
    }

    [Boolean]IsSummable() {
        return $False
    }
}

Function New-JtColRenFile_Year {
    
    [JtColRenFile_Year]::new()
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


Function New-JtColRenInput_Betrag {

    Param (
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Label
    )

    [String]$MyLabel = "BETRAG"
    if($Label) {
        $MyLabel = $Label
    }

    [JtColRenInputCurrency]::new($MyLabel)
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


Function Convert-JtFilePath_To_Decimal_JtPreisliste_Preis {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FilePath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtPreisliste]$JtPreisliste
    )

    [String]$MyFunctionName = "Convert-JtFilePath_To_Decimal_JtPreisliste_Preis"

    [JtPreisliste]$MyJtPreisliste = $JtPreisliste
    [String]$MyFilePath_Input = $FilePath_Input

    [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $MyFilePath_Input
    [String]$MyFilename = $MyJtIoFile.GetName()

    [String]$MyPaper = Convert-JtFilename_To_Papier -Filename $MyFilename
    [Decimal]$MyDecArea = Convert-JtFilename_To_DecQm -Filename $MyFilename

    [Decimal]$MyDecBasePrice_Paper = $MyJtPreisliste.GetDecBasePrice_Paper($MyPaper)
    [Decimal]$MyDecBasePrice_Ink = $MyJtPreisliste.GetDecBasePrice_Ink($MyPaper)
    
    Write-JtLog -Where $MyFunctionName -Text "MyPaper: $MyPaper - MyDecArea: $MyDecArea - MyDecBasePrice_Paper: $MyDecBasePrice_Paper MyDecBasePrice_Ink: $MyDecBasePrice_Ink"
    [Decimal]$MyDecResult = ($MyDecArea * $MyDecBasePrice_Ink) + ($MyDecArea * $MyDecBasePrice_Paper)
    return $MyDecResult
}



Export-ModuleMember -Function Get-JtColRen
Export-ModuleMember -Function Get-JtTemplateFile
Export-ModuleMember -Function Get-JtPreisliste

Export-ModuleMember -Function New-JtPreisliste_Plotten_2022_01_01 
Export-ModuleMember -Function New-JtPreisliste_Plotten_2020_07_01


Export-ModuleMember -Function New-JtColRenFile_Age
Export-ModuleMember -Function New-JtColRenFile_Anzahl
Export-ModuleMember -Function New-JtColRenFile_Area
Export-ModuleMember -Function New-JtColRenFile_Dim
Export-ModuleMember -Function New-JtColRenFile_Euro
Export-ModuleMember -Function New-JtColRenFile_Name
Export-ModuleMember -Function New-JtColRenFile_Path
Export-ModuleMember -Function New-JtColRenFile_JtPreisliste
Export-ModuleMember -Function New-JtColRenFile_JtPreisliste_Ink
Export-ModuleMember -Function New-JtColRenFile_JtPreisliste_Paper
Export-ModuleMember -Function New-JtColRenFile_JtPreisliste_Price
Export-ModuleMember -Function New-JtColRenFile_Year
Export-ModuleMember -Function New-JtColRenInput_Anzahl
Export-ModuleMember -Function New-JtColRenInput_Bxh
Export-ModuleMember -Function New-JtColRenInput_Betrag
Export-ModuleMember -Function New-JtColRenInput_Betrag
Export-ModuleMember -Function New-JtColRenInput_BetragEuro
Export-ModuleMember -Function New-JtColRenInput_BetragPreis
Export-ModuleMember -Function New-JtColRenInput_BetragGesamt
Export-ModuleMember -Function New-JtColRenInput_Datum
Export-ModuleMember -Function New-JtColRenInput_Stand
Export-ModuleMember -Function New-JtColRenInput_Sum
Export-ModuleMember -Function New-JtColRenInput_Text
Export-ModuleMember -Function New-JtColRenInput_TextNr
Export-ModuleMember -Function New-JtColRenInput_MonthId

