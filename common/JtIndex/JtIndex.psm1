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
    
    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input
    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder_Input -Normal
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

    # [String]$MyUrl = "https://www.archland.uni-hannover.de"
    [String]$MyUrl = "https://www.archland.uni-hannover.de/de/fakultaet/ausstattung/plotservice/"
    [String]$MyPath = $MyFolderPath_Input
    
    [JtPreisliste]$MyJtPreisliste = Get-JtPreisliste

    [JtTblTable]$MyJtTblTable = Convert-JtFolderPath_To_JtTblTable_BxH -FolderPath_Input $MyFolderPath_Input
    [System.Data.Datatable]$MyDataTable = Convert-JtTblTable_To_Datatable -JtTblTable $MyJtTblTable
    [JtMdTable]$MyJtMdTable = [JtMdTable]::new($MyDataTable)
    [String]$MyTable_Output = $MyJtMdTable.GetOutput()

    $MyParams = @{
        Text  = $MyMdDoc.GetOutput()
        Url   = $MyUrl
        Path  = $MyPath
        Table = $MyTable_Output
    }
    [String]$MyOutput = Convert-JtTextTemplate @MyParams

    $MyParams = @{
        FolderPath_Output = $MyFolderPath_Output
        Content           = $MyOutput
        Name              = "ABRECHNUNG"
        Extension2        = [JtIo]::FileExtension_Md_Bxh
        # OnlyOne           = $True
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
    [String]$MyTable_Output = $MyDataTable.GetOutput()

    $MyParams = @{
        Text  = $MyMdDoc.GetOutput()
        Path  = $MyPath
        Table = $MyTable_Output
    }
    [String]$MyOutput = Convert-JtTextTemplate @MyParams
    
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

    [String]$MyValue = Convert-JtFolderPath_To_Value_Anzahl -FolderPath_Input $MyFolderPath_Input
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
        
    [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyFolderPath_Output -Force

   
    [String]$MyFolderPath_Output = $MyJtIoFolder_Output.GetPath()
    
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
        [String]$MyBetrag = Convert-JtFolderPath_To_Value_Betrag_Part_For_Year -FolderPath_Input $MyFolderPath_Input -Year $MyYear
     
        Convert-JtFolderPath_To_Meta_Betrag_Year -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output -Betrag $MyBetrag -Name $MyName -Year $MyYear
    }
}

Function Convert-JtFolderPath_To_Meta_Betrag_Year {
        
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Name,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Year,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Betrag
    )
    
    [String]$MyBetrag = $Betrag
    [String]$MyName = $Name
    [String]$MyYear = $Year
    
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
    
    $MyParams = @{
        FolderPath_Input  = $MyFolderPath_Input
        FolderPath_Output = $MyFolderPath_Output
        Name              = $MyName
        Year              = $MyYear
        Betrag            = $MyBetrag
        # OnlyOne           = $True
    }
    Write-JtIoFile_Meta_Betrag @MyParams
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

    # Remove-JtIoFiles_Meta -FolderPath $MyFolderPath_Output

    [JtColRen]$MyJtColRen = New-JtColRenFileJtPreisliste_Price
    [Decimal]$MyDecPrice = 0

    Write-JtLog -Where $MyFunctionName -Text "MyInfo: $MyInfo"
        
    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder_Input -Normal
    foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File
        [String]$MyFilePath = $MyJtIoFile.GetPath()
        [String]$MySheetPrice = $MyJtColRen.GetOutput($MyFilePath)
        [Decimal]$MyDecSheetPrice = Convert-JtString_To_Decimal -Text $MySheetPrice
        
        $MyDecPrice = $MyDecPrice + $MyDecSheetPrice
    }
    [String]$MyBetrag = Convert-JtDecimal_To_String2 -Decimal $MyDecPrice
    
    $MyParams = @{
        FolderPath_Input  = $MyFolderPath_Input
        FolderPath_Output = $MyFolderPath_Output
        Name              = "BETRAG"
        Betrag            = $MyBetrag
        Year              = "y"
    }
    Write-JtIoFile_Meta_Betrag @MyParams
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
        [String]$MyBetrag = Convert-JtFolderPath_To_Value_Betrag_Part -FolderPath_Input $MyFolderPath_Input -PartName $MyPart
        $MyParams = @{
            FolderPath_Input  = $MyFolderPath_Input
            FolderPath_Output = $MyFolderPath_Output
            Name              = $MyPart
            Year              = $MyYear
            Betrag            = $MyBetrag
        }
        Write-JtIoFile_Meta_Betrag @MyParams
        
        [String]$MyPart = "VORAUS"
        [String]$MyBetrag = Convert-JtFolderPath_To_Value_Betrag_Part -FolderPath_Input $MyFolderPath_Input -PartName $MyPart
        $MyParams = @{
            FolderPath_Input  = $MyFolderPath_Input
            FolderPath_Output = $MyFolderPath_Output
            Name              = $MyPart
            Year              = $MyYear
            Betrag            = $MyBetrag
        }
        Write-JtIoFile_Meta_Betrag @MyParams
        
        [String]$MyPart = "ZAHLUNG"
        [String]$MyBetrag = Convert-JtFolderPath_To_Value_Betrag_Part -FolderPath_Input $MyFolderPath_Input -PartName $MyPart
        $MyParams = @{
            FolderPath_Input  = $MyFolderPath_Input
            FolderPath_Output = $MyFolderPath_Output
            Name              = $MyPart
            Year              = $MyYear
            Betrag            = $MyBetrag
        }
        Write-JtIoFile_Meta_Betrag @MyParams
    }
}



Function Convert-JtFolderPath_To_Value_Anzahl {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input
    )

    [String]$MyFunctionName = "Convert-JtFolderPath_To_Value_Anzahl"

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
    [String]$MyCount = -Join ("", $MyIntCount)
    return $MyCount
}

Function Convert-JtFolderPath_To_Value_Betrag_BxH {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input
    )

    [String]$MyFunctionName = "Convert-JtFolderPath_To_Value_Betrag_BxH"

    [String]$MyFolderPath_Input = $FolderPath_input

    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input
    if (!($MyJtIoFolder_Input.IsExisting())) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Error!!! Please edit XML for MyJtIoFolder_Input: $MyJtIoFolder_Input"
        return "ERROR"
    }

    [JtColRen]$MyJtColRen = New-JtColRenFileJtPreisliste_Price
    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyFolderPath_Input -Normal
    foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File
        [String]$MyFilePath = $MyJtIoFile.GetPath()
        [String]$MySheetPrice = $MyJtColRen.GetOutput($MyFilePath)
        [Decimal]$MyDecSheetPrice = Convert-JtString_To_Decimal -Text $MySheetPrice
        
        $MyDecPrice = $MyDecPrice + $MyDecSheetPrice
    }
    [String]$MyBetrag = Convert-JtDecimal_To_String2 -Decimal $MyDecPrice
    return $MyBetrag
}


Function Convert-JtFolderPath_To_Value_Betrag_Part {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$PartName
    )

    [String]$MyFunctionName = "Convert-JtFolderPath_To_Value_Betrag_Part"

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



Function Convert-JtFolderPath_To_Value_Betrag_Part_For_Year {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][Int16]$Year
    )

    [String]$MyFunctionName = "Convert-JtFolderPath_To_Value_Betrag_Part_For_Year"
    
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
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Betrag
    )

    [String]$MyBetrag = $Betrag
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
    [String]$MyValue = $MyBetrag

    $MyParams = @{
        Part1 = Convert-JtDotter -Text $MyFolderName -PatternOut "1"
        Part2 = Convert-JtDotter -Text $MyFolderName -PatternOut "2"
        Part3 = Convert-JtDotter -Text $MyFolderName -PatternOut "3"
        Part4 = Convert-JtDotter -Text $MyFolderName -PatternOut "4"
        Part5 = Convert-JtDotter -Text $MyFolderName -PatternOut "5"
        Part6 = Convert-JtDotter -Text $MyFolderName -PatternOut "6"
        Name  = $MyName
        Year  = $MyYear
        Value = Convert-JtString_To_Betrag -Text $MyValue
    }
    [String]$MyLabel = Get-JtLabel_Xxx @MyParams
    return $MyLabel
}

Function Get-JtLabel_Betrag_Miete {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Betrag,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Year
    )

    # [String]$MyFunctionName = "Get-JtLabel_Betrag_Miete"
    [String]$MyName = "MIETE"


    [String]$MyFolderPath_Input = $FolderPath_Input
    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input
    [String]$MyFolderName = $MyJtIoFolder_Input.GetName()
    [String]$MyValue = $Betrag
    [String]$MyYear = $Year

    $MyParams = @{
        Part1 = Convert-JtDotter -Text $MyFolderName -PatternOut "1"
        Part2 = Convert-JtDotter -Text $MyFolderName -PatternOut "2"
        Part3 = Convert-JtDotter -Text $MyFolderName -PatternOut "3"
        Part4 = Convert-JtDotter -Text $MyFolderName -PatternOut "4"
        Part5 = Convert-JtDotter -Text $MyFolderName -PatternOut "5"
        Part6 = Convert-JtDotter -Text $MyFolderName -PatternOut "6"
        Name  = $MyName
        Year  = $MyYear
        Value = Convert-JtString_To_Betrag -Text $MyValue
    }
    [String]$MyLabel = Get-JtLabel_Xxx @MyParams
    return $MyLabel
}


Function Get-JtLabel_Betrag_Voraus {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Betrag,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Year
    )
        
    # [String]$MyFunctionName = "Get-JtLabel_Betrag_Voraus"
    [String]$MyName = "VORAUS"
        
    [String]$MyFolderPath_Input = $FolderPath_Input
    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input
    [String]$MyFolderName = $MyJtIoFolder_Input.GetName()
    [String]$MyValue = $Betrag
    [String]$MyYear = $Year
        
    $MyParams = @{
        Part1 = Convert-JtDotter -Text $MyFolderName -PatternOut "1"
        Part2 = Convert-JtDotter -Text $MyFolderName -PatternOut "2"
        Part3 = Convert-JtDotter -Text $MyFolderName -PatternOut "3"
        Part4 = Convert-JtDotter -Text $MyFolderName -PatternOut "4"
        Part5 = Convert-JtDotter -Text $MyFolderName -PatternOut "5"
        Part6 = Convert-JtDotter -Text $MyFolderName -PatternOut "6"
        Name  = $MyName
        Year  = $MyYear
        Value = Convert-JtString_To_Betrag -Text $MyValue
    }
    [String]$MyLabel = Get-JtLabel_Xxx @MyParams
    return $MyLabel
}
    
    
Function Get-JtLabel_Betrag_Zahlung {
        
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Year,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Betrag
    )
            
    # [String]$MyFunctionName = "Get-JtLabel_Betrag_Zahlung"
    [String]$MyName = "ZAHLUNG"
            
    [String]$MyFolderPath_Input = $FolderPath_Input
    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input
    [String]$MyFolderName = $MyJtIoFolder_Input.GetName()
    [String]$MyValue = $Betrag
    [String]$MyYear = $Year

    $MyParams = @{
        Part1 = Convert-JtDotter -Text $MyFolderName -PatternOut "1"
        Part2 = Convert-JtDotter -Text $MyFolderName -PatternOut "2"
        Part3 = Convert-JtDotter -Text $MyFolderName -PatternOut "3"
        Part4 = Convert-JtDotter -Text $MyFolderName -PatternOut "4"
        Part5 = Convert-JtDotter -Text $MyFolderName -PatternOut "5"
        Part6 = Convert-JtDotter -Text $MyFolderName -PatternOut "6"
        Name  = $MyName
        Year  = $MyYear
        Value = Convert-JtString_To_Betrag -Text $MyValue
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

Function Write-JtIoFile {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FilePath_Output,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Content,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][Switch]$Overwrite
    )

    [String]$MyFunctionName = "Write-JtIoFile"
        
    [String]$MyFilePath_Output = $FilePath_Output
    [String]$MyContent = $Content
    if (Test-JtIoFilePath $MyFilePath_Output) {
        if ($Overwrite) {
            Write-JtLog_Error -Where $MyFunctionName -Text "File exists. Replacing old file!! FilePath_Output: $FilePath_Output"
            Write-JtLog_File -Where $MyFunctionName -Text "Writing file." -FilePath $MyFilePath_Output
            $MyContent | Out-File -FilePath $MyFilePath_Output -Encoding utf8
        }
        else {
            Write-JtLog_Error -Where $MyFunctionName -Text "File exists. Not overwriting!!! FilePath_Output: $FilePath_Output"
        }
    }
    else {
        Write-JtLog_File -Where $MyFunctionName -Text "Writing file." -FilePath $MyFilePath_Output
        $MyContent | Out-File -FilePath $MyFilePath_Output -Encoding utf8
    }
}


Function Write-JtIoFile_Md {
        
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Content,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Name,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Extension2,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][Switch]$OnlyOne,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][Switch]$Overwrite
    )

    # [String]$MyFunctionName = "Write-JtIoFile_Md"

    [String]$MyFolderPath_Output = $FolderPath_Output
    [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyFolderPath_Output
    [String]$MyFoldername_Output = $MyJtIoFolder_Output.GetName()

    [String]$MyExtension2 = $Extension2
    [String]$MyContent = $Content
    [String]$MyOverwrite = $Overwrite
    [String]$MyName = $Name
    [String]$MyPrefix = [JtIo]::FilePrefix_Folder
    
    [String]$MyExtension_Md = [JtIo]::FileExtension_Md
    if (! ($MyExtension2.EndsWith($MyExtension_Md))) {
        Throw "Illegal extension"
        return
    }
    
    [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyFolderPath_Output
    if ($OnlyOne) {
        [String]$MyFilter = -join ($MyPrefix, "*", $MyExtension2)
        $MyJtIoFolder_Output.DoRemoveFiles_All($MyFilter)
    }
    
    $MyFilename_Output = -Join ($MyPrefix, ".", $MyName, ".", $MyFoldername_Output, $MyExtension2)
    $MyFilename_Output = Convert-JtLabel_To_Filename -Label $MyFilename_Output
    [String]$MyFilePath_Output = $MyJtIoFolder_Output.GetFilePath($MyFilename_Output)

    if ($MyOverwrite) {

        Write-JtIoFile -FilePath_Output $MyFilePath_Output -Content $MyContent -Overwrite
    }
    else {
        Write-JtIoFile -FilePath_Output $MyFilePath_Output -Content $MyContent
        
    }
    Convert-JtIoFile_Md_To_Pdf -FolderPath_Input $MyFolderPath_Output -Filename_Input $MyFilename_Output
    
}

Function Write-JtIoFile_Meta {
    Param (
        [Cmdletbinding()]
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Prefix,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Label,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Extension2,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][Switch]$OnlyOne,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][Switch]$Overwrite
    )

    # [String]$MyFunctionName = "Write-JtIoFile_Meta"

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
    [String]$MyExtension2 = $Extension2
    [String]$MyOverwrite = $Overwrite
    [String]$MyLabel = $Label

    [String]$MyExtension_Meta = [JtIo]::FileExtension_Meta
    if (! ($MyExtension2.EndsWith($MyExtension_Meta))) {
        Throw "Illegal extension"
        return
    }

    [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyFolderPath_Output
    if ($OnlyOne) {
        [String]$MyFilter = -join ("*", $MyExtension2)
        $MyJtIoFolder_Output.DoRemoveFiles_All($MyFilter)
    }

    $MyLabel = $Label
    if ($Prefix) {
        $MyPrefix = $Prefix
        $MyLabel = -join ($MyPrefix, ".", $MyLabel)
    }


    $MyFilename_Output = -Join ($MyLabel, $MyExtension2)

    $MyContent = $MyFolderPath_Input

    $MyFilename_Output = Convert-JtLabel_To_Filename -Label $MyFilename_Output
    [String]$MyFilePath_Output = $MyJtIoFolder_Output.GetFilePath($MyFilename_Output)

    if ($MyOverwrite) {
        Write-JtIoFile -FilePath_Output $MyFilePath_Output -Content $MyContent -Overwrite
    }
    else {
        Write-JtIoFile -FilePath_Output $MyFilePath_Output -Content $MyContent

    }
}


Function Write-JtIoFile_Meta_Anzahl {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Anzahl
    )

    [String]$MyFunctionName = "Write-JtIoFile_Meta_Anzahl"
    Write-JtLog -Where $MyFunctionName -Text "Writing meta file."

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output

    [String]$MyAnzahl = $Anzahl
    
    [String]$MyPrefix = [JtIo]::FilePrefix_Folder
    [String]$MyLabel = $MyAnzahl
    [String]$MyExtension2 = [JtIo]::FileExtension_Meta_Anzahl

    $MyParams = @{
        FolderPath_Input  = $MyFolderPath_Input
        FolderPath_Output = $MyFolderPath_Output
        Prefix            = $MyPrefix
        Label             = $MyLabel
        Extension2        = $MyExtension2
        #        Overwrite         = $True
    }
    Write-JtIoFile_Meta @MyParams
}

Function Write-JtIoFile_Meta_Betrag {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Name,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Year,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Betrag
    )

    [String]$MyFunctionName = "Write-JtIoFile_Meta_Betrag"
    Write-JtLog -Where $MyFunctionName -Text "Writing meta file."

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output

    [String]$MyName = $Name
    [String]$MyYear = $Year
    [String]$MyBetrag = $Betrag


    if ($Year) {
        $MyYear = $Year
    }
    else {
        $MyYear = "20xx"
    }

    [String]$MyLabel = Get-JtLabel_Betrag -FolderPath_Input $MyFolderPath_Input -Name $MyName -Year $MyYear -Betrag $MyBetrag 
    
    [String]$MyPrefix = [JtIo]::FilePrefix_Folder
    [String]$MyExtension2 = [JtIo]::FileExtension_Meta_Betrag

    $MyParams = @{
        FolderPath_Input  = $MyFolderPath_Input
        FolderPath_Output = $MyFolderPath_Output
        Prefix            = $MyPrefix
        Label             = $MyLabel
        Extension2        = $MyExtension2
        Overwrite         = $True
    }
    Write-JtIoFile_Meta @MyParams
}

Function Write-JtIoFile_Meta_Report {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Name,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Value
    )

    [String]$MyFunctionName = "Write-JtIoFile_Meta_Report"
    Write-JtLog -Where $MyFunctionName -Text "Writing meta file."

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output

    [String]$MyName = $Name
    [String]$MyValue = $Value
    
    [String]$MyPrefix = [JtIo]::FilePrefix_Report
    [String]$MyLabel = -join ($MyName, ".", $MyValue)
    [String]$MyExtension2 = [JtIo]::FileExtension_Meta_Report

    $MyParams = @{
        FolderPath_Input  = $MyFolderPath_Input
        FolderPath_Output = $MyFolderPath_Output
        Prefix            = $MyPrefix
        Label             = $MyLabel
        Extension2        = $MyExtension2
        Overwrite         = $True
    }
    Write-JtIoFile_Meta @MyParams
}

Function Write-JtIoFile_Meta_Time {
        
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Name
    )

    [String]$MyFunctionName = "Write-JtIoFile_Meta_Time"
    Write-JtLog -Where $MyFunctionName -Text "Writing meta file."

    [String]$MyFolderPath_Output = $FolderPath_Output
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyName = $Name
    [String]$MyPrefix = "_timestamp"
    [String]$MyTimestamp = Get-JtTimestamp
    
    [String]$MyLabel = -join ($MyTimestamp, ".", $MyName)
    
    $MyParams = @{
        FolderPath_Input  = $MyFolderPath_Input
        FolderPath_Output = $MyFolderPath_Output
        Prefix            = $MyPrefix
        Label             = $MyLabel
        Extension2        = [JtIo]::FileExtension_Meta_Time
        Overwrite         = $True
        # OnlyOne           = $True
    }
    Write-JtIoFile_Meta @MyParams
}

Function Write-JtIoFile_Meta_Version {
    
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )
        
    [String]$MyFunctionName = "Write-JtIoFile_Meta_Version"
    Write-JtLog -Where $MyFunctionName -Text "Writing meta file."
        
    [String]$MyFolderPath_Output = $FolderPath_Output
    [String]$MyFolderPath_Input = $MyFolderPath_Output
    [String]$MyTimestamp = Get-JtTimestamp
    [String]$MyPrefix = "_v"
        
    $MyParams = @{
        FolderPath_Input  = $MyFolderPath_Input
        FolderPath_Output = $MyFolderPath_Output
        Prefix            = $MyPrefix
        Label             = $MyTimestamp
        Extension2        = [JtIo]::FileExtension_Meta_Version
        OnlyOne           = $True
        Overwrite         = $True
    }
    Write-JtIoFile_Meta @MyParams
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
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FilePath_Output

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
        Write-JtLog_Folder_Error -Where $MyFunctionName -Text $MyMessage -FilePath $MyFilePath_Input -FilePath_Output $MyFilePath_Output
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

Export-ModuleMember -Function Convert-JtFolderPath_To_AlFoldertypes 
Export-ModuleMember -Function Convert-JtFolderPath_To_AlYears


Export-ModuleMember -Function Convert-JtFolderPath_To_Md_BxH
Export-ModuleMember -Function Convert-JtFolderPath_To_Md_Zahlung

Export-ModuleMember -Function Convert-JtFolderPath_To_Meta_Anzahl
Export-ModuleMember -Function Convert-JtFolderPath_To_Meta_Betrag 
Export-ModuleMember -Function Convert-JtFolderPath_To_Meta_BxH
Export-ModuleMember -Function Convert-JtFolderPath_To_Meta_Zahlung

Export-ModuleMember -Function Convert-JtFolderPath_To_Value_Anzahl
Export-ModuleMember -Function Convert-JtFolderPath_To_Value_Betrag_BxH
Export-ModuleMember -Function Convert-JtFolderPath_To_Value_Betrag_Part
Export-ModuleMember -Function Convert-JtFolderPath_To_Value_Betrag_Part_For_Year

Export-ModuleMember -Function Get-JtLabel_Anzahl
Export-ModuleMember -Function Get-JtLabel_Betrag
Export-ModuleMember -Function Get-JtLabel_Betrag_Miete
Export-ModuleMember -Function Get-JtLabel_Betrag_Voraus
Export-ModuleMember -Function Get-JtLabel_Betrag_Zahlung

Export-ModuleMember -Function New-JtIndex_Anzahl
Export-ModuleMember -Function New-JtIndex_Betrag
Export-ModuleMember -Function New-JtIndex_BxH
Export-ModuleMember -Function New-JtIndex_Default
Export-ModuleMember -Function New-JtIndex_Zahlung

Export-ModuleMember -Function Test-JtFolder
Export-ModuleMember -Function Test-JtFolder_File
Export-ModuleMember -Function Test-JtFolder_Recurse

Export-ModuleMember -Function Write-JtIoFile
Export-ModuleMember -Function Write-JtIoFile_Meta
Export-ModuleMember -Function Write-JtIoFile_Meta_Betrag
Export-ModuleMember -Function Write-JtIoFile_Meta_Report
Export-ModuleMember -Function Write-JtIoFile_Meta_Time
Export-ModuleMember -Function Write-JtIoFile_Meta_Version

Export-ModuleMember -Function Update-JtIndex_BxH
Export-ModuleMember -Function Update-JtFolder_Md_and_Meta 
Export-ModuleMember -Function Update-JtFolderPath_Md_and_Meta 
