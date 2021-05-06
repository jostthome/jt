using module Jt  
using module JtIo
using module JtTbl
# using module JtCsv

class JtMd : JtClass{

    JtMd() {
        $This.ClassName = "JtMd"
        $This.JtInf_Name = $This.GetType()
    }

    static [String]GetLinkForLine([String]$Line) {
        [String]$MyResult = $Line
        if ($Null -eq $Line) {

        }
        else {
            # [String]$MyPattern = "[\[][A-Za-z_]*[\]][\(](https:\/\/)[A-Za-z0-9.\-\/]*(\))"
            [String]$MyPattern = "(https:\/\/)[A-Za-z0-9.\-\/]*"
            $Line -match $MyPattern
            if ($Null -eq $matches) {

            }
            else {
                [String]$Link = $matches[0]
                $MyResult = $Link
            }
        }
        return $MyResult
    }

    static [System.Collections.ArrayList]GetList([System.Collections.ArrayList]$TheAlJtIoFiles, [String]$ThePattern) {
        [System.Collections.ArrayList]$MyList = [System.Collections.ArrayList]::new()
        foreach ($File in $TheAlJtIoFiles) {
            [JtIoFile]$MyJtIoFile = $File
            [String]$MyFilename = $MyJtIoFile.GetName()
            [String]$MyLabel_File = $MyJtIoFile.GetLabelForFileName()
            [String]$MyFilePath = $MyJtIoFile.GetPath()
            [String]$MyPattern = $ThePattern
            [String]$MyPattern = $MyPattern.Replace("{FILELABEL}", $MyLabel_File)
            [String]$MyFileExtension = [System.IO.Path]::GetExtension($MyFilename)
            
            [String]$MyContent = Get-Content -Path $MyFilePath -Encoding UTF8
            [System.Collections.ArrayList]$AlHitList = [JtMd]::GetHits($MyContent, $MyPattern)
            foreach ($El in $AlHitList) {
                [String]$MyFind = $MyContent | Select-String -Pattern $MyPattern
                if ($Null -ne $MyFind) {
                    $MyContent -match $MyPattern
                    # if ($matches.Length -gt 0) {
                    #     [String]$MyLine = $matches[0]
                    #     if ($MyLine.Length -gt 0) {
                    #         Write-Host "MyLine: " $MyLine
                    #     }
                    # }
                    [PSCustomObject]$MyObject = [PSCustomObject]@{ }
                    $MyObject | Add-Member -MemberType NoteProperty -Name Filename -Value $MyFilename
                    $MyObject | Add-Member -MemberType NoteProperty -Name FilePath -Value $MyFilePath
                    $MyObject | Add-Member -MemberType NoteProperty -Name Extension -Value $MyFileExtension
                    # $MyObject | Add-Member -MemberType NoteProperty -Name Find -Value $MyLine
                    $MyObject | Add-Member -MemberType NoteProperty -Name Label -Value $MyLabel_File
                    
                    $MyLab = [JtMd]::GetLabelForLine($El)
                    $MyObject | Add-Member -MemberType NoteProperty -Name Lab -Value $MyLab
                    
                    $MyLink = [JtMd]::GetLinkForLine($El)
                    $MyObject | Add-Member -MemberType NoteProperty -Name URL -Value $MyLink
                    $MyList.add($MyObject)
                }
            }
        }
        return $MyList
    }

    static [String]GetLabelForLine([String]$Line) {
        [String]$MyResult = $Line
        if ($Null -eq $Line) {

        }
        else {
            # [String]$MyPattern = "[\[][A-Za-z_]*[\]][\(](https:\/\/)[A-Za-z0-9.\-\/]*(\))"
            [String]$MyPattern = "[\[][A-Za-z0-9_]*[\]]"
            $Line -match $MyPattern
            if ($Null -eq $matches) {

            }
            else {
                [String]$Label = $matches[0]
                $MyResult = $Label
            }
        }
        $MyResult = $MyResult.Replace("[", "")
        $MyResult = $MyResult.Replace("]", "")
        return $MyResult
    }


    static [System.Collections.ArrayList]GetHits([String]$Content, [String]$Pattern) {
        $Mat3 = $Content.split() | Where-Object { $_ -match $Pattern } | ForEach-Object { $Matches[0] }
        $Mat3

        [System.Collections.ArrayList]$MyList = [System.Collections.ArrayList]::new()
        # if ($matches.Length -gt 0) {
        $e = $mat3 | foreach-object { $_ -match $Pattern } | ForEach-Object { $Matches[0] }
        if ($null -eq $e) {

        }
        else {
            ForEach ($element in $e) {
                $MyList.Add($element)
            }
        }
        return $MyList
    }

    static [Boolean]DoWriteJtMdCsv([JtIoFolder]$TheJtIoFolderWork, [JtIoFolder]$TheJtIoFolder_Output, [String]$TheLabel, [String]$TheFilter, [String]$ThePattern) {
        [System.Collections.ArrayList]$MyAlList = [System.Collections.ArrayList]::new()
        [String]$MyJtIoFolder_Work = $TheJtIoFolderWork
        
        [String]$MyFolderPath_Output = $TheJtIoFolder_Output.GetPath()
        [String]$MyFilter = $TheFilter
        [String]$MyLabel = $TheLabel
        [String]$MyPattern = $ThePattern

        [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder_Work -Filter $MyFilter -Recurse
        [System.Collections.ArrayList]$MyAlList = [JtMd]::GetList($MyAlJtIoFiles, $MyPattern)

        Convert-JtAl_to_FileCsv -ArrayList $MyAlList -FolderPath_Output $MyFolderPath_Output -Label $MyLabel  
        return $True
    }
}

class JtMdDocument {

    [String]$End = "`n"

    hidden [System.Collections.ArrayList]$Lines = [System.Collections.ArrayList]::new()

    JtMdDocument([String]$TheTitle) {
        $This.AddH1($TheTitle)
    }

    AddLine([String]$TheInput) {
        $This.Lines.Add(-join($TheInput, $This.End))
    }

    AddLine() {
        $This.Lines.Add(-join("---", $This.End))

    }

    AddH1([String]$TheInput) {
        [String]$MyLine = -join("# ", $TheInput, $This.End)
        $This.AddLine($MyLine)
    }

    AddH2([String]$TheInput) {
        [String]$MyLine = -join("## ", $TheInput, $This.End)
        $This.AddLine($MyLine)
    }

    AddH3([String]$TheInput) {
        [String]$MyLine = -join("### ", $TheInput, $This.End)
        $This.AddLine($MyLine)
    }

    [String]GetOutput() {
        [String]$MyResult = ""

        $MyResult = ($This.Lines -join $This.End)
        return $MyResult
    }
}


Function Convert-JtIoFile_Md_To_Pdf {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Filename_Input
    )

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $MyFolderPath_Input
    
    [String]$MyFilename_Input = $Filename_Input
    
    [String]$MyExtension_Md = [JtIo]::FileExtension_Md
    [String]$MyExtension_Pdf = [JtIo]::FileExtension_Pdf
    
    
    [String]$MyFilename_Output = $MyFilename_Input.Replace($MyExtension_Md, $MyExtension_Pdf)
    
    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input
    [String]$MyFilePath_Input = $MyJtIoFolder_Input.GetFilePath($MyFilename_Input)

    [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyFolderPath_Output
    [String]$MyFilePath_Output = $MyJtIoFolder_Output.GetFilePath($MyFilename_Output)
    

    # miktex has do be installed.
    # choco install miktex -y
    [String]$MyFilePath_Pandoc_Exe = "pandoc.exe"
    [String]$MyFilePath_Pandoc_Exe_Apps = "c:/apps/tools/pandoc/pandoc.exe"
    if(Test-JtIoFilePath -FilePath $MyFilePath_Pandoc_Exe_Apps) {
        $MyFilePath_Pandoc_Exe = $MyFilePath_Pandoc_Exe_Apps
    }

    [String]$MyCommand = -join ($MyFilePath_Pandoc_Exe, ' -s -V geometry:left=2cm,right=1cm,top=1.5cm,bottom=1cm -o "', $MyFilePath_Output, '" "', $MyFilePath_Input, '"')
    $MyCommand
    Invoke-Expression -Command:$MyCommand

    return $True
}




Function Get-JtDataTable_Info_Column_Width {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][System.Data.Datatable]$DataTable,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][Int32]$IntCol
    )

    [System.Data.Datatable]$MyDataTable = $DataTable
    [Int32]$MyIntNumberCol = $IntCol
    [int32]$MyIntResult = 0
    foreach ($MyRow in $MyDataTable.Rows) {
        # [Int32]$IntWidth = $Row.GetValueFromColumnByNumber($ColNumber)
        [String]$MyValue = $MyRow.ItemArray[$MyIntNumberCol]
        [Int32]$MyIntWidth = $MyValue.Length
        if ($MyIntWidth -gt $MyIntResult) {
            $MyIntResult = $MyIntWidth
        }

        [String]$MyValue = $MyDataTable.Columns[$MyIntNumberCol].caption
        [Int32]$MyIntWidth = $MyValue.Length
        if ($MyIntWidth -gt $MyIntResult) {
            $MyIntResult = $MyIntWidth
        }
    }
    return , $MyIntResult
}

class JtMdTable : JtClass {

    [String]$Vertical = "|"

    [System.Data.Datatable]$Datatable = $Null

    JtMdTable([System.Data.Datatable]$TheDataTable) {
        if ($Null -eq $TheDataTable) {
            Throw "JtTblTable is null!"
        }
        $This.Datatable = $TheDataTable
    }

    [Int32]GetColWidth([System.Data.Datatable]$TheDataTable, [Int32]$TheIntNumberCol) {
        return Get-JtDataTable_Info_Column_Width -DataTable $TheDataTable -IntCol $TheIntNumberCol
    }

    [String]GetFormattedOutput([Int32]$TheIntCol, [String]$TheInput) {
        [String]$MyInput = $TheInput
        [Int32]$MyIntCol = $TheIntCol

        [int32]$MyColWidth = $This.GetColWidth($This.Datatable, $MyIntCol)

        [String]$MySpacer = "                                                                                                                                 "
        [String]$MyOut = ( -join ($MyInput, $MySpacer)).Substring(0, $MyColWidth)


        [String]$MyResult = $MyOut
        return $MyResult 
    }

    [String]GetFormattedLineOutput([Int32]$TheIntCol, [String]$TheInput) {
        [String]$MyInput = $TheInput
        [Int32]$MyIntCol = $TheIntCol

        [int32]$MyColWidth = $This.GetColWidth($This.Datatable, $MyIntCol)

        [String]$MySpacer = "                                                                                                                                 "
        [String]$MyOut = ( -join ($MyInput, $MySpacer)).Substring(0, $MyColWidth + 2)


        [String]$MyResult = $MyOut
        return $MyResult 
    }

    [String]GetHeadLine([System.Array]$TheArrayList) {
        [System.Array]$MyArrayList = $TheArrayList
        [String]$MyVert = $This.Vertical

        [System.Collections.ArrayList]$MyLIne = [System.Collections.ArrayList]::new()
        
        
        $MyLine.Add($MyVert)
        
        [Int32]$i = 0
        foreach ($Element in $MyArrayList) {

            [String]$MyElement = $Element
            [String]$MyOutput = $This.GetFormattedOutput($i, $MyElement)
            # [String]$TheElement = $Element
            $MyLine.Add($MyOutput)
            $MyLine.Add($MyVert)
            $i = $i + 1
        }
        
        $MyLine.Add("`n")
        [String]$MyResult = $MyLine
        return $MyResult
    }

    [String]GetNormalLine($MyDatarow) {
        [String]$MyVert = $This.Vertical

        [System.Collections.ArrayList]$MyLIne = [System.Collections.ArrayList]::new()
        
        $MyLine.Add($MyVert)
        
        [Int32]$i = 0
        foreach ($Element in $MyDatarow.ItemArray) {
            [String]$MyElement = $Element
            [String]$MyOutput = $This.GetFormattedOutput($i, $MyElement)
            # [String]$TheElement = $Element
            $MyLine.Add($MyOutput)
            $MyLine.Add($MyVert)
            $i = $i + 1
        }
        
        $MyLine.Add("`n")
        
        [String]$MyResult = $MyLine
        return $MyResult
    }
    
    [String]GetHorLine([System.Collections.ArrayList]$TheArrayList) {
        [String]$MyVert = $This.Vertical
        [String]$MyHor = "-----------------------------------------------------------------------------------"
        
        [System.Collections.ArrayList]$MyLIne = [System.Collections.ArrayList]::new()
        
        
        $MyLine.Add($MyVert)
        
        [Int32]$i = 0
        foreach ($Element in $TheArrayList) {
            [String]$MyOutput = $This.GetFormattedLineOutput($i, $MyHor)
            # [String]$TheElement = $Hor
            $MyLine.Add($MyOutput)
            $MyLine.Add($MyVert)
            $i = $i + 1
        }
        
        $MyLine.Add("`n")
        
        [String]$MyResult = [system.String]::Join("", $MyLine.ToArray())
        return $MyResult
    }

    [String]GetOutput() {
        [System.Collections.ArrayList]$MyRows = $This.Datatable.rows
        [System.Collections.ArrayList]$MyLines = [System.Collections.ArrayList]::new()

        [System.Collections.ArrayList]$MyListhead = [System.Collections.ArrayList]::new()
        foreach($Column in $This.Datatable.Columns) {
            [String]$MyCaption = $Column
            $MyListhead.Add($MyCaption)
        }
        $MyLines.add($This.GetHeadLine($MyListhead))
        $MyLines.add($This.GetHorLine($MyListhead))

        foreach($Row in $MyRows) {
            $MyLines.add($This.GetNormalLine($Row))
        }

        [String]$MyResult = [system.String]::Join("", $MyLines.ToArray())
        return $MyResult
    }
}


Function New-JtMdDocument {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Title
    )

    # [String]$MyFunctionName = "New-JtMdDocument"

    [String]$MyTitle = $Title

    [JtMdDocument]::new($MyTitle)

}

Function New-JtMdTable {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][System.Data.Datatable]$DataTable
    )


    # [String]$MyFunctionName = "New-JtMdTable"

    [System.Data.Datatable]$MyDataTable = $DataTable

    [JtMdTable]::new($MyDataTable)

}

Export-ModuleMember -Function Convert-JtIoFile_Md_To_Pdf
Export-ModuleMember -Function New-JtMdDocument
Export-ModuleMember -Function New-JtMdTable