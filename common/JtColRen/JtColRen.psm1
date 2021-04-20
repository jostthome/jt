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
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Part
    )
    
    [String]$MyPart = $Part
    $MyPart = $MyPart.Replace("_", "")
    $MyPart = $MyPart.Replace(" ", "")
    $MyPart = $MyPart.ToLower()

    [JtColRen]$MyJtColRen = New-JtColRenInput_Text -Label $MyPart
    if ($MyPart -eq "preis") {
        $MyJtColRen = New-JtColRenInput_Betrag -Label "PREIS"
    }
    elseif ($MyPart -eq "anzahl") {
        $MyJtColRen = New-JtColRenInput_Anzahl 
    }
    elseif ($MyPart -eq "datum") {
        $MyJtColRen = New-JtColRenInput_Datum 
    }
    elseif ($MyPart -eq "nachname") {
        $MyJtColRen = New-JtColRenInput_Text -Label "NACHNAME"
    } 
    elseif ($MyPart -eq "vorname") {
        $MyJtColRen = New-JtColRenInput_Text -Label "VORNAME"
    } 
    elseif ($MyPart -eq "bxh") {
        $MyJtColRen = New-JtColRenInput_BxH
    }         
    elseif ($MyPart -eq "betrag") {
        $MyJtColRen = New-JtColRenInput_Betrag
    }
    elseif ($MyPart -eq "gesamt") {
        $MyJtColRen = New-JtColRenInput_Betrag -Label "GESAMT"
    }
    elseif ($MyPart -eq "miete") {
        $MyJtColRen = New-JtColRenInput_Betrag -Label "MIETE"
    }
    elseif ($MyPart -eq "org") {
        $MyJtColRen = New-JtColRenInput_Text -Label "ORG"
    } 
    elseif ($MyPart -eq "voraus") {
        $MyJtColRen = New-JtColRenInput_Betrag -Label "VORAUS"
    }
    elseif ($MyPart -eq "stand") {
        $MyJtColRen = New-JtColRenInput_Stand
    }
    elseif ($MyPart -eq "soll") {
        $MyJtColRen = New-JtColRenInput_Betrag -Label "SOLL"
    }
    elseif ($MyPart -eq "stunden") {
        $MyJtColRen = New-JtColRenInput_Betrag -Label "STUNDEN"
    }
    elseif ($MyPart -eq "euro") {
        $MyJtColRen = New-JtColRenInput_Betrag -Label "EURO"
    }
    elseif ($MyPart -eq "0000-00") {
        $MyJtColRen = New-JtColRenInput_MonthId
    }
    elseif ($MyPart -eq "zahlung") {
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
        [String]$MyValue = $TheValue
        return Test-JtPart_IsValidAs_Betrag -Part $MyValue
    }
    
    [String]GetOutput([String]$TheValue) {
        [String]$MyValue = $TheValue
        return Convert-JtString_To_Betrag -Text $MyValue
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
    if ($Label) {
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

class JtDataRepository : JtClass {

    [JtIoFolder]$JtIoFolder = $Null

    JtDataRepository([String]$TheFolderPath) {
        [String]$This.ClassName = "JtDataRepository"
        [String]$MyFolderPath = $TheFolderPath
        [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $MyFolderPath
        $This.JtIoFolder = $MyJtIoFolder
    }

    DoUpdateMeta() {
        [System.Collections.ArrayList]$MyAlJtDataFolders = $This.GetAlJtDataFolders()
        ForEach ($Folder in $MyAlJtDataFolders) {
            [JtDataFolder]$MyJtDataFolder = $Folder

            $MyJtDataFolder.DoUpdateMeta()
        }
    }

    DoReportProblems([String]$TheFolderPath_Output) {
        [System.Collections.ArrayList]$MyAlJtDataFolders = $This.GetAlJtDataFolders()
        ForEach ($Folder in $MyAlJtDataFolders) {
            [JtDataFolder]$MyJtDataFolder = $Folder

            $MyJtDataFolder.DoCheck($TheFolderPath_Output)
        }
    }
    [Decimal]GetDecSize() {
        [JtIoFolder]$MyJtIoFolder = $This.JtIoFolder
        [Decimal]$MyDecSize = Get-JtFolderPath_Info_SizeGb -FolderPath $MyJtIoFolder
        Write-JtLog -Where $This.ClassName -Text "Size of $This.JtIoFolder  $MyDecSize"
        return $MyDecSize
    }
    
    [Decimal]GetIntFiles() {
        [JtIoFolder]$MyJtIoFolder = $This.JtIoFolder
        [Int32]$MyIntFiles = Get-JtFolderPath_Info_FilesCount -FolderPath $MyJtIoFolder
        Write-JtLog -Where $This.ClassName -Text "Number of files in $This.JtIoFolder  $MyIntFiles"
        return $MyIntFiles
    }
    
    [Decimal]GetIntFolders() {
        [JtIoFolder]$MyJtIoFolder = $This.JtIoFolder
        [Int32]$MyIntFiles = Get-JtFolderPath_Info_FilesCount -FolderPath $MyJtIoFolder
        Write-JtLog -Where $This.ClassName -Text "Number of files in $This.JtIoFolder  $MyIntFiles"
        return $MyIntFiles
    }
    
    [System.Collections.ArrayList]GetAlJtDataFolders() {
        return $This.GetAlJtDataFolders($Null)
    }

    [System.Collections.ArrayList]GetAlJtDataFolders([String]$TheExtension2) {
        [String]$MyExtension2 = $TheExtension2

        if (!($MyExtension2)) {
            $MyExtension2 = [JtIo]::FileExtension_Folder
        }

        [JtIoFolder]$MyJtIoFolder = $This.JtIoFolder

        [System.Collections.ArrayList]$MyAlJtDataFolders = New-Object System.Collections.ArrayList

        [String]$MyFilter = -join ("*", $MyExtension2)
        [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder -Filter $MyFilter -Recurse

        foreach ($File in $MyAlJtIoFiles) {
            [JtIoFile]$MyJtIoFile = $File
            [JtIoFolder]$MyJtIoFolder_Parent = $MyJtIoFile.GetJtIoFolder_Parent()
            [JtDataFolder]$MyJtDataFolder = New-JtDataFolder -FolderPath $MyJtIoFolder_Parent
            $MyAlJtDataFolders.Add($MyJtDataFolder) | Out-Null
        }
        [Int16]$MyIntNumber = $MyAlJtDataFolders.Count
        Write-JtLog -Where $This.ClassName -Text "Found $MyIntNumber datafolder(s) in $MyJtIoFolder"
        return $MyAlJtDataFolders
    }

    [System.Collections.ArrayList]GetAlJtDataFolders_Betrag() {
        [String]$MyExtension2 = [JtIo]::FileExtension_Folder_Betrag
        return $This.GetAlJtDataFolders($MyExtension2)
    }

    [System.Collections.ArrayList]GetAlJtDataFolders_Zahlung() {
        [String]$MyExtension2 = [JtIo]::FileExtension_Folder_Zahlung
        return $This.GetAlJtDataFolders($MyExtension2)
    }
    
    [System.Collections.ArrayList]GetAlJtIoFiles_Buchung() {
        [System.Collections.ArrayList]$MyAlJtIoFiles_Result = New-Object System.Collections.ArrayList
        [System.Collections.ArrayList]$MyAlJtDataFolders = $This.GetAlJtDataFolders()
        ForEach ($Folder in $MyAlJtDataFolders) {
            [JtDataFolder]$MyJtDataFolder = $Folder
            
            [System.Collections.ArrayList]$MyAlJtIoFiles = $MyJtDataFolder.GetAlJtIoFiles_Buchung()
            
            ForEach ($File in $MyAlJtIoFiles) {
                [JtIoFile]$MyJtIoFile = $File
                $MyAlJtIoFiles_Result.Add($MyJtIoFile) | Out-Null
            }
        }
        return $MyAlJtIoFiles_Result
    }

        
    [System.Collections.ArrayList]GetAlJtIoFiles_Meta() {
        [System.Collections.ArrayList]$MyAlJtIoFiles_Result = New-Object System.Collections.ArrayList
        [System.Collections.ArrayList]$MyAlJtDataFolders = $This.GetAlJtDataFolders()
        ForEach ($Folder in $MyAlJtDataFolders) {
            [JtDataFolder]$MyJtDataFolder = $Folder
            
            [System.Collections.ArrayList]$MyAlJtIoFiles = $MyJtDataFolder.GetAlJtIoFiles_Meta()
            
            ForEach ($File in $MyAlJtIoFiles) {
                [JtIoFile]$MyJtIoFile = $File
                $MyAlJtIoFiles_Result.Add($MyJtIoFile) | Out-Null
            }
        }
        return $MyAlJtIoFiles_Result
    }

    [String]GetLabel() {
        [String]$MyFolderPath = $This.JtIoFolder.GetPath()
        [String]$MyLabel = Convert-JtDotter -Text $MyFolderPath -PatternOut "1" -SeparatorIn "\" -Reverse
        return $MyLabel
    }
}

Function New-JtDataRepository {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath
    )
        
    # [String]$MyFunctionName = "New-JtDataFolder"
        
    [String]$MyFolderPath = $FolderPath

        
    [JtDataRepository]$MyJtDataRepository = [JtDataRepository]::new($MyFolderPath)
    
    Return , $MyJtDataRepository
}
    
    
class JtDataFolder : JtClass {
        
    [JtIoFolder]$JtIoFolder = $Null
        
    JtDataFolder([String]$TheFolderPath) {
        [String]$This.ClassName = "JtDataFolder"
        [String]$MyFolderPath = $TheFolderPath
        [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $MyFolderPath
            
        $This.JtIoFolder = $MyJtIoFolder
    }
        
    [Boolean]IsValid() {
        [Boolean]$MyBlnValid = $True
        if (!($This.JtIoFolder.IsExisting())) {
            return $False
        }

        [JtTemplateFile]$MyJtTemplateFile = Get-JtTemplateFile -FolderPath_Input $This.JtIoFolder
        if (!($MyJtTemplateFile.IsValid())) {
            return $False
        }
        return $MyBlnValid
    }

    [JtTemplateFile]GetJtTemplateFile() {
        [JtTemplateFile]$MyJtTemplateFile = Get-JtTemplateFile -FolderPath_Input $This.JtIoFolder
        return $MyJtTemplateFile
    }

    [System.Collections.ArrayList]GetAlJtIoFiles_Normal() {
        [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $This.JtIoFolder -Normal
        return $MyAlJtIoFiles
    }


    [Decimal]GetIntFiles() {
        [JtIoFolder]$MyJtIoFolder = $This.JtIoFolder
        [Int32]$MyIntFiles = Get-JtFolderPath_Info_FilesCount -FolderPath $MyJtIoFolder
        Write-JtLog -Where $This.ClassName -Text "Number of files in $This.JtIoFolder  $MyIntFiles"
        return $MyIntFiles
    }
    

    DoUpdateMeta() {
        [Boolean]$MyBlnUpdate = $False
        [JtTemplateFile]$MyJtTemplateFile = Get-JtTemplateFile -FolderPath_Input $This.JtIoFolder
        [String]$MyFilename_Template = $MyJtTemplateFile.GetName()
        if ($MyFilename_Template.EndsWith("BETRAG.folder")) {
            $MyBlnUpdate = $True
        }

        if ($MyFilename_Template.EndsWith("ZAHLUNG.folder")) {
            $MyBlnUpdate = $True
        }

        if ($MyBlnUpdate) {
            $MyAlYears = $This.GetAlYears()
            ForEach ($Year in $MyAlYears) {
                [String]$MyYear = $Year
                [String]$MyName = "BETRAG"
                [Decimal]$MyDecBetrag = $This.GetBetragForYear($MyYear)
                
                $MyParams = @{
                    FolderPath_Input  = $This.JtIoFolder
                    FolderPath_Output = $This.JtIoFolder
                    Name              = $MyName
                    Year              = $MyYear
                    Betrag            = $MyDecBetrag
                    # OnlyOne           = $True
                }
                Write-JtIoFile_Meta_Betrag_Year @MyParams
            }
        }
    }

    [Boolean]DoCheck([String]$TheFolderPath_Output) {
        [String]$MyFunctionName = "Test-JtFolder"
    
        [String]$MyFolderPath_Input = $This.JtIoFolder.GetPath()
        [String]$MyFolderPath_Output = $TheFolderPath_Output
        
        [String]$MyExtension = ".cmd"
        [String]$MyComputerName = Get-JtComputername
        [String]$MyFilename_Output = -join ("check", ".", $MyComputername, $MyExtension)
        [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyFolderPath_Output
        [String]$MyFilePath_Output = $MyJtIoFolder_Output.GetFilePath($MyFilename_Output)
    
    
        $MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyFolderPath_Input -Normal
        ForEach ($File_Content in $MyAlJtIoFiles) {
            [JtIoFile]$MyJtIoFile_Content = $File_Content
    
            # $MyJtTemplateFile.GetName()
            Write-JtLog -Where $MyFunctionName -Text "File_Content: $File_Content"
            [Boolean]$MyBlnIsFileOk = Test-JtFolder_File -FilePath_Input $MyJtIoFile_Content -FilePath_Output $MyFilePath_Output
            if (!($MyBlnIsFileOk)) {
                Write-JtLog_Error -Where $MyFunctionName -Text "Found (at least) one problem in folder... MyFolderPath_Input: $MyFolderPath_Input"
                Return $False
            }
        }
        Return $True
    }

    [Boolean]GetBlnSum() {
        [Boolean]$MyBlnSum = $False

        [JtTemplateFile]$MyJtTemplateFile = Get-JtTemplateFile -FolderPath_Input $This.JtIoFolder
        [String]$MyFilename_Template = $MyJtTemplateFile.GetName()
        if ($MyFilename_Template.EndsWith("BETRAG.folder")) {
            $MyBlnSum = $True
        }

        if ($MyFilename_Template.EndsWith("ZAHLUNG.folder")) {
            $MyBlnSum = $True
        }

        return $MyBlnSum
    }
        
    [System.Collections.ArrayList]GetAlYears() {
        [String]$MyFolderPath_Input = $This.JtIoFolder
            
        [JtList]$MyJtList = New-JtList
            
        [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyFolderPath_Input -Normal
        ForEach ($File in  $MyAlJtIoFiles) {
            [JtIoFile]$MyJtIoFile = $File
            [String]$MyFilename = $MyJtIoFile.GetName()
            $MyYear = Convert-JtFilename_To_Jahr -Filename $MyFilename
            $MyJtList.Add($MyYear)
        }
        [System.Collections.ArrayList]$MyAlYears = $MyJtList.GetValues()
        return $MyAlYears
    }

    [Decimal]GetBetragForYear([Int16]$TheIntYear) {
        [String]$MyFolderPath_Input = $This.JtIoFolder
        [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input
        [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder_Input -Normal

        [JtTemplateFile]$MyTemplateFile = Get-JtTemplateFile -FolderPath_Input $MyFolderPath_Input
    
        if (!($MyJtIoFolder_Input.IsExisting())) {
            Write-JtLog_Error -Where $This.ClassName -Text "Folder is not existing! MyJtIoFolder_Input: $MyJtIoFolder_Input"
            return 0
        }
        if (!($This.GetBlnSum())) {
            return 0
        }
        
        [Decimal]$MyDecResult = 0
        [String]$MyFilterPrefix = $TheIntYear 
    
        Foreach ($File in $MyAlJtIoFiles) {
            [JtIoFile]$MyJtIoFile = $File
            [Decimal]$MyDecBetrag = 0
    
            [String]$MyFilename = $MyJtIoFile.GetName()
            if ($MyFilename.StartsWith($MyFilterPrefix)) {
                [String]$MyPart = [JtIo]::FilePart_Betrag
                [String]$MyValue = $MyTemplateFile.GetValueFromFilenameForPart($MyFilename, $MyPart)
                if (!(Test-JtPart_IsValidAs_Betrag -Part $MyValue)) {
                    Return 99991
                }
                else {
                    [Decimal]$MyDecBetrag = Convert-JtPart_To_DecBetrag -Part $MyValue
                }
                $MyDecResult = $MyDecResult + $MyDecBetrag
            }
        }
        return $MyDecResult
    }

    [Decimal]GetBuchungForYear([Int16]$TheIntYear) {
        [String]$MyYear = [String]$TheIntYear
        [String]$MyFolderPath_Input = $This.JtIoFolder
        [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input
        
        if (!($MyJtIoFolder_Input.IsExisting())) {
            Write-JtLog_Error -Where $This.ClassName -Text "Folder is not existing! MyJtIoFolder_Input: $MyJtIoFolder_Input"
            return 0
        }
        if (!($This.GetBlnSum())) {
            return 0
        }
        
        [Decimal]$MyDecResult = 0
        
        [String]$MyPrefix = [JtIo]::FilePrefix_Buchung
        [String]$MyExtension = [JtIo]::FileExtension_Jpg
        [String]$MyFilter = -join ($MyPrefix, "*", $MyExtension)
        
        [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder_Input -Filter $MyFilter
        Foreach ($File in $MyAlJtIoFiles) {
            [JtIoFile]$MyJtIoFile = $File
            [String]$MyFilePath = $MyJtIoFile.GetPath()
            [Decimal]$MyDecBetrag = 0
    
            [String]$MyFilename = $MyJtIoFile.GetName()
            [String]$MyYear_File = Convert-JtDotter -Text $MyFilename -PatternOut "3" -Reverse
            if ($MyYear_File -eq $MyYear) {
                if (Test-JtFilename_IsContainingValid_Betrag -Filename $MyFilename) {
                    [Decimal]$MyDecBetrag = Convert-JtFilename_To_DecBetrag -Filename $MyFilename
                    return $MyDecBetrag
                }
                else {
                    Write-JtLog_Folder_Error -Where $This.ClassName -Text "Problem with file; EURO (in GetInfo) MyFolderPath_Input: $MyFolderPath_Input" -FilePath $MyFilePath
                    
                    Return 9991
                }
            }
        }
        return $MyDecResult
    }

    [System.Collections.ArrayList]GetAlJtIoFiles_Buchung() {
        [System.Collections.ArrayList]$MyAlJtIoFiles_Result = New-Object System.Collections.ArrayList
        [String]$MyPrefix = [JtIo]::FilePrefix_Buchung
        [String]$MyExtension = [JtIo]::FileExtension_Jpg
        [String]$MyFilter = -join ($MyPrefix, "*", $MyExtension)
        [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $This.JtIoFolder -Filter $MyFilter
        ForEach ($File in $MyAlJtIoFiles) {
            [JtIoFile]$MyJtIoFile = $File
            $MyAlJtIoFiles_Result.Add($MyJtIoFile) | Out-Null
        }
        return $MyAlJtIoFiles_Result
    }

    [System.Collections.ArrayList]GetAlJtIoFiles_Meta() {
        [System.Collections.ArrayList]$MyAlJtIoFiles_Result = New-Object System.Collections.ArrayList
        [String]$MyExtension = [JtIo]::FileExtension_Meta
        [String]$MyFilter = -join ("*", $MyExtension)
        [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $This.JtIoFolder -Filter $MyFilter
        ForEach ($File in $MyAlJtIoFiles) {
            [JtIoFile]$MyJtIoFile = $File
            $MyAlJtIoFiles_Result.Add($MyJtIoFile) | Out-Null
        }
        return $MyAlJtIoFiles_Result
    }
}

Function New-JtDataFolder {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath
    )

    # [String]$MyFunctionName = "New-JtDataFolder"

    [String]$MyFolderPath = $FolderPath
    
    [JtDataFolder]$MyJtDataFolder = [JtDataFolder]::new($MyFolderPath)
    Return , $MyJtDataFolder
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
    [String]$Filename_Template
    [Boolean]$BlnValid = $True

    JtTemplateFile([String]$TheFolderPath) {
        $This.ClassName = "JtTemplateFile"
        
        [String]$MyFolderPath = $TheFolderPath
        
        [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $MyFolderPath
        # Write-JtLog -Where $This.ClassName -Text "DoInit. Path: $FolderPath"
        $This.JtIoFile = $null
        
        [String]$MyExtension = [JtIo]::FileExtension_Folder
        [String]$MyFilter = -join ("*", $MyExtension)
        [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder -Filter $MyFilter
        if ($MyAlJtIoFiles.Count -gt 0) {
            $This.JtIoFile = $MyAlJtIoFiles[0]
            $This.BlnValid = $True
            $This.Filename_Template = $This.JtIoFile.GetName()
        }
        else {
            $This.BlnValid = $False
            Write-JtLog_Error -Where $This.ClassName -Text "Template file is missing. MyJtIoFolder: $MyJtIoFolder - MyFilter: $MyFilter"
        }
        $This.JtIoFolder = $MyJtIoFolder
    }

    [String]GetValueFromFilenameForPart([String]$TheFilename, [String]$ThePart) {
        [String]$MyFilename_Template = $This.GetFilename_template()
        [String]$MyFilename = $TheFilename
        [String]$MyPart = $ThePart

        [String]$MyMethodName = "GetValueFromFilenameForPart"

        [String]$MyResult = "ERROR"
        $MyAlParts_Template = $MyFilename_Template.Split(".")

        for ([Int16]$i = 0; $i -lt $MyAlParts_Template.Count; $i = $i + 1 ) {
        
            $MyPartInTemplate = Convert-JtDotter -Text $MyFilename_Template -PatternOut "$i"

            if ($MyPart -eq $MyPartInTemplate) {
                $MyValue = Convert-JtDotter -Text $MyFilename -PatternOut "$i"
                return $MyValue
            }
        }
        Write-JtLog_Error -Where $This.ClassName -Text "$MyMethodName - Problem. MyFilename: $MyFilename - MyFilename_Template: $MyFilename_Template - MyPart: $MyPart"
        return $MyResult
    }

    [Boolean]IsValid() {
        return $This.BlnValid
    }
    
    [JtColRen]GetJtColRenForColumnNumber([Int16]$IntCol) {
        [System.Collections.ArrayList]$MyAlJtColRens = $This.GetAlJtColRens()
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

    [System.Collections.ArrayList]GetAlJtColRens() {
        [System.Collections.ArrayList]$MyAlJtColRens = [System.Collections.ArrayList]::new()
        if (!($This.BlnValid)) {
            [JtIoFolder]$MyJtIoFolder = $This.JtIoFolder
            Write-JtLog_Error -Where $This.ClassName -Text "GetAlJtColRens. Not VALID; returning NULL at PATH: $MyJtIoFolder"
            return $Null
        }

        [String]$MyFilename_Template = $This.Filename_Template
        
        $MyAlParts_Template = $MyFilename_Template.Split(".")
        foreach ($Part in $MyAlParts_Template) {
            [String]$MyPart = $Part
            # Write-JtLog -Where $This.ClassName -Text "GetAlJtColRens. MyFilename_Template: $MyFilename_Template"
            [JtColRen]$MyJtColRen = Get-JtColRen -Part $MyPart
            $MyAlJtColRens.Add($MyJtColRen)
        }
        return $MyAlJtColRens
    }

    [Int16]GetIntParts() {
        [System.Collections.ArrayList]$MyAlJtColRens = $This.GetAlJtColRens()
        [Int32]$NumTemplateParts = $MyAlJtColRens.Count
        return $NumTemplateParts
    }

    [JtIoFolder]GetJtIoFolder() {
        return [JtIoFolder]$This.JtIoFolder
    }

    [String]GetName() {
        return $This.Filename_Template
    }

    [String]GetFilename_Template() {
        return $This.Filename_Template
    }


    [String]GetMessage_Error([String]$TheFilePath) {
        [String]$MyMessage = $Null

        [String]$MyFilePath_Input = $TheFilePath
        [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $MyFilePath_Input
        [String]$MyFilename = $MyJtIoFile.GetName()
        $MyAlFileNameParts = $MyFilename.Split(".")
        [Int16]$MyIntFilenameParts = $MyAlFileNameParts.Count
        
        [String]$MyFilename_Template = $This.GetName()
        
        [System.Collections.ArrayList]$MyAlColRens = $This.GetAlJtColRens()
        $MyAlTemplateParts = $MyFilename_Template.Split(".")
        [Int16]$MyIntTemplateParts = $MyAlTemplateParts.Count
        
        if ($MyIntFilenameParts -ne $MyIntTemplateParts) {
            $MyMessage = "Not in expected format. Parts in filename; MyIntFilenameParts: $MyIntFilenameParts - Parts in template; MyIntTemplateParts: $MyIntTemplateParts"
            return $MyMessage
        }
        for ([Int32]$i = 0; $i -lt $MyIntTemplateParts; $i++) {
            [String]$MyPart_Template = $MyAlTemplateParts[$i]
            [String]$MyPart_Filename = $MyAlFilenameParts[$i]
            [JtColRen]$MyJtColRen = $MyAlColRens[$i]
            [Boolean]$MyBlnValid = $MyJtColRen.CheckValid($MyPart_Filename)
            if (!($MyBlnValid)) {
                [String]$MyMessage = "Part in filename not valid. Part; MyPart_Template: $MyPart_Template - Value; MyPart_Filename: $MyPart_Filename"
                return $MyMessage
            }
        }
        return $MyMessage
    }

    [Boolean]IsFileValid([String]$TheFilePath) {
        [String]$MyFilePath_Input = $TheFilePath

        [String]$MyMessage_Error = $This.GetMessage_Error($MyFilePath_Input)
    
        if ($MyMessage_Error) {
            return $False
        }
        return $True
    }
}

Function Get-JtTemplateFile {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input
    )

    [String]$MyFolderPath_Input = $FolderPath_Input
        
    [JtTemplateFile]::new($MyFolderPath_Input)
}

Function New-JtTemplateFile {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Filename_Template
    )
    
    [String]$MyFunctionName = "New-JtTemplateFile"
        
    [String]$MyFolderPath_Output = $FolderPath_Output
    [String]$MyFilename_Template = $Filename_Template
        
    [JtTemplateFile]$MyTemplateFile = Get-JtTemplateFile -FolderPath $MyFolderPath_Output
    if (!($MyTemplateFile.IsValid())) {
        [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyFolderPath_Output
        [String]$MyFilePath_Output = $MyJtIoFolder_Output.GetFilePath($MyFilename_Template)
        Write-JtLog_File -Where $MyFunctionname -Text "Creating TemplateFile" -FilePath $MyFilePath_Output
        [String]$MyContent = Get-JtTimestamp
        $MyContent | Out-File -FilePath $MyFilePath_Output -Encoding utf8
    }
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

Export-ModuleMember -Function New-JtDataFolder
Export-ModuleMember -Function New-JtDataRepository

Export-ModuleMember -Function New-JtTemplateFile

