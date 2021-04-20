using module JtColRen
using module JtIo
using module JtTbl

Set-StrictMode -Version "2.0"
# $ErrorActionPreference = "Inquire"
$ErrorActionPreference = "Stop"

Function Update-JtBuchung {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )
    
    [String]$MyFunctionName = "Update-JtBuchung"

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output

    [JtTblTable]$MyJtTblTable = New-JtTblTable "Buchung"
    
    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input
    
    [JtDataRepository]$MyJtDataRepository = New-JtDataRepository -FolderPath $MyFolderPath_Input
    
    $MyAlJtIoFolders = $MyJtDataRepository.GetAlJtDataFolders()
    
    ForEach ($Folder in $MyAlJtIoFolders) {
        [JtDataFolder]$MyJtDataFolder = $Folder
        [JtIoFolder]$MyJtIoFolder = $MyJtDataFolder.JtIoFolder
        
        [Boolean]$MyBlnShow = $False
        [JtTblRow]$MyJtTblRow = New-JtTblRow
        [String]$MyFoldername = $MyJtIoFolder.GetName()
        
        [JtTemplateFile]$MyJtTemplateFile = Get-JtTemplateFile -FolderPath_Input $MyJtIoFolder
        $MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder -Normal
        if ($MyFolderName.EndsWith("rechnung")) {
            $MyBlnShow = $True
            
            if (!($MyJtTemplateFile.IsValid())) {
                Write-JtLog_Error -Where $MyFunctionName -Text "Template not valid in $MyJtIoFolder"
            }
        }

        if ($MyFolderName.EndsWith("zahlung")) {
            $MyBlnShow = $True
            
            if (!($MyJtTemplateFile.IsValid())) {
                Write-JtLog_Error -Where $MyFunctionName -Text "Template not valid in $MyJtIoFolder"
            }
        }
        
        if ($MyFolderName.EndsWith("buchung")) {
            $MyBlnShow = $True
            
            if (!($MyJtTemplateFile.IsValid())) {
                Write-JtLog_Error -Where $MyFunctionName -Text "Template not valid in $MyJtIoFolder"
            }
        }
        
        if ($MyBlnShow) {
            $MyJtTblRow.Add("Folder", $MyFoldername)
            $MyJtTblRow.Add("Files", $MyAlJtIoFiles.Count)
            [Int16]$MyIntParts = $MyFoldername.Split(".").Count
            $MyJtTblRow.Add("Parts", $MyIntParts)

            ForEach ($i in 1..8) {
                [String]$MyPart = Convert-JtDotter -Text $MyFoldername -PatternOut "$i"
                $MyJtTblRow.Add("P$i", $MyPart)
            }

            $MyJtTblRow.Add("Template", $MyJtTemplateFile.GetName())
            $MyJtTblRow.Add("Path", $MyJtIoFolder.GetPath())
            $MyJtTblTable.AddRow($MyJtTblRow)
        }
    }

    # $MyAlJtIoFolders

    # $MyJtTblTable.GetObjects()

    $MyDataTable = Convert-JtTblTable_To_Datatable -JtTblTable $MyJtTblTable
    Convert-JtDataTable_To_Csv -DataTable $MyDataTable -FolderPath_Output $MyFolderPath_Output -Label "buchung"

}

# Update-JtBuchung -FolderPath_Input "$env:OneDrive\BANK" -FolderPath_Output "d:\stb.buchung"
Update-JtBuchung -FolderPath_Input "$env:OneDrive" -FolderPath_Output "d:\stb.buchung"
