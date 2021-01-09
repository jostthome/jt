using module JtClass
using module JtIo
using module JtTbl
using module JtUtil
using module JtColRen
using module JtCsv
using module JtMd
using module JtPreisliste
using module JtTemplateFile

class JtFolderRenderer : JtClass {

    [JtIoFolder]$JtIoFolder = $Null
    [JtTemplateFile]$JtTemplateFile = $Null

    JtFolderRenderer([JtIoFolder]$TheJtIoFolder) {
        $This.ClassName = "JtFolderRenderer"
        $This.JtIoFolder = $TheJtIoFolder
        Write-JtLog -Text ( -join ("JtFolderRenderer; path:", $This.JtIoFolder.GetPath()))
        $This.JtTemplateFile = Get-JtTemplateFile -JtIoFolder $This.JtIoFolder -Extension $This.GetTemplateFileExtension()
        Write-JtLog( -Join ("JtFolderRenderer label:", $this.GetLabel(), " JtTemplateFile name:", $This.JtTemplateFile.GetName()))
    }

    [Boolean]DoCheckFolder() {
        [Boolean]$Result = $True
        [System.Collections.ArrayList]$Files = $This.JtIoFolder.GetNormalFiles()

        
        if ($False -eq $This.JtTemplateFile.IsValid()) {
            return $False
        }
        
        foreach ($MyFile in $Files) {
            [JtIoFile]$JtIoFile = $MyFile
            [Boolean]$FileValid = $This.JtTemplateFile.DoCheckFile($JtIoFile)
            if ($($FileValid)) {
                $Result = $False
            }
        }
        return $Result
    }
    
    [Boolean]DoCleanFilesInFolder() {
        [String]$OutputFilePrefix = $This.GetOutputFilePrefix()
        [String]$OutputFileExtension = $This.GetOutputFileExtension()
        $This.JtIoFolder.DoCleanFiles($OutputFilePrefix, $OutputFileExtension)
        
        [String]$OutputFilePrefix = $This.GetOutputFilePrefixCsv()
        [String]$OutputFileExtension = $This.GetOutputFileExtensionCsv()
        $This.JtIoFolder.DoCleanFiles($OutputFilePrefix, $OutputFileExtension)
        
        return $True
    }

    [Boolean]DoWriteCsvFileIn([JtIoFolder]$FolderTarget) {
        [String]$OutputFileLabel = $This.GetOutputFileLabelCsv()

        $OutputFileLabel = ConvertTo-LabelToFilename $OutputFileLabel
        
        if ($FolderTarget.IsExisting()) {
            # OK.
        }
        else {
            Write-JtError -Text ( -join ("TargetFolder does not exist!!! TargetFolder:", $FolderTarget.GetPath()))
            return $False
        }
        
        if ($This.JtIoFolder.IsExisting()) {
            [System.Data.Datatable]$DataTable = $This.GetDatatable()
            New-JtCsvWriteData -Label $OutputFileLabel -JtIoFolder $FolderTarget -DataTable $DataTable
            return $True
        }
        else {
            Write-JtError -Text ( -join ("JtIoFolder does not exist!!! TargetFolder:", $This.JtIoFolder.GetPath()))
            return $False
        }
    }
    
    [Boolean]DoWriteCsvFileInFolder() {
        [JtIoFolder]$FolderTarget = $This.JtIoFolder
        return $This.DoWriteCsvFileIn($FolderTarget)
    }
    
    [Boolean]DoWriteInCInventory() {
        if (!($This.JtIoFolder.IsExisting())) {
            Write-JtError -Text ( -join ("Error!!! Please edit XML for:", $This.JtIoFolder.GetPath()))
            return $False
        }
        # $This.DoCleanFilesInFolder()
        $This.DoWriteSpecialFileInCInventory()
        return $True
    }

    [Boolean]DoWriteMdFileIn([JtIoFolder]$FolderTarget) {
        Write-JtLog -Text ("Writing MD-Doc - BEGIN")
        [String]$Md = $This.GetMdDoc() 
        Write-JtLog -Text ($Md)
        Write-JtLog -Text ("Writing MD-Doc - END")
        
        [String]$OutFileName = $This.GetMdFileName()
        [String]$OutFilePath = $FolderTarget.GetFilePath($OutFileName)
        
        Write-JtIo -Text ( -join ("Writing MD-Doc:", $OutFilePath))
        $Md | Out-File -FilePath $OutFilePath -Encoding UTF8

        return $True
    }

    [Boolean]DoWriteMdFile() {
        [JtIoFolder]$FolderTarget = $This.JtIoFolder
        return $This.DoWriteMdFileIn($FolderTarget)
    }

    
    [Boolean]DoWriteInFolder() {
        if (!($This.JtIoFolder.IsExisting())) {
            Write-JtError -Text ( -join ("Error!!! Please edit XML for:", $This.JtIoFolder.GetPath()))
            return $False
        }
        $This.DoCleanFilesInFolder()
        $This.DoWriteSpecialFileInFolder()
        return $True
    }
    
    [Boolean]DoWriteSpecialFileIn([JtIoFolder]$FolderTarget) {
        [String]$OutputFileName = $This.GetOutputFileName()
        $OutputFileName = ConvertTo-LabelToFilename $OutputFileName
        
        if ($FolderTarget.IsExisting()) {
            # OK.
        }
        else {
            Write-JtError -Text ( -join ("TargetFolder does not exist!!! TargetFolder:", $FolderTarget.GetPath()))
            return $False
        }
        
        [String]$OutputFilePath = $FolderTarget.GetFilePath($OutputFileName)
        if ($This.JtIoFolder.IsExisting()) {
            Write-JtIo -Text ( -join ("WARNING. Creating special file. PREFIX:", $This.GetOutputFilePrefix(), " EXTENSION:", $This.GetOutputFileExtension(), "; file:", $OutputFilePath))
            $This.JtIoFolder.GetPath() | Out-File -FilePath $OutputFilePath -Encoding UTF8
            return $True
        }
        else {
            Write-JtError -Text ( -join ("JtIoFolder does not exist!!! TargetFolder:", $This.JtIoFolder.GetPath()))
            return $False
        }
    }
    
    [Boolean]DoWriteSpecialFileInFolder() {
        [JtIoFolder]$FolderTarget = $This.JtIoFolder
        return $This.DoWriteSpecialFileIn($FolderTarget)
    }
    

    [System.Data.DataTable]GetDatatable() {
        [System.Collections.ArrayList]$Files = $This.JtIoFolder.GetNormalFiles()
        [JtTemplateFile]$TemplateFile = $This.JtTemplateFile
        [String]$TemplateFileName = $TemplateFile.GetName()
        [System.Collections.ArrayList]$ColRens = $TemplateFile.GetJtColRens()

        [JtColRen]$ColRen = New-JtColRenFileName
        $ColRens.Add($ColRen)
        
        [JtColRen]$ColRen = New-JtColRenFilePath
        $ColRens.Add($ColRen)

        $FilenameParts = $TemplateFileName.Split(".")
        [System.Data.Datatable]$Datatable = New-Object System.Data.Datatable
        
        foreach ($ColRen in $ColRens) {
            [JtColRen]$MyColRen = [JtColRen]$ColRen
            [String]$Header = $MyColRen.GetHeader()

            Write-JtLog ( -join ("GetDatatable.TemplateFileName:", $TemplateFileName, " Header:", $Header))
            $Datatable.Columns.Add($Header, "String")
        }

        
        
        foreach ($MyFile in $Files) {
            [JtIoFile]$JtIoFile = $MyFile
            [String]$FileName = $JtIoFile.GetName()
            Write-JtLog -Text ( -join ("____FileName:", $FileName))

            $FilenameParts = $FileName.Split(".")
            $Row = $Datatable.NewRow()
            for ([Int32]$j = 0; $j -lt $FilenameParts.Count; $j++) {
                [JtColRen]$ColRen = $ColRens[$j]
                if ($Null -eq $ColRen) {
                    Throw "ColRen is NULL for $j with filename: $FileName"
                }
                else {
                    [String]$Header = $ColRen.GetHeader()
                    [String]$Value = $ColRens[$j].GetOutput($FilenameParts[$j])
                    $Row.($Header) = $Value
                }
            }

            [JtColRen]$ColRen = New-JtColRenFileName
            [String]$Header = $ColRen.GetHeader()
            [String]$Value = $ColRen.GetOutput($JtIoFile.GetPath())
            $Row.($Header) = $Value

            [JtColRen]$ColRen = New-JtColRenFilePath
            [String]$Header = $ColRen.GetHeader()
            [String]$Value = $ColRen.GetOutput($JtIoFile.GetPath())
            $Row.($Header) = $Value

            $Datatable.Rows.Add($Row)
        }
        return $Datatable
    }

    
    [String]GetInfo() {
        Throw "GetInfo should be overwritten"
        return $Null
    }
    
    [String]GetLabel() {
        Throw "GetLabel should be overwritten"
        return $Null
    }
    
    [String]GetMdDoc() {
        Throw "GetMdDoc should be overwritten"
        return $Null
    }
    
    [String]GetOutputFileExtension() {
        Throw "GetOutputFileExtension should be overwritten"
        return $Null
    }
    
    [String]GetOutputFilePrefix() {
        Throw "GetOutputFilePrefix should be overwritten"
        return $Null
    }
    
    [String]GetOutputFilePrefixCsv() {
        return [JtIoFile]::FilePrefixFolder
    }
    
    [String]GetOutputFileExtensionCsv() {
        return [JtUtil]::FileExtensionCsv
    }
    
    [String]GetOutputFileLabelCsv() {
        [String]$OutputFilePrefix = $This.GetOutputFilePrefixCsv()
        
        [String]$MyFolderName = $This.JtIoFolder.GetName()
        [String]$FileLabel = $MyFolderName
        [String]$OutputFileName = -join ($OutputFilePrefix, ".", $FileLabel)
        return $OutputFileName
    }
    
    [String]GetOutputFileName() {
        [String]$OutputFilePrefix = $This.GetOutputFilePrefix()
        [String]$OutputFileExtension = $This.GetOutputFileExtension()
        [String]$MyValue = $This.GetInfo()
        
        [String]$MyFolderName = $This.JtIoFolder.GetName()
        [String]$FileLabel = -join ($MyFolderName, ".", $MyValue)
        [String]$OutputFileName = -join ($OutputFilePrefix, ".", $FileLabel, $OutputFileExtension)
        return $OutputFileName
    }


    [String]GetSum([String]$MyColumn) {
        [Decimal]$MySum = 0
        if (!($This.JtIoFolder.IsExisting())) {
            Write-JtError -Text ( -join ("Error!!! Please edit XML for:", $This.JtIoFolder.GetPath()))
            return $False
        }
        $Files = $This.JtIoFolder.GetNormalFiles()
        for ([int32]$i = 0; $i -lt $Files.Count; $i++) {
            [JtIoFile]$JtIoFile = $Files[$i]
            [Decimal]$MyDec = 0

            [String]$TemplateFileName = $This.JtTemplateFile.GetName()

            [String]$MyValue = $JtIoFile.GetInfoFromFileName($TemplateFileName, $JtIoFile.GetName(), $MyColumn)
            $MyValue = $MyValue.Replace("_", ",")
            
            [Decimal]$MyDec = 0

            try {
                [Decimal]$MyDec = [Decimal]$MyValue
            }
            catch {
                Write-JtError -Text ( -join ("Problme in COL:", $MyColumn, " with value:", $MyValue))
            }
            $MySum = $MySum + $MyDec
        }
        [Decimal]$DecResult = $MySum / 100

        [String]$Result = $DecResult.ToString("0.00")
        $Result = $Result.Replace(",", "_")
        $Result = $Result.Replace(".", "_")
        return $Result
    }

    [String]GetTemplateFileExtension() {
        [String]$Extension = [JtIo]::FilenameExtension_Folder
        return $Extension
    }
}

class JtFolderRenderer_Count : JtFolderRenderer {

    JtFolderRenderer_Count([JtIoFolder]$TheJtIoFolder) : Base($TheJtIoFolder) {
        $This.ClassName = "JtFolderRenderer_Count"
    }

    [System.Data.Datatable]GetDatatable() {
        [System.Data.Datatable]$Datatable = New-Object System.Data.Datatable 
        [System.Collections.ArrayList]$Files = $This.JtIoFolder.GetNormalFiles()
        [System.Collections.ArrayList]$ColRens = $This.JtTemplateFile.GetJtColRens()

        foreach ($ColRen in $ColRens) {
            [String]$Header = $ColRen.GetHeader()
            $Datatable.Columns.Add($Header, "String")
        }

        [JtColRen]$ColRen = New-JtColRenFileYear
        [String]$Header = $ColRen.GetHeader()
        $Datatable.Columns.Add($Header, "String")
            
        [JtColRen]$ColRen = New-JtColRenFileAge
        [String]$Header = $ColRen.GetHeader()
        $Datatable.Columns.Add($Header, "String")

        foreach ($MyFile in $Files) {
            [JtIoFile]$JtIoFile = $MyFile
            [String]$FileName = $JtIoFile.GetName()
            Write-JtLog -Text ( -join ("____FileName:", $FileName))
    
            $FilenameParts = $FileName.Split(".")
            $Row = $Datatable.NewRow()
            for ([Int32]$j = 0; $j -lt $FilenameParts.Count; $j++) {
                [JtColRen]$ColRen = $ColRens[$j]
                [String]$Header = $ColRen.GetHeader()
                [String]$Value = $ColRens[$j].GetOutput($FilenameParts[$j])
                $Row.($Header) = $Value
            }

            [JtColRen]$ColRen = New-JtColRenFileYear
            [String]$Header = $ColRen.GetHeader()
            [String]$Value = $ColRen.GetOutput($JtIoFile.GetPath())
            $Row.($Header) = $Value

            [JtColRen]$ColRen = New-JtColRenFileAge
            [String]$Header = $ColRen.GetHeader()
            [String]$Value = $ColRen.GetOutput($JtIoFile.GetPath())
            $Row.($Header) = $Value

            $Datatable.Rows.Add($Row)
        }
        return $Datatable
    }

    [Decimal]GetInfo() {
        [Decimal]$MyCount = 0
        if (!($This.JtIoFolder.IsExisting())) {
            Write-JtError -Text ( -join ("Error!!! Please edit XML for:", $This.JtIoFolder.GetPath()))
            return $False
        }
        $Files = $This.JtIoFolder.GetNormalFiles()
        for ([int32]$i = 0; $i -lt $Files.Count; $i++) {
            [JtIoFile]$JtIoFile = $Files[$i]
            if ($JtIoFile.GetInfoFromFileName_Count_IsValid()) {
                [String]$MyAnz = $JtIoFile.GetInfoFromFileName_Count()
                [Decimal]$MyDecAnz = [Decimal]$MyAnz 
                $MyCount = $MyCount + $MyDecAnz
            }
            else {
                [JtIoFolder]$Folder = [JtIoFolder]::new($JtIoFile)
                Write-JtFolder -Text ( -join ("Problem with file (in GetInfo): "), $JtIoFile.GetName()) -Path $Folder.GetPath()
            }
            
        }
        return $MyCount
    }

    [String]GetLabel() {
        return "COUNT"
    }
    
    [String]GetOutputFileExtension() {
        [String]$Result = [JtIo]::FilenameExtension_Sum
        return $Result
    }

    [String]GetOutputFilePrefix() {
        [String]$Result = [JtIoFile]::FilePrefixAnzahl
        return $Result
    }
}


class JtFolderRenderer_Default : JtFolderRenderer {

    JtFolderRenderer_Default([JtIoFolder]$TheJtIoFolder) : Base($TheJtIoFolder) {
        $This.ClassName = "JtFolderRenderer_Default"
    }

    [Decimal]GetInfo() {
        [Decimal]$MyCount = 0
        if (!($This.JtIoFolder.IsExisting())) {
            Write-JtError -Text ( -join ("Error!!! Please edit XML for:", $This.JtIoFolder.GetPath()))
            return $False
        }
        $Files = $This.JtIoFolder.GetNormalFiles()
        for ([int32]$i = 0; $i -lt $Files.Count; $i++) {
            [JtIoFile]$JtIoFile = $Files[$i]
            Write-JtLog -Text ( -join ("JtIoFile: ", $JtIoFile.GetName()))
        }
        return $MyCount
    }

    
    [String]GetLabel() {
        return "DEFAULT"
    }
    
    [String]GetOutputFileExtension() {
        [String]$Result = [JtIo]::FilenameExtension_Sum
        return $Result
    }

    [String]GetOutputFilePrefix() {
        [String]$Result = [JtIoFile]::FilePrefixAnzahl
        return $Result
    }

    [Boolean]DoWriteSpecialFileIn([JtIoFolder]$FolderTarget) {
            return $False
    }

}


class JtFolderRenderer_Miete : JtFolderRenderer {

    JtFolderRenderer_Miete([JtIoFolder]$TheJtIoFolder) : Base($TheJtIoFolder) {
        $This.ClassName = "JtFolderRenderer_Miete"
    }
    


    [String]GetSum_Miete() {
        [String]$MyCol = "MIETE"
        [String]$MySum = $This.GetSum($MyCol)
        return $MySum
    }

    [String]GetSum_Nebenkosten() {
        [String]$MyCol = "NEBENKOSTEN"
        [String]$MySum = $This.GetSum($MyCol)
        return $MySum
    }

    [String]GetSum_Betrag() {
        [String]$MyCol = "BETRAG"
        [String]$MySum = $This.GetSum($MyCol)
        return $MySum
    }
    
    [System.Data.Datatable]GetDatatable() {
        [System.Data.Datatable]$Datatable = New-Object System.Data.Datatable
        [JtTemplateFile]$JtTemplateFile = $This.JtTemplateFile
        [System.Collections.ArrayList]$ColRens = $JtTemplateFile.GetJtColRens()

        [JtColRen]$ColRen = New-JtColRenInputTextNr
        $Datatable.Columns.Add($ColRen.GetHeader(), "String")
        
        [Int32]$j = 0
        $j = 0
        [JtColRen]$ColRen = $ColRens[$j]
        $Datatable.Columns.Add($ColRen.GetHeader(), "String")

        $j = 1
        [JtColRen]$ColRen = $ColRens[$j]
        $Datatable.Columns.Add($ColRen.GetHeader(), "String")

        $j = 2
        [JtColRen]$ColRen = $ColRens[$j]
        $Datatable.Columns.Add($ColRen.GetHeader(), "String")
        
        $j = 3
        [JtColRen]$ColRen = $ColRens[$j]
        $Datatable.Columns.Add($ColRen.GetHeader(), "String")

        $j = 4
        [String]$MySum = $This.GetSum_Miete()
        [JtColRen]$ColRen = $ColRens[$j]
        $Datatable.Columns.Add($ColRen.GetHeader(), "String")
        
        $j = 5
        [String]$MySum = $This.GetSum_Nebenkosten()
        [JtColRen]$ColRen = $ColRens[$j]
        $Datatable.Columns.Add($ColRen.GetHeader(), "String")
        
        $j = 6
        [String]$MySum = $This.GetSum_Betrag
        [JtColRen]$ColRen = $ColRens[$j]
        $Datatable.Columns.Add($ColRen.GetHeader(), "String")


        [System.Collections.ArrayList]$Files = $This.JtIoFolder.GetNormalFiles()

        [Int32]$IntLine = 1
        foreach ($MyFile in $Files) {
            [JtIoFile]$JtIoFile = $MyFile
            [String]$FileName = $JtIoFile.GetName()
            Write-Host "____FileName:" $FileName
            
            [String]$Value = ""
            
            $FilenameParts = $FileName.Split(".")
            $Row = $Datatable.NewRow()

            for ([Int32]$j = 0; $j -lt ($FilenameParts.Count - 1); $j++) {
                
                [JtColRen]$ColRen = New-JtColRenInputTextNr
                [String]$Header = $ColRen.GetHeader()
                $Row.($Header) = $IntLine

                [JtColRen]$ColRen = $ColRens[$j]
                
                if ($Null -eq $ColRen) {
                    Write-JtError -Text ( -join ("This should not happen. JtColRen is NULL. JtIoFile:", $JtIoFile.GetPath()))
                }
                else {
                    [String]$Header = $ColRen.GetHeader()
                    $Value = $ColRens[$j].GetOutput($FilenameParts[$j])
                    $Row.($Header) = $Value
                }
            }
            
            $Datatable.Rows.Add($Row)
            $IntLine = $IntLine + 1
        }
        
        $Row = $Datatable.NewRow()
        
        [JtColRen]$ColRen = New-JtColRenInputTextNr
        $Row.($ColRen.GetHeader()) = "SUM:"
        
        [Int32]$j = 0
        $j = 0
        [JtColRen]$ColRen = $ColRens[$j]
        $Row.($ColRen.GetHeader()) = "(Monat)"

        $j = 1
        [JtColRen]$ColRen = $ColRens[$j]
        $Row.($ColRen.GetHeader()) = "(Art)"

        $j = 2
        [JtColRen]$ColRen = $ColRens[$j]
        $Row.($ColRen.GetHeader()) = "(Objekt)"
        
        $j = 3
        [JtColRen]$ColRen = $ColRens[$j]
        $Row.($ColRen.GetHeader()) = "(Mieter)"

        $j = 4
        [String]$MySum = $This.GetSum_Miete()
        [JtColRen]$ColRen = $ColRens[$j]
        $Row.($ColRen.GetHeader()) = $ColRen.GetOutput($MySum)
        
        $j = 5
        [String]$MySum = $This.GetSum_Nebenkosten()
        [JtColRen]$ColRen = $ColRens[$j]
        $Row.($ColRen.GetHeader()) = $ColRen.GetOutput($MySum)
        
        $j = 6
        [String]$MySum = $This.GetSum_Betrag()
        [JtColRen]$ColRen = $ColRens[$j]
        $Row.($ColRen.GetHeader()) = $ColRen.GetOutput($MySum)

        $DataTable.Rows.Add($Row)

        return $DataTable
    }



    [String]GetInfo() {
        if (!($This.JtIoFolder.IsExisting())) {
            Write-JtError -Text ( -join ("Error!!! Please edit XML for:", $This.JtIoFolder.GetPath()))
            return $False
        }

        $Result = -join ($This.GetSum_Miete(), ".", $This.GetSum_Nebenkosten(), ".", $This.GetSum_Betrag())
        return $Result
    }

    
    [String]GetLabel() {
        return "MIETE"
    }
    


    [String]GetMdDoc() {

        [String]$FolderName = $This.JtIoFolder.GetName()
        $FoldernameParts = $FolderName.split(".")
        [String]$Jahr = $FolderNameParts[$FoldernameParts.count - 1]
        [MdDocument]$MdDocument = [MdDocument]::new( -Join ("Zahlungen ", $Jahr))
        [String]$Timestamp = Get-JtTimestamp
        $MdDocument.AddLine( -join ("*", " ", "Stand: ", $Timestamp))
        $MdDocument.AddLine( -join ("*", " ", $This.JtIoFolder.GetParentFolder().GetPath()))

        # $MdDocument.AddLine("Hier werden die Pläne aufgelistet.")

        $MdDocument.AddH2("Miete und Nebenkosten")

        [MdTable]$MyTable = [MdTable]::new($This.GetDatatable())

        $MdDocument.AddLine($MyTable.GetOutput())

        $MdDocument.AddLine("---")

        return $MdDocument.GetOutput()
    }

    [String]GetMdFileName() {
        [String]$OutputFilePrefix = "zzz.ABRECHNUNG"
        [String]$OutputFileExtension = [JtIo]::FilenameExtension_Md
        
        [String]$MyFolderName = $This.JtIoFolder.GetName()
        [String]$OutputFileName = -join ($OutputFilePrefix, ".", $MyFolderName, $OutputFileExtension)
        return $OutputFileName
    }

    [String]GetOutputFileExtension() {
        [String]$Result = [JtIo]::FilenameExtension_Sum
        return $Result
    }

    [String]GetOutputFilePrefix() {
        [String]$Result = [JtIoFile]::FilePrefixSum
        return $Result
    }

    [String]GetTemplateFileExtension() {
        [String]$Extension = [JtIo]::FilenameExtension_Whg
        return $Extension
    }

}


class JtFolderRenderer_Poster : JtFolderRenderer {

    [JtPreisliste]$JtPreisliste = $Null
    [String]$TemplateFileName = $Null

    JtFolderRenderer_Poster([JtIoFolder]$TheJtIoFolder, [JtPreisliste]$MyJtPreisliste) : Base($TheJtIoFolder) {
        $This.ClassName = "JtFolderRenderer_Poster"
        $This.JtPreisliste = $MyJtPreisliste
        $This.TemplateFileName = -join ("_NACHNAME.VORNAME.LABEL.PAPIER.BxH", [JtIo]::FilenameExtension_Poster)
    }
    

    
    [System.Data.DataTable]GetDatatable() {
        [System.Data.Datatable]$Datatable = New-Object System.Data.Datatable

        [JtColRen]$MyRen = New-JtColRenInputTextNr
        $Datatable.Columns.Add($MyRen.GetHeader(), "String")
        
        [JtColRen]$MyRen = New-JtColRenFileJtPreisliste_Price -JtPreisliste $This.JtPreisliste
        $Datatable.Columns.Add($MyRen.GetHeader(), "String")
        
        [JtColRen]$MyRen = New-JtColRenInputText -Label "NACHNAME"
        $Datatable.Columns.Add($MyRen.GetHeader(), "String")

        [JtColRen]$MyRen = New-JtColRenInputText -Label "VORNAME"
        $Datatable.Columns.Add($MyRen.GetHeader(), "String")

        [JtColRen]$MyRen = New-JtColRenInputText -Label "LABEL"
        $Datatable.Columns.Add($MyRen.GetHeader(), "String")

        [JtColRen]$MyRen = New-JtColRenInputText -Label "PAPIER"
        $Datatable.Columns.Add($MyRen.GetHeader(), "String")

        [JtColRen]$MyRen = New-JtColRenInputText -Label "BxH"
        $Datatable.Columns.Add($MyRen.GetHeader(), "String")

        [JtColRen]$MyRen = New-JtColRenFileArea
        $Datatable.Columns.Add($MyRen.GetHeader(), "String")
        
        [JtColRen]$MyRen = New-JtColRenFileJtPreisliste_Paper -JtPreisliste $This.JtPreisliste
        $Datatable.Columns.Add($MyRen.GetHeader(), "String")
        
        [JtColRen]$MyRen = New-JtColRenFileJtPreisliste_Ink -JtPreisliste $This.JtPreisliste
        $Datatable.Columns.Add($MyRen.GetHeader(), "String")


        [System.Collections.ArrayList]$Files = $This.JtIoFolder.GetNormalFiles()



        [Int32]$IntLine = 1
        foreach ($MyFile in $Files) {
            $Row = $Datatable.NewRow()
            [JtIoFile]$JtIoFile = $MyFile
            [String]$FileName = $JtIoFile.GetName()
            Write-Host "____FileName:" $FileName
            
            [String]$Value = ""
            
            [JtColRen]$MyRen = New-JtColRenInputTextNr
            [String]$Value = $IntLine
            $Row.($MyRen.GetHeader()) = $Value
            
            $FilenameParts = $FileName.Split(".")

            [JtColRen]$MyRen = New-JtColRenFileJtPreisliste_Price -JtPreisliste $This.JtPreisliste
            [String]$Value = $MyRen.GetOutput($JtIoFile.GetPath())
            $Row.($MyRen.GetHeader()) = $Value
            Write-JtLog ( -join ("Preis:", $Value))

            [JtColRen]$MyRen = New-JtColRenInputText -Label "NACHNAME"
            $Value = $FilenameParts[0]
            $Row.($MyRen.GetHeader()) = $Value
    
            [JtColRen]$MyRen = New-JtColRenInputText -Label "VORNAME"
            $Value = $FilenameParts[1]
            $Row.($MyRen.GetHeader()) = $Value
            
            [JtColRen]$MyRen = New-JtColRenInputText -Label "LABEL"
            $Value = $FilenameParts[2]
            $Row.($MyRen.GetHeader()) = $Value
    
            [JtColRen]$MyRen = New-JtColRenInputText -Label "PAPIER"
            $Value = $FilenameParts[3]
            $Row.($MyRen.GetHeader()) = $Value

            [JtColRen]$MyRen = New-JtColRenInputText -Label "BxH"
            $Value = $FilenameParts[4]
            $Row.($MyRen.GetHeader()) = $Value
            
            [JtColRen]$MyRen = New-JtColRenFileArea
            [String]$Value = $MyRen.GetOutput($JtIoFile.GetPath())
            $Row.($MyRen.GetHeader()) = $Value
            
            [JtColRen]$MyRen = New-JtColRenFileJtPreisliste_Paper -JtPreisliste $This.JtPreisliste
            [String]$Value = $MyRen.GetOutput($JtIoFile.GetPath())
            $Row.($MyRen.GetHeader()) = $Value
            
            [JtColRen]$MyRen = New-JtColRenFileJtPreisliste_Ink -JtPreisliste $This.JtPreisliste
            [String]$Value = $MyRen.GetOutput($JtIoFile.GetPath())
            $Row.($MyRen.GetHeader()) = $Value
            
            $Datatable

            $Datatable.Rows.Add($Row)
            $IntLine = $IntLine + 1
        }
        
        $Row = $Datatable.NewRow()

        [JtColRen]$MyRen = New-JtColRenInputTextNr
        [String]$Header = $MyRen.GetHeader()
        [String]$Value = "SUM:"
        $Row.($Header) = $Value

        [JtColRen]$JtColRen = New-JtColRenFileJtPreisliste_Price -JtPreisliste $This.JtPreisliste
        [String]$Header = $JtColRen.GetHeader()
        [String]$Value = $This.GetInfo()
        $Row.($Header) = $Value

        [JtColRen]$JtColRen = New-JtColRenFileJtPreisliste_Paper -JtPreisliste $This.JtPreisliste
        [String]$Header = $JtColRen.GetHeader()
        [String]$Value = ""
        $Row.($Header) = $Value

        [JtColRen]$JtColRen = New-JtColRenFileJtPreisliste_Ink -JtPreisliste $This.JtPreisliste
        [String]$Header = $JtColRen.GetHeader()
        [String]$Value = ""
        $Row.($Header) = $Value

        $Datatable.Rows.Add($Row)

        $Datatable

        return $Datatable
    }

    [String]GetInfo() {
        [JtColRen]$ColRenJtPreisliste_Price = New-JtColRenFileJtPreisliste_Price -JtPreisliste $This.JtPreisliste
        [Decimal]$MyPrice = 0
        if (!($This.JtIoFolder.IsExisting())) {
            Write-JtError -Text ( -join ("Error!!! Please edit XML for:", $This.JtIoFolder.GetPath()))
            return $False
        }
        $Files = $This.JtIoFolder.GetNormalFiles()
        foreach ($File in $Files) {
            [JtIoFile]$JtIoFile = $File
            
            [String]$MySheetPrice = $ColRenJtPreisliste_Price.GetOutput($JtIoFile.GetPath())
            # Write-JtLog ( -join ("___ MySheetPrice:", $MySheetPrice))

            [Decimal]$MyDecSheetPrice = ConvertTo-JtStringToDecimal $MySheetPrice
            # Write-JtLog ( -join ("___ MyDecSheetPrice:", $MyDecSheetPrice))
    
            $MyPrice = $MyPrice + $MyDecSheetPrice
        }
        [Decimal]$DecResult = $MyPrice

        [String]$Result = ConvertTo-JtDecimalToString2 $DecResult
        return $Result
    }

    [String]GetLabel() {
        return "POSTER"
    }

    [String]GetMdDoc() {
        [MdDocument]$MdDocument = [MdDocument]::new("Fakultät für Architektur und Landschaft")
        $MdDocument.AddLine("https://www.archland.uni-hannover.de/de/fakultaet/ausstattung/plotservice/")
        $MdDocument.AddH2("Plot-Service - Abrechnung")
        
        [String]$Timestamp = Get-JtTimestamp
        $MdDocument.AddLine( -join ("*", " ", "Stand: ", $Timestamp))
        $MdDocument.AddLine( -join ("*", " ", "Preisliste: ", $This.JtPreisliste.GetTitle()))
        $MdDocument.AddLine( -join ("*", " ", $This.JtIoFolder.GetPath()))

        $MdDocument.AddH2("Pläne")

        [MdTable]$MyTable = [MdTable]::new($This.GetDatatable())

        $MdDocument.AddLine($MyTable.GetOutput())

        $MdDocument.AddLine("---")
        $MdDocument.AddLine("Kunde")
        $MdDocument.AddLine("---")
        $MdDocument.AddLine("Plot-Service")
        $MdDocument.AddLine("---")

        return $MdDocument.GetOutput()
    }

    [String]GetMdFileName() {
        [String]$OutputFilePrefix = "zzz.ABRECHNUNG"
        [String]$OutputFileExtension = [JtIo]::FilenameExtension_Md
        
        [String]$MyFolderName = $This.JtIoFolder.GetName()
        [String]$OutputFileName = -join ($OutputFilePrefix, ".", $MyFolderName, $OutputFileExtension)
        return $OutputFileName
    }

    [String]GetOutputFileExtension() {
        [String]$Result = [JtIo]::FilenameExtension_Sum
        return $Result
    }

    [String]GetOutputFilePrefix() {
        [String]$Result = [JtIoFile]::FilePrefixSum
        return $Result
    }

    [String]GetTemplateFileExtension() {
        [String]$Extension = [JtIo]::FilenameExtension_Poster
        return $Extension
    }
}

class JtFolderRenderer_Sum : JtFolderRenderer {

    JtFolderRenderer_Sum([JtIoFolder]$TheJtIoFolder) : Base($TheJtIoFolder) {
        $This.ClassName = "JtFolderRenderer_Sum"
    }
    
    [System.Data.Datatable]GetNewDatatable() {
        [System.Data.Datatable]$Datatable = New-Object System.Data.Datatable
        [System.Collections.ArrayList]$Files = $This.JtIoFolder.GetNormalFiles()
        [JtTemplateFile]$JtTemplateFile = $This.JtTemplateFile
    
        foreach ($MyFile in $Files) {
            [JtIoFile]$JtIoFile = $MyFile
            [String]$FileName = $JtIoFile.GetName()
            Write-JtLog ( -join ("____FileName: ", $FileName))
            
            [String]$Value = ""
            
            $Row = $Datatable.NewRow()
            $FilenameParts = $FileName.Split(".")
            for ([Int32]$j = 0; $j -lt $FilenameParts.Count; $j++) {
                [JtColRen]$Ren = $JtTemplateFile.GetJtColRenForColumnNumber($j)

                [String]$Header = $Ren.GetHeader()
                [String]$Value = $Ren.GetOutput($FilenameParts[$j])
                $Row.($Header) = $Value
            }

            [JtColRen]$Ren = New-JtColRenFileYear
            [String]$Header = $Ren.GetHeader()
            [String]$Value = $Ren.GetOutput($JtIoFile.GetPath())
            $Row.($Header) = $Value

            [JtColRen]$Ren = New-JtColRenFileAge
            [String]$Header = $Ren.GetHeader()
            [String]$Value = $Ren.GetOutput($JtIoFile.GetPath())
            $Row.($Header) = $Value

            [JtColRen]$Ren = New-JtColRenFileName
            [String]$Header = $Ren.GetHeader()
            [String]$Value = $Ren.GetOutput($JtIoFile.GetPath())
            $Row.($Header) = $Value

            [JtColRen]$Ren = New-JtColRenFilePath
            [String]$Header = $Ren.GetHeader()
            [String]$Value = $Ren.GetOutput($JtIoFile.GetPath())
            $Row.($Header) = $Value

            $Datatable.Rows.Add($Row)
        }
        return $Datatable
    }


    [String]GetInfo() {
        [Decimal]$MySum = 0
        if (!($This.JtIoFolder.IsExisting())) {
            Write-JtError -Text ( -join ("Error!!! Please edit XML for:", $This.JtIoFolder.GetPath()))
            return $False
        }
        $Files = $This.JtIoFolder.GetNormalFiles()
        for ([int32]$i = 0; $i -lt $Files.Count; $i++) {
            [JtIoFile]$JtIoFile = $Files[$i]
            [Decimal]$MyDecEuro = 0

            if ($JtIoFile.GetInfoFromFileName_Euro_IsValid()) {
                [String]$MyEuro = $JtIoFile.GetInfoFromFileName_Euro()
                
                # Write-Host "___MyEuro:" $MyEuro
                [Decimal]$MyDecEuro = [Decimal]$MyEuro 
                # Write-Host "___MyDecEuro:" $MyDecEuro
            }
            else {
                [JtIoFolder]$JtIoFolder = [JtIoFolder]::new($JtIoFile)
                Write-JtFolder -Text ( -join ("Problem with file; EURO (in GetInfo):", $JtIoFile.GetName())) -Path $JtIoFolder.GetPath()
            }
    
            $MySum = $MySum + $MyDecEuro
        }
        [Decimal]$DecResult = $MySum / 100

        [String]$Result = $DecResult.ToString("0.00")
        $Result = $Result.Replace(",", "_")
        $Result = $Result.Replace(".", "_")
        return $Result
    }

    [String]GetLabel() {
        return "SUM"
    }

    [String]GetOutputFileExtension() {
        [String]$Result = [JtIo]::FilenameExtension_Sum
        return $Result
    }

    [String]GetOutputFilePrefix() {
        [String]$Result = [JtIoFile]::FilePrefixSum
        return $Result
    }

}
