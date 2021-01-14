using module JtClass
using module JtIo
using module JtTbl
using module JtCsv

class JtMd : JtClass{

    JtMd() {
        $This.ClassName = "JtMd"
        $This.JtInf_Name = $This.GetType()
    }

    static [String]GetLinkForLine([String]$Line) {
        [String]$Result = $Line
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
                $Result = $Link
            }
        }
        return $Result
    }

    static [System.Collections.ArrayList]GetList([System.Collections.ArrayList]$JtIoFiles, [String]$ThePattern) {
        [System.Collections.ArrayList]$MyList = [System.Collections.ArrayList]::new()
        foreach ($AnyFile in $JtIoFiles) {
            [JtIoFile]$JtIoFile = $AnyFile
            [String]$FileName = $JtIoFile.GetName()
            [String]$FileLabel = $JtIoFile.GetLabelForFileName()
            [String]$FilePath = $JtIoFile.GetPath()
            [String]$Pattern = $ThePattern.Replace("{FILELABEL}", $FileLabel)
            [String]$FileExtension = [System.IO.Path]::GetExtension($FileName)
            
            [String]$Content = Get-Content -Path $JtIoFile.GetPath() -Encoding UTF8
            [System.Collections.ArrayList]$MyHitList = [JtMd]::GetHits($Content, $Pattern)
            foreach ($El in $MyHitList) {
                [String]$Find = $Content | Select-String -Pattern $Pattern
                if ($Null -ne $Find) {
                    $Content -match $Pattern
                    # if ($matches.Length -gt 0) {
                    #     [String]$MyLine = $matches[0]
                    #     if ($MyLine.Length -gt 0) {
                    #         Write-Host "MyLine: " $MyLine
                    #     }
                    # }
                    [PSCustomObject]$MyObject = [PSCustomObject]@{ }
                    $MyObject | Add-Member -MemberType NoteProperty -Name Filename -Value $FileName
                    $MyObject | Add-Member -MemberType NoteProperty -Name Filepath -Value $FilePath
                    $MyObject | Add-Member -MemberType NoteProperty -Name Extension -Value $FileExtension
                    # $MyObject | Add-Member -MemberType NoteProperty -Name Find -Value $MyLine
                    $MyObject | Add-Member -MemberType NoteProperty -Name Label -Value $FileLabel
                    
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
        [String]$Result = $Line
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
                $Result = $Label
            }
        }
        $Result = $Result.Replace("[", "")
        $Result = $Result.Replace("]", "")
        return $Result
    }


    static [System.Collections.ArrayList]GetHits([String]$Content, [String]$Pattern) {
        $Mat3 = $Content.split() | Where-Object { $_ -match $Pattern } | ForEach-Object { $Matches[0] }
        $Mat3

        [System.Collections.ArrayList]$MyList = [System.Collections.ArrayList]::new()
        # if($matches.Length -gt 0) {
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

    static [Boolean]DoWriteJtMdCsv([JtIoFolder]$FolderWork, [JtIoFolder]$FolderTarget, [String]$MyLabel, [String]$MyFilter, [String]$ThePattern) {
        [System.Collections.ArrayList]$MyList = [System.Collections.ArrayList]::new()
        [System.Collections.ArrayList]$JtIoFiles = $FolderWork.GetJtIoFilesWithFilter($MyFilter, $True)

        [System.Collections.ArrayList]$ArrayList = [JtMd]::GetList($JtIoFiles, $ThePattern)

        New-JtCsvWriteArraylist -Label $MyLabel -JtIoFolder $FolderTarget -ArrayList $ArrayList

        return $True
    }
}

class MdDocument {

    [String]$End = "`n"

    hidden [System.Collections.ArrayList]$Lines = [System.Collections.ArrayList]::new()

    MdDocument([String]$Title) {
        $This.AddH1($Title)
    }

    [Boolean]AddLine([String]$Input) {
        $This.Lines.Add(-join($Input, $This.End))
        return $True
    }

    [Boolean]AddLine() {
        $This.Lines.Add(-join("---", $This.End))
        return $True
    }

    [Boolean]AddH1([String]$Input) {
        [String]$MyLine = -join("# ", $Input, $This.End)
        $This.AddLine($MyLine)
        return $True
    }

    [Boolean]AddH2([String]$Input) {
        [String]$MyLine = -join("## ", $Input, $This.End)
        $This.AddLine($MyLine)
        return $True
    }

    [Boolean]AddH3([String]$Input) {
        [String]$MyLine = -join("### ", $Input, $This.End)
        $This.AddLine($MyLine)
        return $True
    }

    [String]GetOutput() {
        [String]$Result = ""

        $Result = ($This.Lines -join $This.End)

        return $Result
    }

}


class MdTable : JtClass {

    [String]$Vertical = "|"

    [System.Data.Datatable]$Datatable = $Null

    MdTable([System.Data.Datatable]$MyDatatable) {
        if($Null -eq $MyDatatable) {
            Throw "JtTblTable is null!"
        }
        $This.Datatable = $MyDatatable
    }

    
    [Int32] GetColWidth([System.Data.Datatable]$DataTable, [Int32]$ColNumber) {
        [int32]$Result = 0
        foreach ($Row in $DataTable.Rows) {
            # [Int32]$IntWidth = $Row.GetValueFromColumnByNumber($ColNumber)
            [String]$Value = $Row.ItemArray[$ColNumber]
            [Int32]$IntWidth = $Value.Length
            if ($IntWidth -gt $Result) {
                $Result = $IntWidth
            }

            [String]$Value = $DataTable.Columns[$ColNumber].caption
            [Int32]$IntWidth = $Value.Length
            if ($IntWidth -gt $Result) {
                $Result = $IntWidth
            }
        }
        return $Result
    }

    [String]GetFormattedOutput([Int32]$IntCol, [String]$Input) {
        [String]$Result = $Input

        [int32]$ColWidth = $This.GetColWidth($This.Datatable, $IntCol)

        [String]$Spacer = "                                                                                                                                 "
        [String]$Out = ( -join ($Input, $Spacer)).Substring(0, $ColWidth)

        $Result = $Out
        return $Result 
    }

    [String]GetHeadLine([System.Array]$ArrayList) {
        [String]$Vert = $This.Vertical

        [System.Collections.ArrayList]$MyLIne = [System.Collections.ArrayList]::new()
        
        [String]$Result = ""
        
        $MYLine.Add($Vert)
        
        [Int32]$i = 0
        foreach ($Element in $ArrayList) {
            [String]$TheElement = $This.GetFormattedOutput($i, $Element)
            # [String]$TheElement = $Element
            $MyLine.Add($TheElement)
            $MyLine.Add($Vert)
            $i = $i + 1
        }

        $MyLine.Add("`n")
        
        $Result = -join ($MyLine)
        return $Result
    }

    [String]GetNormalLine($Datarow) {
        [String]$Vert = $This.Vertical

        [System.Collections.ArrayList]$MyLIne = [System.Collections.ArrayList]::new()
        
        [String]$Result = ""
        
        $MYLine.Add($Vert)
        
        [Int32]$i = 0
        foreach ($Element in $Datarow.ItemArray) {
            [String]$TheElement = $This.GetFormattedOutput($i, $Element)
            # [String]$TheElement = $Element
            $MyLine.Add($TheElement)
            $MyLine.Add($Vert)
            $i = $i + 1
        }

        $MyLine.Add("`n")
        
        $Result = -join ($MyLine)
        return $Result
    }
    
    [String]GetHorLine([System.Collections.ArrayList]$ArrayList) {
        [String]$Vert = $This.Vertical
        [String]$Hor = "-----------------------------------------------------------------------------------"
        
        [System.Collections.ArrayList]$MyLIne = [System.Collections.ArrayList]::new()
        
        [String]$Result = ""
        
        $MYLine.Add($Vert)
        
        [Int32]$i = 0
        foreach ($Element in $ArrayList) {
            [String]$TheElement = $This.GetFormattedOutput($i, $Hor)
            # [String]$TheElement = $Hor
            $MyLine.Add($TheElement)
            $MyLine.Add($Vert)
            $i = $i + 1
        }

        $MyLine.Add("`n")
        
        $Result = [system.String]::Join("", $MyLine.ToArray())
        return $Result
    }

    [String]GetOutput() {
        [System.Collections.ArrayList]$MyRows = $This.Datatable.rows
        [System.Collections.ArrayList]$Lines = [System.Collections.ArrayList]::new()


        [System.Collections.ArrayList]$Listhead = [System.Collections.ArrayList]::new()
        foreach($Column in $This.Datatable.Columns) {
            $Listhead.Add($Column.caption)
        }
        $Lines.add($This.GetHeadLine($Listhead))
        $Lines.add($This.GetHorLine($Listhead))

        foreach($Row in $MyRows) {
            $Lines.add($This.GetNormalLine($Row))

        }
        #     [System.Array]$TheList = $MyRow.GetValues() 
        # }

        [String]$Result = ""
        $Result = [system.String]::Join("", $Lines.ToArray())

        return $Result
    }
}
