using module JtClass
using module JtIo
using module JtUtil
using module JtTbl
using module JtRep
using module JtReps

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




class JtCsvTool : JtClass {

    [JtIoFolder]$FoldercombineTarget
    [System.Collections.ArrayList]$Reports
    [String]$SelectionLabel
    


    JtCsvTool([JtIoFolder]$MyFolderReports, [JtIoFolder]$FolderTarget, [String]$SelectionLabel, [System.Collections.ArrayList]$MySelection) {
        $This.ClassName = "JtCsvTool"

        $This.SelectionLabel = $SelectionLabel
        $This.FoldercombineTarget = $FolderTarget.GetSubfolder($This.SelectionLabel, $True)

        [System.Collections.ArrayList]$MyReports = $MyFolderReports.GetSelectedSubfolders($MySelection)
        $This.Reports = $MyReports
    }
    
    JtCsvTool([JtIoFolder]$MyFolderReports, [JtIoFolder]$FolderTarget) {
        $This.ClassName = "JtCsvTool"

        $This.SelectionLabel = "all"
        $This.FoldercombineTarget = $FolderTarget.GetSubfolder($This.SelectionLabel, $True)

        $This.Reports = $MyFolderReports.GetSubfolders($False)
    }

    [Boolean]DoIt() {
        Write-JtLog -Text ( -join ("DoIt - FoldercombineTarget:", $This.FoldercombineTarget.GetPath()))
        
        [System.Collections.ArrayList]$TheCsvFileNames = $This.GetCsvFilenames()
        foreach ($FileName in $TheCsvFileNames) {
            [String]$MyFilename = $FileName

            [System.Collections.ArrayList]$MyCsvFiles = [System.Collections.ArrayList]::new()
            [System.Collections.ArrayList]$MyCsvFilePaths = [System.Collections.ArrayList]::new()
            foreach ($Folder in $This.Reports) {
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

