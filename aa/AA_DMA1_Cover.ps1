using module JtImageMagick
using module JtIo


Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"

[String]$F2 = "C:\_inventory\temp\cover"


[JtIoFolder]$MyFolder = New-JtIoFolder -Path (-join($env:OneDrive, "\", "1.UNI\11.DMA1"))

#GetJtIoFilesWithFilter([String]$MyFilter, [Boolean]$DoRecurse) {

[String]$MyFilter = "*.web.pdf"
[System.Collections.ArrayList]$MyFiles = $MyFolder.GetJtIoFilesWithFilter($MyFilter, $True)

$MyFiles.Count

foreach($MyFile in $Myfiles) {
    [JtIoFile]$TheFile = $MyFile
    [String]$FolderPath = $TheFile.GetPathOfFolder()
    [JtIoFolder]$MyFolder = New-JtIoFolder -Path $FolderPath
    New-ImageMagickItemCover -InputFolder $MyFolder.GetPath() -FolderWork $F2 -Filename $TheFile.GetName()
}


