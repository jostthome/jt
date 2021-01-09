using module  JtIoFolder 
using module  JtFolderRenderer
using module  JtPreisliste
using module  JtTbl

Set-StrictMode -version latest
$ErrorActionPreference = "Stop"


Write-JTLog ("Miete")
[JtIoFolder]$JtIoFolder = New-JtIoFolder -Path "C:\apps\Documents\miete\Beispiel_Miete1"
[JtFolderRenderer]$JtFolderRenderer = [JtFolderRenderer_Miete]::new($JtIoFolder)
Write-Host $JtFolderRenderer.GetInfo()
New-JtInvMiete

exit 


Write-JTLog ("Poster")
[JtPreisliste]$JtPreisliste = New-JtPreisliste_Plotten_2020_07_01 
[JtIoFolder]$JtIoFolder = New-JtIoFolder -Path "C:\apps\Documents\poster\Beispiel_Poster"
[JtFolderRenderer]$JtFolderRenderer = [JtFolderRenderer_Poster]::new($JtIoFolder, $JtPreisliste)
$JtFolderRenderer.GetInfo()
Write-Host $JtFolderRenderer.GetMdDoc()


Write-JTLog ("Lizenzen")
[JtIoFolder]$JtIoFolder = New-JtIoFolder -Path "C:\apps\Documents\folder\Beispiel_Lizenzen"
[JtFolderRenderer]$JtFolderRenderer = [JtFolderRenderer_Count]::new($JtIoFolder)
Write-Host $JtFolderRenderer.GetInfo()
# Write-Host $JtFolderRenderer.GetMdDoc()

Write-JTLog ("Rechnungen")
[JtIoFolder]$JtIoFolder = New-JtIoFolder -Path "C:\apps\Documents\folder\Beispiel_Rechnungen1"
[JtFolderRenderer]$JtFolderRenderer = [JtFolderRenderer_Sum]::new($JtIoFolder)
Write-Host $JtFolderRenderer.GetInfo()
# Write-Host $JtFolderRenderer.GetMdDoc()



