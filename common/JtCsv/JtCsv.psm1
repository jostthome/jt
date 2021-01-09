using module JtClass
using module JtIo
using module JtUtil
using module JtTbl
using module JtRep
using module JtReps

class JtCsvTool : JtClass {

    [JtIoFolder]$FolderReports
    [JtIoFolder]$FoldercombineTarget
    [System.Collections.ArrayList]$Selection


    static [Boolean]IsJtIoFolderInSelection([JtIoFolder]$TheFolder, [System.Collections.ArrayList]$Sel) {
        if ($Null -eq $Sel) {
            return $False
        }
        [Boolean]$Result = $False
        foreach ($Element in $Sel) {
            [String]$TheName = $Element.ToString()
            [String]$Search = -join ("*", $TheName, "*")

            [String]$FullPath = $TheFolder.GetPath()

            if ($FullPath -like $Search) {
                return $True
            }
        }
        return $Result
    }

    static [System.Collections.ArrayList]GetSelectedJtIoFiles([System.Array]$Folders, [System.Collections.ArrayList]$MySelection) {
        [System.Collections.ArrayList]$Result = [System.Collections.ArrayList]@()
        foreach ($Folder in $Folders) {
            [JtIoFolder]$JtIoFolder = $Folder
            $FullPath = $JtIoFolder.GetPath()
            if ($Null -eq $MySelection) {
                [JtIoFile]$JtIoFile = New-JtIoFile -Path $FullPath
                $Result.Add($FullPath)
            }
            else {
                [Boolean]$Compare = [JtCsvTool]::IsJtIoFolderInSelection($JtIoFolder, $MySelection)
                if ($True -eq $Compare) {
                    [JtIoFile]$JtIoFile = New-JtIoFile -Path $FullPath
                    $Result.Add($FullPath)
                }
            } 
        }
        return $Result
    }

    static [System.Collections.ArrayList]GetSelectedJtIoFolders([System.Array]$Folders, [System.Collections.ArrayList]$MySelection) {
        [System.Collections.ArrayList]$Result = [System.Collections.ArrayList]@()
        foreach ($Folder in $Folders) {
            [JtIoFolder]$JtIoFolder = $Folder
            if ($Null -eq $MySelection) {
                $Result.Add($JtIoFolder)
            }
            else {
                [Boolean]$Compare = [JtCsvTool]::IsJtIoFolderInSelection($JtIoFolder, $MySelection)
                if ($True -eq $Compare) {
                    $Result.Add($JtIoFolder)
                }
            } 
        }
        return $Result
    }

    JtCsvTool([JtIoFolder]$FolderSource, [JtIoFolder]$FolderTarget, [String]$SelectionLabel, [System.Collections.ArrayList]$MySelection) {
        $This.ClassName = "JtCsvTool"
        $This.FolderReports = $FolderSource
        $This.FoldercombineTarget = $FolderTarget.GetSubfolder($SelectionLabel, $True)
        [System.Collections.ArrayList]$This.Selection = $MySelection
    }
    
    JtCsvTool([JtIoFolder]$FolderSource, [JtIoFolder]$FolderTarget) {
        $This.ClassName = "JtCsvTool"
        $This.FolderReports = $FolderSource
        [String]$SelectionLabel = "all"
        $This.FoldercombineTarget = $FolderTarget.GetSubfolder($SelectionLabel, $True)
        [System.Collections.ArrayList]$This.Selection = $Null
    }

    [Boolean]DoIt() {
        Write-JtLog -Text ( -join ("DoIt - FoldercombineTarget:", $This.FoldercombineTarget.GetPath()))

        [System.Collections.ArrayList]$AllReports = $This.FolderReports.GetSubfolders($False)
        [System.Collections.ArrayList]$MyReports = $AllReports
        if ($This.Selection.Count -gt 0) {
            [System.Collections.ArrayList]$SelectedReports = [JtCsvTool]::GetSelectedJtIoFolders($AllReports, $This.Selection)
            [System.Collections.ArrayList]$MyReports = $SelectedReports
        }
        
        [System.Collections.ArrayList]$TheCsvFileNames = $This.GetCsvFilenames()
        foreach ($FileName in $TheCsvFileNames) {
            [String]$MyFilename = $FileName

            [System.Collections.ArrayList]$MyCsvFiles = [System.Collections.ArrayList]::new()
            [System.Collections.ArrayList]$MyCsvFilePaths = [System.Collections.ArrayList]::new()
            foreach ($Folder in $MyReports) {
                [JtIoFolder]$MyFolder = $Folder
                [JtIoFolder]$MyFolderCsv = $MyFolder.GetSubfolder("csv")
                if(!($Null -eq $MyFolderCsv)) {
                    [JtIoFile]$JtIoFile = $MyFolderCsv.GetJtIoFile($MyFilename)
                    if ($JtIoFile.IsExisting()) {
                        $MyCsvFiles.Add($JtIoFile)
                        $MyCsvFilePaths.Add($JtIoFile.GetPath())
                    }
                }
            }

            $CsvData = $MyCsvFilePaths | Import-Csv  -Delimiter ([JtUtil]::Delimiter)

            [JtIoFile]$MyOutfile = $This.FoldercombineTarget.GetJtIoFile($MyFilename)
            Write-JtIo -Text ( -join ("Combining for ", $MyFilename, " to:", $MyOutfile.GetPath()))                
            # $CsvData | Export-Csv $MyOutfile.GetPath() -NoTypeInformation -Append -Delimiter ([JtUtil]::Delimiter) -Force
            $CsvData | Export-Csv $MyOutfile.GetPath() -NoTypeInformation -Delimiter ([JtUtil]::Delimiter) -Force
        }
        return $True
    }

    [System.Collections.ArrayList]GetCsvFilenames() {
        [System.Collections.ArrayList]$MyFilenames = [System.Collections.ArrayList]::new()
        
        [System.Collections.ArrayList]$MyReps = [JtReps]::GetReps()
        foreach ($MyRep in $MyReps) {
            [JtRep]$Rep = $MyRep
            $MyFilenames.Add($Rep.GetCsvFilename())
        }

        return $MyFilenames
    }
}



class JtCsv : JtClass {
    
    [String]$Label = $Null
    [JtIoFolder]$JtIoFolder = $Null
    
    JtCsv([String]$MyLabel, [JtIoFolder]$MyFolder) {
        $This.ClassName = "JtCsv"
        $This.Label = $MyLabel
        $This.JtIoFolder = $MyFolder
    }

    [String]GetFileName() {
        [String]$MyExtension = [JtIo]::FilenameExtension_Csv
        [String]$MyFileName = -join ($This.Label, $MyExtension)
        return $MyFileName
    }
    
    [String]GetFilePathCsv() {
        [String]$MyFileName = $This.GetFileName()
        [String]$MyFilePath = $This.JtIoFolder.GetFilePath($MyFileName)
        return $MyFilePath
    }
}

class JtCsvWriteArraylist : JtCsv {
    
    [System.Collections.ArrayList]$Objects = $Null
    
    JtCsvWriteArraylist([String]$MyLabel, [JtIoFolder]$MyFolder, [System.Collections.ArrayList]$ArrayList) : Base($MyLabel, $MyFolder) {
        $This.ClassName = "JtCsvWriteArraylist"
        $This.Objects = $ArrayList

        [String]$MyExtension = [JtIo]::FilenameExtension_Csv
        [String]$FilePathCsv = $This.GetFilePathCsv()
        Write-JtIo -Text ( -join ("WARNING. Creating ", $MyExtension, " file:", $FilePathCsv))
        $This.Objects | Export-Csv -Path $FilePathCsv -NoTypeInformation -Delimiter ";"

    }
}

Function New-JtCsvWriteArraylist {

    Param (
        [Parameter()]
        [String]$Label,
        [Parameter()]
        [JtIoFolder]$JtIoFolder, 
        [Parameter()]
        [System.Collections.ArrayList]$ArrayList
    )

    [JtCsvWriteArraylist]::new($Label, $JtIoFolder, $ArrayList)
}

class JtCsvWriteData : JtCsv {

    [System.Object[]]$DataTable = $Null

    JtCsvWriteData([String]$MyLabel, [JtIoFolder]$MyFolder, [System.Object[]]$MyDataTable) : base($MyLabel, $MyFolder) {
        $This.ClassName = "JtCsvWriteArraylist"
        $This.DataTable = $MyDataTable

        [String]$FilePathCsv = $This.GetFilePathCsv()
        if($This.DataTable.count -gt 0) {

            [String]$MyExtension = [JtIo]::FilenameExtension_Csv
            Write-JtIo -Text ( -join ("WARNING. Creating ", $MyExtension, " file:", $FilePathCsv))
    
            $TheData = $This.DataTable[0].Table
    
            $TheData | Export-Csv -Path $FilePathCsv -NoTypeInformation -Delimiter ";"
        } else {
            Write-JtError "No rows for JtCsvWriteData while writing csv: $FilePathCsv"
        }
    }
}

Function New-JtCsvWriteData {

    Param (
        [Parameter()]
        [String]$Label,
        [Parameter()]
        [JtIoFolder]$JtIoFolder, 
        [Parameter()]
        [System.Object[]]$DataTable
    )

    [JtCsvWriteData]::new($Label, $JtIoFolder, $DataTable)
}


Function New-JtCsvWriteTbl {

    Param (
        [Parameter()]
        [String]$Label,
        [Parameter()]
        [JtIoFolder]$JtIoFolder, 
        [Parameter()]
        [JtTblTable]$JtTblTable
    )

    # $Datatable = Get-JtDataTableFromTable -JtTblTable $JtTblTable
    $Datatable = Get-JtDataTableFromTable -JtTblTable $JtTblTable
    New-JtCsvWriteData -Label $Label -JtIoFolder $JtIoFolder -Datatable $Datatable
}
