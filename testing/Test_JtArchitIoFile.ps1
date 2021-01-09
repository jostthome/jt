# [String]$PathCommonDev = -join($env:OneDrive, "\", "0.INVENTORY", "\", "common")
# [String]$PathCommonLive = "C:\apps\inventory\common"

# [String]$PathCommon = ""
# if(Test-Path $PathCommonDev) {
#     $PathCommon = $PathCommonDev
# } else {
#     $PathCommon = $PathCommonLive
# }




Set-StrictMode -version latest
$ErrorActionPreference = "Stop"

[String]$WorkFolder = "C:\TEMP\abgabe"
[String]$FileName = "2019-06-10.thome_jost.blatt02_grundrisse.fabriano.594x841.pdf"
[String]$FilePath = -join($WorkFolder, "\", $FileName)

[JtIoFile]$JtIoFile = New-JtIoFile -Path $FilePath

Write-Host "Path:" $JtIoFile.GetPath()
Write-Host "Size:" $JtIoFile.GetInfoFromFileName_Area()
Write-Host "Size:" $JtIoFile.GetInfoFromFileName_Age()

