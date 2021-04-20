using module JtIo
using module JtTbl

Set-StrictMode -Version "2.0"
# $ErrorActionPreference = "Inquire"
$ErrorActionPreference = "Stop"

Function New-JtFolder_Overview_Csv {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Label
    )

    # [String]$MyFunctionName = "New-JtFolder_Overview_Csv"
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
    [String]$MyLabel = $Label

    [String]$MyExtension = [JtIo]::FileExtension_Folder
    [String]$MyFilter = "*$MyExtension"

    $MyAlJtIoFiles_Folder = Get-JtChildItem -FolderPath $MyFolderPath_Input -Filter $MyFilter -Recurse

    [JtTblTable]$MyJtTblTable = New-JtTblTable -Label $MyLabel
    ForEach($File in $MyAlJtIoFiles_Folder) {
        [JtIoFile]$MyJtIoFile = $File

        [JtIoFolder]$MyJtIoFolder_Parent = $MyJtIoFile.GetJtIoFolder_Parent()

        [String]$MyFolderPath_Parent = $MyJtIoFolder_Parent.GetPath()

        [String]$MyFilename = $MyJtIoFile.GetName()
        [String]$MyFoldername = Convert-JtFolderPath_To_Foldername -FolderPath $MyFolderPath_Parent

        [JtTblRow]$MyJtTblRow = New-JtTblRow

        ForEach($IntI in 1..9) {
            [String]$MyCol = "Fol$IntI"
            [String]$MyValue = Convert-JtDotter -Text $MyFoldername -PatternOut "$IntI"
            $MyJtTblRow.Add($MyCol, $MyValue)
        }

        [String]$MyCol = "Parts"
        [String]$MyValue = ($MyFoldername.Split(".")).Count
        $MyJtTblRow.Add($MyCol, $MyValue)

        ForEach($IntI in 1..8) {
            [String]$MyCol = "File$IntI"
            [String]$MyValue = Convert-JtDotter -Text $MyFilename -PatternOut "$IntI"
            $MyJtTblRow.Add($MyCol, $MyValue)
        }

        [String]$MyCol = "Level"
        [String]$MyValue = Get-JtFolderPath_Info_Level -FolderPath $MyFolderPath_Parent
        $MyJtTblRow.Add($MyCol, $MyValue)

        [String]$MyCol = "Ext2"
        [String]$MyValue = $MyJtIoFile.GetExtension2()
        $MyJtTblRow.Add($MyCol, $MyValue)

        [String]$MyCol = "Path"
        [String]$MyValue = $MyFolderPath_Parent
        $MyJtTblRow.Add($MyCol, $MyValue)

        $MyJtTblTable.AddRow($MyJtTblRow)

    }
    $MyDataTable = Convert-JtTblTable_To_Datatable -JtTblTable $MyJtTblTable
    Convert-JtDataTable_To_Csv -DataTable $MyDataTable -FolderPath_Output $MyFolderPath_Output -Label $MyLabel
}
New-JtFolder_Overview_Csv -FolderPath_Input "%OneDrive%" -FolderPath_Output "%OneDrive%\0.INVENTORY\01.OUTPUT\stb" -Label "OneDrive"

