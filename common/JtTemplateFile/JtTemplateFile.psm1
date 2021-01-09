using module JtClass
using module JtIo
using module JtColRen

class JtTemplateFile : JtClass {

    [JtIoFile]$JtIoFile = $Null
    [JtIoFolder]$JtIoFolder = $Null
    [String]$TemplateFileExtension = $Null
    [String]$JtTemplateFileName = ""
    [Boolean]$Valid = $False

    JtTemplateFile([JtIoFolder]$MyFolder) {
        $This.ClassName = "JtTemplateFile"
        $This.JtIoFolder = $MyFolder
        $This.TemplateFileExtension = [JtIo]::FilenameExtension_Folder
        $This.DoInit()
    }
    
    JtTemplateFile([JtIoFolder]$MyFolder, [String]$MyExtension) {
        $This.ClassName = "JtTemplateFile"
        $This.JtIoFolder = $MyFolder
        $This.TemplateFileExtension = $MyExtension
        $This.DoInit()
        
    }

    # [JtIoFile]GetJtTemplateFile() {
    #     [String]$MyExtension = $This.GetTemplateFileExtension()
    #     [JtIoFile]$JtIoFile = $Null
    #     [String]$MyFilter = -join ("*", $MyExtension)
    #     [System.Collections.ArrayList]$FolderFiles = $This.JtIoFolder.GetJtIoFilesWithFilter($MyFilter) 
    #     if ($Null -eq $FolderFiles) {
    #         Write-JtError -Text ( -join ("This should not happen. FolderFiles is null for JtIoFolder ", $This.JtIoFolder.GetPath()))
    #     }
    #     elseif ($FolderFiles.Count -lt 1) {
    #         Write-JtError -Text ( -join ("This should not happen. No FolderFile in JtIoFolder ", $This.JtIoFolder.GetPath()))
    #     }
    #     elseif ($FolderFiles.Count -gt 1) {
    #         Write-JtError -Text ( -join ("This should not happen. More than one FolderFiles in JtIoFolder ", $This.JtIoFolder.GetPath()))
    #     }
    #     else {
    #         [JtIoFile]$JtIoFile = $FolderFiles[0]
    #     }
    #     return $JtIoFile
    # }

    [Boolean]DoInit() {
        [String]$MyExtension = $This.TemplateFileExtension
        [String]$Filter = -join ("*", $MyExtension)
        [System.Collections.ArrayList]$TheFiles = $This.JtIoFolder.GetJtIoFilesWithFilter($Filter, $False)
        $This.JtIoFile = $null
        if ($TheFiles.Count -gt 0) {
            $This.JtIoFile = $TheFiles[0]
            $This.Valid = $True
            $This.JtTemplateFileName = $This.JtIoFile.GetName()
        }
        else {
            $This.Valid = $False
#            Write-JtError -Text ( -join ("Template file is missing. Folder:", $This.JtIoFolder.GetPath(), " Filter:", $Filter))
        }
        return $True
    }

    [Boolean]IsValid() {
        return $This.Valid
    }
    
    [JtColRen]GetJtColRenForColumnNumber([Int16]$IntCol) {
        [System.Collections.ArrayList]$JtColRens = $This.GetJtColRens()
        if ($IntCol -lt $JtColRens.Count) {
            return $JtColRens[$IntCol]
        }
        else {
            [String]$MyLabel = -join ("Column_Number_", $IntCol)
            [JtColRen]$JtColRen = New-JtColRenInputText -Label $MyLabel
            Write-JtError -Text ( -join ("Problem with column number ", $IntCol) )
        }
        return $JtColRen
    }

    [System.Collections.ArrayList]GetJtColRens() {
        $TemplateParts = $This.JtTemplateFileName.Split(".")
 
        [System.Collections.ArrayList]$JtColRens = [System.Collections.ArrayList]::new()
        foreach ($Part in $TemplateParts) {
            [String]$MyPart = $Part
            [JtColRen]$MyJtColRen = [JtColRen]::GetJtColRen($MyPart) 
            # $Head = $MyJtColRen.GetHeader()
            $JtColRens.Add($MyJtColRen)
        }
        return $JtColRens
    }

    [Int16]GetJtColRensCount() {
        [System.Collections.ArrayList]$JtColRens = $This.GetJtColRens()
        [Int32]$NumTemplateParts = $JtColRens.Count
        return $NumTemplateParts
    }

    [Boolean]GetHasColumnForAnzahl() {
        [JtColRen]$ColCompare = New-JtColRenInputAnzahl
        return $This.GetHasColumnOfType($ColCompare)
    }
    
    [Boolean]GetHasColumnForArea() {
        [JtColRen]$ColCompare = New-JtColRenInputArea
        return $This.GetHasColumnOfType($ColCompare)
    }
    
    [Boolean]GetHasColumnForEuro() {
        [JtColRen]$ColCompare = New-JtColRenInputCurrencyEuro
        return $This.GetHasColumnOfType($ColCompare)
    }

    [Boolean]GetHasColumnOfType([JtColRen]$JtColRen) {
        [Boolean]$Result = $false
        [System.Collections.ArrayList]$JtColRens = $This.GetJtColRens()
        
        [JtColRen]$ColCompare = $JtColRen
        foreach ($MyJtColRen in $JtColRens) {
            [JtColRen]$JtColRen = $MyJtColRen
            if ($ColCompare -eq $JtColRen) {
                $Result = $true
                return $Result
            }
        }
        return $Result
    }

    [Boolean]DoCheckFile([JtIoFile]$JtIoFile) {
        [Boolean]$Result = $True

        [System.Collections.ArrayList]$ColRens = $This.GetJtColRens()
        [Int32]$NumTemplateParts = $ColRens.Count
        
        [String]$FileName = $JtIoFile.GetName()
        $FileNameParts = $FileName.Split(".")
        $NumOfFilenameParts = $FileNameParts.Count
            
        if ($NumOfFilenameParts -ne $NumTemplateParts) {
            Write-JtError -Text ( -join ("Filename does not have the expected format: ", $FileName, ", fileName parts:", $NumOfFilenameParts, " , template parts:", $NumTemplateParts))
            Write-JtError -Text ( -join ("Problem with file (DoCheckFile): ", $JtIoFile.GetPath()))
                
            [JtIoFolder]$TheFolder = [JtIoFolder]::new($JtIoFile)
            [String]$Message = -join ("Problem with file (DoCheckFile): ", $FileName)
            Write-JtFolder -Text $Message -Path $TheFolder.GetPath()
            $Result = $False
        }
        else {
            for ([Int32]$i = 0; $i -lt $NumTemplateParts; $i++) {
                [String]$MyValue = $FileNameParts[$i]
                [JtColRen]$ColRen = $ColRens[$i]
                [Boolean]$IsValid = $ColRen.CheckValid($MyValue)
                if ($False -eq $IsValid) {
                    [String]$Message = -join ("Problem with file (DoCheckFile; IsValid);  ", $FileName)
                    return $False
                }
            }
        }
        return $Result
    }

    [String]GetName() {
        return $This.JtTemplateFileName
    }
}

Function Get-JtTemplateFile {
    Param (
        [Parameter(Mandatory = $true)]
        [JtIoFolder]$JtIoFolder,
        [Parameter(Mandatory = $false)]
        [String]$Extension
    )

    [JtTemplateFile]::new($JtIoFolder, $Extension)
}
