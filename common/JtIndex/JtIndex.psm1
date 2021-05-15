using module Jt  
using module JtColRen
using module JtIo
using module JtMd
using module JtTbl

Function Convert-JtFolderPath_To_Csv_Buchung {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    # [String]$MyFunctionName = "Convert-JtFolderPath_To_Csv_Buchung"

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output

    [JtDataRepository]$MyJtDataRepository = Get-JtDataRepository -FolderPath $MyFolderPath_Input

    [System.Collections.ArrayList]$MyAlJtIoFiles = $MyJtDataRepository.GetAlJtIoFiles_Buchung()

    Convert-JtAlJtIoFiles_to_FileCsv -ArrayList $MyAlJtIoFiles -FolderPath_Output $MyFolderPath_Output -Label "table.buchung_jpg"
}

Function Convert-JtFolderPath_To_AlJtIoFiles_Buchung {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input
    )

    [String]$MyFunctionName = "Convert-JtFolderPath_To_AlJtIoFiles_Buchung"

    [String]$MyFolderPath_Input = $FolderPath_Input

    [System.Collections.ArrayList]$MyAlJtIoFiles_Result = New-Object System.Collections.ArrayList
    [System.Collections.ArrayList]$MyAlJtDataFolders = Convert-JtFolderPath_To_AlJtDataFolders -FolderPath_Input $MyFolderPath_Input

    ForEach ($Folder in $MyAlJtDataFolders) {
        [JtDataFolder]$MyJtDataFolder = $Folder

        $MyAlJtIoFiles = $MyJtDataFolder.GetAlJtIoFiles_Buchung()
        ForEach ($File in $MyAlJtIoFiles) {
            [JtIoFile]$MyJtIoFile = $File
            $MyAlJtIoFiles_Result.Add($MyJtIoFile) | Out-Null
        }
    }
    [Int16]$MyIntNumber = $MyAlJtIoFiles_Result.Count
    Write-JtLog -Where $MyFunctionName -Text "Found $MyIntNumber buchung files(s) in $MyFolderPath_Input"
    return , $MyAlJtIoFiles_Result
}



Function Convert-JtFolderPath_To_AlJtIoFiles_Meta {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input
    )

    [String]$MyFunctionName = "Convert-JtFolderPath_To_AlJtIoFiles_Meta"

    [String]$MyFolderPath_Input = $FolderPath_Input

    
    [System.Collections.ArrayList]$MyAlJtIoFiles_Result = New-Object System.Collections.ArrayList
    [System.Collections.ArrayList]$MyAlJtDataFolders = Convert-JtFolderPath_To_AlJtDataFolders -FolderPath_Input $MyFolderPath_Input

    ForEach ($Folder in $MyAlJtDataFolders) {
        [JtDataFolder]$MyJtDataFolder = $Folder

        [System.Collections.ArrayList]$MyAlJtIoFiles = $MyJtDataFolder.GetAlJtIoFiles_Meta()
        ForEach ($File in $MyAlJtIoFiles) {
            [JtIoFile]$MyJtIoFile = $File
            $MyAlJtIoFiles_Result.Add($MyJtIoFile) | Out-Null
        }
    }
    [Int16]$MyIntNumber = $MyAlJtIoFiles_Result.Count
    Write-JtLog -Where $MyFunctionName -Text "Found $MyIntNumber meta files(s) in $MyFolderPath_Input"
    return , $MyAlJtIoFiles_Result
}



Function Convert-JtFolderPath_To_AlJtDataFolders {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input
    )

    [String]$MyFunctionName = "Convert-JtFolderPath_To_AlJtDataFolders"

    [String]$MyFolderPath_Input = $FolderPath_Input

    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input

    [String]$MyExtension = [JtIo]::FileExtension_Folder
    [String]$MyFilter = -join ("*", $MyExtension)
    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder_Input -Filter $MyFilter -Recurse

    [System.Collections.ArrayList]$MyAlJtDataFolders = New-Object System.Collections.ArrayList

    foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File
        [JtIoFolder]$MyJtIoFolder_Parent = $MyJtIoFile.GetJtIoFolder_Parent()
        [JtDataFolder]$MyJtDataFolder = Get-JtDataFolder -FolderPath $MyJtIoFolder_Parent
        $MyAlJtDataFolders.Add($MyJtDataFolder) | Out-Null
    }
    [Int16]$MyIntNumber = $MyJtDataFolders.Count
    Write-JtLog -Where $MyFunctionName -Text "Found $MyIntNumber datafolder(s) in $MyFolderPath_Input"
    return , $MyJtDataFolders
}

Function Convert-JtFolderPath_To_AlFoldertypes {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath
    )

    [String]$MyFilter = -join ("*", [JtIo]::FileExtension_Folder)
    [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $FolderPath
    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder -Filter $MyFilter -Recurse

    [JtList]$MyJtList = New-JtList

    foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File
        [String]$MyExtension2 = $MyJtIoFile.GetExtension2()
        $MyJtList.Add($MyExtension2)
    }
    return $MyJtList.GetValues()
}

Function Convert-JtFolderPath_To_AlTemplates {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath
    )
    [String]$MyFunctionName = "Convert-JtFolderPath_To_AlTemplates"

    [String]$MyFilter = -join ("*", [JtIo]::FileExtension_Folder)
    [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $FolderPath
    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder -Filter $MyFilter -Recurse

    [JtList]$MyJtList = New-JtList

    foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File
        [String]$MyFilename = $MyJtIoFile.GetName()        

        $MyJtList.Add($MyFilename)
    }
    return $MyJtList.GetValues()
}

Function Convert-JtFolderPath_To_AlYears {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input
    )

    [String]$MyFunctionName = "Convert-JtFolderPath_To_AlYears"

    [String]$MyFolderPath_Input = $FolderPath_Input

    Write-JtLog -Where $MyFunctionName -Text "Starting..."
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

Function Convert-JtFolderPath_To_Md_Betrag {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )
            
    [String]$MyFunctionName = "Convert-JtFolderPath_To_Md_Betrag"
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
    
    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input
    
    Write-JtLog -Where $MyFunctionName -Text "Start..."
    
    [String]$MyFoldername_Input = $MyJtIoFolder_Input.GetName()
    [String]$MyTitle = Convert-JtDotter -Text $MyFoldername_Input -PatternOut "3.4.5.6.7" -SeparatorOut " - "
    [String]$MyJahr = Convert-JtDotter -Text $MyFoldername_Input -PatternOut "7"
    [String]$MyBetrag = Convert-JtFolderPath_To_Decimal_Betrag_Part -FolderPath_Input $MyFolderPath_Input -Part "BETRAG"
    [JtMdDocument]$MyMdDoc = Get-JtTemplate_Md_Betrag -Title $MyTitle

    [String]$MyFolderPath_Parent = $MyJtIoFolder_Input.GetJtIoFolder_Parent().GetPath()
    [String]$MyPath = $MyFolderPath_Parent

    [JtTblTable]$MyJtTblTable = Convert-JtFolderPath_To_JtTblTable_Betrag -FolderPath_Input $MyFolderPath_Input
    [System.Data.Datatable]$MyDataTable = Convert-JtTblTable_To_Datatable -JtTblTable $MyJtTblTable
    [JtMdTable]$MyJtMdTable = New-JtMdTable -DataTable $MyDataTable
    [String]$MyTable_Output = $MyJtMdTable.GetOutput()

    $MyHashTable = @{
        Jahr   = $MyJahr
        Betrag = $MyBetrag
        Path   = $MyPath
        Table  = $MyTable_Output
    }

    $MyParams = @{
        Text    = $MyMdDoc.GetOutput()
        Replace = $MyHashTable
    }
    [String]$MyOutput = Convert-JtText_Template @MyParams
    
    $MyParams = @{
        FolderPath_Output = $MyFolderPath_Output
        Content           = $MyOutput
        Name              = "ABRECHNUNG"
        Extension2        = [JtIo]::FileExtension_Md_Abrechnung
        OnlyOne           = $True
    }
    Write-JtIoFile_Md @MyParams
}


Function Convert-JtFolderPath_To_Md_Test {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "Convert-JtFolderPath_To_Md_Test"
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
    
    Write-JtLog -Where $MyFunctionName -Text "Start..."
    
    [JtMdDocument]$MyMdDoc = Get-JtTemplate_Md -Title "Ordner"

    [String]$MyPath = $MyFolderPath_Input

    $MyAlYears = Convert-JtFolderPath_To_AlYears -FolderPath_Input $MyFolderPath_Input

    [String]$MyTables = ""
    
    ForEach ($Year in $MyAlYears) {
        [Int16]$MyYear = $Year

        
        [JtTblTable]$MyJtTblTable = Convert-JtFolderPath_To_JtTblTable_Betrag -FolderPath_Input $MyFolderPath_Input -Year $MyYear
        [System.Data.Datatable]$MyDataTable = Convert-JtTblTable_To_Datatable -JtTblTable $MyJtTblTable
        [JtMdTable]$MyJtMdTable = New-JtMdTable -DataTable $MyDataTable
        [String]$MyTable_Output = $MyJtMdTable.GetOutput()
        
    }
    $MyTables = $MyTables + $MyTable_Output

    $MyHashTable = @{
        Path  = $MyPath
        Table = $MyTables
    }
        
    $MyParams = @{
        Text    = $MyMdDoc.GetOutput()
        Replace = $MyHashTable
    }
    [String]$MyOutput = Convert-JtText_Template @MyParams

    $MyParams = @{
        FolderPath_Output = $MyFolderPath_Output
        Content           = $MyOutput
        Name              = "ABRECHNUNG"
        Extension2        = [JtIo]::FileExtension_Md
        # OnlyOne           = $True
    }
    Write-JtIoFile_Md @MyParams
}

Function Convert-JtFolderPath_To_Md_BxH {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "Convert-JtFolderPath_To_Md_BxH"
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
    
    Write-JtLog -Where $MyFunctionName -Text "Start..."
    
    [JtPreisliste]$MyJtPreisliste = Get-JtPreisliste
    
    [JtPreisliste]$MyJtPreisliste_Title = $MyJtPreisliste.GetTitle()
    [JtMdDocument]$MyMdDoc = Get-JtTemplate_Md_BxH -JtPreisliste_Title $MyJtPreisliste_Title

    [String]$MyUrl = "https://www.archland.uni-hannover.de/de/fakultaet/ausstattung/plotservice/"
    [String]$MyPath = $MyFolderPath_Input
    
    [JtTblTable]$MyJtTblTable = Convert-JtFolderPath_To_JtTblTable_BxH -FolderPath_Input $MyFolderPath_Input
    [System.Data.Datatable]$MyDataTable = Convert-JtTblTable_To_Datatable -JtTblTable $MyJtTblTable
    [JtMdTable]$MyJtMdTable = New-JtMdTable -DataTable $MyDataTable
    [String]$MyTable_Output = $MyJtMdTable.GetOutput()

    $MyHashTable = @{
        Url   = $MyUrl
        Path  = $MyPath
        Table = $MyTable_Output
    }

    $MyParams = @{
        Text    = $MyMdDoc.GetOutput()
        Replace = $MyHashTable
    }
    [String]$MyOutput = Convert-JtText_Template @MyParams

    $MyParams = @{
        FolderPath_Output = $MyFolderPath_Output
        Content           = $MyOutput
        Name              = "ABRECHNUNG"
        Extension2        = [JtIo]::FileExtension_Md_Bxh
        # OnlyOne           = $True
    }
    Write-JtIoFile_Md @MyParams
}

Function Convert-JtFolderPath_To_Md_Stunden {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )
            
    [String]$MyFunctionName = "Convert-JtFolderPath_To_Md_Stunden"
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
    
    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input
    
    Write-JtLog -Where $MyFunctionName -Text "Start..."
    
    [String]$MyFoldername_Input = $MyJtIoFolder_Input.GetName()
    [String]$MyTitle = Convert-JtDotter -Text $MyFoldername_Input -PatternOut "1.2.3.4.5" -SeparatorOut " - "
    [JtMdDocument]$MyMdDoc = Get-JtTemplate_Md_Stunden -Title $MyTitle

    [String]$MyFolderPath_Parent = $MyJtIoFolder_Input.GetJtIoFolder_Parent().GetPath()
    [String]$MyPath = $MyFolderPath_Parent

    [JtTblTable]$MyJtTblTable = Convert-JtFolderPath_To_JtTblTable_Stunden -FolderPath_Input $MyFolderPath_Input
    [System.Data.Datatable]$MyDataTable = Convert-JtTblTable_To_Datatable -JtTblTable $MyJtTblTable
    [JtMdTable]$MyJtMdTable = New-JtMdTable -DataTable $MyDataTable
    [String]$MyTable_Output = $MyJtMdTable.GetOutput()

    $MyHashTable = @{
        Path  = $MyPath
        Table = $MyTable_Output
    }

    $MyParams = @{
        Text    = $MyMdDoc.GetOutput()
        Replace = $MyHashTable
    }
    [String]$MyOutput = Convert-JtText_Template @MyParams
    
    $MyParams = @{
        FolderPath_Output = $MyFolderPath_Output
        Content           = $MyOutput
        Name              = "STUNDENZETTEL"
        Extension2        = [JtIo]::FileExtension_Md_Zahlung
        OnlyOne           = $True
    }
    Write-JtIoFile_Md @MyParams
}

   
Function Convert-JtFolderPath_To_Md_Zahlung {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )
            
    [String]$MyFunctionName = "Convert-JtFolderPath_To_Md_Zahlung"
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
    
    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input
    
    Write-JtLog -Where $MyFunctionName -Text "Start..."
    
    [String]$MyFoldername_Input = $MyJtIoFolder_Input.GetName()
    [String]$MyTitle = Convert-JtDotter -Text $MyFoldername_Input -PatternOut "3.4.5.6.7" -SeparatorOut " - "
    [String]$MyJahr = Convert-JtDotter -Text $MyFoldername_Input -PatternOut "7"
    [String]$MyMiete = Convert-JtFolderPath_To_Decimal_Betrag_Part -FolderPath_Input $MyFolderPath_Input -Part "MIETE"
    [JtMdDocument]$MyMdDoc = Get-JtTemplate_Md_Zahlung -Title $MyTitle

    [String]$MyFolderPath_Parent = $MyJtIoFolder_Input.GetJtIoFolder_Parent().GetPath()
    [String]$MyPath = $MyFolderPath_Parent

    [JtTblTable]$MyJtTblTable = Convert-JtFolderPath_To_JtTblTable_Zahlung -FolderPath_Input $MyFolderPath_Input
    [System.Data.Datatable]$MyDataTable = Convert-JtTblTable_To_Datatable -JtTblTable $MyJtTblTable
    [JtMdTable]$MyJtMdTable = New-JtMdTable -DataTable $MyDataTable
    [String]$MyTable_Output = $MyJtMdTable.GetOutput()

    $MyHashTable = @{
        Jahr  = $MyJahr
        Miete = $MyMiete
        Path  = $MyPath
        Table = $MyTable_Output
    }

    $MyParams = @{
        Text    = $MyMdDoc.GetOutput()
        Replace = $MyHashTable
    }
    [String]$MyOutput = Convert-JtText_Template @MyParams
    
    $MyParams = @{
        FolderPath_Output = $MyFolderPath_Output
        Content           = $MyOutput
        Name              = "ABRECHNUNG"
        Extension2        = [JtIo]::FileExtension_Md
        OnlyOne           = $True
    }
    Write-JtIoFile_Md @MyParams
}

Function Convert-JtFolderPath_To_Meta_Anzahl {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "Convert-JtFolderPath_To_Meta_Anzahl"

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output

    [String]$MyValue = Convert-JtFolderPath_To_Integer_Anzahl -FolderPath_Input $MyFolderPath_Input
    Write-JtLog -Where $MyFunctionName -Text "MyValue: $MyValue"

    # Remove-JtIoFiles_Meta -FolderPath $MyFolderPath_Output

    $MyParams = @{
        FolderPath_Input  = $MyFolderPath_Input
        FolderPath_Output = $MyFolderPath_Output
        Anzahl            = $MyValue
    }
    [String]$MyResult = Write-JtIoFile_Meta_Anzahl @MyParams

    # [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder_Input -Normal
    
    # [JtTblTable]$MyJtTblTable = Convert-JtFolderPath_To_JtTblTable_Anzahl -FolderPath_Input $MyFolderPath_Input
    # [System.Data.Datatable]$MyDataTable = Convert-JtTblTable_To_DataTable -JtTblTable $MyJtTblTable
    Write-Output $MyResult
}

Function Convert-JtFolderPath_To_Meta_Betrag {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )
    
    [String]$MyFunctionName = "Convert-JtFolderPath_To_Meta_Betrag"
    
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
        
    # Remove-JtIoFiles_Meta -FolderPath $MyFolderPath_Output
    
    [JtTemplateFile]$MyJtTemplateFile = Get-JtTemplateFile -FolderPath_Input $MyFolderPath_Input
    if (!($MyJtTemplateFile.IsValid())) {
        Write-JtLog_Error -Where $MyFunctionName -Text "MyJtTemplateFile is not valid at MyFolderPath_Input: $MyFolderPath_Input"
        return
    }
            
    $MyAlYears = Convert-JtFolderPath_To_AlYears -FolderPath_Input $MyFolderPath_Input
    ForEach ($Year in $MyAlYears) {
        [String]$MyYear = $Year
        [String]$MyName = "BETRAG"
        [Decimal]$MyDecBetrag = Convert-JtFolderPath_To_Decimal_Betrag_Part_For_Year -FolderPath_Input $MyFolderPath_Input -Year $MyYear

        $MyParams = @{
            FolderPath_Input  = $MyFolderPath_Input
            FolderPath_Output = $MyFolderPath_Output
            Name              = $MyName
            Year              = $MyYear
            Betrag            = $MyDecBetrag
            # OnlyOne           = $True
        }
        Write-JtIoFile_Meta_Betrag_Year @MyParams
    }
}

Function Convert-JtFolderPath_To_Meta_BxH {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )
    
    [String]$MyFunctionName = "Convert-JtFolderPath_To_Meta_BxH"

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
    
    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input

    if (!($MyJtIoFolder_Input.IsExisting())) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Folder does not exist!!! MyJtIoFolder_Input: $MyJtIoFolder_Input"
        return 
    }

    Write-JtLog -Where $MyFunctionName -Text "DoIt. ... for MyFolderPath_Input: $MyFolderPath_Input"

    [Decimal]$MyDecBetrag = Convert-JtFolderPath_To_Decimal_Betrag_BxH -FolderPath_Input $MyFolderPath_Input
    
    $MyParams = @{
        FolderPath_Input  = $MyFolderPath_Input
        FolderPath_Output = $MyFolderPath_Output
        Name              = "BETRAG"
        Betrag            = $MyDecBetrag
        Year              = "y"
    }
    Write-JtIoFile_Meta_Betrag @MyParams
}


Function Convert-JtFolderPath_To_Meta_Stunden {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "Convert-JtFolderPath_To_Meta_Stunden"

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
    
    Write-JtLog -Where $MyFunctionName -Text "Start. MyFolderPath_Input: $MyFolderPath_Input"
    
    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input
    [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyFolderPath_Output
    
    [String]$MyFolderPath_Input = $MyJtIoFolder_Input.GetPath()
    [String]$MyFolderPath_Output = $MyJtIoFolder_Output.GetPath()
    
    # Remove-JtIoFiles_Meta -FolderPath $MyFolderPath_Output
    
    $MyAlYears = Convert-JtFolderPath_To_AlYears -FolderPath_Input $MyFolderPath_Input
    ForEach ($MyYear in $MyAlYears) {

        [String]$MyPart = "SOLL"
        [Decimal]$MyDecBetrag = Convert-JtFolderPath_To_Decimal_Betrag_Part -FolderPath_Input $MyFolderPath_Input -Part $MyPart
        $MyParams = @{
            FolderPath_Input  = $MyFolderPath_Input
            FolderPath_Output = $MyFolderPath_Output
            Name              = $MyPart
            Year              = $MyYear
            Betrag            = $MyDecBetrag
        }
        Write-JtIoFile_Meta_Betrag @MyParams
        
        [String]$MyPart = "STUNDEN"
        [Decimal]$MyDecBetrag = Convert-JtFolderPath_To_Decimal_Betrag_Part -FolderPath_Input $MyFolderPath_Input -Part $MyPart
        $MyParams = @{
            FolderPath_Input  = $MyFolderPath_Input
            FolderPath_Output = $MyFolderPath_Output
            Name              = $MyPart
            Year              = $MyYear
            Betrag            = $MyDecBetrag
        }
        Write-JtIoFile_Meta_Betrag @MyParams
    }
}

Function Convert-JtFolderPath_To_Meta_Zahlung {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "Convert-JtFolderPath_To_Meta_Zahlung"

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
    
    Write-JtLog -Where $MyFunctionName -Text "Start. MyFolderPath_Input: $MyFolderPath_Input"
    
    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input
    [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyFolderPath_Output
    
    [String]$MyFolderPath_Input = $MyJtIoFolder_Input.GetPath()
    [String]$MyFolderPath_Output = $MyJtIoFolder_Output.GetPath()
    
    # Remove-JtIoFiles_Meta -FolderPath $MyFolderPath_Output
    
    $MyAlYears = Convert-JtFolderPath_To_AlYears -FolderPath_Input $MyFolderPath_Input
    ForEach ($MyYear in $MyAlYears) {

        [String]$MyPart = "MIETE"
        [Decimal]$MyDecBetrag = Convert-JtFolderPath_To_Decimal_Betrag_Part -FolderPath_Input $MyFolderPath_Input -Part $MyPart
        $MyParams = @{
            FolderPath_Input  = $MyFolderPath_Input
            FolderPath_Output = $MyFolderPath_Output
            Name              = $MyPart
            Year              = $MyYear
            Betrag            = $MyDecBetrag
        }
        Write-JtIoFile_Meta_Betrag @MyParams
        
        [String]$MyPart = "VORAUS"
        [Decimal]$MyDecBetrag = Convert-JtFolderPath_To_Decimal_Betrag_Part -FolderPath_Input $MyFolderPath_Input -Part $MyPart
        $MyParams = @{
            FolderPath_Input  = $MyFolderPath_Input
            FolderPath_Output = $MyFolderPath_Output
            Name              = $MyPart
            Year              = $MyYear
            Betrag            = $MyDecBetrag
        }
        Write-JtIoFile_Meta_Betrag @MyParams
        
        [String]$MyPart = "ZAHLUNG"
        [Decimal]$MyDecBetrag = Convert-JtFolderPath_To_Decimal_Betrag_Part -FolderPath_Input $MyFolderPath_Input -Part $MyPart
        $MyParams = @{
            FolderPath_Input  = $MyFolderPath_Input
            FolderPath_Output = $MyFolderPath_Output
            Name              = $MyPart
            Year              = $MyYear
            Betrag            = $MyDecBetrag
        }
        Write-JtIoFile_Meta_Betrag @MyParams
    }
}

Function Convert-JtFolderPath_To_Decimal_Betrag_BxH {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input
    )

    [String]$MyFunctionName = "Convert-JtFolderPath_To_Decimal_Betrag_BxH"

    [String]$MyFolderPath_Input = $FolderPath_input

    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input
    if (!($MyJtIoFolder_Input.IsExisting())) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Error!!! Please edit XML for MyJtIoFolder_Input: $MyJtIoFolder_Input"
        return "ERROR"
    }

    [JtColRen]$MyJtColRen = New-JtColRenFile_JtPreisliste_Price
    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyFolderPath_Input -Normal
    foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File
        [String]$MyFilePath = $MyJtIoFile.GetPath()

        [String]$MySheetPrice = $MyJtColRen.GetOutput($MyFilePath)
        [Decimal]$MyDecSheetPrice = Convert-JtString_To_Decimal -Text $MySheetPrice
        
        $MyDecPrice = $MyDecPrice + $MyDecSheetPrice
    }
    # [String]$MyBetrag = Convert-JtDecimal_To_String2 -Decimal $MyDecPrice
    [Decimal]$MyDecBetrag = $MyDecPrice
    return $MyDecBetrag
}

Function Convert-JtFolderPath_To_Decimal_Betrag_Part {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Part
    )
    begin
    {

    }
    process
    {

    [String]$MyFunctionName = "Convert-JtFolderPath_To_Decimal_Betrag_Part"

    [String]$MyFolderPath_Input = $FolderPath_input

    [String]$MyPart = $Part
    [Decimal]$MySum = 0
    if (!(Test-JtIoFolderPath -FolderPath $MyFolderPath_Input)) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Error!!! Please edit XML for MyFolderPath_Input: $MyJtIoFolder_Input"
        return 0
    }
    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyFolderPath_Input -Normal
    ForEach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File
        
        [String]$MyValue = Convert-JtFilePath_To_Info_For_Part -FilePath $MyJtIoFile -Part $MyPart
        if ($MyValue.Length -lt 1) {
            Write-JtLog_Error -Where $MyFunctionName -Text "MyValue is empty. MyColumn: $MyColumn - MyFilename: $MyFilename - MyFilename_Template: $MyFilename_Template"
            return -9999
        }
        else {
            [Decimal]$MyDecValue = Convert-JtString_To_Decimal -Text $MyValue -Part
            $MySum = $MySum + $MyDecValue
        }
    }
    [Decimal]$MyDecResult = $MySum
    return $MyDecResult
}
}

Function Convert-JtFolderPath_To_Decimal_Betrag_Part_For_Year {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][Int16]$Year
    )

    # [String]$MyFunctionName = "Convert-JtFolderPath_To_Decimal_Betrag_Part_For_Year"
    
    [JtDataFolder]$MyJtDataFolder = Get-JtDataFolder -FolderPath $MyFolderPath_Input
    [Decimal]$MyDecResult = $MyJtDataFolder.GetBetragForYear($MyIntYear)
    Return $MyDecResult
}


Function Convert-JtFolderPath_To_Integer_Anzahl {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input
    )

    [String]$MyFunctionName = "Convert-JtFolderPath_To_Integer_Anzahl"

    [String]$MyFolderPath_Input = $FolderPath_Input
        
    [Int16]$MyIntCount = 0
        
    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input
    if (!($MyJtIoFolder_Input.IsExisting())) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Error!!! Please edit XML for MyJtIoFolder_Input: $MyJtIoFolder_Input"
        return "ERROR"
    }

    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyFolderPath_Input -Normal
    ForEach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File
        [String]$MyFilename = $MyJtIoFile.GetName()
        if (Test-JtFilename_IsContainingValid_Anzahl -Filename $MyFilename) {
            [Int16]$MyIntAnz = Convert-JtFilename_To_IntAnzahl -Filename $MyFilename
            $MyIntCount = $MyIntCount + $MyIntAnz
        }
        else {
            [String]$MyMsg = "GetInfo. Problem with file. MyFilename: $MyFilename"
            [String]$MyFilePath = $MyJtIoFile.GetPath()
            Write-JtLog_Folder_Error -Where $MyFunctionName -Text $MyMsg -FilePath $MyFilePath
        }
    }
    return $MyIntCount
}

Function Convert-JtFolderPath_To_JtTblTable_Anzahl {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input
    )

    [String]$MyFunctionName = "Convert-JtFolderPath_To_JtTblTable_Anzahl"

    Write-JtLog -Where $MyFunctionName -Text "Start..."

    [String]$MyFolderPath_Input = $FolderPath_Input
    [JtTemplateFile]$MyJtTemplateFile = Get-JtTemplateFile -FolderPath_Input $MyFolderPath_Input

    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyFolderPath_Input -Normal
    [System.Collections.ArrayList]$MyAlJtColRens = $MyJtTemplateFile.GetAlJtColRens()
    
    if ($Null -eq $MyAlJtColRens) {
        Write-JtLog -Where $MyFunctionName -Text "MyAlJtColRens is NULL. MyFolderPath_Input: $MyFolderPath_Input"
        return $Null
    }
    
    [JtTblTable]$MyJtTblTable = New-JtTblTable -Label $MyFunctionName
    
    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyFolderPath_Input -Normal
    foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File
        [Boolean]$MyBlnFileOk = Test-JtFolder_File -FilePath_Input $MyJtIoFile
        if ($MyBlnFileOk) {
            [String]$MyFilename = $MyJtIoFile.GetName()
            Write-JtLog -Where $MyFunctionName -Text "______FileName: $MyFilename"
    
            $MyFilenameParts = $MyFilename.Split(".")
            [JtTblRow]$MyJtTblRow = New-JtTblRow
            for ([Int32]$j = 0; $j -lt $MyFilenameParts.Count; $j++) {
                [JtColRen]$MyJtColRen = $MyAlJtColRens[$j]
                [String]$MyLabel = $MyJtColRen.GetLabel()
                # $MyDataTable.Columns.Add($MyLabel, "String")
                [String]$MyValue = $MyAlJtColRens[$j].GetOutput($MyFilenameParts[$j])

                $MyJtTblRow.Add($MyLabel, $MyValue)
            }

            [String]$MyLabel = "JAHR"
            [String]$MyValue = Convert-JtFilePath_To_Value_Year -FilePath $MyJtIoFile.GetPath()
            $MyJtTblRow.Add($MyLabel, $MyValue)

            [String]$MyLabel = "ALTER"
            [String]$MyValue = Convert-JtFilePath_To_Value_Age -FilePath $MyJtIoFile.GetPath()
            $MyJtTblRow.Add($MyLabel, $MyValue)

            $MyJtTblTable.AddRow($MyJtTblRow)
        }
        else {
            Write-JtLog_Folder_Error -Where $MyFunctionName -Text "File is not valid." -FilePath $MyJtIoFile
        }
    }
    return , $MyJtTblTable
}


Function Convert-JtFolderPath_To_JtTblTable_Betrag {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][Int16]$Year

    )

    [String]$MyFunctionName = "Convert-JtFolderPath_To_JtTblTable_Betrag"

    [Int16]$MyIntYear = $Year
    [String]$MyYear = $Null
    if ($MyIntYear) {
        $MyYear = -join ("", $MyIntYear)
    }

    [String]$MyFolderPath_Input = $FolderPath_Input
    [System.Collections.ArrayList]$MyAlJtIoFiles = $Null
    if ($MyYear) {
        [String]$MyFilter = -join ($MyYear, "*")
        $MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyFolderPath_Input -Filter $MyFilter -Normal
    }
    else {
        $MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyFolderPath_Input -Normal
    }
    
    [JtTemplateFile]$MyJtTemplateFile = Get-JtTemplateFile -FolderPath_Input $MyFolderPath_Input
    [System.Collections.ArrayList]$MyAlJtColRens = $MyJtTemplateFile.GetAlJtColRens()
    
    [Int32]$MyIntLine = 1

    [JtTblTable]$MyJtTblTable = New-JtTblTable -Label $MyFunctionName
    foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File
        [Boolean]$MyBlnFileOk = Test-JtFolder_File -FilePath_Input $MyJtIoFile
        if ($MyBlnFileOk) {
            [JtTblRow]$MyJtTblRow = New-JtTblRow
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
        
    [String]$MyPart = "BETRAG"
    [Decimal]$MyDecBetrag = Convert-JtFolderPath_To_Decimal_Betrag_Part -FolderPath_Input $MyFolderPath_Input -Part $MyPart
    [String]$MyValue = Convert-JtDecimal_To_String2 -Decimal $MyDecBetrag
    $MyJtTblRow_Footer.Add($MyPart, $MyValue)

    $MyJtTblTable.AddRow($MyJtTblRow_Footer) | Out-Null

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
    $MyAlParts_Template = $MyFilename_Template.Split(".")
   
    [JtTblTable]$MyJtTblTable = New-JtTblTable -Label "JtTblTable_BxH"
    
    [Int32]$MyIntLine = 1
    
    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyFolderPath_Input -Normal
    foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File
        [Boolean]$MyBlnFileOk = Test-JtFolder_File -FilePath_Input $MyJtIoFile
        if ($MyBlnFileOk) {
            [JtTblRow]$MyJtTblRow = New-JtTblRow
            [String]$MyFilename = $MyJtIoFile.GetName()
            [String]$MyPath = $MyJtIoFile.GetPath()

            [JtColRen]$MyJtColRen = New-JtColRenInput_TextNr
            [String]$MyLabel = $MyJtColRen.GetLabel()
            [String]$MyValue = $MyIntLine
            $MyJtTblRow.Add($MyLabel, $MyValue) | Out-Null

            [JtColRen]$MyJtColRen = New-JtColRenFile_JtPreisliste_Price
            [String]$MyLabel = $MyJtColRen.GetLabel()
            [String]$MyPath = $MyJtIoFile.GetPath()
            [String]$MyValue = $MyJtColRen.GetOutput($MyPath)
            $MyJtTblRow.Add($MyLabel, $MyValue) | Out-Null
        
            $MyAlFilenameParts = $MyFilename.Split(".")
            for ($IntI = 0; $IntI -lt ($MyAlParts_Template.Count - 1); $IntI ++) {
                [String]$MyLabel = $MyAlParts_Template[$IntI]
                [JtColRen]$MyJtColRen = New-JtColRenInput_Text -Label $MyLabel
                [String]$MyValue = $MyAlFilenameParts[$IntI]
                $MyValue = $MyJtColRen.GetOutput($MyValue)
                $MyJtTblRow.Add($MyLabel, $MyValue) | Out-Null
            }
        
            [String]$MyLabel = "DIM"
            [String]$MyValue = Convert-JtFilePath_To_Value_DecQm -FilePath $MyPath
            $MyJtTblRow.Add($MyLabel, $MyValue) | Out-Null
        
            [JtColRen]$MyJtColRen = New-JtColRenFile_JtPreisliste_Paper
            [String]$MyLabel = $MyJtColRen.GetLabel()
            [String]$MyValue = $MyJtColRen.GetOutput($MyPath)
            $MyJtTblRow.Add($MyLabel, $MyValue) | Out-Null
        
            [JtColRen]$MyJtColRen = New-JtColRenFile_JtPreisliste_Ink
            [String]$MyLabel = $MyJtColRen.GetLabel()
            [String]$MyValue = $MyJtColRen.GetOutput($MyPath)
            $MyJtTblRow.Add($MyLabel, $MyValue) | Out-Null
        
            $MyJtTblTable.AddRow($MyJtTblRow) | Out-Null
            $MyIntLine = $MyIntLine + 1
        }
        else {
            Write-JtLog_Folder_Error -Where $MyFunctionName -Text "File is not valid." -FilePath $MyJtIoFile
        }
    }
    
    [JtTblRow]$MyJtTblRow = New-JtTblRow
    
    [JtColRen]$MyJtColRen = New-JtColRenInput_TextNr
    [String]$MyLabel = $MyJtColRen.GetLabel()
    [String]$MyValue = "SUM:"
    $MyJtTblRow.Add($MyLabel, $MyValue) | Out-Null
    
    [JtColRen]$MyJtColRen = New-JtColRenFile_JtPreisliste_Price
    [String]$MyLabel = $MyJtColRen.GetLabel()
    [Decimal]$MyDecBetrag = Convert-JtFolderPath_To_Decimal_Betrag_BxH -FolderPath_Input $MyFolderPath_Input
    [String]$MyValue = Convert-JtDecimal_To_String2 -Decimal $MyDecBetrag
    $MyJtTblRow.Add($MyLabel, $MyValue) | Out-Null
    
    [JtColRen]$MyJtColRen = New-JtColRenFile_JtPreisliste_Paper
    [String]$MyLabel = $MyJtColRen.GetLabel()
    [String]$MyValue = ""
    $MyJtTblRow.Add($MyLabel, $MyValue) | Out-Null
    
    [JtColRen]$MyJtColRen = New-JtColRenFile_JtPreisliste_Ink
    [String]$MyLabel = $MyJtColRen.GetLabel()
    [String]$MyValue = ""
    $MyJtTblRow.Add($MyLabel, $MyValue) | Out-Null

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
    
    [System.Collections.ArrayList]$MyAlJtColRens = $MyJtTemplateFile.GetAlJtColRens()
    if (!($MyAlJtColRens)) {
        Write-JtLog -Where $MyFunctionName -Text "MyAlJtColRens is NULL. MyJtIoFolder_Input: $MyJtIoFolder_Input"
        return $Null
    }
    
    [JtTblTable]$MyJtTblTable = New-JtTblTable -Label $MyFunctionName
    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyFolderPath_Input -Normal
    foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File
        [Boolean]$MyBlnFileOk = Test-JtFolder_File -FilePath_Input $MyJtIoFile

        if ($MyBlnFileOk) {
            [JtTblRow]$MyJtTblRow = New-JtTblRow 

            [String]$MyFilename = $MyJtIoFile.GetName()
            Write-JtLog -Where $MyFunctionName -Text "______ MyFileName: $MyFilename"

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

            [String]$MyLabel = "JAHR"
            [String]$MyValue = Convert-JtFilePath_To_Value_Year -FilePath $MyJtIoFile.GetPath()
            $MyJtTblRow.Add($MyLabel, $MyValue)

            [String]$MyLabel = "ALTER"
            [String]$MyValue = Convert-JtFilePath_To_Value_Age -FilePath $MyJtIoFile.GetPath()
            $MyJtTblRow.Add($MyLabel, $MyValue)
        
            $MyJtTblTable.AddRow($MyJtTblRow)
        }
        else {
            Write-JtLog_Folder_Error -Where $MyFunctionName -Text "File is not valid." -FilePath $MyJtIoFile
        }
    }
    return , $MyJtTblTable
}

Function Convert-JtFolderPath_To_JtTblTable_Filetypes {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Expected
    )

    [String]$MyFunctionName = "Convert-JtFolderPath_To_JtTblTable_Filetypes"

    [String]$MyLabel = $MyFunctionName
    [String]$MyFolderPath_Input = $FolderPath_Input

    [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $MyFolderPath_Input 
            
    [JtTblTable]$MyJtTblTable = New-JtTblTable -Label $MyLabel
    [String]$MyExpected = $Expected
    [Array]$MyAlExtensions_Expected = $MyExpected.Split(",")

    [System.Collections.ArrayList]$MyAlJtIoSubfolders = $MyJtIoFolder.GetAlJtIoFolders_Sub()
    foreach ($SubFolder in $MyAlJtIoSubfolders) {
        [JtIoFolder]$MyJtIoFolder = $SubFolder

        [JtTblRow]$MyJtTblRow = New-JtTblRow

        [String]$MyFoldername = $MyJtIoFolder.GetName()
        $MyJtTblRow.Add("NAME", $MyFoldername)
        # $MyJtTblRow.Add("Label", $MyLabel)

        [String]$MyExtension_Meta = [JtIo]::FileExtension_Meta
        # Generate columes for each expected type (X_pdf,X_jpg)
        foreach ($Extension in $MyAlExtensions_Expected) {
            [String]$MyExtension = $Extension
            [String]$MyLabelExtension = $MyExtension.Replace($MyExtension_Meta, "")

            $MyColumnName = -join ("x", $MyLabelExtension.ToUpper())
            $MyColumnName = $MyColumnName.Replace(".", "")
            $MyColumnValue = "-"
            [JtIoFile]$MyFile = $null
            [String]$MyFilter = -join ("*", $MyExtension)
            [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder -Filter $MyFilter 
            if ($MyAlJtIoFiles.Count -gt 0) {
                [JtIoFile]$MyFile = $MyAlJtIoFiles[0]
                $MyColumnValue = $MyFile.GetName()
                $MyColumnValue = $MyColumnValue.Replace("$MyExtension", "")
            }
            $MyJtTblRow.Add($MyColumnName, $MyColumnValue)
        }
        
        foreach ($Extension in $MyAlExtensions_Expected) {
            [String]$MyExtension = $Extension
            [String]$MyLabelExtension = $MyExtension.Replace($MyExtension_Meta, "")
            
            [String]$MyFilter = -join ("*", $MyExtension)
            [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder -Filter $MyFilter 
            [Int16]$MyIntCountForType = $MyAlJtIoFiles.Count
            
            $MyColumnName = -join ("y", $MyLabelExtension.ToUpper())
            $MyColumnName = $MyColumnName.Replace(".", "")
            $MyColumnValue = $MyIntCountForType
            $MyJtTblRow.Add($MyColumnName, $MyColumnValue)
        }
        $MyJtTblTable.AddRow($MyJtTblRow)
    }
    return , $MyJtTblTable 
}

Function Convert-JtFolderPath_To_JtTblTable_Stunden {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input
    )

    [String]$MyFunctionName = "Convert-JtFolderPath_To_JtTblTable_Stunden"

    [String]$MyFolderPath_Input = $FolderPath_Input
    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyFolderPath_Input -Normal
    
    [JtTemplateFile]$MyJtTemplateFile = Get-JtTemplateFile -FolderPath_Input $MyFolderPath_Input
    [System.Collections.ArrayList]$MyAlJtColRens = $MyJtTemplateFile.GetAlJtColRens()
    
    [Int32]$MyIntLine = 1

    [JtTblTable]$MyJtTblTable = New-JtTblTable -Label $MyFunctionName
    foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File
        [Boolean]$MyBlnFileOk = Test-JtFolder_File -FilePath_Input $MyJtIoFile
        if ($MyBlnFileOk) {
            [JtTblRow]$MyJtTblRow = New-JtTblRow
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
    $MyJtTblRow_Footer.Add($MyLabel, "(Nachname)") | Out-Null

    [Int32]$j = 2
    [String]$MyPart = "SOLL"
    [Decimal]$MyDecBetrag = Convert-JtFolderPath_To_Decimal_Betrag_Part -FolderPath_Input $MyFolderPath_Input -Part $MyPart
    [String]$MyValue = Convert-JtDecimal_To_String2 -Decimal $MyDecBetrag
    $MyJtTblRow_Footer.Add($MyPart, $MyValue) | Out-Null
        
    [Int32]$j = 3
    [String]$MyPart = "STUNDEN"
    [Decimal]$MyDecBetrag = Convert-JtFolderPath_To_Decimal_Betrag_Part -FolderPath_Input $MyFolderPath_Input -Part $MyPart
    [String]$MyValue = Convert-JtDecimal_To_String2 -Decimal $MyDecBetrag
    $MyJtTblRow_Footer.Add($MyPart, $MyValue) | Out-Null

    $MyJtTblTable.AddRow($MyJtTblRow_Footer) | Out-Null
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
    [System.Collections.ArrayList]$MyAlJtColRens = $MyJtTemplateFile.GetAlJtColRens()
    
    [Int32]$MyIntLine = 1

    [JtTblTable]$MyJtTblTable = New-JtTblTable -Label $MyFunctionName
    foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File
        [Boolean]$MyBlnFileOk = Test-JtFolder_File -FilePath_Input $MyJtIoFile
        if ($MyBlnFileOk) {
            [JtTblRow]$MyJtTblRow = New-JtTblRow
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
    [Decimal]$MyDecBetrag = Convert-JtFolderPath_To_Decimal_Betrag_Part -FolderPath_Input $MyFolderPath_Input -Part $MyPart
    [String]$MyValue = Convert-JtDecimal_To_String2 -Decimal $MyDecBetrag
    $MyJtTblRow_Footer.Add($MyPart, $MyValue) | Out-Null
        
    [Int32]$j = 5
    [String]$MyPart = "VORAUS"
    [Decimal]$MyDecBetrag = Convert-JtFolderPath_To_Decimal_Betrag_Part -FolderPath_Input $MyFolderPath_Input -Part $MyPart
    [String]$MyValue = Convert-JtDecimal_To_String2 -Decimal $MyDecBetrag
    $MyJtTblRow_Footer.Add($MyPart, $MyValue) | Out-Null
        
    [Int32]$j = 6
    [String]$MyPart = "ZAHLUNG"
    [Decimal]$MyDecBetrag = Convert-JtFolderPath_To_Decimal_Betrag_Part -FolderPath_Input $MyFolderPath_Input -Part $MyPart
    [String]$MyValue = Convert-JtDecimal_To_String2 -Decimal $MyDecBetrag
    $MyJtTblRow_Footer.Add($MyPart, $MyValue)

    $MyJtTblTable.AddRow($MyJtTblRow_Footer) | Out-Null

    return , $MyJtTblTable
}


Function Get-JtLabel_Anzahl {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Anzahl,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Year
    )

    # [String]$MyFunctionName = "Get-JtLabel_Anzahl"
    [String]$MyFolderName = $FolderName
    [String]$MyValue = $Anzahl
    [String]$MyYear = $Year

    $MyParams = @{
        Part1 = Convert-JtDotter -Text $MyFolderName -PatternOut "1" 
        Part2 = Convert-JtDotter -Text $MyFolderName -PatternOut "2" 
        Part3 = Convert-JtDotter -Text $MyFolderName -PatternOut "3" 
        Part4 = Convert-JtDotter -Text $MyFolderName -PatternOut "4" 
        Part5 = Convert-JtDotter -Text $MyFolderName -PatternOut "5" 
        Part6 = Convert-JtDotter -Text $MyFolderName -PatternOut "6" 
        Name  = "ANZAHL"
        Year  = $MyYear
        Value = $MyValue
    }
    [String]$MyLabel = Get-JtLabel_Xxx @MyParams
    return $MyLabel
}

Function Get-JtLabel_Betrag {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Name,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Year,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][Decimal]$Betrag
    )

    [Decimal]$MyDecBetrag = $Betrag
    [String]$MyName = $Name
    [String]$MyYear = $Year
    
    [String]$MyFolderPath_Input = $FolderPath_Input
    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input
    
    [String]$MyFolderName = $MyJtIoFolder_Input.GetName()

    # Convert-JtString_To_Betrag -Text $MyValue
    [String]$MyValue = Convert-JtDecimal_To_String2 -Decimal $MyDecBetrag

    $MyParams = @{
        Part1 = Convert-JtDotter -Text $MyFolderName -PatternOut "1"
        Part2 = Convert-JtDotter -Text $MyFolderName -PatternOut "2"
        Part3 = Convert-JtDotter -Text $MyFolderName -PatternOut "3"
        Part4 = Convert-JtDotter -Text $MyFolderName -PatternOut "4"
        Part5 = Convert-JtDotter -Text $MyFolderName -PatternOut "5"
        Part6 = Convert-JtDotter -Text $MyFolderName -PatternOut "6"
        Name  = $MyName
        Year  = $MyYear
        Value = $MyValue
    }
    [String]$MyLabel = Get-JtLabel_Xxx @MyParams
    return $MyLabel
}

Function Get-JtLabel_Xxx {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Part1,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Part2,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Part3,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Part4,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Part5,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Part6,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Name,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Year,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Value
    )

    # [String]$MyLabel = -join ($Part1, ".", $Part2, ".", $Part3, ".", $Part4, ".", $Part5, ".", $Part6, ".", $Name, ".", $Year, ".", $Value)
    [String]$MyLabel = -join ($Part1, ".", $Part2, ".", $Part3, ".", $Part4, ".", $Part5, ".", $Part6, ".", $Year, ".", $Value)
    return $MyLabel
}

Function Get-JtTemplate_Md {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Title
    )

    # [String]$MyFunctionName = "Get-JtTemplate_Md"
    [String]$MyTitle = $Title
    
    [JtMdDocument]$MyJtMdDoc = New-JtMdDocument -Title $MyTitle
    
    [String]$MyTimestamp = Get-JtTimestamp
    $MyJtMdDoc.AddLine("* Stand: $MyTimestamp")
    
    $MyJtMdDoc.AddLine("* Pfad: {path}")
    
    $MyJtMdDoc.AddH2("TABELLE")
    
    $MyJtMdDoc.AddLine("{table}")
    $MyJtMdDoc.AddH3("ZUAMMENFASSUNG")
    $MyJtMdDoc.AddLine("Summe für das Jahr __{jahr}__. Summe: __{betrag} Euro__")
    
    $MyJtMdDoc.AddLine("---")

    return , $MyJtMdDoc
}


Function Get-JtTemplate_Md_Betrag {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Title
    )

    # [String]$MyFunctionName = "Get-JtTemplate_Md_Zahlung"
    
    [JtMdDocument]$MyJtMdDoc = New-JtMdDocument -Title $MyTitle
    
    [String]$MyTimestamp = Get-JtTimestamp
    $MyJtMdDoc.AddLine("* Stand: $MyTimestamp")
    
    $MyJtMdDoc.AddLine("* Pfad: {path}")
    
    $MyJtMdDoc.AddH2("BETRÄGE")
    
    $MyJtMdDoc.AddLine("{table}")
    $MyJtMdDoc.AddH3("Zusammenfassung")
    $MyJtMdDoc.AddLine("Summe für das Jahr __{jahr}__. Summe: __{betrag} Euro__")
    
    $MyJtMdDoc.AddLine("---")

    return , $MyJtMdDoc
}

Function Get-JtTemplate_Md_BxH {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$JtPreisliste_Title
    )

    # [String]$MyFunctionName = "Get-JtTemplate_Md_BxH"
    [String]$MyJtPreisliste_Title = $JtPreisliste_Title
    
    [JtMdDocument]$MyJtMdDoc = New-JtMdDocument -Title "Fakultät für Architektur und Landschaft"
    $MyJtMdDoc.AddH2("Plot-Service - Abrechnung")
    $MyJtMdDoc.AddLine("Datum: {date}")
    $MyJtMdDoc.AddLine("{table}")
    $MyJtMdDoc.AddLine("---")
    $MyJtMdDoc.AddLine("Kunde")
    $MyJtMdDoc.AddLine("---")
    $MyJtMdDoc.AddLine("Plot-Service")
    $MyJtMdDoc.AddLine("---")    
    
    $MyJtMdDoc.AddLine("* Stand: {date}; Preisliste: $MyJtPreisliste_Title")
    
    $MyJtMdDoc.AddLine("* {path}")
    $MyJtMdDoc.AddLine("* {url}")
    return , $MyJtMdDoc
}

Function Get-JtTemplate_Md_Stunden {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Title
    )

    # [String]$MyFunctionName = "Get-JtTemplate_Md_Stunden"
    
    [JtMdDocument]$MyJtMdDoc = New-JtMdDocument -Title $MyTitle
    
    
    [String]$MyTimestamp = Get-JtTimestamp
    $MyJtMdDoc.AddLine("* Stand: $MyTimestamp")
    
    $MyJtMdDoc.AddLine("* Pfad: {path}")
    
    $MyJtMdDoc.AddH2("SOLL und STUNDEN")

    $MyJtMdDoc.AddLine("{table}")
    $MyJtMdDoc.AddLine("---")
    return $MyJtMdDoc
}

Function Get-JtTemplate_Md_Zahlung {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Title
    )

    # [String]$MyFunctionName = "Get-JtTemplate_Md_Zahlung"
    
    [JtMdDocument]$MyJtMdDoc = New-JtMdDocument -Title $MyTitle
    
    [String]$MyTimestamp = Get-JtTimestamp
    $MyJtMdDoc.AddLine("* Stand: $MyTimestamp")
    
    $MyJtMdDoc.AddLine("* Pfad: {path}")
    
    $MyJtMdDoc.AddH2("MIETE und VORAUS")
    $MyJtMdDoc.AddH3("Übersicht der Zahlungen")
    
    $MyJtMdDoc.AddLine("{table}")
    $MyJtMdDoc.AddH3("Zusammenfassung")
    $MyJtMdDoc.AddLine("Mieteinnahmen für das Jahr __{jahr}__. Summe: __{miete} Euro__")
    
    $MyJtMdDoc.AddLine("---")

    return $MyJtMdDoc
}

Function New-JtIndex_Anzahl {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "New-JtIndex_Anzahl"

    # [String]$MyLabel = "ANZAHL"

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output

    Write-JtLog -Where $MyFunctionName -Text "... for MyFolderPath_Input: $MyFolderPath_Input"
    # Convert-JtFolderPath_To_Csv_FileList -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output

    Convert-JtFolderPath_To_Meta_Anzahl -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
}


Function New-JtIndex_Betrag {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "New-JtIndex_Betrag"
    Write-JtLog -Where $MyFunctionName -Text "Starting..."

    # [String]$MyLabel = "BETRAG"

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output

    # Write-JtLog -Where $MyFunctionName -Text "... for MyFolderPath_Input: $MyFolderPath_Input"
    # Convert-JtFolderPath_To_Csv_FileList -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output

    Convert-JtFolderPath_To_Meta_Betrag -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
    Convert-JtFolderPath_To_Md_Betrag -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
}

Function New-JtIndex_BxH {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "New-JtIndex_BxH"

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output

    Write-JtLog -Where $MyFunctionName -Text "Starting..."

    # $This.Filename_Template = -join ("_NACHNAME.VORNAME.LABEL.PAPIER.BxH", [JtIo]::FileExtension_Folder)
    
    # [String]$MyLabel = "BxH"

    # Write-JtLog -Where $MyFunctionName -Text "... for MyFolderPath_Input: $MyFolderPath_Input"
    # Convert-JtFolderPath_To_Csv_FileList -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output

    Convert-JtFolderPath_To_Meta_BxH -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
    Convert-JtFolderPath_To_Md_BxH -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
}


Function New-JtIndex_Default {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "New-JtIndex_Default"
    Write-JtLog -Where $MyFunctionName -Text "Starting..."
    
    # [String]$MyLabel = "DEFAULT"

    Write-JtLog -Where $MyFunctionName -Text "Start..."

    # [String]$MyFolderPath_Input = $FolderPath_Input
    # [String]$MyFolderPath_Output = $FolderPath_Output

    # Convert-JtFolderPath_To_Csv_FileList -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
}

Function New-JtIndex_Stunden {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "New-JtIndex_Stunden"

    # [String]$MyLabel = "ZAHLUNG"

    Write-JtLog -Where $MyFunctionName -Text "Start..."

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output

    # Convert-JtFolderPath_To_Csv_FileList -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output

    Remove-JtIoFiles_Meta -FolderPath $MyFolderPath_Output

    Convert-JtFolderPath_To_Meta_Stunden -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
    Convert-JtFolderPath_To_Md_Stunden -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
}

Function New-JtIndex_Zahlung {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "New-JtIndex_Zahlung"

    # [String]$MyLabel = "ZAHLUNG"

    Write-JtLog -Where $MyFunctionName -Text "Start..."

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output

    # Convert-JtFolderPath_To_Csv_FileList -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output

    Convert-JtFolderPath_To_Meta_Zahlung -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
    Convert-JtFolderPath_To_Md_Zahlung -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
}



Function New-JtRepo_Report_Betraege {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Years
    )

    [String]$MyFunctionName = "New-JtRepo_Report_Betraege"
    
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
    [String]$MyYears = $Years
    
    [JtDataRepository]$MyJtDataRepository = Get-JtDataRepository -FolderPath $MyFolderPath_Input
    [System.Collections.ArrayList]$MyAlJtDataFolders = $MyJtDataRepository.GetAlJtDataFolders()

    [String]$MyLabel = $MyJtDataRepository.GetLabel()
    [JtTblTable]$MyJtTblTable = New-JtTblTable -Label $MyLabel
    [String]$MyLabel_Report = -join ($MyLabel, ".", "report", ".", "betraege")

    ForEach ($Folder in $MyAlJtDataFolders) {
        [JtDataFolder]$MyJtDataFolder = $Folder

        [JtTblRow]$MyJtTblRow = New-JtTblRow

        [String]$MyFoldername = $MyJtDataFolder.JtIoFolder.GetName()
        $MyJtTblRow.Add("FOLDERNAME", $MyFoldername)

        $MyAlYears = $MyYears.Split(".")
        [Int16]$MyIntScore = 0
        ForEach ($Year in $MyAlYears) {
            [Int16]$MyIntYear = [Int16]$Year
            [Decimal]$MyDecValue_Betrag = $MyJtDataFolder.GetBetragForYear($MyIntYear)
            [String]$MyValue = Convert-JtDecimal_To_String2 -Decimal $MyDecValue_Betrag
            $MyJtTblRow.Add("BETRAG$Year", $MyValue)
            
            [Int16]$MyIntYear = [Int16]$Year
            [Decimal]$MyDecValue_Buchung = $MyJtDataFolder.GetBuchungForYear($MyIntYear)
            [String]$MyValue = Convert-JtDecimal_To_String2 -Decimal $MyDecValue_Buchung
            $MyJtTblRow.Add("BUCHUNG$Year", $MyValue)
            
            if ($MyDecValue_Betrag -eq $MyDecValue_Buchung) {
                $MyJtTblRow.Add("CHECK$Year", "0")
            }
            else {
                $MyJtTblRow.Add("CHECK$Year", "1")
                $MyIntScore ++
            }
        }
        $MyJtTblRow.Add("PROBLEMS", $MyIntScore)
        
        [String]$MyPath = $MyJtDataFolder.JtIoFolder.GetPath()
        $MyJtTblRow.Add("PATH", $MyPath)
        $MyJtTblTable.AddRow($MyJtTblRow)
    }
    $MyDataTable = Convert-JtTblTable_To_Datatable -JtTblTable $MyJtTblTable
    Convert-JtDataTable_To_Csv -DataTable $MyDataTable -Label $MyLabel_Report -FolderPath_Output $MyFolderPath_Output
}


Function New-JtRepo_Report_Meta {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "New-JtRepo_Report_Meta"

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output

    [JtDataRepository]$MyJtDataRepository = Get-JtDataRepository -FolderPath $MyFolderPath_Input
    [String]$MyLabel = $MyJtDataRepository.GetLabel()
    [String]$MyExtension2 = [JtIo]::FileExtension_Meta_Report
    [String]$MyLabel_Report = -join ($MyLabel, $MyExtension2)

    [System.Collections.ArrayList]$MyAlJtIoFiles = $MyJtDataRepository.GetAlJtIoFiles_Meta()

    Write-JtLog -Where $MyFunctionName -Text "MyLabel_Report: $MyLabel_Report - MyJtIoFolder_Output: $MyJtIoFolder_Output"

    [JtTblTable]$MyJtTblTable = New-JtTblTable -Label $MyLabel_Report
    foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File

        [JtTblRow]$MyJtTblRow = Convert-JtFilePath_To_JtTblRow_Betrag -FilePath $MyJtIoFile
        $MyJtTblTable.AddRow($MyJtTblRow)
    }
    Convert-JtTblTable_To_Csv -JtTblTable $MyJtTblTable -FolderPath_Output $MyFolderPath_Output
}



Function New-JtRepo_Report_YyyJpg {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "New-JtRepo_Report_YyyJpg"
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
    
    [JtDataRepository]$MyJtDataRepository = Get-JtDataRepository -FolderPath $MyFolderPath_Input
    
    
    [System.Collections.ArrayList]$MyAlJtIoFiles_Buchung = $MyJtDataRepository.GetAlJtIoFiles_Buchung()

    [String]$MyLabel = $MyJtDataRepository.GetLabel()

    [String]$MyLabel_Report = -join ($MyLabel, ".", "report", ".", "yyyjpg")
    [JtTblTable]$MyJtTblTable = New-JtTblTable -Label $MyLabel_Report
    
    ForEach ($File in $MyAlJtIoFiles_Buchung) {
        [JtTblRow]$MyJtTblRow = New-JtTblRow

        [JtIoFile]$MyJtIoFile = $File

        [String]$MyFilename = $MyJtIoFile.GetName()

        [JtIoFolder]$MyJtIoFolder = $MyJtIoFile.GetJtIoFolder_Parent()
        [String]$MyFoldername = $MyJtIoFolder.GetName()
        $MyLabel_Folder = Convert-JtDotter $MyFoldername -PatternOut "1.2.3.4.5.6"
        $MyLabel_File = Convert-JtDotter $MyFilename -PatternOut "2.3.4.5.6.7"
        #        Write-Host $MyLabel_Folder "-" $MyLabel_File 
        #        Write-JtLog -Where $MyFunctionName -Text "File:  $MyLabel_File - $MyLabel_Folder"
        if ($MyLabel_Folder -ne $MyLabel_File) {
            Write-JtLog_Error -Where $MyFunctionName -Text "File: $MyJtIoFile"
            $MyJtTblRow.Add("FOLDERLABEL", $MyLabel_Folder)
            $MyJtTblRow.Add("FILELABEL", $MyLabel_File)
            $MyJtTblRow.Add("FOLDERPATH", $MyJtIoFolder)
            $MyJtTblTable.AddRow($MyJtTblRow)
        }
    }
    $MyDataTable = Convert-JtTblTable_To_Datatable -JtTblTable $MyJtTblTable
    [Int16]$MyIntRows = $MyDataTable.Rows.Count
    if ($MyIntRows -gt 0) {
        Convert-JtDataTable_To_Csv -DataTable $MyDataTable -FolderPath_Output $MyFolderPath_Output -Label $MyLabel_Report
    }
    else {
        Write-JtLog -Where $MyFunctionName -Text "Nothing to do. No rows."
    }
}

Function New-JtRepo_Report_Foldernames {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "New-JtRepo_Report_Foldernames"
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output

    [JtDataRepository]$MyJtDataRepository = Get-JtDataRepository -FolderPath $MyFolderPath_Input
    
    [String]$MyLabel = $MyJtDataRepository.GetLabel()
    [String]$MyLabel_Report = -join ($MyLabel, ".", "report", ".", "foldernames")

    [System.Collections.ArrayList]$MyAlJtDataFolders = $MyJtDataRepository.GetAlJtDataFolders()
    
    [JtTblTable]$MyJtTblTable = New-JtTblTable "foldernames"

    ForEach ($Folder in $MyAlJtDataFolders) {
        [JtDataFolder]$MyJtDataFolder = $Folder

        [JtTblRow]$MyJtTblRow = New-JtTblRow

        [String]$MyFoldername = $MyJtDataFolder.JtIoFolder.GetName()

        $MyPart = Convert-JtDotter $MyFoldername -PatternOut "1" -silent
        $MyJtTblRow.Add("ART", $MyPart)

        $MyPart = Convert-JtDotter $MyFoldername -PatternOut "2" -silent
        $MyJtTblRow.Add("WER", $MyPart)

        $MyPart = Convert-JtDotter $MyFoldername -PatternOut "3" -silent
        $MyJtTblRow.Add("KAT", $MyPart)

        $MyPart = Convert-JtDotter $MyFoldername -PatternOut "4" -silent
        $MyJtTblRow.Add("THEMA", $MyPart)

        $MyPart = Convert-JtDotter $MyFoldername -PatternOut "5" -silent
        $MyJtTblRow.Add("DET1", $MyPart)

        $MyPart = Convert-JtDotter $MyFoldername -PatternOut "6" -silent
        $MyJtTblRow.Add("DET2", $MyPart)
        
        $MyPart = Convert-JtDotter $MyFoldername -PatternOut "7" -silent
        $MyJtTblRow.Add("JAHR", $MyPart)

        $MyPart = Convert-JtDotter $MyFoldername -PatternOut "8" -silent
        $MyJtTblRow.Add("TYPE", $MyPart)
        
        $MyPart = Convert-JtDotter $MyFoldername -PatternOut "9" -Silent
        $MyJtTblRow.Add("INFO", $MyPart)
        
        $MyJtTblRow.Add("FOLDERNAME", $MyFoldername)
        $MyJtTblRow.Add("PARTS", ($MyFoldername.Split(".")).Count)
        
        [String]$MyPath = $MyJtDataFolder.JtIoFolder.GetPath()
        $MyJtTblRow.Add("PATH", $MyPath)
        $MyJtTblTable.AddRow($MyJtTblRow)
    }
    $MyDataTable = Convert-JtTblTable_To_Datatable -JtTblTable $MyJtTblTable
    Convert-JtDataTable_To_Csv -DataTable $MyDataTable -Label $MyLabel_Report -FolderPath_Output $MyFolderPath_Output
}


Function New-JtRepo_Report_NormalFiles {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "New-JtRepo_Report_NormalFiles"
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output

    [JtDataRepository]$MyJtDataRepository = Get-JtDataRepository -FolderPath $MyFolderPath_Input
    
    [String]$MyLabel = $MyJtDataRepository.GetLabel()
    [String]$MyLabel_Report = -join ($MyLabel, ".", "report", ".", "normalfiles")

    [System.Collections.ArrayList]$MyAlJtDataFolders = $MyJtDataRepository.GetAlJtDataFolders()
    
    [JtTblTable]$MyJtTblTable = New-JtTblTable "normalfiles"

    ForEach ($Folder in $MyAlJtDataFolders) {
        [JtDataFolder]$MyJtDataFolder = $Folder

        [String]$MyFolderPath = $MyJtDataFolder.GetPath()
        [JtTblRow]$MyJtTblRow = New-JtTblRow

        $MyAlJtIoFiles = $MyJtDataFolder.GetAlJtIoFiles_Normal()

        [JtTemplateFile]$MyJtTemplateFile = $MyJtDataFolder.GetJtTemplateFile()
        [String]$MyFilename_Template = $MyJtTemplateFile.GetName()

        ForEach ($File in $MyAlJtIoFiles) {
            [JtIoFile]$MyJtIoFile = $File
            ForEach ($i in 1..9) {
                [String]$MyFilename = $MyJtIoFile.GetName()
                $MyPart = Convert-JtDotter $MyFilename -PatternOut "$i" -silent
                $MyJtTblRow.Add("F$i", $MyPart)
            }

            ForEach ($i in 1..9) {
                $MyPart = Convert-JtDotter $MyFilename_Template -PatternOut "$i" -silent
                $MyJtTblRow.Add("T$i", $MyPart)
            }
            $MyJtTblRow.Add("Template", $MyFilename_Template)
            $MyJtTblRow.Add("Filename", $MyFilename)
            $MyJtTblRow.Add("FilePath", $MyJtIoFile.GetPath())
            $MyJtTblRow.Add("Foldername", $MyJtDataFolder.GetName())
            $MyJtTblRow.Add("FolderPath", $MyFolderPath)

            
            # [String]$MyFoldername = $MyJtDataFolder.JtIoFolder.GetName()
            
            # $MyPart = Convert-JtDotter $MyFoldername -PatternOut "1" -silent
            # $MyJtTblRow.Add("ART", $MyPart)
            
            # $MyPart = Convert-JtDotter $MyFoldername -PatternOut "2" -silent
            # $MyJtTblRow.Add("WER", $MyPart)
            
            # $MyPart = Convert-JtDotter $MyFoldername -PatternOut "3" -silent
            # $MyJtTblRow.Add("KAT", $MyPart)
            
            # $MyPart = Convert-JtDotter $MyFoldername -PatternOut "4" -silent
            # $MyJtTblRow.Add("THEMA", $MyPart)
            
            # $MyPart = Convert-JtDotter $MyFoldername -PatternOut "5" -silent
            # $MyJtTblRow.Add("DET1", $MyPart)
            
            # $MyPart = Convert-JtDotter $MyFoldername -PatternOut "6" -silent
            # $MyJtTblRow.Add("DET2", $MyPart)
            
            # $MyPart = Convert-JtDotter $MyFoldername -PatternOut "7" -silent
            # $MyJtTblRow.Add("JAHR", $MyPart)
            
            # $MyPart = Convert-JtDotter $MyFoldername -PatternOut "8" -silent
            # $MyJtTblRow.Add("TYPE", $MyPart)
            
            # $MyPart = Convert-JtDotter $MyFoldername -PatternOut "9" -Silent
            # $MyJtTblRow.Add("INFO", $MyPart)
            
            # $MyJtTblRow.Add("FOLDERNAME", $MyFoldername)
            # $MyJtTblRow.Add("PARTS", ($MyFoldername.Split(".")).Count)
            
            # [String]$MyPath = $MyJtDataFolder.JtIoFolder.GetPath()
            # $MyJtTblRow.Add("PATH", $MyPath)
            if ($MyAlJtIoFiles.Count -gt 0) {
                $MyJtTblTable.AddRow($MyJtTblRow)
            }
            else {
                Write-JtLog_Error -Where $MyFunctionName -Text "Folder has no NormalFiles. MyFolderPath: $MyFolderPath"
            }
        }
        
    }
    $MyDataTable = Convert-JtTblTable_To_Datatable -JtTblTable $MyJtTblTable
    Convert-JtDataTable_To_Csv -DataTable $MyDataTable -Label $MyLabel_Report -FolderPath_Output $MyFolderPath_Output
}

Function New-JtRepo_Report_Repo {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "New-JtRepo_Report_Repo"

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
    

    [JtDataRepository]$MyJtDataRepository = Get-JtDataRepository -FolderPath $MyFolderPath_Input

    [System.Collections.ArrayList]$MyAlJtDataFolders = $MyJtDataRepository.GetAlJtDataFolders()
    [String]$MyLabel = $MyJtDataRepository.GetLabel()

    [String]$MyLabel_Report = -join ($MyLabel, ".", "report", ".", "repo")
    
    [JtTblTable]$MyJtTblTable = New-JtTblTable -Label $MyLabel_Report

    ForEach ($Folder in $MyAlJtDataFolders) {
        [JtDataFolder]$MyJtDataFolder = $Folder

        [JtTblRow]$MyJtTblRow = New-JtTblRow

        [String]$MyFoldername = $MyJtDataFolder.JtIoFolder.GetName()
        $MyJtTblRow.Add("FOLDERNAME", $MyFoldername)

        [String]$MyPath = $MyJtDataFolder.JtIoFolder.GetPath()
        $MyJtTblRow.Add("PATH", $MyPath)

        # [System.Collections.ArrayList]$MyJtDataFolder.GetAlJtIoFiles()
        [Int16]$MyIntFiles = $MyJtDataFolder.GetIntFiles()
        $MyJtTblRow.Add("FILES", $MyIntFiles)
        
        $MyJtTblTable.AddRow($MyJtTblRow)
    }
    $MyDataTable = Convert-JtTblTable_To_Datatable -JtTblTable $MyJtTblTable
    Convert-JtDataTable_To_Csv -DataTable $MyDataTable -Label $MyLabel_Report -FolderPath_Output $MyFolderPath_Output
}


Function New-JtRepo_Report_Parts {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "New-JtRepo_Report_Parts"

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output

    [JtDataRepository]$MyJtDataRepository = Get-JtDataRepository -FolderPath $MyFolderPath_Input
    [String]$MyLabel = $MyJtDataRepository.GetLabel()

    $MyAlTemplates = Convert-JtFolderPath_To_AlTemplates -FolderPath $MyFolderPath_Input

    [String]$MyLabel_Report = -join ($MyLabel, ".", "report", ".", "parts")

    [JtList]$MyJtList = New-JtList
    ForEach ($Template in $MyAlTemplates) {
        [String]$MyTemplate = $Template

        $MyAlParts = $MyTemplate.Split(".")
        ForEach ($Part in $MyAlParts) {
            [String]$MyPart = $Part
            $MyJtList.Add($MyPart)
        }
    }
    $MyAlParts_All = $MyJtList.GetValues()
    [JtTblTable]$MyJtTblTable = New-JtTblTable -Label $MyLabel_Report

    ForEach ($Part in $MyAlParts_All) {
        [String]$MyPart = $Part

        $MyPart
        try {
    
            Get-JtColRen -Part $MyPart
        }
        catch {
            $MyPart

        }

        [JtTblRow]$MyJtTblRow = New-JtTblRow

        $MyJtTblRow.Add("PART", $MyPart)
        
        $MyJtTblTable.AddRow($MyJtTblRow)
    }
    $MyDataTable = Convert-JtTblTable_To_Datatable -JtTblTable $MyJtTblTable
    Convert-JtDataTable_To_Csv -DataTable $MyDataTable -Label $MyLabel_Report -FolderPath_Output $MyFolderPath_Output
}

Function New-JtRepo_Report_Templates {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "New-JtRepo_Report_Templates"

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output

    [JtDataRepository]$MyJtDataRepository = Get-JtDataRepository -FolderPath $MyFolderPath_Input
    [String]$MyLabel = $MyJtDataRepository.GetLabel()

    $MyAlTemplates = Convert-JtFolderPath_To_AlTemplates -FolderPath $MyFolderPath_Input

    [String]$MyLabel_Report = -join ($MyLabel, ".", "report", ".", "templates")
    
    [JtTblTable]$MyJtTblTable = New-JtTblTable -Label $MyLabel_Report

    ForEach ($Folder in $MyAlTemplates) {
        [String]$MyFoldertype = $Folder

        [JtTblRow]$MyJtTblRow = New-JtTblRow

        $MyJtTblRow.Add("FOLDERNAME", $MyFoldertype)
        
        $MyJtTblTable.AddRow($MyJtTblRow)
    }
    $MyDataTable = Convert-JtTblTable_To_Datatable -JtTblTable $MyJtTblTable
    Convert-JtDataTable_To_Csv -DataTable $MyDataTable -Label $MyLabel_Report -FolderPath_Output $MyFolderPath_Output
}

Function New-JtRepo_Report_Foldertypes {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "New-JtRepo_Report_Foldertypes"

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output

    [JtDataRepository]$MyJtDataRepository = Get-JtDataRepository -FolderPath $MyFolderPath_Input
    [String]$MyLabel = $MyJtDataRepository.GetLabel()

    $MyAlFoldertypes = Convert-JtFolderPath_To_AlFoldertypes -FolderPath $MyFolderPath_Input

    [String]$MyLabel_Report = -join ($MyLabel, ".", "report", ".", "foldertypes")
    
    [JtTblTable]$MyJtTblTable = New-JtTblTable -Label $MyLabel_Report

    ForEach ($Folder in $MyAlFoldertypes) {
        [String]$MyFoldertype = $Folder

        [JtTblRow]$MyJtTblRow = New-JtTblRow

        $MyJtTblRow.Add("FOLDERTYPE", $MyFoldertype)
        
        $MyJtTblTable.AddRow($MyJtTblRow)
    }
    $MyDataTable = Convert-JtTblTable_To_Datatable -JtTblTable $MyJtTblTable
    Convert-JtDataTable_To_Csv -DataTable $MyDataTable -Label $MyLabel_Report -FolderPath_Output $MyFolderPath_Output
}

Function New-JtRepo_Report_Problems {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "New-JtRepo_Report_Problems"

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output

    [JtDataRepository]$MyJtDataRepository = Get-JtDataRepository -FolderPath $MyFolderPath_Input
    [String]$MyLabel = $MyJtDataRepository.GetLabel()
    [String]$MyLabel_Report = -join ($MyLabel, ".", "report", ".", "problems")
    [JtTblTable]$MyJtTblTable = New-JtTblTable -Label $MyLabel_Report
    [Int16]$MyIntProblems = 0

    $MyAlJtDataFolders = $MyJtDataRepository.GetAlJtDataFolders()
    ForEach ($Folder in $MyAlJtDataFolders) {
        [JtDataFolder]$MyJtDataFolder = $Folder
        [JtTemplateFile]$MyJtTemplateFile = $MyJtDataFolder.GetJtTemplateFile()
        $MyAlJtIoFiles = $MyJtDataFolder.GetAlJtIoFiles_Normal()

        foreach ($File in $MyAlJtIoFiles) {
            [JtIoFile]$MyJtIoFile = $File
            $MyJtIoFile
            [String]$MyMessage = $MyJtTemplateFile.GetMessage_Error($MyJtIoFile)
            if ($MyMessage) {
                [JtTblRow]$MyJtTblRow = New-JtTblRow
                $MyJtTblRow.Add("FILENAME", $MyJtIoFile.GetName())
                $MyJtTblRow.Add("MESSAGE", $MyMessage)
                $MyJtTblRow.Add("FILEPATH", $MyJtIoFile.GetPath())
                $MyJtTblRow.Add("FOLDERPATH", $MyJtDataFolder.JtIoFolder.GetPath())

                $MyJtTblTable.AddRow($MyJtTblRow)
                $MyIntProblems ++
            }
        }
    }
    if ($MyIntProblems -gt 0) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Number of problems found. MyIntProblems: $MyIntProblems"
        $MyDataTable = Convert-JtTblTable_To_Datatable -JtTblTable $MyJtTblTable
        Convert-JtDataTable_To_Csv -DataTable $MyDataTable -Label $MyLabel_Report -FolderPath_Output $MyFolderPath_Output
    }
    else {
        Write-JtLog -Where $MyFunctionName -Text "No problems found for repo $MyLabel"
    }
}

Function Test-JtFolder {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    # [String]$MyFunctionName = "Test-JtFolder"
    
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output

    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input 
    # [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyFolderPath_Output 

    [String]$MyFilter = -join ("*", [JtIo]::FileExtension_Folder)
    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder_Input -Filter $MyFilter -Recurse
    
    foreach ($File_Folder in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile_Folder = $File_Folder
        [JtIoFolder]$MyJtIoFolder_Parent = $MyJtIoFile_Folder.GetJtIoFolder_Parent()

        [JtDataFolder]$MyJtDataFolder = Get-JtDataFolder -FolderPath $MyJtIoFolder_Parent

        [Boolean]$MyBlnCheck = $MyJtDataFolder.DoCheck($MyFolderPath_Output)
        if (!($MyBlnCheck)) {
            return $False
        }
    }
}

Function Test-JtFolder_Recurse {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "Test-JtFolder_Recurse"

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_input
    if ($FolderPath_Output) { 
        $MyFolderPath_Output = $FolderPath_Output
    }

    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input
    

    [String]$MyExtension = [JtIo]::FileExtension_Folder
    [String]$MyFilter = -join ("*", $MyExtension)
    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder_Input -Filter $MyFilter -Recurse

    [Int16]$MyIntProblems = 0
    foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File
        [JtIoFolder]$MyJtIoFolder_Parent = $MyJtIoFile.GetJtIoFolder_Parent()

        [Int16]$MyIntFolderSum = Test-JtFolder -FolderPath_Input $MyJtIoFolder_Parent -FolderPath_Output $MyFolderPath_Output
        $MyIntProblems = $MyIntProblems + $MyIntFolderSum
    }

    if ($MyIntProblems -gt 0) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Number of problems found. MyIntProblems: $MyIntProblems"
    }
}

Function Test-JtFolder_File {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FilePath_Input,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$FilePath_Output
    )

    [String]$MyFunctionName = "Test-JtFolder_File"
    
    [String]$MyFilePath_Input = $FilePath_Input
    [String]$MyFilePath_Output = $FilePath_Output

    [JtIoFile]$MyJtIoFile_Input = New-JtIoFile -FilePath $MyFilePath_Input
    
    [JtIoFolder]$MyJtIoFolder_Parent = $MyJtIoFile_Input.GetJtIoFolder_Parent()
    
    [JtTemplateFile]$MyJtTemplateFile = Get-JtTemplateFile -FolderPath $MyJtIoFolder_Parent
    [String]$MyMessage = $MyJtTemplateFile.GetMessage_Error($MyFilePath_Input)

    if ($MyMessage) {
        if ($MyFilePath_Output) {
            Write-JtLog_Folder_Error -Where $MyFunctionName -Text $MyMessage -FilePath $MyFilePath_Input -FilePath_Output $MyFilePath_Output
        }
        return $False
    }
    return $True
}

Function Update-JtFolderPath_Md_And_Meta {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "Update-JtFolderPath_Md_And_Meta"
    
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output

    # [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyFolderPath_Output 

    [String]$MyFilter = -join ("*", [JtIo]::FileExtension_Folder)
    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyFolderPath_Input -Filter $MyFilter -Recurse
    
    foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File
        [JtIoFolder]$MyJtIoFolder_Parent = $MyJtIoFile.GetJtIoFolder_Parent()

        Write-JtLog -Where $MyFunctionName -Text "Folder... MyJtIoFolder_Parent: $MyJtIoFolder_Parent"

        # Update-JtFolder_Md_And_Meta -FolderPath_Input $MyJtIoFolder_Parent -FolderPath_Output $MyJtIoFolder_Output
        Update-JtFolder_Md_And_Meta -FolderPath_Input $MyJtIoFolder_Parent -FolderPath_Output $MyFolderPath_Output
    }
}


Function Update-JtFolder_Md {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "Update-JtFolder_Md"

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
        
    [JtTemplateFile]$MyJtTemplateFile = Get-JtTemplateFile -FolderPath_Input $MyFolderPath_Input

    if (!($MyJtTemplateFile.IsValid())) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Template file is not valid."
        Return
    } 

    [String]$MyFilename_Template = $MyJtTemplateFile.GetName()

    if ($MyFilename_Template.EndsWith([JtIo]::FileExtension_Folder_Anzahl)) {
        # Convert-JtFolderPath_To_Md_Anzahl -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
    }
    elseif ($MyFilename_Template.EndsWith([JtIo]::FileExtension_Folder_Betrag)) {
        Convert-JtFolderPath_To_Md_Betrag -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
    }
    elseif ($MyFilename_Template.EndsWith([JtIo]::FileExtension_Folder_BxH)) {
        Convert-JtFolderPath_To_Md_BxH -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
    }
    elseif ($MyFilename_Template.EndsWith([JtIo]::FileExtension_Folder_Stand)) {
        # Convert-JtFolderPath_To_Md_Default -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
    }
    elseif ($MyFilename_Template.EndsWith([JtIo]::FileExtension_Folder_Stunden)) {
        Convert-JtFolderPath_To_Md_Stunden -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
    }
    elseif ($MyFilename_Template.EndsWith([JtIo]::FileExtension_Folder_Zahlung)) {
        Convert-JtFolderPath_To_Md_Zahlung -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
    }
    else {
        #        Convert-JtFolderPath_To_Md_Default -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
    }
}


Function Update-JtFolder_Md_And_Meta {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "Update-JtFolder_Md_And_Meta"

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
        
    [JtTemplateFile]$MyJtTemplateFile = Get-JtTemplateFile -FolderPath_Input $MyFolderPath_Input

    if (!($MyJtTemplateFile.IsValid())) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Template file is not valid."
        Return
    } 

    [String]$MyFilename_Template = $MyJtTemplateFile.GetName()

    if ($MyFilename_Template.EndsWith([JtIo]::FileExtension_Folder_Anzahl)) {
        New-JtIndex_Anzahl -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
    }
    elseif ($MyFilename_Template.EndsWith([JtIo]::FileExtension_Folder_Betrag)) {
        New-JtIndex_Betrag -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
    }
    elseif ($MyFilename_Template.EndsWith([JtIo]::FileExtension_Folder_BxH)) {
        New-JtIndex_BxH -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
    }
    elseif ($MyFilename_Template.EndsWith([JtIo]::FileExtension_Folder_Stand)) {
        New-JtIndex_Default -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
    }
    elseif ($MyFilename_Template.EndsWith([JtIo]::FileExtension_Folder_Stunden)) {
        New-JtIndex_Stunden -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
    }
    elseif ($MyFilename_Template.EndsWith([JtIo]::FileExtension_Folder_Zahlung)) {
        New-JtIndex_Zahlung -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
    }
    else {
        New-JtIndex_Default -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
    }
}

Function Update-JtIndex_BxH {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Filename_Template
    )

    # [String]$MyFunctionName = "Update-JtIndex_BxH"
    
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFilename_Template = $Filename_Template

    [String]$MyFolderPath_Output = $MyFolderPath_Input
    
    New-JtTemplateFile -FolderPath_Output $MyFolderPath_Output -Filename_Template $MyFilename_Template
    Convert-JtIoFilenamesAtFolderPath -FolderPath_Input $MyFolderPath_Input
}


Export-ModuleMember -Function Convert-JtFolderPath_To_Csv_Buchung
Export-ModuleMember -Function New-JtRepo_Report_Meta

Export-ModuleMember -Function Convert-JtFolderPath_To_AlJtIoFiles_Buchung
Export-ModuleMember -Function Convert-JtFolderPath_To_AlJtIoFiles_Meta


Export-ModuleMember -Function Convert-JtFolderPath_To_AlJtDataFolders
Export-ModuleMember -Function Convert-JtFolderPath_To_AlFoldertypes 
Export-ModuleMember -Function Convert-JtFolderPath_To_AlFoldernames
Export-ModuleMember -Function Convert-JtFolderPath_To_AlTemplates
Export-ModuleMember -Function Convert-JtFolderPath_To_AlYears

Export-ModuleMember -Function Convert-JtFolderPath_To_Integer_Anzahl
Export-ModuleMember -Function Convert-JtFolderPath_To_Decimal_Betrag_BxH
Export-ModuleMember -Function Convert-JtFolderPath_To_Decimal_Betrag_Part
Export-ModuleMember -Function Convert-JtFolderPath_To_Decimal_Betrag_Part_For_Year
    
Export-ModuleMember -Function Convert-JtFolderPath_To_JtTblTable_Anzahl
Export-ModuleMember -Function Convert-JtFolderPath_To_JtTblTable_Betrag
Export-ModuleMember -Function Convert-JtFolderPath_To_JtTblTable_BxH
Export-ModuleMember -Function Convert-JtFolderPath_To_JtTblTable_Files
Export-ModuleMember -Function Convert-JtFolderPath_To_JtTblTable_Filetypes
Export-ModuleMember -Function Convert-JtFolderPath_To_JtTblTable_Zahlung
    
Export-ModuleMember -Function Convert-JtFolderPath_To_Md_Betrag
Export-ModuleMember -Function Convert-JtFolderPath_To_Md_BxH
Export-ModuleMember -Function Convert-JtFolderPath_To_Md_Test
Export-ModuleMember -Function Convert-JtFolderPath_To_Md_Zahlung
    
Export-ModuleMember -Function Convert-JtFolderPath_To_Meta_Anzahl
Export-ModuleMember -Function Convert-JtFolderPath_To_Meta_Betrag 
Export-ModuleMember -Function Convert-JtFolderPath_To_Meta_BxH
Export-ModuleMember -Function Convert-JtFolderPath_To_Meta_Soll
Export-ModuleMember -Function Convert-JtFolderPath_To_Meta_Stunden
Export-ModuleMember -Function Convert-JtFolderPath_To_Meta_Zahlung
    
Export-ModuleMember -Function Get-JtLabel_Anzahl
Export-ModuleMember -Function Get-JtLabel_Betrag
Export-ModuleMember -Function Get-JtLabel_Betrag_Miete
Export-ModuleMember -Function Get-JtLabel_Betrag_Voraus
Export-ModuleMember -Function Get-JtLabel_Betrag_Zahlung

Export-ModuleMember -Function Get-JtTemplate_Md
Export-ModuleMember -Function Get-JtTemplate_Md_Betrag
Export-ModuleMember -Function Get-JtTemplate_Md_BxH
    
Export-ModuleMember -Function New-JtIndex_Anzahl
Export-ModuleMember -Function New-JtIndex_Betrag
Export-ModuleMember -Function New-JtIndex_BxH
Export-ModuleMember -Function New-JtIndex_Default
Export-ModuleMember -Function New-JtIndex_Stunden
Export-ModuleMember -Function New-JtIndex_Zahlung
    
Export-ModuleMember -Function New-JtRepo_Report_Betraege
Export-ModuleMember -Function New-JtRepo_Report_Foldernames
Export-ModuleMember -Function New-JtRepo_Report_Foldertypes
Export-ModuleMember -Function New-JtRepo_Report_NormalFiles
Export-ModuleMember -Function New-JtRepo_Report_Parts
Export-ModuleMember -Function New-JtRepo_Report_Problems
Export-ModuleMember -Function New-JtRepo_Report_Repo
Export-ModuleMember -Function New-JtRepo_Report_Templates
Export-ModuleMember -Function New-JtRepo_Report_YyyJpg

Export-ModuleMember -Function Test-JtFolder
Export-ModuleMember -Function Test-JtFolder_File
Export-ModuleMember -Function Test-JtFolder_Recurse
Export-ModuleMember -Function Test-JtFolder_Recurse_Element

Export-ModuleMember -Function Update-JtIndex_BxH
Export-ModuleMember -Function Update-JtFolder_Md
Export-ModuleMember -Function Update-JtFolder_Md_and_Meta 
Export-ModuleMember -Function Update-JtFolderPath_Md_and_Meta 
