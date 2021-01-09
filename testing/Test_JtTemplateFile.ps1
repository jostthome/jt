 
using module JtFolderRenderer
using module JtPreisliste
using module JtTbl
using module JtTemplateFile
using module JtColRen

Set-StrictMode -version latest
$ErrorActionPreference = "Stop"

Write-JTLog ("Poster")
[JtPreisliste]$JtPreisliste = New-JtPreisliste_Plotten_2020_07_01 
[JtIoFolder]$JtIoFolder = New-JtIoFolder -Path "C:\apps\Documents\poster\Beispiel_Poster"


[JtTemplateFile]$JtTemplateFile = Get-JTTemplateFile -JtIoFolder $JtIoFolder
$JtTemplateFile

$Parts = $JtTemplateFile.GetName().split(".")
$Parts

Write-Host "--------------------------------------------"

foreach($Part in $Parts) {
    Write-Host "Part:" $Part

    [JtColRen]$ColRen = [JtColRen]::GetJtColRen($Part)
    Write-Host "Header:" $ColRen.GetHeader()
    Write-Host "Label:" $ColRen.GetLabel()
    Write-Host "Output:" $ColRen.GetOutput("1200")
    Write-Host "Name:" $ColRen.GetName()
    Write-Host "-------------------------"
}


$NormalFiles = $JtIoFolder.GetNormalFiles()
$NormalFiles

foreach($MyFile in $NormalFiles) {

    $MyFile.GetName()
}


$c = $JtTemplateFile.GetJtColRens()
$c

# [JtFolderRenderer]$JtFolderRenderer = [JtFolderRenderer_Poster]::new($JtIoFolder, $JtPreisliste)
# $JtFolderRenderer.GetInfo()
# Write-Host $JtFolderRenderer.GetMdDoc()
exit
