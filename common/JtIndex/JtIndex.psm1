using module Jt  
using module JtColRen
using module JtIo
using module JtMd
using module JtTbl

Function Convert-JtFolderPath_To_AlFoldertypes {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath
    )

    [String]$MyFilter = "*.folder"
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

    $MyParams = @{
        Text  = $MyMdDoc.GetOutput()
        Url   = $MyUrl
        Path  = $MyPath
        Table = $MyTable_Output
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

    $MyParams = @{
        Text  = $MyMdDoc.GetOutput()
        Path  = $MyPath
        Table = $MyTable_Output
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
    [JtMdDocument]$MyMdDoc = Get-JtTemplate_Md_Zahlung -Title $MyTitle

    [String]$MyFolderPath_Parent = $MyJtIoFolder_Input.GetJtIoFolder_Parent().GetPath()
    [String]$MyPath = $MyFolderPath_Parent

    [JtTblTable]$MyJtTblTable = Convert-JtFolderPath_To_JtTblTable_Zahlung -FolderPath_Input $MyFolderPath_Input
    [System.Data.Datatable]$MyDataTable = Convert-JtTblTable_To_Datatable -JtTblTable $MyJtTblTable
    [JtMdTable]$MyJtMdTable = New-JtMdTable -DataTable $MyDataTable
    [String]$MyTable_Output = $MyJtMdTable.GetOutput()

    $MyParams = @{
        Text  = $MyMdDoc.GetOutput()
        Path  = $MyPath
        Table = $MyTable_Output
    }
    [String]$MyOutput = Convert-JtText_Template @MyParams
    
    $MyParams = @{
        FolderPath_Output = $MyFolderPath_Output
        Content           = $MyOutput
        Name              = "ABRECHNUNG"
        Extension2        = [JtIo]::FileExtension_Md_Zahlung
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
    Write-JtIoFile_Meta_Anzahl @MyParams

    # [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder_Input -Normal
    
    [JtTblTable]$MyJtTblTable = Convert-JtFolderPath_To_JtTblTable_Anzahl -FolderPath_Input $MyFolderPath_Input
    [System.Data.Datatable]$MyDataTable = Convert-JtTblTable_To_DataTable -JtTblTable $MyJtTblTable
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
        [String]$MyDecBetrag = Convert-JtFolderPath_To_Decimal_Betrag_Part_For_Year -FolderPath_Input $MyFolderPath_Input -Year $MyYear

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

    [String]$MyBetrag = Convert-JtFolderPath_To_Decimal_Betrag_BxH -FolderPath_Input $MyFolderPath_Input
    
    $MyParams = @{
        FolderPath_Input  = $MyFolderPath_Input
        FolderPath_Output = $MyFolderPath_Output
        Name              = "BETRAG"
        Betrag            = $MyBetrag
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
        [Decimal]$MyDecBetrag = Convert-JtFolderPath_To_Decimal_Betrag_Part -FolderPath_Input $MyFolderPath_Input -PartName $MyPart
        $MyParams = @{
            FolderPath_Input  = $MyFolderPath_Input
            FolderPath_Output = $MyFolderPath_Output
            Name              = $MyPart
            Year              = $MyYear
            Betrag            = $MyDecBetrag
        }
        Write-JtIoFile_Meta_Betrag @MyParams
        
        [String]$MyPart = "STUNDEN"
        [Decimal]$MyDecBetrag = Convert-JtFolderPath_To_Decimal_Betrag_Part -FolderPath_Input $MyFolderPath_Input -PartName $MyPart
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
        [Decimal]$MyDecBetrag = Convert-JtFolderPath_To_Decimal_Betrag_Part -FolderPath_Input $MyFolderPath_Input -PartName $MyPart
        $MyParams = @{
            FolderPath_Input  = $MyFolderPath_Input
            FolderPath_Output = $MyFolderPath_Output
            Name              = $MyPart
            Year              = $MyYear
            Betrag            = $MyDecBetrag
        }
        Write-JtIoFile_Meta_Betrag @MyParams
        
        [String]$MyPart = "VORAUS"
        [Decimal]$MyDecBetrag = Convert-JtFolderPath_To_Decimal_Betrag_Part -FolderPath_Input $MyFolderPath_Input -PartName $MyPart
        $MyParams = @{
            FolderPath_Input  = $MyFolderPath_Input
            FolderPath_Output = $MyFolderPath_Output
            Name              = $MyPart
            Year              = $MyYear
            Betrag            = $MyDecBetrag
        }
        Write-JtIoFile_Meta_Betrag @MyParams
        
        [String]$MyPart = "ZAHLUNG"
        [Decimal]$MyDecBetrag = Convert-JtFolderPath_To_Decimal_Betrag_Part -FolderPath_Input $MyFolderPath_Input -PartName $MyPart
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
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$PartName
    )

    [String]$MyFunctionName = "Convert-JtFolderPath_To_Decimal_Betrag_Part"

    [String]$MyFolderPath_Input = $FolderPath_input
    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input

    [String]$MyColumn = $Partname
    [Decimal]$MySum = 0
    if (!($MyJtIoFolder_Input.IsExisting())) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Error!!! Please edit XML for MyJtIoFolder: $MyJtIoFolder_Input"
        return 0
    }
    [JtTemplateFile]$MyJtTemplateFile = Get-JtTemplateFile -FolderPath_Input $MyJtIoFolder_Input
    [String]$MyFilename_Template = $MyJtTemplateFile.GetName()
    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder_Input -Normal
    ForEach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File
        
        [String]$MyFilename = $MyJtIoFile.GetName()
        [String]$MyValue = Convert-JtFilename_To_Info_With_Template -Filename $MyFilename -FilenameTemplate $MyFilename_Template -Field $MyColumn
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

Function Convert-JtFolderPath_To_Decimal_Betrag_Part_For_Year {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][Int16]$Year
    )

    [String]$MyFunctionName = "Convert-JtFolderPath_To_Decimal_Betrag_Part_For_Year"
    
    [String]$MyFolderPath_Input = $FolderPath_Input
    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input
    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder_Input -Normal

    if (!($MyJtIoFolder_Input.IsExisting())) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Folder is not existing! MyJtIoFolder_Input: $MyJtIoFolder_Input"
        return 0
    }
    
    [Decimal]$MyDecResult = 0
    [String]$MyFilterPrefix = "20" 
    if ($Year) {
        [String]$MyFilterPrefix = $Year 
    } 

    Foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File
        [String]$MyFilePath = $MyJtIoFile.GetPath()
        [Decimal]$MyDecBetrag = 0

        [String]$MyFilename = $MyJtIoFile.GetName()
        if ($MyFilename.StartsWith($MyFilterPrefix)) {
            if (Test-JtFilename_Betrag_IsValid -Filename $MyFilename) {
                [String]$MyFilename = $MyJtIoFile.GetName()
                [Decimal]$MyDecBetrag = Convert-JtFilename_To_DecBetrag -Filename $MyFilename
            }
            else {
                [JtIoFolder]$MyJtIoFolder_Parent = $MyJtIoFile.GetJtIoFolder_Parent()
                [String]$MyFolderPath = $MyJtIoFolder_Parent.GetPath()
                [String]$MyFilePath = $MyJtIoFile.GetPath()
                Write-JtLog_Folder_Error -Where $MyFunctionName -Text "Problem with file; EURO (in GetInfo) MyFolderPath: $MyFolderPath" -FilePath $MyFilePath

                Return 9991
            }
            $MyDecResult = $MyDecResult + $MyDecBetrag
        }
        else {
            # Write-JtLog -Where $MyFunctionName -Text "Ignoring file. FilePath: $MyFilePath"
        }
    }
    [String]$MyBetrag = Convert-JtDecimal_To_String2 -Decimal $MyDecResult
    return $MyBetrag
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
        if (Test-JtFilename_Anzahl_IsValid -Filename $MyFilename) {
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
        [Boolean]$MyBlnFileOk = Test-JtFolder_File -FilePath_Input $MyJtIoFile
        if ($MyBlnFileOk) {
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

            [JtColRen]$MyJtColRen = New-JtColRenFile_Year
            [String]$MyHeader = $MyJtColRen.GetHeader()
            [String]$MyLabel = $MyJtColRen.GetLabel()
            [String]$MyValue = $MyJtColRen.GetOutput($MyJtIoFile.GetPath())
            $MyJtTblRow.Add($MyLabel, $MyValue)

            [JtColRen]$MyJtColRen = New-JtColRenFile_Age
            [String]$MyHeader = $MyJtColRen.GetHeader()
            [String]$MyLabel = $MyJtColRen.GetLabel()
            [String]$MyValue = $MyJtColRen.GetOutput($MyJtIoFile.GetPath())
            $MyJtTblRow.Add($MyLabel, $MyValue)

            $MyJtTblTable.AddRow($MyJtTblRow)
        }
        else {
            Write-JtLog_Folder_Error -Where $MyFunctionName -Text "File is not valid." -FilePath $MyJtIoFile
        }
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
            for ($IntI = 0; $IntI -lt ($MyAlTemplateParts.Count - 1); $IntI ++) {
                [String]$MyLabel = $MyAlTemplateParts[$IntI]
                $MyLabel = $MyLabel.Replace("_", "")
                [JtColRen]$MyJtColRen = New-JtColRenInput_Text -Label $MyLabel
                [String]$MyValue = $MyAlFilenameParts[$IntI]
                $MyValue = $MyJtColRen.GetOutput($MyValue)
                $MyJtTblRow.Add($MyLabel, $MyValue) | Out-Null
            }
        
            [JtColRen]$MyJtColRen = New-JtColRenFile_Area
            [String]$MyLabel = $MyJtColRen.GetLabel()
            [String]$MyValue = $MyJtColRen.GetOutput($MyPath)
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
    [Decimal]$MyDecValue = Convert-JtFolderPath_To_Decimal_Betrag_BxH -FolderPath_Input $MyFolderPath_Input
    [String]$MyValue = Convert-JtDecimal_To_String2 -Decimal $MyDecValue
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
    
    [System.Collections.ArrayList]$MyAlJtColRens = $MyJtTemplateFile.GetJtColRens()
    if (!($MyAlJtColRens)) {
        Write-JtLog -Where $MyFunctionName -Text "MyAlJtColRens is NULL. MyJtIoFolder_Input: $MyJtIoFolder_Input"
        return $Null
    }
    
    [JtTblTable]$MyJtTblTable = New-JtTblTable -Label $MyFunctionName
    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyFolderPath_Input -Normal
    foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File
        [Boolean]$MyBlnFileValid = Test-JtFolder_File -FilePath_Input $MyJtIoFile

        if ($MyBlnFileValid) {
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

            [JtColRen]$MyJtColRen = New-JtColRenFile_Year
            [String]$MyHeader = $MyJtColRen.GetHeader()
            [String]$MyLabel = $MyJtColRen.GetLabel()
            [String]$MyValue = $MyJtColRen.GetOutput($MyJtIoFile.GetPath())
            $MyJtTblRow.Add($MyLabel, $MyValue)

            [JtColRen]$MyJtColRen = New-JtColRenFile_Age
            [String]$MyHeader = $MyJtColRen.GetHeader()
            [String]$MyLabel = $MyJtColRen.GetLabel()
            [String]$MyValue = $MyJtColRen.GetOutput($MyJtIoFile.GetPath())
            $MyJtTblRow.Add($MyLabel, $MyValue)
        
            $MyJtTblTable.AddRow($MyJtTblRow)
        }
        else {
            Write-JtLog_Folder_Error -Where $MyFunctionName -Text "File is not valid." -FilePath $MyJtIoFile
        }
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
    [System.Collections.ArrayList]$MyAlJtColRens = $MyJtTemplateFile.GetJtColRens()
    
    [Int32]$MyIntLine = 1

    [JtTblTable]$MyJtTblTable = New-JtTblTable -Label $MyFunctionName
    foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File
        [String]$MyFilePath_Input = $MyJtIoFile.GetPath()
        [Boolean]$MyBlnFileOk = Test-JtFolder_File -FilePath_Input $MyFilePath_Input
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
    [Decimal]$MyDecBetrag = Convert-JtFolderPath_To_Decimal_Betrag_Part -FolderPath_Input $MyFolderPath_Input -PartName $MyPart
    [String]$MyValue = Convert-JtDecimal_To_String2 -Decimal $MyDecBetrag
    $MyJtTblRow_Footer.Add($MyPart, $MyValue) | Out-Null
        
    [Int32]$j = 3
    [String]$MyPart = "STUNDEN"
    [Decimal]$MyDecBetrag = Convert-JtFolderPath_To_Decimal_Betrag_Part -FolderPath_Input $MyFolderPath_Input -PartName $MyPart
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
    [System.Collections.ArrayList]$MyAlJtColRens = $MyJtTemplateFile.GetJtColRens()
    
    [Int32]$MyIntLine = 1

    [JtTblTable]$MyJtTblTable = New-JtTblTable -Label $MyFunctionName
    foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File
        [String]$MyFilePath_Input = $MyJtIoFile.GetPath()
        [Boolean]$MyBlnFileOk = Test-JtFolder_File -FilePath_Input $MyFilePath_Input
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
    [Decimal]$MyDecBetrag = Convert-JtFolderPath_To_Decimal_Betrag_Part -FolderPath_Input $MyFolderPath_Input -PartName $MyPart
    [String]$MyValue = Convert-JtDecimal_To_String2 -Decimal $MyDecBetrag
    $MyJtTblRow_Footer.Add($MyPart, $MyValue) | Out-Null
        
    [Int32]$j = 5
    [String]$MyPart = "VORAUS"
    [Decimal]$MyDecBetrag = Convert-JtFolderPath_To_Decimal_Betrag_Part -FolderPath_Input $MyFolderPath_Input -PartName $MyPart
    [String]$MyValue = Convert-JtDecimal_To_String2 -Decimal $MyDecBetrag
    $MyJtTblRow_Footer.Add($MyPart, $MyValue) | Out-Null
        
    [Int32]$j = 6
    [String]$MyPart = "ZAHLUNG"
    [Decimal]$MyDecBetrag = Convert-JtFolderPath_To_Decimal_Betrag_Part -FolderPath_Input $MyFolderPath_Input -PartName $MyPart
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
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Year,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][Decimal]$Betrag
    )

    [Decimal]$MyDecBetrag = $Betrag
    [String]$MyName = $Name

    [String]$MyYear = "JAHRE"
    if ($Year) {
        if ($Year.Length -gt 0) {
            $MyYear = $Year
        }
    }
    
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

Function Get-JtLabel_Betrag_Miete {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Year,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][Decimal]$Betrag
    )

    # [String]$MyFunctionName = "Get-JtLabel_Betrag_Miete"
    [String]$MyName = "MIETE"
    [Decimal]$MyDecBetrag = $Betrag
    
    [String]$MyFolderPath_Input = $FolderPath_Input
    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input
    [String]$MyFolderName = $MyJtIoFolder_Input.GetName()
    [String]$MyYear = $Year
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

Function Get-JtLabel_Betrag_Voraus {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][decimal]$Year,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][Decimal]$Betrag
    )
        
    # [String]$MyFunctionName = "Get-JtLabel_Betrag_Voraus"
    [String]$MyName = "VORAUS"
    [Decimal]$MyDecBetrag = $Betrag
        
    [String]$MyFolderPath_Input = $FolderPath_Input
    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input
    [String]$MyFolderName = $MyJtIoFolder_Input.GetName()
    [String]$MyYear = $Year
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

Function Get-JtLabel_Betrag_Zahlung {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Year,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][Decimal]$Betrag
    )
            
    # [String]$MyFunctionName = "Get-JtLabel_Betrag_Zahlung"
    [String]$MyName = "ZAHLUNG"
    [Decimal]$MyDecBetrag = $Betrag
            
    [String]$MyFolderPath_Input = $FolderPath_Input
    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input
    [String]$MyFolderName = $MyJtIoFolder_Input.GetName()
    [String]$MyYear = $Year
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

    [String]$MyLabel = -join ($Part1, ".", $Part2, ".", $Part3, ".", $Part4, ".", $Part5, ".", $Part6, ".", $Name, ".", $Year, ".", $Value)
    return $MyLabel
}

Function Get-JtTemplate_Md_BxH {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$JtPreisliste_Title
    )

    # [String]$MyFunctionName = "Get-JtTemplate_Md_BxH"
    [String]$MyJtPreisliste_Title = $JtPreisliste_Title
    
    [JtMdDocument]$MyJtMdDoc = New-JtMdDocument -Title "Fakultät für Architektur und Landschaft"
    $MyJtMdDoc.AddH2("Plot-Service - Abrechnung")
    $MyJtMdDoc.AddLine("Datum: <date>")
    $MyJtMdDoc.AddLine("<table>")
    $MyJtMdDoc.AddLine("---")
    $MyJtMdDoc.AddLine("Kunde")
    $MyJtMdDoc.AddLine("---")
    $MyJtMdDoc.AddLine("Plot-Service")
    $MyJtMdDoc.AddLine("---")    
    
    $MyJtMdDoc.AddLine("* Stand: <date>; Preisliste: $MyJtPreisliste_Title")
    
    $MyJtMdDoc.AddLine("* <path>")
    $MyJtMdDoc.AddLine("* <url>")
    return $MyJtMdDoc
}

Function Get-JtTemplate_Md_Stunden {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Title
    )

    [String]$MyFunctionName = "Get-JtTemplate_Md_Stunden"
    
    [JtMdDocument]$MyJtMdDoc = New-JtMdDocument -Title $MyTitle
    
    
    [String]$MyTimestamp = Get-JtTimestamp
    $MyJtMdDoc.AddLine("* Stand: $MyTimestamp")
    
    $MyJtMdDoc.AddLine("* Pfad: <path>")
    
    $MyJtMdDoc.AddH2("SOLL und STUNDEN")

    $MyJtMdDoc.AddLine("<table>")
    $MyJtMdDoc.AddLine("---")
    return $MyJtMdDoc
}


Function Get-JtTemplate_Md_Zahlung {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Title
    )

    [String]$MyFunctionName = "Get-JtTemplate_Md_Zahlung"
    
    [JtMdDocument]$MyJtMdDoc = New-JtMdDocument -Title $MyTitle
    
    
    [String]$MyTimestamp = Get-JtTimestamp
    $MyJtMdDoc.AddLine("* Stand: $MyTimestamp")
    
    $MyJtMdDoc.AddLine("* Pfad: <path>")
    
    $MyJtMdDoc.AddH2("MIETE und VORAUS")

    $MyJtMdDoc.AddLine("<table>")
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
}



Function New-JtIndex_BxH {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "New-JtIndex_BxH"
    Write-JtLog -Where $MyFunctionName -Text "Starting..."

    # $This.FilenameTemplate = -join ("_NACHNAME.VORNAME.LABEL.PAPIER.BxH", [JtIo]::FileExtension_Folder)
    
    # [String]$MyLabel = "BxH"
    
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output

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


Function Test-JtFolder {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FilePath_Output
    )

    [String]$MyFunctionName = "Test-JtFolder"
    
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFilePath_Output = $FilePath_Output

    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input 
    # [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyFolderPath_Output 

    [String]$MyFilter = -join ("*", [JtIo]::FileExtension_Folder)
    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder_Input -Filter $MyFilter -Recurse
    
    foreach ($File_Folder in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile_Folder = $File_Folder
        [JtIoFolder]$MyJtIoFolder_Parent = $MyJtIoFile_Folder.GetJtIoFolder_Parent()

        [JtTemplateFile]$MyJtTemplateFile = Get-JtTemplateFile -FolderPath $MyJtIoFolder_Parent

        $MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder_Parent -Normal
        ForEach ($File_Content in $MyAlJtIoFiles) {
            [JtIoFile]$MyJtIoFile_Content = $File_Content

            $MyJtTemplateFile.GetName()
            Write-JtLog -Where $MyFunctionName -Text "File_Content: $File_Content"
            [Boolean]$BlnIsFileOk = Test-JtFolder_File -FilePath_Input $MyJtIoFile_Content -FilePath_Output $MyFilePath_Output
            if (!($BlnIsFileOk)) {
                Write-JtLog_Error -Where $MyFunctionName -Text "Found (at least) one problem in folder... MyJtIoFolder_Parent: $MyJtIoFolder_Parent"
                Break
            }
        }
    }
}

Function Test-JtFolder_Recurse {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input
    )

    [String]$MyFunctionName = "Test-JtFolder_Recurse"

    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $FolderPath_Input

    [String]$MyExtension = [JtIo]::FileExtension_Folder
    [String]$MyFilter = -join ("*", $MyExtension)
    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder_Input -Filter $MyFilter -Recurse

    [Int16]$MyIntProblems = 0
    foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File
        [JtIoFolder]$MyJtIoFolder_Parent = $MyJtIoFile.GetJtIoFolder_Parent()

        [Int16]$MyIntFolderSum = Test-JtFolder -FolderPath_Input $MyJtIoFolder_Parent
        $MyIntProblems = $MyIntProblems + $MyIntFolderSum
    }

    if ($MyIntProblems -gt 0) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Number of problems found: $MyIntProblems"
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
    [Boolean]$MyResult = $True

    [JtIoFolder]$MyJtIoFolder_Parent = $MyJtIoFile_Input.GetJtIoFolder_Parent()
    [JtTemplateFile]$MyJtTemplateFile = Get-JtTemplateFile -FolderPath $MyJtIoFolder_Parent

    [String]$MyFilename = $MyJtIoFile_Input.GetName()
    $MyAlFileNameParts = $MyFilename.Split(".")
    [Int16]$MyIntFilenameParts = $MyAlFileNameParts.Count

    [System.Collections.ArrayList]$MyAlColRens = $MyJtTemplateFile.GetJtColRens()
    [Int16]$MyIntTemplateParts = $MyAlColRens.Count

    if ($MyIntFilenameParts -ne $MyIntTemplateParts) {
        Write-JtLog_Error -Where $MyFunctionName -Text "DoCheckFile. Not in expected format. MyFilename: $MyFilename - Parts in filename: $MyIntFilenameParts - Parts in template: $MyIntTemplateParts"
                
        [String]$MyMessage = "Problem with file (DoCheckFile): MyFilename: $MyFilename"
        if ($MyFilePath_Output) {
            Write-JtLog_Folder_Error -Where $MyFunctionName -Text $MyMessage -FilePath $MyFilePath_Input -FilePath_Output $MyFilePath_Output
        }
        else {
            Write-JtLog_Folder_Error -Where $MyFunctionName -Text $MyMessage -FilePath $MyFilePath_Input
        }
        $MyResult = $False
    }
    else {
        for ([Int32]$i = 0; $i -lt $MyIntTemplateParts; $i++) {
            [String]$MyValue = $MyAlFileNameParts[$i]
            [JtColRen]$MyJtColRen = $MyAlColRens[$i]
            [Boolean]$IsValid = $MyJtColRen.CheckValid($MyValue)
            if (! ($IsValid)) {
                [String]$MyMessage = "DoCheckFile. File not valid; MyFilename: $MyFilename"
                if ($MyFilePath_Output) {
                    Write-JtLog_Folder_Error -Where $MyFunctionName -Text $MyMessage -FilePath $MyFilePath_Input -FilePath_Output $MyFilePath_Output
                }
                else {
                    Write-JtLog_Folder_Error -Where $MyFunctionName -Text $MyMessage -FilePath $MyFilePath_Input
                }
                return $False
            }
        }
    }
    return $MyResult
}


Function Update-JtFolderPath_Md_And_Meta {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input
    )

    [String]$MyFunctionName = "Update-JtFolderPath_Md_And_Meta"
    
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $MyFolderPath_Input

    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input 
    # [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyFolderPath_Output 

    [String]$MyFilter = -join ("*", [JtIo]::FileExtension_Folder)
    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder_Input -Filter $MyFilter -Recurse
    
    foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File
        [JtIoFolder]$MyJtIoFolder_Parent = $MyJtIoFile.GetJtIoFolder_Parent()

        Write-JtLog -Where $MyFunctionName -Text "Folder... MyJtIoFolder_Parent: $MyJtIoFolder_Parent"

        # Update-JtFolder_Md_And_Meta -FolderPath_Input $MyJtIoFolder_Parent -FolderPath_Output $MyJtIoFolder_Output
        Update-JtFolder_Md_And_Meta -FolderPath_Input $MyJtIoFolder_Parent -FolderPath_Output $MyJtIoFolder_Parent
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

    [String]$MyFunctionName = "Update-JtIndex_BxH"
    
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFilename_Template = $Filename_Template
    
    [JtTemplateFile]$MyTemplateFile = Get-JtTemplateFile -FolderPath $MyFolderPath_Input
    if (!($MyTemplateFile.IsValid())) {
        [String]$MyFolderPath_Output = $MyFolderPath_Input
        [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyFolderPath_Output
        [String]$MyFilePath_Output = $MyJtIoFolder_Output.GetFilePath($MyFilename_Template)
        Write-JtLog_File -Where $MyFunctionname -Text "Creating TemplateFile" -FilePath $MyFilePath_Output
        [String]$MyContent = Get-JtTimestamp
        $MyContent | Out-File -FilePath $MyFilePath_Output -Encoding utf8
    }
    Convert-JtIoFilenamesAtFolderPath -FolderPath_Input $MyFolderPath_Input
}



Export-ModuleMember -Function Convert-JtFolderPath_To_AlFoldertypes 
Export-ModuleMember -Function Convert-JtFolderPath_To_AlYears

Export-ModuleMember -Function Convert-JtFolderPath_To_Integer_Anzahl
Export-ModuleMember -Function Convert-JtFolderPath_To_Decimal_Betrag_BxH
Export-ModuleMember -Function Convert-JtFolderPath_To_Decimal_Betrag_Part
Export-ModuleMember -Function Convert-JtFolderPath_To_Decimal_Betrag_Part_For_Year

Export-ModuleMember -Function Convert-JtFolderPath_To_JtTblTable_Anzahl
Export-ModuleMember -Function Convert-JtFolderPath_To_JtTblTable_Files
Export-ModuleMember -Function Convert-JtFolderPath_To_JtTblTable_BxH
Export-ModuleMember -Function Convert-JtFolderPath_To_JtTblTable_Zahlung

Export-ModuleMember -Function Convert-JtFolderPath_To_Md_BxH
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

Export-ModuleMember -Function New-JtIndex_Anzahl
Export-ModuleMember -Function New-JtIndex_Betrag
Export-ModuleMember -Function New-JtIndex_BxH
Export-ModuleMember -Function New-JtIndex_Default
Export-ModuleMember -Function New-JtIndex_Stunden
Export-ModuleMember -Function New-JtIndex_Zahlung

Export-ModuleMember -Function Test-JtFolder
Export-ModuleMember -Function Test-JtFolder_File
Export-ModuleMember -Function Test-JtFolder_Recurse

Export-ModuleMember -Function Update-JtIndex_BxH
Export-ModuleMember -Function Update-JtFolder_Md_and_Meta 
Export-ModuleMember -Function Update-JtFolderPath_Md_and_Meta 
