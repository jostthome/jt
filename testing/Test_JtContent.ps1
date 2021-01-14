using module  JtIoFolder 
using module  JtIndex
using module  JtPreisliste
using module  JtTbl

Set-StrictMode -version latest
$ErrorActionPreference = "Stop"


Write-JTLog ("Miete")
[JtIoFolder]$JtIoFolder = New-JtIoFolder -Path "C:\apps\Documents\miete\Beispiel_Miete1"
[JtIndex]$JtIndex = [JtIndex_Zahlung]::new($JtIoFolder)
Write-Host $JtIndex.GetInfo()
New-JtInvMiete

exit 


Write-JTLog ("Poster")
[JtPreisliste]$JtPreisliste = New-JtPreisliste_Plotten_2020_07_01 
[JtIoFolder]$JtIoFolder = New-JtIoFolder -Path "C:\apps\Documents\poster\Beispiel_Poster"
[JtIndex]$JtIndex = [JtIndex_BxH]::new($JtIoFolder, $JtPreisliste)
$JtIndex.GetInfo()
Write-Host $JtIndex.GetMdDoc()


Write-JTLog ("Lizenzen")
[JtIoFolder]$JtIoFolder = New-JtIoFolder -Path "C:\apps\Documents\folder\Beispiel_Lizenzen"
[JtIndex]$JtIndex = [JtIndex_Anzahl]::new($JtIoFolder)
Write-Host $JtIndex.GetInfo()
# Write-Host $JtIndex.GetMdDoc()

Write-JTLog ("Rechnungen")
[JtIoFolder]$JtIoFolder = New-JtIoFolder -Path "C:\apps\Documents\folder\Beispiel_Rechnungen1"
[JtIndex]$JtIndex = [JtIndex_Anzahl]::new($JtIoFolder)
Write-Host $JtIndex.GetInfo()
# Write-Host $JtIndex.GetMdDoc()



