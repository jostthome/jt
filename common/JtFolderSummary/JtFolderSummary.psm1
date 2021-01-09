using module JtClass
using module JtIo
using module JtTbl
using module JtCsv


Class JtFolderSummary : JtClass {
    
    [String]$Delimiter = ";"
    [String]$Label = $Null
    [String]$Sub = $Null
    [String]$Expected = $Null
    [JtIoFolder]$IoFolderBase = $Null

    JtFolderSummary ([String]$MyLabel, [String]$MyPath, [String]$MySub, [String]$MyExpected) : Base() {
        $This.ClassName = "JtFolderSummary"
        $This.Label = $MyLabel
        $This.Sub = $MySub
        $This.Expected = $MyExpected
        $This.IoFolderBase = [JtIoFolder]::new($MyPath)
    }
}

Function New-JtFolderSummary {

    Param (
        [Parameter()]
        [String]$Label,
        [Parameter()]
        [String]$Path,
        [Parameter()]
        [String]$Sub,
        [Parameter()]
        [String]$Expected
    )

    [JtFolderSummary]::new($Label, $Path, $Sub, $Expected)
}



Class JtFolderSummaryAll : JtFolderSummary {
    
    JtFolderSummaryAll([String]$MyLabel, [String]$MyPath, [String]$MySub, [String]$MyExpected) : base($MyLabel, $MyPath, $MySub, $MyExpected) {
        $This.ClassName = "JtFolderSummaryAll"

        Write-JtLog -Text ( -join ("Label:", $This.Label, " - Sub:", $This.Sub))
        
        [JtIoFolder]$TheFolder = $This.IoFolderBase.GetSubFolder($This.Sub)
        [System.Collections.ArrayList]$Subfolders = $TheFolder.GetSubFolders()
    
        [System.Collections.ArrayList]$AllFiletypes = $TheFolder.GetFiletypesInSubfolders()

        $JtTblTable = New-JtTblTable -Label $This.ClassName

        foreach ($SubFolder in $Subfolders) {
            [JtTblRow]$JtTblRow = New-JtTblRow
            [JtIoFolder]$MyFolder = $SubFolder
            $FileCountExpected = 0 
            $FileCountAll = 0 

            $JtTblRow.Add("Name", $MyFolder.GetName())

            $JtTblRow.Add("Label", $This.Label)
            
            [Array]$ExpectedTypes = $This.Expected.Split(",")
            
            foreach ($MyType in $ExpectedTypes) {
                [String]$MyExtension = [String]$MyType
                [String]$TypeLabel = $MyExtension

                [System.Collections.ArrayList]$FilesWithExtension = $MyFolder.GetJtIoFilesWithExtension($MyExtension)
                [Int16]$CountForType = $FilesWithExtension.Count
                
                $LabelForType = -join ("X", $TypeLabel.ToLower())
                $LabelForType = $LabelForType.Replace(".", "_")
                
                $ColumnName = $LabelForType 
                $ColumnValue = $CountForType
                $JtTblRow.Add($ColumnName, $ColumnValue)

                $FileCountExpected = $FileCountExpected + $CountForType
            }

            $ColumnName = "CountExpected"
            $ColumnValue = $FileCountExpected
            $JtTblRow.Add( $ColumnName, $FileCountExpected)

            foreach ($MyType in $AllFiletypes) {
                [String]$MyExtension = [String]$MyType
                [String]$TypeLabel = $MyExtension
    
                [System.Collections.ArrayList]$FilesWithExtension = $MyFolder.GetJtIoFilesWithExtension($MyExtension)
                [Int16]$CountForType = $FilesWithExtension.Count
                $LabelForType = -join ("Z", $TypeLabel.ToLower())
                $LabelForType = $LabelForType.Replace(".", "_")

                $ColumnName = $LabelForType 
                $ColumnValue = $FilesWithExtension.Count
                $JtTblRow.Add($ColumnName, $ColumnValue)
                    
                $FileCountAll = $FileCountAll + $CountForType
            }
                
            $ColumnName = "CountAll"
            $ColumnValue = $FileCountAll   
            $JtTblRow.Add($ColumnName, $FileCountAll)
                
            [Boolean]$SameNumber = $false
            if (($FileCountExpected - $ExpectedTypes.Length) -eq 0) {
                $SameNumber = $True
            }
            [String]$IsExpected = "" 
            if ($SameNumber) {
                $IsExpected = "OK"
            }
            else {
                $IsExpected = ""
            }
                
            $ColumnName = "Expected"
            $ColumnValue = $IsExpected
            $JtTblRow.Add($ColumnName, $ColumnValue)

            $JtTblTable.AddRow($JtTblRow)
        }
        New-JtCsvWriteTbl -Label $This.Label -JtIofolder $This.IoFolderBase -JtTblTable $JtTblTable
    }
}

Function New-JtFolderSummaryAll {

    Param (
        [Parameter()]
        [String]$Label,
        [Parameter()]
        [String]$Path,
        [Parameter()]
        [String]$Sub,
        [Parameter()]
        [String]$Expected
    )

    [JtFolderSummaryAll]::new($Label, $Path, $Sub, $Expected)

}




Class JtFolderSummaryMeta : JtFolderSummary {
    
    JtFolderSummaryMeta([String]$MyLabel, [String]$MyPath, [String]$MySub, [String]$MyExpected) : base($MyLabel, $MyPath, $MySub, $MyExpected) {
        $This.ClassName = "JtFolderSummaryMeta"

        Write-JtLog -Text ( -join ("Label:", $This.Label, " - Sub:", $This.Sub))
        
        [JtIoFolder]$TheFolder = $This.IoFolderBase.GetSubFolder($This.Sub)
    
        [JtTblTable]$JtTblTable = New-JtTblTable -Label $This.ClassName

        
        [System.Collections.ArrayList]$Subfolders = $TheFolder.GetSubFolders()
        foreach ($SubFolder in $Subfolders) {
            [JtTblRow]$JtTblRow = New-JtTblRow
            [JtIoFolder]$MyFolder = $SubFolder
            $FileCountExpected = 0 

            [String]$FolderName = $MyFolder.GetName()
            $JtTblRow.Add("NAME", $FolderName)
            # $JtTblRow.Add("Label", $This.Label)
            [Array]$ExpectedTypes = $This.Expected.Split(",")

            foreach ($MyType in $ExpectedTypes) {
                [String]$MyExtension = [String]$MyType
                [String]$TypeLabel = $MyExtension

                [System.Collections.ArrayList]$FilesWithExtension = $MyFolder.GetJtIoFilesWithExtension($MyExtension)
                [Int16]$CountForType = $FilesWithExtension.Count
                
                $LabelForType = -join ("X", $TypeLabel.ToLower())
                $LabelForType = $LabelForType.Replace(".", "")
                
                $ColumnName = $LabelForType 
                $ColumnValue = $CountForType
                

                $FileCountExpected = $FileCountExpected + $CountForType
            }

            [int16]$intExpected = $ExpectedTypes.Count
            

            # Is the result ok? ("OK", "")
            [String]$NumberOk = "0"
            if ($FileCountExpected -ge $intExpected) {
                $NumberOk = "1"
            }
            
            $ColumnName = "OK"
            $ColumnValue = $NumberOk
            # $JtTblRow.Add($ColumnName, $ColumnValue)

            # Is the result ok? ("OK", "")
            [String]$TextOk = "Nein"
            if ($FileCountExpected -ge $intExpected) {
                $TextOk = "Ja"
            }

            $ColumnName = "Best"
            $ColumnValue = $TextOk
            # $JtTblRow.Add($ColumnName, $ColumnValue)

            $ColumnName = "Gef_SOLL"
            $ColumnValue = $ExpectedTypes.Count
            # $JtTblRow.Add($ColumnName, $ColumnValue)

            # How many files were expected? (1)
            $ColumnName = "Gef_IST"
            $ColumnValue = $FileCountExpected
            # $JtTblRow.Add($ColumnName, $ColumnValue)
            
            
            # Which filetypes had to be delivered? (".pdf,.txt")
            $ColumnName = "Typen_SOLL"
            $ColumnValue = $This.Expected
            # $JtTblRow.Add($ColumnName, $ColumnValue)

            # Which filetypes were delivered? (.pdf,.txt)
            [System.Collections.ArrayList]$AllTypes = $MyFolder.GetFileTypesInFolder()
            $ColumnName = "Typen_IST"
            $ColumnValue = $AllTypes -join ","
            # $JtTblRow.Add($ColumnName, $ColumnValue)


            # Generate columes for each expected type (X_pdf,X_jpg)
            foreach ($MyType in $ExpectedTypes) {
                [String]$MyExtension = [String]$MyType
                [String]$TypeLabel = $MyExtension
                [String]$TypeLabel = $MyExtension.Replace(".meta", "")
                [System.Collections.ArrayList]$FilesWithExtension = $MyFolder.GetJtIoFilesWithExtension($MyExtension)
                [Int16]$CountForType = $FilesWithExtension.Count
                
                $LabelForType = -join ("X", $TypeLabel.ToLower())
                $LabelForType = $LabelForType.Replace(".", "")
                $LabelForType = $LabelForType.Replace("_", "")
                
                $ColumnName = $LabelForType 
                $ColumnValue = $CountForType
                
                # $JtTblRow.Add($ColumnName, $ColumnValue)


                $LabelForType = $TypeLabel.ToUpper()
                $LabelForType = $LabelForType.Replace(".", "")
                $LabelForType = $LabelForType.Replace("_", "")
                $ColumnName = $LabelForType 

                $ColumnValue = "-"
                [JtIoFile]$MyFile = $null
                if ($FilesWithExtension.Count -gt 0) {
                    [JtIoFile]$MyFile = $FilesWithExtension[0]
                    $ColumnValue = $MyFile.GetName()
                    $ColumnValue = $ColumnValue.Replace($MyExtension, "")
                }
                $JtTblRow.Add($ColumnName, $ColumnValue)
            }
            $JtTblTable.AddRow($JtTblRow)
        }
        $JtTblTable 
        $JtTblTable 

        New-JtCsvWriteTbl -Label $This.Label -JtIofolder $This.IoFolderBase -JtTblTable $JtTblTable 
    }
}


Function New-JtFolderSummaryMeta {

    Param (
        [Parameter()]
        [String]$Label,
        [Parameter()]
        [String]$Path,
        [Parameter()]
        [String]$Sub
    )

    [JtFolderSummaryMeta]::new($Label, $Path, $Sub, ".user.meta,.room.meta")

}

Class JtFolderSummaryExpected : JtFolderSummary {
    
    JtFolderSummaryExpected([String]$MyLabel, [String]$MyPath, [String]$MySub, [String]$MyExpected) : base($MyLabel, $MyPath, $MySub, $MyExpected) {
        $This.ClassName = "JtFolderSummaryExpected"

        Write-JtLog -Text ( -join ("Label:", $This.Label, " - Sub:", $This.Sub))
        
        [JtIoFolder]$TheFolder = $This.IoFolderBase.GetSubFolder($This.Sub)
    
        $JtTblTable = New-JtTblTable -Label $This.ClassName

        
        [System.Collections.ArrayList]$Subfolders = $TheFolder.GetSubFolders()
        foreach ($SubFolder in $Subfolders) {
            [JtTblRow]$JtTblRow = New-JtTblRow
            [JtIoFolder]$MyFolder = $SubFolder
            $FileCountExpected = 0 

            [String]$FolderName = $MyFolder.GetName()
            $JtTblRow.Add("Name", $FolderName)
            $JtTblRow.Add("Label", $This.Label)
            [Array]$ExpectedTypes = $This.Expected.Split(",")

            foreach ($MyType in $ExpectedTypes) {
                [String]$MyExtension = [String]$MyType
                [String]$TypeLabel = $MyExtension

                [System.Collections.ArrayList]$FilesWithExtension = $MyFolder.GetJtIoFilesWithExtension($MyExtension)
                [Int16]$CountForType = $FilesWithExtension.Count
                
                $LabelForType = -join ("X", $TypeLabel.ToLower())
                $LabelForType = $LabelForType.Replace(".", "_")
                
                $ColumnName = $LabelForType 
                $ColumnValue = $CountForType

                $FileCountExpected = $FileCountExpected + $CountForType
            }

            [int16]$intExpected = $ExpectedTypes.Count
            

            # Is the result ok? ("OK", "")
            [String]$NumberOk = "0"
            if ($FileCountExpected -ge $intExpected) {
                $NumberOk = "1"
            }
            
            $ColumnName = "OK"
            $ColumnValue = $NumberOk
            $JtTblRow.Add($ColumnName, $ColumnValue)

            # Is the result ok? ("OK", "")
            [String]$TextOk = "Nein"
            if ($FileCountExpected -ge $intExpected) {
                $TextOk = "Ja"
            }

            $ColumnName = "Best"
            $ColumnValue = $TextOk
            $JtTblRow.Add($ColumnName, $ColumnValue)



            $ColumnName = "Gef_SOLL"
            $ColumnValue = $ExpectedTypes.Count
            $JtTblRow.Add($ColumnName, $ColumnValue)
            


            # How many files were expected? (1)
            $ColumnName = "Gef_IST"
            $ColumnValue = $FileCountExpected
            $JtTblRow.Add($ColumnName, $ColumnValue)
            
            
            # Which filetypes had to be delivered? (".pdf,.txt")
            $ColumnName = "Typen_SOLL"
            $ColumnValue = $This.Expected
            $JtTblRow.Add($ColumnName, $ColumnValue)

            # Which filetypes were delivered? (.pdf,.txt)
            [System.Collections.ArrayList]$AllTypes = $MyFolder.GetFileTypesInFolder()
            $ColumnName = "Typen_IST"
            $ColumnValue = $AllTypes -join ","
            $JtTblRow.Add($ColumnName, $ColumnValue)


            # Generate columes for each expected type (X_pdf,X_jpg)
            foreach ($MyType in $ExpectedTypes) {
                [String]$MyExtension = [String]$MyType
                [String]$TypeLabel = $MyExtension

                [System.Collections.ArrayList]$FilesWithExtension = $MyFolder.GetJtIoFilesWithExtension($MyExtension)
                [Int16]$CountForType = $FilesWithExtension.Count
                
                $LabelForType = -join ("X", $TypeLabel.ToLower())
                $LabelForType = $LabelForType.Replace(".", "_")
                
                $ColumnName = $LabelForType 
                $ColumnValue = $CountForType
                
                $JtTblRow.Add($ColumnName, $ColumnValue)
            }
            $JtTblTable.AddRow($JtTblRow)
        }
        Write-Host "Hallo"
        New-JtCsvWriteTbl -Label $This.Label -JtIofolder $This.IoFolderBase -JtTblTable $JtTblTable 
    }
}


Function New-JtFolderSummaryExpected {

    Param (
        [Parameter()]
        [String]$Label,
        [Parameter()]
        [String]$Path,
        [Parameter()]
        [String]$Sub,
        [Parameter()]
        [String]$Expected
    )

    [JtFolderSummaryExpected]::new($Label, $Path, $Sub, $Expected)
}



