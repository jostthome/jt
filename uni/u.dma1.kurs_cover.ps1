using module JtImageMagick
using module JtIo

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"

Function New-JtCover_PdfToJpg {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input
    )

    [String]$MyFunctionName = "New-JtCover_PdfToJpg"
    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $FolderPath_Input

    [String]$MyFolderPath_Base = Get-JtFolderPath_Inv_Out
    [JtIoFolder]$MyJtIoFolder_Base = New-JtIoFolder -FolderPath $MyFolderPath_Base
    [JtIoFolder]$MyJtIoFolder_Output = $MyJtIoFolder_Base.GetJtIoFolder_Sub($MyFunctionName, $True)
    [String]$MyFolderPath_Output = $MyJtIoFolder_Output.GetPath()

    [String]$MyFilter = "*.web.pdf"
    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder_Input -Filter $MyFilter -Recurse
    
    $MyAlJtIoFiles.Count

    foreach($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File
        [String]$MyFolderPath_Input = $MyJtIoFile.GetPathOfFolder()
        [String]$MyFilename_Input = $MyJtIoFile.GetName()
        New-JtImageMagick_Item_Cover -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output -Filename_Input $MyFilename_Input
    }
}

[String]$FolderPath_Input = -join($env:OneDrive, "\", "1.UNI\11.DMA1")

New-JtCover_PdfToJpg -FolderPath_Input $FolderPath_Input 



