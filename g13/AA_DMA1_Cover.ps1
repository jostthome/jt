using module JtImageMagick
using module JtIo


Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"


function New-JtPdfWebCovers {

    Param (
        [Parameter(Mandatory = $true)]
        [String]$Source,
        [Parameter(Mandatory = $true)]
        [String]$Target
    )
    
    [JtIoFolder]$MyFolder = New-JtIoFolder -Path $Source

    [String]$MyFilter = "*.web.pdf"
    [System.Collections.ArrayList]$MyFiles = $MyFolder.GetJtIoFilesWithFilter($MyFilter, $True)
    
    $MyFiles.Count
    
    foreach($MyFile in $Myfiles) {
        [JtIoFile]$TheFile = $MyFile
        [String]$FolderPath = $TheFile.GetPathOfFolder()
        [JtIoFolder]$MyFolder = New-JtIoFolder -Path $FolderPath
        New-JtImageMagickItemCover -InputFolder $Source -FolderWork $Target -InputFilename $TheFile.GetName()
    }
}

[String]$Source = -join($env:OneDrive, "\", "1.UNI\11.DMA1")

New-JtPdfWebCovers -Source $Source -Target "C:\_inventory\temp\cover"







