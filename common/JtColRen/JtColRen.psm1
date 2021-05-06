using module Jt 
using module JtIo


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


Function Get-JtColRen {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Part
    )
    
    [String]$MyPart = $Part
    $MyPart = $MyPart.Replace("_", "")
    $MyPart = $MyPart.Replace(" ", "")
    $MyPart = $MyPart.ToLower()


    if ($MyPart -eq "") {
        $MyPart = "EMPTY"
    }

    if ($MyPart -eq "_") {
        $MyPart = "EMPTY"
    }

    [JtColRen]$MyJtColRen = New-JtColRenInput_Text -Label $MyPart
    if ($MyPart -eq "preis") {
        $MyJtColRen = New-JtColRenInput_Betrag -Label "PREIS"
    }
    elseif ($MyPart -eq "folder") {
        $MyJtColRen = New-JtColRenInput_Text -Label "FOLDER"
    }
    elseif ($MyPart -eq "anzahl") {
        $MyJtColRen = New-JtColRenInput_Text -Label "ANZAHL" 
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
    elseif ($MyPart -eq "zahlung") {
        $MyJtColRen = New-JtColRenInput_Betrag -Label "ZAHLUNG"
    }
    return $MyJtColRen
}

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
        # if (!($TheHeader)) {
        #     $This.Header = $TheLabel
        # }
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
    
}

Function New-JtColRenFile_JtPreisliste_Price {
    
    [JtPreisliste]$MyJtPreisliste = Get-JtPreisliste
    [JtColRenFile_JtPreisliste_Price]::new($MyJtPreisliste)
}


Function Convert-JtFilePath_To_Value_Year {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FilePath
    )

    # [String]$MyFunctionName = "Convert-JtFilePath_To_Value_Year"

    [String]$MyFilePath = $FilePath
    [String]$MyFilename = Convert-JtFilePath_To_Filename -FilePath $MyFilePath
    [String]$MyResult = Convert-JtFilename_To_Jahr -Filename $MyFilename
    return $MyResult
}


class JtColRenInput_Bxh : JtColRen {

    JtColRenInput_Bxh() : Base("BxH") {
        $This.ClassName = "JtColRenInput_Bxh"
    }

    [Boolean]CheckValid([String]$TheValue) {
        [String]$MyValue = $TheValue
        [Boolean]$MyBlnValid = Test-JtPart_IsValidAs_Bxh -Part $MyValue
        return $MyBlnValid
    }

    [String]GetOutput([String]$TheValue) {
        return $TheValue
    }

}

Function New-JtColRenInput_Bxh {
    [JtColRenInput_Bxh]::new()
}

class JtColRenInput_Currency : JtColRen {

    JtColRenInput_Currency([String]$TheLabel) : Base($TheLabel) {
        $This.ClassName = "JtColRenInput_Currency"
    }

    [Boolean]CheckValid([String]$TheValue) {
        [String]$MyValue = $TheValue
        [Boolean]$MyBlnValid = Test-JtPart_IsValidAs_Betrag -Part $MyValue
        return $MyBlnValid
    }
    
    [String]GetOutput([String]$TheValue) {
        [String]$MyValue = $TheValue
        return Convert-JtString_To_Betrag -Text $MyValue
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

    [JtColRenInput_Currency]::new($MyLabel)
}



class JtColRenInput_Datum : JtColRen {
    
    JtColRenInput_Datum() : Base("DATUM") {
        $This.ClassName = "JtColRenInput_Datum"
    }
    
    [Boolean]CheckValid([String]$TheValue) {
        [String]$MyValue = $TheValue
        [Boolean]$MyBlnValid = Test-JtPart_IsValidAs_Date -Part $MyValue
        return $MyBlnValid
    }
    
    [String]GetOutput([String]$TheValue) {
        return $TheValue
    }
    
}

Function New-JtColRenInput_Datum {
    [JtColRenInput_Datum]::new()
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
}

Function New-JtColRenInput_Stand {
    [JtColRen_Input_Stand]::new()
}

class JtColRenInput_Text : JtColRen {
    
    JtColRenInput_Text([String]$TheLabel) : Base($TheLabel) {
        $This.ClassName = "JtColRenInput_Text"
    }

    JtColRenInput_Text([String]$TheLabel, [String]$TheHeader) : Base($TheLabel, $TheHeader) {
        $This.ClassName = "JtColRenInput_Text"
    }

    [String]GetOutput([String]$TheValue) {
        return $TheValue
    }
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
    [JtColRenInput_Text]::new($MyLabel, $MyHeader)
}

Function New-JtColRenInput_TextNr {
    [JtColRenInput_Text]::new("NR", "NR")
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
            [JtDataFolder]$MyJtDataFolder = Get-JtDataFolder -FolderPath $MyJtIoFolder_Parent
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

    
Function Get-JtDataRepository {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath
    )    
            
    # [String]$MyFunctionName = "Get-JtDataFolder"
            
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

    [Boolean]DoCheck([String]$TheFolderPath_Output) {
        [String]$MyMethodName = "DoCheck"
    
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
            Write-JtLog -Where $This.ClassName -Text "$MyMethodName. File_Content: $File_Content"
            [Boolean]$MyBlnIsFileOk = Test-JtFolder_File -FilePath_Input $MyJtIoFile_Content -FilePath_Output $MyFilePath_Output
            if (!($MyBlnIsFileOk)) {
                Write-JtLog_Error -Where $This.ClassName  -Text "$MyMethodName. Found (at least) one problem in folder... MyFolderPath_Input: $MyFolderPath_Input"
                Return $False
            }
        }
        Return $True
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

    [System.Collections.ArrayList]GetAlJtIoFiles_Normal() {
        [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $This.JtIoFolder -Normal
        return $MyAlJtIoFiles
    }    

    [System.Collections.ArrayList]GetAlJtDocuments() {
        [System.Collections.ArrayList]$MyAlJtIoFiles = $This.GetAlJtIoFiles_Normal()

        [System.Collections.ArrayList]$MyAlJtDocuments = New-Object System.Collections.ArrayList
        ForEach ($File in $MyAlJtIoFiles) {
            [JtIoFile]$MyJtIofile = $File
            [JtDocument]$MyJtDocument = New-JtDocument -FilePath $MyJtIofile
            $MyAlJtDocuments.Add($MyJtDocument) | Out-Null
        }

        return $MyAlJtDocuments
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

    [Decimal]GetIntFiles() {
        [JtIoFolder]$MyJtIoFolder = $This.JtIoFolder
        [Int32]$MyIntFiles = Get-JtFolderPath_Info_FilesCount -FolderPath $MyJtIoFolder
        Write-JtLog -Where $This.ClassName -Text "Number of files in $This.JtIoFolder  $MyIntFiles"
        return $MyIntFiles
    }    

    [JtTemplateFile]GetJtTemplateFile() {
        [JtTemplateFile]$MyJtTemplateFile = Get-JtTemplateFile -FolderPath_Input $This.JtIoFolder
        return $MyJtTemplateFile
    }        
        
    [String]GetName() {
        [JtIoFolder]$MyJtIoFolder = $This.JtIoFolder
        [String]$MyFilename = $MyJtIoFolder.GetName()
        return $MyFilename
    }

    [String]GetPath() {
        [JtIoFolder]$MyJtIoFolder = $This.JtIoFolder
        [String]$MyPath = $MyJtIoFolder.GetPath()
        return $MyPath
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

}

Function Get-JtDataFolder {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath
    )

    # [String]$MyFunctionName = "Get-JtDataFolder"

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





class JtDocument : JtClass {

    [JtIoFile]$JtIoFile = $Null
    [JtTemplateFile]$JtTemplateFile


    JtDocument([String]$TheFilePath) {
        [String]$MyFilepath = $TheFilePath
        $This.JtIoFile = New-JtIoFile -FilePath $MyFilepath

        [JtIoFolder]$MyJtIoFolder_Parent = $This.JtIoFile.GetJtIoFolder_Parent()

        [JtDataFolder]$MyJtDataFolder = Get-JtDataFolder -FolderPath $MyJtIoFolder_Parent
        $This.JtTemplateFile = $MyJtDataFolder.GetJtTemplateFile()
    }

    [String]GetValueForPart([String]$ThePart) {
        [String]$MyPart = $ThePart
        [String]$MyFilename = $ThePart
        [String]$MyValue = $This.JtTemplateFile.GetValueFromFilenameForPart($MyFilename, $MyPart)
        return $MyValue
    }

    [String]GetOutputForPart([String]$ThePart) {
        [String]$MyPart = $ThePart
        [String]$MyFilename = $ThePart
        [String]$MyValue = $This.JtTemplateFile.GetOutputFromFilenameForPart($MyFilename, $MyPart)
        return $MyValue
    }

    [String]GetPath() {
        [String]$MyPath = $This.JtIoFile.GetPath()
        return $MyPath
    }

    [String]GetName() {
        [String]$MyName = $This.JtIoFile.GetName()
        return $MyName
    }

    [String]GetPart1() {
        [String]$MyFilename = $This.GetName()
        [String]$MyResult = Convert-JtDotter -Text $MyFilename -PatternOut "1"
        return $MyResult
    }

    [String]GetPart([Int]$TheIntPos) {
        [Int]$MyIntPos = $TheIntPos
        [String]$MyFilename = $This.GetName()
        [String]$MyResult = Convert-JtDotter -Text $MyFilename -PatternOut "$MyIntPos"
        return $MyResult
    }

    [String]GetCol([Int]$TheIntPos) {
        [Int]$MyIntPos = $TheIntPos
        [String]$MyFilename_Template = $This.JtTemplateFile.GetName()
        [String]$MyResult = Convert-JtDotter -Text $MyFilename_Template -PatternOut "$MyIntPos"
        return $MyResult
    }

}


Function New-JtDocument {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FilePath
    )

    # [String]$MyFunctionName = "New-JtDocument"
    [String]$MyFilePath = $FilePath


    [JtDocument]::new($MyFilePath)
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
        [String]$MyMethodName = "GetValueFromFilenameForPart"

        [String]$MyFilename_Template = $This.GetFilename_template()
        [String]$MyFilename = $TheFilename
        [String]$MyPart = $ThePart

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

    [String]GetOutputFromFilenameForPart([String]$TheFilename, [String]$ThePart) {
        [String]$MyMethodName = "GetOutputFromFilenameForPart"

        [String]$MyFilename_Template = $This.GetFilename_template()
        [String]$MyFilename = $TheFilename
        [String]$MyPart = $ThePart

        [String]$MyResult = "ERROR"
        $MyAlParts_Template = $MyFilename_Template.Split(".")

        for ([Int16]$i = 0; $i -lt $MyAlParts_Template.Count; $i = $i + 1 ) {
        
            $MyPartInTemplate = Convert-JtDotter -Text $MyFilename_Template -PatternOut "$i"

            if ($MyPart -eq $MyPartInTemplate) {
                $MyValue = Convert-JtDotter -Text $MyFilename -PatternOut "$i"
                
                [JtColRen]$MyJtColRen = Get-JtColRen -Part $MyPart
                [String]$MyOutput = $MyJtColRen.GetOutput($MyValue)

                return $MyOutput
            }
        }
        Write-JtLog_Error -Where $This.ClassName -Text "$MyMethodName - Problem. MyFilename: $MyFilename - MyFilename_Template: $MyFilename_Template - MyPart: $MyPart"
        return $MyResult
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

            $MyPart
            try {
                [JtColRen]$MyJtColRen = Get-JtColRen -Part $MyPart
                $MyAlJtColRens.Add($MyJtColRen)
            }
            catch {
                Write-JtLog_Error -Where $This.ClassName -Text "Problem with MyPart: $MyPart"
            }
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

    [Boolean]IsValid() {
        return $This.BlnValid
    }
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

Function Get-JtTemplateFile {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input
    )

    [String]$MyFolderPath_Input = $FolderPath_Input
        
    [JtTemplateFile]::new($MyFolderPath_Input)
}



Function Convert-JtFilePath_To_Info_For_Part {
    Param (
        [CmdletBinding()]
        [Parameter(Mandatory = $True,ValueFromPipeline = $True)][ValidateNotNullOrEmpty()][String]$FilePath,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Part
    )
        

    process {

        [String]$MyFunctionName = "Convert-JtFilePath_To_Info_For_Part"
        
        [String]$MyFilePath = $FilePath
        [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $MyFilePath
        [String]$MyFilename = $MyJtIoFile.GetName()
        [JtIoFolder]$MyJtIoFolder_Parent = $MyJtIoFile.GetJtIoFolder_Parent()
        [JtTemplateFile]$MyJtTemplateFile = Get-JtTemplateFile -FolderPath_Input $MyJtIoFolder_Parent
        if(!($MyJtTemplateFile.IsValid())) {
            Write-JtLog_Error -Where $MyFunctionName -Text "Template is not valid. MyFilePath: $MyFilePath"
            return ""
        }
        [String]$MyFilename_Template = $MyJtTemplateFile.GetName()
        [String]$MyPart = $Part
        
        [String]$MyResult = "ERROR"
        $MyAlParts_Template = $MyFilename_Template.Split(".")
        
        for ([Int16]$i = 0; $i -lt $MyAlParts_Template.Count; $i = $i + 1 ) {
            [String]$MyPart_Template = Convert-JtDotter -Text $MyFilename_Template -PatternOut "$i"
            
            if ($MyPart_Template -eq $MyPart) {
                [String]$MyPart_Filename = Convert-JtDotter -Text $MyFilename -PatternOut "$i"
                return $MyPart_Filename
            }
        }
        Write-JtLog_Error -Where $MyFunctionName -Text "Problem. MyFilename: $MyFilename - MyFilename_Template: $MyFilename_Template - MyPart: $MyPart"
        return $MyResult
    }
}



Export-ModuleMember -Function Get-JtColRen
Export-ModuleMember -Function Get-JtDataFolder
Export-ModuleMember -Function Get-JtDataRepository
Export-ModuleMember -Function Get-JtPreisliste

Export-ModuleMember -Function New-JtPreisliste_Plotten_2022_01_01 
Export-ModuleMember -Function New-JtPreisliste_Plotten_2020_07_01

Export-ModuleMember -Function New-JtColRenFile_JtPreisliste
Export-ModuleMember -Function New-JtColRenFile_JtPreisliste_Ink
Export-ModuleMember -Function New-JtColRenFile_JtPreisliste_Paper
Export-ModuleMember -Function New-JtColRenFile_JtPreisliste_Price

Export-ModuleMember -Function New-JtColRenInput_Bxh
Export-ModuleMember -Function New-JtColRenInput_Betrag
Export-ModuleMember -Function New-JtColRenInput_Datum
Export-ModuleMember -Function New-JtColRenInput_Stand
Export-ModuleMember -Function New-JtColRenInput_Sum
Export-ModuleMember -Function New-JtColRenInput_Text
Export-ModuleMember -Function New-JtColRenInput_TextNr

Export-ModuleMember -Function New-JtDocument


Export-ModuleMember -Function Get-JtTemplateFile
Export-ModuleMember -Function New-JtTemplateFile

Export-ModuleMember -Function Convert-JtFilePath_To_Info_For_Part
