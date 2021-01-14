using module JtClass
using module JtIo
using module JtTbl
using module JtUtil
using module JtColRen
using module JtCsv
using module JtMd
using module JtPreisliste
using module JtTemplateFile

class JtFolder : JtClass {

    [String]$OutputFilePrefix = "xyz"
    [String]$OutputFileExtension = ".xyz"
    [String]$TemplateFileExtension = $Null
    
    [JtIoFolder]$JtIoFolder = $Null

    [JtTemplateFile]$JtTemplateFile = $Null

    JtFolder([String]$MyPath) {
        Write-JtLog ( -join ("JtFolder. Path: ", $MyPath, " Type: ", $MyPath.GetType()))
        $This.JtIoFolder = New-JtIoFolder -Path $MyPath
        Write-JtLog ( -join ("JtFolder. Path: ", $This.JtIoFolder.GetPath()))
        $This.JtTemplateFile = Get-JtTemplateFile -JtIoFolder $This.JtIoFolder
    }

    DoCleanSpecialFiles() {
        [String]$MyOutputFilePrefix = $This.OutputFilePrefix
        [String]$MyOutputFileExtension = $This.OutputFileExtension
        $This.JtIoFolder.DoCleanFiles($MyOutputFilePrefix, $MyOutputFileExtension)
    }

    [Boolean]DoWriteSpecialFile() {
        $This.DoWriteSpecialFileIn($This.JtIoFolder) 
        return $True
    }

    [String] GetInfo() {
        Throw "GetInfo should be overwritten."
        return ""
    }

    
    [Boolean]DoWriteSpecialFileIn([JtIoFolder]$FolderTarget) {
        [String]$OutputFileName = $This.GetSpecialFileName()
        $OutputFileName = ConvertTo-LabelToFilename $OutputFileName
        
        if ($FolderTarget.IsExisting()) {
            # OK.
        }
        else {
            Write-JtError ( -join ($This.ClassName, ". DoWriteSpecialFileIn.TargetFolder does not exist!!!! TargetFolder:", $FolderTarget.GetPath()))
            return $False
        }
        
        [String]$OutputFilePath = $FolderTarget.GetFilePath($OutputFileName)
        if ($This.JtIoFolder.IsExisting()) {
            Write-JtIo ( -join ("WARNING. Creating special file. PREFIX:", $This.OutputFilePrefix, " EXTENSION:", $This.OutputFileExtension, "; file:", $OutputFilePath))
            $This.JtIoFolder.GetPath() | Out-File -FilePath $OutputFilePath -Encoding UTF8
            return $True
        }
        else {
            Write-JtError ( -join ("JtIoFolder does not exist!!! TargetFolder:", $This.JtIoFolder.GetPath()))
            return $False
        }
    }

    
    [String]GetSpecialFileName() {
        [String]$MyOutputFilePrefix = $This.OutputFilePrefix
        [String]$MyOutputFileExtension = $This.OutputFileExtension
        [String]$MyValue = $This.GetInfo()
        
        [String]$MyFolderName = $This.JtIoFolder.GetName()
        [String]$FileLabel = -join ($MyFolderName, ".", $MyValue)
        [String]$OutputFileName = -join ($MyOutputFilePrefix, ".", $FileLabel, $MyOutputFileExtension)
        return $OutputFileName
    }

    [String]GetSum([String]$MyColumn) {
        [Decimal]$MySum = 0
        if (!($This.JtIoFolder.IsExisting())) {
            Write-JtError -Text ( -join ("Error!!! Please edit XML for:", $This.JtIoFolder.GetPath()))
            return $False
        }
        [String]$TemplateFileName = $This.JtTemplateFile.GetName()
        $Files = $This.JtIoFolder.GetNormalFiles()
        for ([int32]$i = 0; $i -lt $Files.Count; $i++) {
            [JtIoFile]$JtIoFile = $Files[$i]

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

}

class JtFolder_Anzahl_Meta : JtFolder {

    JtFolder_Anzahl_Meta([String]$Path) : base($Path) {
        $This.ClassName = "JtFolder_Anzahl_Meta"
        $This.OutputFilePrefix = [JtIo]::FilenamePrefix_Anzahl
        $This.OutputFileExtension = [JtIo]::FilenameExtension_Anzahl_Meta

        Write-JtLog ( -join ("INFO:", $This.GetInfo()))
        $This.DoCleanSpecialFiles()
        #        $This.DoWriteSpecialFileIn([JtIoFolder]$FolderTarget)
        $This.DoWriteSpecialFile()
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
                if ($Null -eq $Folder) {
                    Write-JtError ( -join ($This.ClassName, ":", "Problem with file (in GetInfo): ", $JtIoFile.GetPath()))
                    exit
                }
                else {
                    [String]$Msg = -join ("Problem with file (in GetInfo): ", $JtIoFile.GetName())
                    [String]$Path = $Folder.GetPath()
                    Write-JtFolder -Text $Msg -Path $Path
                }
            }
        }
        return $MyCount
    }   
}

function New-JtFolder_Anzahl_Meta {
    Param (
        [Parameter(Mandatory = $true)]
        [String]$Path
    )

    [JtFolder_Anzahl_Meta]::new($Path)
}

class JtFolder_Files_Csv : JtFolder {

    JtFolder_Files_Csv([String]$Path) : base($Path) {
        $This.ClassName = "JtFolder_Files_Csv"

        $This.OutputFilePrefix = [JtIo]::FilenamePrefix_Csv
        $This.OutputFileExtension = [JtIo]::FilenameExtension_Csv
        
        $This.DoCleanSpecialFiles()
        #        $This.DoWriteSpecialFileIn([JtIoFolder]$FolderTarget)
        #   $This.DoWriteSpecialFile()

        $This.DoWriteCsvFileInFolder()

        Write-JtLog ( -join ("INFO:", $This.GetInfo()))
    }

    
    [Boolean]DoCheckFolder() {
        [Boolean]$Result = $True
        [System.Collections.ArrayList]$Files = $This.JtIoFolder.GetNormalFiles()

        foreach ($MyFile in $Files) {
            [JtIoFile]$JtIoFile = $MyFile
            [Boolean]$FileValid = $This.JtTemplateFile.DoCheckFile($JtIoFile)
            if (!($FileValid)) {
                $Result = $False
            }
        }
        return $Result
    }

    [System.Data.DataTable]GetDatatable() {
        [System.Collections.ArrayList]$Files = $This.JtIoFolder.GetNormalFiles()
        [JtTemplateFile]$TemplateFile = $This.JtTemplateFile
        [String]$TemplateFileName = $TemplateFile.GetName()
        Write-JtLog ( -join ($This.ClassName, " GetDatatable. TemplateFileName:", $TemplateFileName))
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
        return "info"
    }

    [String]GetOutputFileLabelCsv() {
        [String]$OutputFilePrefix = $This.OutputFilePrefix
        
        [String]$MyFolderName = $This.JtIoFolder.GetName()
        [String]$FileLabel = $MyFolderName
        [String]$OutputFileName = -join ($OutputFilePrefix, ".", $FileLabel, ".", "files")
        return $OutputFileName
    }

    [Boolean]DoWriteCsvFileIn([JtIoFolder]$FolderTarget) {
        [String]$OutputFileLabel = $This.GetOutputFileLabelCsv()

        $OutputFileLabel = ConvertTo-LabelToFilename $OutputFileLabel

        if (!($This.JtTemplateFile.IsValid())) {
            Write-JtError -Text ( -join ("TemplateFile is not valid in path:", $This.JtIoFolder.GetPath()))
            return $False
        }
        
        if (!($FolderTarget.IsExisting())) {
            Write-JtError -Text ( -join ($This.ClassName, ".DoWriteCsvFileIn.TargetFolder does not exist!!! TargetFolder:", $FolderTarget.GetPath()))
            return $False
        }
        
        if (!($This.JtIoFolder.IsExisting())) {
            Write-JtError -Text ( -join ($This.ClassName, ".JtIoFolder does not exist!!! TargetFolder:", $This.JtIoFolder.GetPath()))
            return $False
        }
        
        [System.Data.Datatable]$DataTable = $This.GetDatatable()
        New-JtCsvWriteData -Label $OutputFileLabel -JtIoFolder $FolderTarget -DataTable $DataTable
        return $True
    }
    
    [Boolean]DoWriteCsvFileInFolder() {
        [JtIoFolder]$FolderTarget = $This.JtIoFolder
        return $This.DoWriteCsvFileIn($FolderTarget)
    }

    DoCleanFilesInFolder() {
        [String]$MyOutputFilePrefix = $This.OutputFilePrefix
        [String]$MyOutputFileExtension = $This.OutputFileExtension
        $This.JtIoFolder.DoCleanFiles($MyOutputFilePrefix, $MyOutputFileExtension)
    }
}

function New-JtFolder_Files_Csv {
    Param (
        [Parameter(Mandatory = $true)]
        [String]$Path
    )

    [JtFolder_Files_Csv]::new($Path)

}

class JtFolder_Betrag_Meta : JtFolder {

    JtFolder_Betrag_Meta([String]$Path) : base($Path) {

        $This.OutputFilePrefix = [JtIo]::FilenamePrefix_Folder
        $This.OutputFileExtension = [JtIo]::FilenameExtension_Betrag_Meta

        $This.DoCleanSpecialFiles()
        #        $This.DoWriteSpecialFileIn([JtIoFolder]$FolderTarget)

        if ($This.JtTemplateFile.IsValid()) {

            $This.DoWriteSpecialFile()
        }

        Write-JtLog ( -join ("INFO:", $This.GetInfo()))
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
                [String]$Path = $JtIoFolder.GetPath()
                Write-JtFolder -Text ( -join ("Problem with file; EURO (in GetInfo):", $JtIoFile.GetName())) -Path $Path
            }
    
            $MySum = $MySum + $MyDecEuro
        }
        [Decimal]$DecResult = $MySum / 100

        [String]$Result = $DecResult.ToString("0.00")
        $Result = $Result.Replace(",", "_")
        $Result = $Result.Replace(".", "_")
        return $Result
    }
}

function New-JtFolder_Betrag_Meta {
    Param (
        [Parameter(Mandatory = $true)]
        [String]$Path
    )

    [JtFolder_Betrag_Meta]::new($Path)
}

class JtFolder_Md : JtFolder {
    
    JtFolder_Md([String]$Path) : base($Path) {
        $This.ClassName = "JtFolder_Md"
        $This.OutputFilePrefix = [JtIo]::FilenamePrefix_Folder
        $This.OutputFileExtension = [JtIo]::FilenameExtension_Md
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
}
function New-JtFolder_Md {
    Param (
        [Parameter(Mandatory = $true)]
        [String]$Path
    )

    [JtFolder_Md]::new($Path)
}

class JtFolder_Zahlung_Md : JtFolder_Md {

    JtFolder_Zahlung_Md([String]$Path) : base($Path) {
        $This.ClassName = "JtFolder_Zahlung_Md"
        $This.OutputFileExtension = [JtIo]::FilenameExtension_Zahlung_Md
        $This.DoCleanSpecialFiles()
        #        $This.DoWriteSpecialFileIn([JtIoFolder]$FolderTarget)
        # $This.DoWriteSpecialFile()

        $This.DoWriteMdFile()

        Write-JtLog ( -join ("JtFolder_Zahlung_Md-INFO:", $This.GetInfo()))
    }

    [System.Data.Datatable]GetDatatable() {

        [JtFolder_Zahlung_Meta]$JtFolder_Zahlung_Meta = New-JtFolder_Zahlung_Meta -Path $This.JtIoFolder.GetPath()
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
        [String]$MySum = $JtFolder_Zahlung_Meta.GetSum_Miete()
        [JtColRen]$ColRen = $ColRens[$j]
        $Datatable.Columns.Add($ColRen.GetHeader(), "String")
        
        $j = 5
        [String]$MySum = $JtFolder_Zahlung_Meta.GetSum_Nebenkosten()
        [JtColRen]$ColRen = $ColRens[$j]
        $Datatable.Columns.Add($ColRen.GetHeader(), "String")
        
        $j = 6
        [String]$MySum = $JtFolder_Zahlung_Meta.GetSum_Betrag
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
        [String]$MySum = $JtFolder_Zahlung_Meta.GetSum_Miete()
        [JtColRen]$ColRen = $ColRens[$j]
        $Row.($ColRen.GetHeader()) = $ColRen.GetOutput($MySum)
        
        $j = 5
        [String]$MySum = $JtFolder_Zahlung_Meta.GetSum_Nebenkosten()
        [JtColRen]$ColRen = $ColRens[$j]
        $Row.($ColRen.GetHeader()) = $ColRen.GetOutput($MySum)
        
        $j = 6
        [String]$MySum = $JtFolder_Zahlung_Meta.GetSum_Betrag()
        [JtColRen]$ColRen = $ColRens[$j]
        $Row.($ColRen.GetHeader()) = $ColRen.GetOutput($MySum)

        $DataTable.Rows.Add($Row)

        return $DataTable
    }

    [String] GetInfo() {
        return "zahlung_md"
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
        [String]$OutputFileExtension = [JtIo]::FilenameExtension_Zahlung_Md
        
        [String]$MyFolderName = $This.JtIoFolder.GetName()
        [String]$OutputFileName = -join ($OutputFilePrefix, ".", $MyFolderName, $OutputFileExtension)
        return $OutputFileName
    }

}
function New-JtFolder_Zahlung_Md {
    Param (
        [Parameter(Mandatory = $true)]
        [String]$Path
    )

    [JtFolder_Zahlung_Md]::new($Path)
}

class JtFolder_BxH_Md : JtFolder_Md {

    [JtPreisliste]$JtPreisliste
    [String]$Price

    JtFolder_BxH_Md([String]$Path, [JtPreisliste]$MyJtPreisliste) : base($Path) {
        $This.ClassName = "JtFolder_BxH_Md"
        $This.JtPreisliste = $MyJtPreisliste
        $This.OutputFileExtension = [JtIo]::FilenameExtension_Bxh_Md
        $This.DoCleanSpecialFiles()
        $This.Price = New-JtFolder_BxH_Meta -Path $This.JtIoFolder.GetPath()
        #        $This.DoWriteSpecialFileIn([JtIoFolder]$FolderTarget)
        # $This.DoWriteSpecialFile()

        $This.DoWriteMdFile()

        Write-JtLog ( -join ("INFO:", $This.GetInfo()))
    }

    [String] GetInfo() {
        return "abrechnung"
    }


    [System.Data.DataTable]GetDatatable() {
        [String]$MyPrice = $This.Price


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
        [String]$Value = $MyPrice
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
        [String]$OutputFileExtension = [JtIo]::FilenameExtension_Bxh_Md
        
        [String]$MyFolderName = $This.JtIoFolder.GetName()
        [String]$OutputFileName = -join ($OutputFilePrefix, ".", $MyFolderName, $OutputFileExtension)
        return $OutputFileName
    }
}

function New-JtFolder_BxH_Md {
    Param (
        [Parameter(Mandatory = $true)]
        [String]$Path
    )

    [JtPreisliste]$MyJtPreisliste = New-JtPreisliste_Plotten_2020_07_01
    [JtFolder_BxH_Md]::new($Path, $MyJtPreisliste)
}

class JtFolder_Zahlung_Meta : JtFolder {

    JtFolder_Zahlung_Meta([String]$Path) : base($Path) {
        $This.ClassName = "JtFolder_Zahlung_Meta"
        $This.OutputFilePrefix = "zzz"
        $This.OutputFileExtension = [JtIo]::FilenameExtension_Zahlung_Meta

        $This.DoCleanSpecialFiles()
        #        $This.DoWriteSpecialFileIn([JtIoFolder]$FolderTarget)
        $This.DoWriteSpecialFile()

        Write-JtLog ( -join ("INFO:", $This.GetInfo()))
    }

    hidden [String]GetSum_Miete() {
        [String]$MyCol = "MIETE"
        [String]$MySum = $This.GetSum($MyCol)
        return $MySum
    }

    hidden [String]GetSum_Nebenkosten() {
        [String]$MyCol = "NEBENKOSTEN"
        [String]$MySum = $This.GetSum($MyCol)
        return $MySum
    }

    hidden [String]GetSum_Betrag() {
        [String]$MyCol = "ZAHLUNG"
        [String]$MySum = $This.GetSum($MyCol)
        return $MySum
    }
    


    [String]GetInfo() {
        if (!($This.JtIoFolder.IsExisting())) {
            Write-JtError -Text ( -join ("Error!!! Please edit XML for:", $This.JtIoFolder.GetPath()))
            return $False
        }

        [String]$Result = -join ($This.GetSum_Miete(), ".", $This.GetSum_Nebenkosten(), ".", $This.GetSum_Betrag())
        return $Result
    }

}

function New-JtFolder_Zahlung_Meta {

    Param (
        [Parameter(Mandatory = $true)]
        [String]$Path
    )

    [JtFolder_Zahlung_Meta]::new($Path)
}

class JtFolder_BxH_Meta : JtFolder {

    [JtPreisliste]$JtPreisliste = $Null
    [String]$TemplateFileName = $Null

    
    JtFolder_BxH_Meta([String]$Path) : base($Path) {
        $This.ClassName = "JtFolder_BxH_Meta"
        $This.OutputFilePrefix = "zzz"
        $This.OutputFileExtension = [JtIo]::FilenameExtension_Bxh_Meta
        $This.JtPreisliste = New-JtPreisliste_Plotten_2020_07_01
        $This.TemplateFileName = -join ("_NACHNAME.VORNAME.LABEL.PAPIER.BxH", [JtIo]::FilenameExtension_Folder)

        $This.DoCleanSpecialFiles()
        #        $This.DoWriteSpecialFileIn([JtIoFolder]$FolderTarget)
        $This.DoWriteSpecialFile()

        Write-JtLog ( -join ("INFO:", $This.GetInfo()))
    }

    [String]GetInfo() {
        [JtPreisliste]$MyJtPreisliste = $This.JtPreisliste
        [JtColRen]$ColRenJtPreisliste_Price = New-JtColRenFileJtPreisliste_Price -JtPreisliste $MyJtPreisliste
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
}

function New-JtFolder_BxH_Meta {
    Param (
        [Parameter(Mandatory = $true)]
        [String]$Path
    )

    [JtFolder_BxH_Meta]$JtFolder = [JtFolder_BxH_Meta]::new($Path)
    return $JtFolder.GetInfo()
}

class JtIndex : JtClass {

    JtIndex() {
        $This.ClassName = "JtIndex"
    }

    DoIt([JtIoFolder]$MyJtIoFolder) {
        Throw "DoIt in JtIndex should be overwritten."
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
            Write-JtError -Text ( -join ($This.ClassName, ". TargetFolder does not exist!!! TargetFolder:", $FolderTarget.GetPath()))
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
    
    
    [String]GetTemplateFileExtension() {
        [String]$Extension = [JtIo]::FilenameExtension_Folder
        return $Extension
    }
}

class JtIndex_Anzahl : JtIndex {

    JtIndex_Anzahl() {
        $This.ClassName = "JtIndex_Anzahl"
    }
    
    DoIt([JtIoFolder]$MyJtIoFolder) {
        [String]$Path = $MyJtIoFolder.GetPath()
        New-JtFolder_Files_Csv -path $Path
        New-JtFolder_Anzahl_Meta -path $Path
    }

    [String]GetLabel() {
        return "SUM"
    }
}

function New-JtIndex_Anzahl {

    Param (
        [Parameter(Mandatory = $true)]
        [String]$Path
    )
    [JtIoFolder]$JtIoFolder = New-JtIoFolder -Path $Path

    [JtIndex]$JtIndex = [JtIndex_Anzahl]::new()
    $JtIndex.DoIt($JtIoFolder)
}

class JtIndex_Betrag : JtIndex {

    JtIndex_Betrag() {
        $This.ClassName = "JtIndex_Betrag"

    }

    DoIt([JtIoFolder]$MyJtIoFolder) {
        [String]$Path = $MyJtIoFolder.GetPath()
        New-JtFolder_Files_Csv -Path $Path
        New-JtFolder_Betrag_Meta -Path $Path 
    }   
    

    [String]GetLabel() {
        return "SUM"
    }
}

function New-JtIndex_Betrag {

    Param (
        [Parameter(Mandatory = $true)]
        [String]$Path
    )

    [JtIoFolder]$JtIoFolder = New-JtIoFolder -Path $Path

    [JtIndex]$JtIndex = [JtIndex_Betrag]::new()
    $JtIndex.DoIt($JtIoFolder)
}

class JtIndex_BxH : JtIndex {

    [JtPreisliste]$JtPreisliste = $Null
    [String]$TemplateFileName = $Null

    JtIndex_BxH() {
        $This.ClassName = "JtIndex_BxH"
        [JtPreisliste]$MyJtPreisliste = New-JtPreisliste_Plotten_2020_07_01
        $This.JtPreisliste = $MyJtPreisliste
    }
    
    DoIt([JtIoFolder]$MyJtIoFolder) {
        [String]$Path = $MyJtIoFolder.GetPath()
        ConvertTo-JtIoBetterFilenames -Path $Path
    
        Write-JtLog(-join("DoIt:", $Path))
        [String]$MyFilter = -join ("*", [JtIo]::FilenameExtension_Folder)
        [System.Collections.ArrayList]$FolderFiles = $MyJtIoFolder.GetJtIoFilesWithFilter($MyFilter) 
    
        if ($FolderFiles.Count -eq 0) {
            [String]$JtTemplateFileName = $This.JtPreisliste.TemplateFileName
            [String]$JtTemplateFilePath = $MyJtIoFolder.GetFilePath($JtTemplateFileName)
    
            Write-JtIo ( -join ("Creating file:", $JtTemplateFilePath))
            "Hello world!" | Out-File -FilePath $JtTemplateFilePath -Encoding utf8
        }

        [String]$Path = $MyJtIoFolder.GetPath()
        New-JtFolder_BxH_Meta -Path $Path
        New-JtFolder_BxH_Md -Path $Path

        New-JtFolder_Files_Csv -Path $Path

    }

    [String]GetLabel() {
        return "BxH"
    }
}

function New-JtIndex_BxH {

    Param (
        [Parameter(Mandatory = $true)]
        [String]$Path
    )

    [JtIoFolder]$JtIoFolder = New-JtIoFolder -Path $Path
    [JtIndex]$JtIndex = [JtIndex_BxH]::new()
    $JtIndex.DoIt($JtIoFolder)

    # $JtIndex.DoWriteInFolder()
}

class JtIndex_Default : JtIndex {

    JtIndex_Default() {
        $This.ClassName = "JtIndex_Default"
    }
    
    DoIt([JtIoFolder]$MyJtIoFolder) {
        [String]$Path = $MyJtIoFolder.GetPath()
        New-JtFolder_Files_Csv -path $Path
    }


    [String]GetLabel() {
        return "DEFAULT"
    }
}

function New-JtIndex_Default {

    Param (
        [Parameter(Mandatory = $true)]
        [String]$Path
    )

    [JtIoFolder]$JtIoFolder = New-JtIoFolder -Path $Path

    [JtIndex]$JtIndex = [JtIndex_Default]::new()
    $JtIndex.DoIt($JtIoFolder)
}

class JtIndex_Zahlung : JtIndex {

    JtIndex_Zahlung() {
        $This.ClassName = "JtIndex_Zahlung"
    }

    DoIt([JtIoFolder]$MyJtIoFolder) {
        [String]$Path = $MyJtIoFolder.GetPath()
        New-JtFolder_Files_Csv -Path $Path
        New-JtFolder_Zahlung_Meta -Path $Path
        
        New-JtFolder_Zahlung_Md -Path $Path
    }

    [String]GetLabel() {
        return "Zahlung"
    }
}

function New-JtIndex_Zahlung {

    Param (
        [Parameter(Mandatory = $true)]
        [String]$Path
    )
    [JtIoFolder]$JtIoFolder = New-JtIoFolder -Path $Path

    [JtIndex]$JtIndex = [JtIndex_Zahlung]::new()
    $JtIndex.DoIt($JtIoFolder)
}

