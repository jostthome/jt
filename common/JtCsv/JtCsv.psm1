using module Jt  
using module JtColRen
using module JtInf
using module JtIo
using module JtRep
using module JtTbl

class JtCsv : JtClass {
    
    [String]$Label = $Null
    [JtIoFolder]$JtIoFolder = $Null
    
    JtCsv([String]$TheLabel, [JtIoFolder]$TheJtIoFolder) {
        $This.ClassName = "JtCsv"
        $This.Label = $TheLabel
        $This.JtIoFolder = $TheJtIoFolder
    }
}

Class JtCsvFolderSummary : JtClass {
    
    [String]$Label = $Null
    [String]$Sub = $Null
    [String]$Expected = $Null
    [JtIoFolder]$JtIoFolder_Base = $Null

    JtCsvFolderSummary([String]$TheLabel, [String]$TheFolderPath, [String]$TheSub, [String]$TheExpected) : Base() {
        $This.ClassName = "JtCsvFolderSummary"
        $This.Label = $TheLabel
        [String]$MyfolderPath = $TheFolderPath
        [JtIoFolder]$MyJtIoFolder_Base = New-JtIoFolder -FolderPath $MyFolderPath
        $This.JtIoFolder_Base = $MyJtIoFolder_Base
        $This.Sub = $TheSub
        $This.Expected = $TheExpected
    }
}

Class JtCsvFolderSummaryMeta : JtCsvFolderSummary {
    
    JtCsvFolderSummaryMeta([String]$TheLabel, [String]$TheFolderPath, [String]$TheSub, [String]$TheExpected) : base($TheLabel, $TheFolderPath, $TheSub, $TheExpected) {
        $This.ClassName = "JtCsvFolderSummaryMeta"

        [String]$MyLabel = $TheLabel
        [String]$MySub = $TheSub

        Write-JtLog -Where $This.ClassName -Text "Label: $MyLabel - Sub: $MySub"

        [JtIoFolder]$MyJtIoFolder_Base = $This.JtIoFolder_Base
        [JtIoFolder]$MyJtIoFolder_Work = $MyJtIoFolder_Base.GetJtIoFolder_Sub($MySub)

        if (!($MyJtIoFolder_Base.IsExisting())) {
            Write-JtLog_Error -Where $This.ClassName -Text "The folder is not existing. MySub: $MySub in MyJtIoFolder_Base: $MyJtIoFolder_Base"
            return
        }
            
        [JtTblTable]$MyJtTblTable = $This.GetTable($MyJtIoFolder_Work, $MyLabel)
        [String]$MyFolderPath_Output = $MyJtIoFolder_Base.GetPath()
        Convert-JtTblTable_To_Csv -JtTblTable $MyJtTblTable -FolderPath_Output $MyFolderPath_Output
    }

    [JtTblTable]GetTable([JtIoFolder]$TheJtIoFolder, [String]$TheLabel) {
        [JtIoFolder]$MyJtIoFolder = $TheJtIoFolder
        [JtIoFolder]$MyLabel = $TheLabel
            
        [JtTblTable]$MyJtTblTable = New-JtTblTable -Label $MyLabel
        [String]$MyExpected = $This.Expected
        [Array]$MyAlExtensions_Expected = $MyExpected.Split(",")

        [System.Collections.ArrayList]$MyAlJtIoSubfolders = $MyJtIoFolder.GetAlJtIoFolders_Sub()
        foreach ($SubFolder in $MyAlJtIoSubfolders) {
            [JtIoFolder]$MyJtIoFolder = $SubFolder

            [JtTblRow]$MyJtTblRow = New-JtTblRow
            [Int16]$MyIntFileCountExpected = 0 

            [String]$MyFoldername = $MyJtIoFolder.GetName()
            $MyJtTblRow.Add("NAME", $MyFoldername)
            # $MyJtTblRow.Add("Label", $MyLabel)

            foreach ($Type in $MyAlExtensions_Expected) {
                [String]$MyExtension = $Type

                [String]$MyFilter = -join ("*", $MyExtension)
                [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder -Filter $MyFilter 
                [Int16]$MyIntCountForType = $MyAlJtIoFiles.Count
                
                $MyColumnName = Convert-JtString_To_ColHeader -Text $MyExtension -Prefix "X"
                $MyColumnValue = $MyIntCountForType
                $MyJtTblRow.Add($MyColumnName, $MyColumnValue)

                $MyIntFileCountExpected = $MyIntFileCountExpected + $MyIntCountForType
            }
            [int16]$MyIntExpected = $MyAlExtensions_Expected.Count

            # Is the result ok? ("OK", "")
            [Int16]$MyIntNumberOk = 0
            if ($MyIntFileCountExpected -ge $MyIntExpected) {
                $MyIntNumberOk = "1"
            }
            
            $MyColumnName = "OK"
            $MyColumnValue = $MyIntNumberOk
            # $MyJtTblRow.Add($MyColumnName, $MyColumnValue)

            # Is the result ok? ("OK", "")
            [String]$MyTextOk = "Nein"
            if ($MyIntFileCountExpected -ge $MyIntExpected) {
                $MyTextOk = "Ja"
            }

            $MyColumnName = "Best"
            $MyColumnValue = $MyTextOk
            # $MyJtTblRow.Add($MyColumnName, $MyColumnValue)

            $MyColumnName = "Gef_SOLL"
            $MyColumnValue = $MyAlExtensions_Expected.Count
            # $MyJtTblRow.Add($MyColumnName, $MyColumnValue)

            # How many files were expected? (1)
            $MyColumnName = "Gef_IST"
            $MyColumnValue = $MyIntFileCountExpected
            # $MyJtTblRow.Add($MyColumnName, $MyColumnValue)
            
            # Which filetypes had to be delivered? (".pdf,.txt")
            $MyColumnName = "Typen_SOLL"
            $MyColumnValue = $MyExpected
            # $MyJtTblRow.Add($MyColumnName, $MyColumnValue)

            # Which filetypes were delivered? (.pdf,.txt)
            [System.Collections.ArrayList]$MyAlTypes = $MyJtIoFolder.GetAlExtensions()
            $MyColumnName = "Typen_IST"
            $MyColumnValue = $MyAlTypes -join ","
            # $MyJtTblRow.Add($MyColumnName, $MyColumnValue)

            # Generate columes for each expected type (X_pdf,X_jpg)
            foreach ($Extension in $MyAlExtensions_Expected) {
                [String]$MyExtension = $Extension
                [String]$MyLabelExtension = $MyExtension.Replace([JtIo]::FileExtension_Meta, "")

                [String]$MyFilter = -join ("*", $MyExtension)
                [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder -Filter $MyFilter 
                [Int16]$MyIntCountForType = $MyAlJtIoFiles.Count
                
                $MyColumnName = Convert-JtString_To_ColHeader -Text $MyLabelExtension -Prefix "X" 
                $MyColumnValue = $MyIntCountForType
                $MyJtTblRow.Add($MyColumnName, $MyColumnValue)

                $MyColumnName = Convert-JtString_To_ColHeader -Text $MyLabelExtension -Prefix "X2" 
                $MyColumnValue = "-"
                [JtIoFile]$MyFile = $null
                if ($MyAlJtIoFiles.Count -gt 0) {
                    [JtIoFile]$MyFile = $MyAlJtIoFiles[0]
                    $MyColumnValue = $MyFile.GetName()
                    $MyColumnValue = $MyColumnValue.Replace($MyExtension, "")
                }
                $MyJtTblRow.Add($MyColumnName, $MyColumnValue)
            }
            $MyJtTblTable.AddRow($MyJtTblRow)
        }
        return $MyJtTblTable 
    }
}




Function Convert-JtAl_to_FileCsv {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][System.Collections.ArrayList]$ArrayList,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output, 
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Label
    )

    $MyFunctionName = "Convert-JtAl_to_FileCsv"

    [System.Collections.ArrayList]$MyAl = $ArrayList
    [String]$MyLabel = $Label
    [String]$MyFolderPath_Output = $FolderPath_Output
    [String]$MyExtension = [JtIo]::FileExtension_Csv
    [String]$MyFilename_Output = -join ($MyLabel, $MyExtension)
    [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $MyFolderPath_Output -Force
    [String]$MyFilePath_Csv = $MyJtIoFolder.GetFilePath($MyFilename_Output)
    
    Write-JtLog_File -Where $MyFunctionName -Text "WARNING. Creating file. EXTENSION: $MyExtension" -FilePath $MyFilePath_Csv
    $MyAl | Export-Csv -Path $MyFilePath_Csv -NoTypeInformation -Delimiter ([JtClass]::Delimiter)
}


Function Convert-JtAlJtIoFiles_to_FileCsv {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][System.Collections.ArrayList]$ArrayList,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output, 
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Label,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Filename_Template
    )

    [String]$MyFunctionName = "Convert-JtAlJtIoFiles_to_FileCsv"

    [System.Collections.ArrayList]$MyAlJtIoFiles = $ArrayList
    [String]$MyFolderPath_Output = $FolderPath_Output
    [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyFolderPath_Output
    [String]$MyLabel = $Label
    [String]$MyFilename_Template = $Filename_Template

    Write-JtLog -Where $MyFunctionName -Text "MyLabel: $MyLabel - MyFilename_Template: $MyFilename_Template - MyJtIoFolder_Output: $MyJtIoFolder_Output"

    [JtTblTable]$MyJtTblTable = New-JtTblTable -Label $MyLabel
    foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File

        [JtTblRow]$MyJtTblRow = $Null    
        if ($MyFilename_Template) {
            $MyJtTblRow = [JtTblFilelist]::GetRowForFileUsingTemplate($MyJtIoFile, $MyFilename_Template)
        }
        else {
            $MyJtTblRow = Convert-JtFilePath_To_JtTblRow_Betrag -FilePath $MyJtIoFile
        }
        $MyJtTblTable.AddRow($MyJtTblRow)
    }
    [String]$MyFolderPath_Output = $MyJtIoFolder_Output.GetPath()
    Convert-JtTblTable_To_Csv -JtTblTable $MyJtTblTable -FolderPath_Output $MyFolderPath_Output  
}

Function Convert-JtAlJtIoFiles_to_JtTblTable {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][System.Collections.ArrayList]$ArrayList,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Label
    )

    [String]$MyFunctionName = "Convert-JtAlJtIoFiles_to_JtTblTable"

    [System.Collections.ArrayList]$MyAlJtIoFiles = $ArrayList
    [String]$MyLabel = $Label

    Write-JtLog -Where $MyFunctionName -Text "MyLabel: $MyLabel"

    [JtTblTable]$MyJtTblTable = New-JtTblTable -Label $MyLabel
    foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File

        [JtTblRow]$MyJtTblRow = Convert-JtIoFile_To_JtTblRow_Normal -FilePath $MyJtIoFile
        $MyJtTblTable.AddRow($MyJtTblRow)
    }
    return $MyJtTblTable
}

Function Convert-JtAlJtIoFiles_to_Documents {
    Param (
        [Cmdletbinding()]
        [Parameter(Mandatory = $True, ValueFromPipeline = $True)][ValidateNotNullOrEmpty()][System.Collections.ArrayList]$ArrayList,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Label
    )

    [String]$MyFunctionName = "Convert-JtAlJtIoFiles_to_Documents"

    [System.Collections.ArrayList]$MyAlJtIoFiles = $ArrayList
    [String]$MyLabel = $Label

    Write-JtLog -Where $MyFunctionName -Text "MyLabel: $MyLabel"

    [JtTblTable]$MyJtTblTable = New-JtTblTable -Label $MyLabel
    foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File

        [JtTblRow]$MyJtTblRow = Convert-JtIoFile_To_JtTblRow_Document -FilePath $MyJtIoFile
        $MyJtTblTable.AddRow($MyJtTblRow) | Out-Null
    }
    return $MyJtTblTable
}


Function Convert-JtDataTable_To_Csv {
    Param (
        [Parameter(Mandatory = $True)][System.Object[]]$DataTable,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Label,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Prefix,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Extension2
    )

    [String]$MyFunctionName = "Convert-JtDataTable_To_Csv"
    
    [String]$MyFolderPath_Output = $FolderPath_Output
    [String]$MyLabel = $Label
    $MyDataTable = $DataTable

    [String]$MyExtension = [JtIo]::FileExtension_Csv
    if ($Extension2) {
        $MyExtension = $Extension2
    }

    [String]$MyFilename_Output = -join ($MyLabel, $MyExtension)

    [String]$MyPrefix = $Null
    if ($Prefix) {
        $MyFilename_Output = -join ($MyPrefix, ".", $MyFilename_Output)
    }
    
    [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyFolderPath_Output -Force

    Write-JtLog -Where $MyFunctionName -Text "Starting ... MyFilename_Output: $MyFilename_Output"
    [String]$MyFilePath_Csv = $MyJtIoFolder_Output.GetFilePath($MyFilename_Output)

    if (1 -gt $MyDataTable.count) {
        Write-JtLog_Error -Where $MyFunctionName -Text "No rows. At path MyFilePath_Csv: $MyFilePath_Csv"
        return
    }
    
    Write-JtLog_File -Where $MyFunctionName -Text "WARNING. Creating file with MyExtension: $MyExtension" -FilePath $MyFilePath_Csv
    
    $MyData = $MyDataTable[0].Table
    $MyData | Export-Csv -Path $MyFilePath_Csv -NoTypeInformation -Delimiter ([JtClass]::Delimiter)
}

Function Convert-JtFilePath_To_JtTblRow_Betrag {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FilePath
    )
        
    # [String]$MyFunctionName = "Convert-JtFilePath_To_JtTblRow_Betrag"
    
    [String]$MyFilePath = $FilePath
    [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $MyFilePath
    [String]$MyFilename = $MyJtIoFile.GetName()
        
    [JtIoFolder]$MyJtIoFolder_Parent = $MyJtIoFile.GetJtIoFolder_Parent()
    [String]$MyFoldername_Parent = $MyJtIoFolder_Parent.GetName()
    [String]$MyFolderPath_Input = $MyJtIoFolder_Parent.GetPath()
        
    [JtTblRow]$MyJtTblRow = New-JtTblRow
        
    $MyAlPartsPath = $MyFolderPath_Input.Split("\")
    ForEach ($IntI in 4..8) {
        if ($IntI -lt $MyAlPartsPath.Count) {
            [String]$MyPart = $MyAlPartsPath[$IntI]
            $MyValue = $Mypart
        }
        else {
            $MyValue = "x"
        }
        $MyJtTblRow.Add("PA$IntI", $MyValue)
    }
        
    ForEach ($IntJ in 1..8) {
        [String]$MyPart = Convert-JtDotter -Text $MyFoldername_Parent -PatternOut $IntJ
        $MyJtTblRow.Add("IN$IntJ", $MyPart)
    }

    [String]$MyPart = Convert-JtDotter -Text $MyFilename -PatternOut "2" -Reverse
    $MyPart = $MyPart.Replace("_", ",")
    $MyJtTblRow.Add("BETRAG", $MyPart)

    [String]$MyPart = Convert-JtDotter -Text $MyFilename -PatternOut "3" -Reverse
    $MyJtTblRow.Add("JAHR", $MyPart)
        
    $MyJtTblRow.Add("NAME", $MyFilename)

    [String]$MyLevel = Get-JtFolderPath_Info_Level -FolderPath $MyJtIoFolder_Parent
    $MyJtTblRow.Add("LEVEL", $MyLevel)

    [String]$MyExtension = $MyJtIoFile.GetExtension()
    $MyJtTblRow.Add("EXTENSION", $MyExtension)
        
    $MyJtTblRow.Add("FOLDERNAME", $MyFoldername_Parent)

    [String]$MyFilePath = $MyJtIoFile.GetPath()
    $MyJtTblRow.Add("FILEPATH", $MyFilePath)

    $MyJtTblRow.Add("FOLDERPATH", $MyFolderPath_Input)
        
    return $MyJtTblRow
}

Function Convert-JtIoFile_To_JtTblRow_Normal {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FilePath
    )
            
    [String]$MyFunctionName = "Convert-JtIoFile_To_JtTblRow_Normal"

    [String]$MyFilePath = $FilePath
    [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $FilePath
            
    Write-JtLog -Where $MyFunctionName -Text "FilePath: $FilePath"
            
    [JtTblRow]$MyJtTblRow = New-JtTblRow
                
    [JtIoFolder]$MyJtIoFolder_Parent = $MyJtIoFile.GetJtIoFolder_Parent()
    [String]$MyFoldername_Parent = $MyJtIoFolder_Parent.GetName()
                
    Foreach ($i in 1..8) {
        [String]$MyPart = Convert-JtDotter -Text $MyFoldername_Parent -PatternOut "$i"
        $MyJtTblRow.Add("PART$i", $MyPart) | Out-Null
    }
    $MyJtTblRow.Add("PARENT_NAME", $MyFoldername_Parent) | Out-Null
                
    [String]$MyFilename = $MyJtIoFile.GetName()
    $MyJtTblRow.Add("NAME", $MyFileName) | Out-Null
        
    [String]$MyExtension2 = $MyJtIoFile.GetExtension2()
    $MyJtTblRow.Add("EXTENSION2", $MyExtension2) | Out-Null

    $MyJtTblRow.Add("PATH", $MyFilePath) | Out-Null

    Foreach ($i in 2..9) {
        [String]$MyLev = Convert-JtPath_To_Parts -Path $MyFilePath -PatternOut "$i"
        $MyJtTblRow.Add("LEV$i", $MyLev) | Out-Null
    }
    return $MyJtTblRow
}

Function Convert-JtIoFile_To_JtTblRow_Document {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FilePath
    )
            
    [String]$MyFunctionName = "Convert-JtIoFile_To_JtTblRow_Document"

    [String]$MyFilePath = $FilePath
    [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $FilePath
    [String]$MyFilename = $MyJtIoFile.GetName()
            
    Write-JtLog -Where $MyFunctionName -Text "FilePath: $FilePath"
            
    [JtTblRow]$MyJtTblRow = New-JtTblRow
                
    [JtIoFolder]$MyJtIoFolder_Parent = $MyJtIoFile.GetJtIoFolder_Parent()
    # [String]$MyFoldername_Parent = $MyJtIoFolder_Parent.GetName()
    [JtTemplateFile]$MyJtTemplateFile = Get-JtTemplateFile -FolderPath_Input $MyJtIoFolder_Parent
    [String]$MyFilename_Template = $MyjtTemplateFile.GetName()

    [Int16]$MyIntParts = ($MyFilename_Template.Split(".")).count

                
    For ($i = 1; $i -lt $MyIntParts; $i++) {
        [String]$MyCol = Convert-JtDotter -Text $MyFilename_Template -PatternOut "$i"
        [String]$MyHeader = C
        [String]$MyPart = Convert-JtDotter -Text $MyFilename -PatternOut "$i"
        [String]$MyOutput = $MyJtTemplateFile.GetOutputFromFilenameForPart($MyFilename, $MyCol)
        $MyJtTblRow.Add($MyCol, $MyOutput) | Out-Null
    }
    # $MyJtTblRow.Add("PARENT_NAME", $MyFoldername_Parent)
                
    [String]$MyFilename = $MyJtIoFile.GetName()
    $MyJtTblRow.Add("NAME", $MyFileName) | Out-Null
        
    # [String]$MyExtension2 = $MyJtIoFile.GetExtension2()
    # $MyJtTblRow.Add("EXTENSION2", $MyExtension2)

    $MyJtTblRow.Add("PATH", $MyFilePath) | Out-Null

    # Foreach ($i in 2..9) {
    #     [String]$MyLev = Convert-JtPath_To_Parts -Path $MyFilePath -PatternOut "$i"
    #     $MyJtTblRow.Add("LEV$i", $MyLev)
    # }
    return $MyJtTblRow
}


Function Convert-JtFolderPath_To_Csv_Filelist {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Filter,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Label
    )

    [String]$MyFunctionName = "Convert-JtFolderPath_To_Csv_Filelist"

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output

    [String]$MyLabel = $Label
    [String]$MyFilter = $Filter
    
    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $FolderPath_Input
    if (!($MyJtIoFolder_Input.IsExisting())) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Folder does not exist!!! MyJtIoFolder_Input: $MyJtIoFolder_Input"
        return
    }

    [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $FolderPath_Output -Force
    if (!($MyJtIoFolder_Output.IsExisting())) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Folder does not exist!!! MyJtIoFolder_Output: $MyJtIoFolder_Output"
        return
    }
        
    [JtTemplateFile]$MyJtTemplateFile = Get-JtTemplateFile -FolderPath_Input $MyJtIoFolder_Input
    if (!($MyJtTemplateFile.IsValid())) {
        Write-JtLog_Error -Where $MyFunctionName -Text "TemplateFile is not valid. MyJtTemplateFile: $MyJtTemplateFile"
        return 
    }

    Write-JtLog -Where $MyFunctionName -Text "Creating CSV filelist for MyFolderPath_Input: $MyFolderPath_Input"

    if ($MyFilter) {
        [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyFolderPath_Input -Filter $MyFilter -Recurse
    }
    else {
        [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyFolderPath_Input -Recurse
    }

    [Int16]$MyIntNumberOfFiles = $MyAlJtIoFiles.count
    
    if (! ($MyIntNumberOfFiles -gt 0 )) {
        Write-JtLog -Where $MyFunctionName -Text "No files found. Noting to do. MyFolderPath_Input: $MyFolderPath_Input"
        return
    }
    $MyJtTblTable = Convert-JtFolderPath_To_JtTblTable_Files -FolderPath_Input $MyFolderPath_Input 
    $MyDatatable = Convert-JtTblTable_To_DataTable -JtTblTable $MyJtTblTable 
    $MyDataTable
            
    [String]$MyFoldername = $MyJtIoFolder_Input.GetName()
    [String]$MyLabel = $MyFoldername
    if ($Label) {
        $MyLabel = $Label
    }

    $MyParams = @{
        DataTable         = $MyDataTable 
        FolderPath_Output = $MyFolderPath_Output 
        Prefix            = [JtIo]::FilePrefix_Folder
        Label             = $MyLabel
        Extension2        = [JtIo]::FileExtension_Csv_Filelist
    }
    Convert-JtDataTable_To_Csv @MyParams
}


Function Convert-JtFolderPath_To_Csv_FileList_Alter {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )
        
    [String]$MyFunctionName = "Convert-JtFolderPath_To_Csv_FileList_Alter"

    Write-JtLog -Where $MyFunctionName -Text "Start..."
    
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
}

Function Convert-JtTblTable_To_Csv {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtTblTable]$JtTblTable,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )
    [String]$MyFunctionName = "Convert-JtTblTable_To_Csv"

    [String]$MyFolderPath_Output = $FolderPath_Output
    [JtTblTable]$MyJtTblTable = $JtTblTable
    [String]$MyLabel = $MyJtTblTable.GetLabel()
        
    Write-JtLog -Where $MyFunctionName -Text "MyLabel: $MyLabel"
    $MyDatatable = Convert-JtTblTable_To_Datatable -JtTblTable $MyJtTblTable

    if ($Null -eq $MyDatatable) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Datatable is NULL. LABEL: $MyLabel"
        return
    }

    $MyParams = @{
        DataTable         = $MyDataTable 
        FolderPath_Output = $MyFolderPath_Output 
        Label             = $MyLabel
    }
    Convert-JtDataTable_To_Csv @MyParams
}

Function Convert-JtTblTable_To_Datatable {
    param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtTblTable]$JtTblTable
    )

    [String]$MyFunctionName = "Convert-JtTblTable_To_Datatable"
    
    [JtTblTable]$MyJtTblTable = $JtTblTable
    [String]$MyLabel = $MyJtTblTable.GetLabel() 
    Write-JtLog -Where $MyFunctionName -Text "Start... MyLabel: $MyLabel"
    
    [System.Data.DataTable]$MyDataTable = New-Object System.Data.DataTable
    [System.Collections.ArrayList]$MyAlObjects = $MyJtTblTable.GetObjects()

    [System.Collections.Specialized.OrderedDictionary]$MyOrdDic = $MyAlObjects[0]
    foreach ($MyKey in $MyOrdDic.keys) {
        $MyDataTable.Columns.Add($MyKey, "String") | Out-Null
    }

    [Int16]$MyIntObjects = $MyAlObjects.count
    Write-JtLog -Where $MyFunctionName -Text "Number of objects. MyIntObjects: $MyIntObjects"

    foreach ($Element in $MyAlObjects) {
        [System.Collections.Specialized.OrderedDictionary]$MyOrdDic = $Element

        $MyRow = $MyDataTable.NewRow()

        foreach ($MyKey in $MyOrdDic.keys) {
            $MyRow.($MyKey) = $MyOrdDic[$MyKey]
        }
        $MyDataTable.Rows.Add($MyRow) | Out-Null
    }
    return , $MyDataTable
}


Function New-JtCsv_ComputerRoomUser {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Expected
    )

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
    [String]$MyExpected = $Expected

    [JtTblTable]$MyJtTblTable = Convert-JtFolderPath_To_JtTblTable_Filetypes -FolderPath_Input $MyFolderPath_Input -Expected $MyExpected
    $MyDataTable = Convert-JtTblTable_To_Datatable -JtTblTable $MyJtTblTable
    Convert-JtDataTable_To_Csv -DataTable $MyDataTable -Label "ComputerRoomUser" -FolderPath_Output $MyFolderPath_Output
}



Function New-JtCsv_FolderSummaryAll {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Label,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Sub,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Expected
    )
    [String]$MyFunctionName = "New-JtCsv_FolderSummaryAll"
    
    [String]$MyLabel = $Label
    [String]$MyFolderPath = $FolderPath
    [String]$MySub = $Sub
    [String]$MyExpected = $Expected
                    
    Write-JtLog -Where $MyFunctionName -Text "Start..."

    [JtIoFolder]$MyJtIoFolder_Base = New-JtIoFolder -FolderPath $MyFolderPath
    [JtIoFolder]$MyJtIoFolder_Work = $MyJtIoFolder_Base.GetJtIoFolder_Sub($MySub)
                
    if (!($MyJtIoFolder_Base.IsExisting())) {
        Write-JtLog_Error -Where $MyFunctionName -Text "The folder is not existing. MySub: $MySub in MyJtIoFolder_Base: $MyJtIoFolder_Base"
        return
    }
        
    [System.Collections.ArrayList]$MyAlExtensions_All = $MyJtIoFolder_Work.GetAlExtensions_Recurse()
        
    [JtTblTable]$MyJtTblTable = New-JtTblTable -Label $MyLabel
    [String]$MyExpected = $Expected
    [Array]$MyAlExtensions_Expected = $MyExpected.Split(",")
                        
    [System.Collections.ArrayList]$MyAlJtIoSubfolders = $MyJtIoFolder_Work.GetAlJtIoFolders_Sub()
    foreach ($Folder in $MyAlJtIoSubfolders) {
        [JtIoFolder]$MyJtIoFolder = $Folder
        
        [JtTblRow]$MyJtTblRow = New-JtTblRow
        $MyIntFileCountExpected = 0 
        $MyIntFileCountAll = 0 
                    
        $MyJtTblRow.Add("Name", $MyJtIoFolder.GetName())
        # $MyJtTblRow.Add("Label", $MyLabel)
        foreach ($Extension in $MyAlExtensions_Expected) {
            [String]$MyExtension = $Extension
        
            [String]$MyFilter = -join ("*", $MyExtension)
            [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder -Filter $MyFilter 
            [Int16]$MyIntCountForType = $MyAlJtIoFiles.Count
                        
            $MyColumnName = Convert-JtString_To_ColHeader -Text $MyExtension -Prefix "X"  
            $MyColumnValue = $MyIntCountForType
            $MyJtTblRow.Add($MyColumnName, $MyColumnValue)
        
            $MyIntFileCountExpected = $MyIntFileCountExpected + $MyIntCountForType
        }
        
        $MyColumnName = "CountExpected"
        $MyColumnValue = $MyIntFileCountExpected
        $MyJtTblRow.Add($MyColumnName, $MyColumnValue)
        
        foreach ($Extension in $MyAlExtensions_All) {
            [String]$MyExtension = $Extension
            [String]$MyLabelExtension = $MyExtension.Replace([JtIo]::FileExtension_Meta, "")
        
            if ($MyLabelExtension.Length -lt 1) {
                $MyLabelExtension = "EMPTY" 
            }
                        
            
            [String]$MyFilter = -join ("*", $MyExtension)
            [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder -Filter $MyFilter 
            [Int16]$MyIntCountForType = $MyAlJtIoFiles.Count
        
        
            $MyColumnName = Convert-JtString_To_ColHeader -Text $MyLabelExtension -Prefix "Z" 
            $MyColumnValue = $MyIntCountForType
            $MyJtTblRow.Add($MyColumnName, $MyColumnValue)
                            
            $MyIntFileCountAll = $MyIntFileCountAll + $MyIntCountForType
        }
                        
        $MyColumnName = "CountAll"
        $MyColumnValue = $MyIntFileCountAll   
        $MyJtTblRow.Add($MyColumnName, $MyIntFileCountAll)
                        
        [Boolean]$MySameNumber = $False
        if (($MyIntFileCountExpected - $MyAlExtensions_Expected.Length) -eq 0) {
            $MySameNumber = $True
        }
        [String]$MyIsExpected = "" 
        if ($MySameNumber) {
            $MyIsExpected = "OK"
        }
        else {
            $MyIsExpected = ""
        }
                        
        $MyColumnName = "Expected"
        $MyColumnValue = $MyIsExpected
        $MyJtTblRow.Add($MyColumnName, $MyColumnValue)
        $MyJtTblTable.AddRow($MyJtTblRow)
    }
    [String]$MyFolderPath_Output = $MyJtIoFolder_Base.GetPath()
    Convert-JtTblTable_To_Csv -JtTblTable $MyJtTblTable -FolderPath_Output $MyFolderPath_Output
}


Function New-JtCsv_FolderSummaryMeta {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Label,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Sub
    )

    [JtCsvFolderSummaryMeta]::new($Label, $FolderPath, $Sub, ".user.meta,.room.meta")

}

Function New-JtCsv_FolderSummaryExpected {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Label,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Sub,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Expected
    )


    [JtIoFolder]$MyJtIoFolder_Base = $Null
    
    [String]$MyFunctionName = "New-JtCsv_FolderSummaryExpected"

    [String]$MyLabel = $Label
    [String]$MySub = $Sub
    [String]$MyExpected = $Expected

    [String]$MyFolderPath = $FolderPath
    [JtIoFolder]$MyJtIoFolder_Base = New-JtIoFolder -FolderPath $MyFolderPath

    Write-JtLog -Where $MyFunctionName -Text "MyLabel: $MyLabel - MySub: $MySub"
        
    [JtIoFolder]$MyJtIoFolder_Base = $MyJtIoFolder_Base
    [JtIoFolder]$MyJtIoFolder_Work = $MyJtIoFolder_Base.GetJtIoFolder_Sub($MySub)

    if (!($MyJtIoFolder_Base.IsExisting())) {
        Write-JtLog_Error -Where $MyFunctionName -Text "The folder is not existing. MySub: $MySub in MyJtIoFolder_Base: $MyJtIoFolder_Base"
        return
    }

    $MyJtTblTable = New-JtTblTable -Label $MyLabel
        
    [System.Collections.ArrayList]$MyAlJtIoSubfolders = $MyJtIoFolder_Work.GetAlJtIoFolders_Sub()
    foreach ($Folder in $MyAlJtIoSubfolders) {
        [JtIoFolder]$MyJtIoFolder = $Folder
        [JtTblRow]$MyJtTblRow = New-JtTblRow
        [Int16]$MyIntFileCountExpected = 0 

        [String]$MyFoldername = $MyJtIoFolder.GetName()
        $MyJtTblRow.Add("Name", $MyFoldername)
        $MyJtTblRow.Add("Label", $MyLabel)

        [Array]$MyAlExtensions_Expected = $MyExpected.Split(",")
        foreach ($Extension in $MyAlExtensions_Expected) {
            [String]$MyExtension = $Extension

            [String]$MyFilter = -join ("*", $MyExtension)
            [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder -Filter $MyFilter 
            [Int16]$MyIntCountForType = $MyAlJtIoFiles.Count

            $MyIntFileCountExpected = $MyIntFileCountExpected + $MyIntCountForType
        }

        [int16]$MyIntExpected = $MyAlExtensions_Expected.Count

        $MyColumnName = "OK"
        # Is the result ok? ("OK", "")
        [Int16]$MyIntNumberOk = 0
        if ($MyIntFileCountExpected -ge $MyIntExpected) {
            $MyIntNumberOk = 1
        }
        $MyColumnValue = $MyIntNumberOk
        $MyJtTblRow.Add($MyColumnName, $MyColumnValue)

        # Is the result ok? ("OK", "")
        [String]$MyTextOk = "Nein"
        if ($MyIntFileCountExpected -ge $MyIntExpected) {
            $MyTextOk = "Ja"
        }

        $MyColumnName = "Best"
        $MyColumnValue = $MyTextOk
        $MyJtTblRow.Add($MyColumnName, $MyColumnValue)

        $MyColumnName = "Gef_SOLL"
        $MyColumnValue = $MyAlExtensions_Expected.Count
        $MyJtTblRow.Add($MyColumnName, $MyColumnValue)

        # How many files were expected? (1)
        $MyColumnName = "Gef_IST"
        $MyColumnValue = $MyIntFileCountExpected
        $MyJtTblRow.Add($MyColumnName, $MyColumnValue)
            
        # Which filetypes had to be delivered? (".pdf,.txt")
        $MyColumnName = "Typen_SOLL"
        $MyColumnValue = $This.Expected
        $MyJtTblRow.Add($MyColumnName, $MyColumnValue)

        # Which filetypes were delivered? (.pdf,.txt)
        [System.Collections.ArrayList]$MyAlTypes = $MyJtIoFolder.GetAlExtensions()
        $MyColumnName = "Typen_IST"
        $MyColumnValue = $MyAlTypes -join ","
        $MyJtTblRow.Add($MyColumnName, $MyColumnValue)

        # Generate columes for each expected type (X_pdf,X_jpg)
        foreach ($Type in $MyAlExtensions_Expected) {
            [String]$MyExtension = [String]$Type

            $MyColumnName = Convert-JtString_To_ColHeader -Text $MyExtension -Prefix "X" 
            [String]$MyFilter = -join ("*", $MyExtension)
            [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder -Filter $MyFilter 
            [Int16]$MyIntCountForType = $MyAlJtIoFiles.Count
            $MyColumnValue = $MyIntCountForType
            $MyJtTblRow.Add($MyColumnName, $MyColumnValue)
        }
        $MyJtTblTable.AddRow($MyJtTblRow)
    }

    [String]$MyFolderPath_Output = $MyJtIoFolder_Base.GetPath()
    Convert-JtTblTable_To_Csv -JtTblTable $MyJtTblTable -FolderPath_Output $MyFolderPath_Output
}


Function New-JtCsvGenerator {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Label
    )

    [String]$MyFunctionName = "New-JtCsvGenerator"

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_input
    
    [String]$MyLabel = "NO LABEL"
    if ($Label) {
        $MyLabel = $Label
    }

    Write-JtLog -Where $MyFunctionName -Text "Starting ... MyLabel: $MyLabel - MyJtIoFolder_Input: $MyJtIoFolder_Input"
        
    # has to be fixed...
    # $MyAlJtTblRow contains some integers; not only rows...
    [System.Collections.ArrayList]$MyAlJtTblRow = Get-JtAl_Rep_JtTblRow -FolderPath_Input $MyFolderPath_Input
    $MyAl = $MyAlJtTblRow[$MyAlJtTblRow.Count - 1]
    foreach ($JtTblRow in $MyAl) {
        $JtTblRow

        if ($JtTblRow) {

            $JtTblRow.GetType()
            
            [JtTblRow]$MyJtTblRow = $JtTblRow
            [String]$MyLabel_Row = $MyJtTblRow.GetLabel()
            [String]$MyLabel_Rep = $MyLabel_Row.Replace("Get-JtRep_", "")
            # Write-JtLog -Where $MyFunctionName -Text "MyLabel: $MyLabel - MyLabel_Rep: $MyLabel_Rep - MyJtIoFolder_Input: $MyJtIoFolder_Input"
            
            [Boolean]$MyBlnUseLine = $True
            # test it
            
            [JtTblTable]$MyJtTblTable = New-JtTblTable -Label $MyLabel_Rep
            if ($MyBlnUseLine) {
                $MyJtTblTable.AddRow($MyJtTblRow) | Out-Null
            }
            
            [JtIoFolder]$MyJtIoFolder_Csv = $MyJtIoFolder_Input.GetJtIoFolder_Sub("csv", $True)
            [String]$MyFolderPath_Output = $MyJtIoFolder_Csv.GetPath()
            Convert-JtTblTable_To_Csv -JtTblTable $MyJtTblTable -FolderPath_Output $MyFolderPath_Output
        }
    }
    return $MyFolderPath_Output
}
    
Export-ModuleMember -Function Convert-JtFilePath_To_JtTblRow_Betrag
Export-ModuleMember -Function Convert-JtIoFile_To_JtTblRow_Document
Export-ModuleMember -Function Convert-JtIoFile_To_JtTblRow_Normal

Export-ModuleMember -Function Convert-JtFolderPath_To_Csv_FileList
Export-ModuleMember -Function Convert-JtFolderPath_To_Csv_FileList_Alter

Export-ModuleMember -Function Convert-JtAl_to_FileCsv
Export-ModuleMember -Function Convert-JtAlJtIoFiles_to_FileCsv
Export-ModuleMember -Function Convert-JtAlJtIoFiles_to_JtTblTable
Export-ModuleMember -Function Convert-JtAlJtIoFiles_to_Documents
Export-ModuleMember -Function Convert-JtDataTable_To_Csv

Export-ModuleMember -Function Convert-JtTblTable_To_Datatable
Export-ModuleMember -Function Convert-JtTblTable_To_Csv

Export-ModuleMember -Function New-JtCsvGenerator
Export-ModuleMember -Function New-JtCsv_FolderSummaryAll
Export-ModuleMember -Function New-JtCsv_FolderSummaryExpected
Export-ModuleMember -Function New-JtCsv_FolderSummaryMeta 
Export-ModuleMember -Function New-JtCsv_ComputerRoomUser


