using module JtIo

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"


function New-JtAbgabeOrdner {

    Param (
        [Parameter(Mandatory = $true)]
        [String]$BasePath,
        [Parameter(Mandatory = $true)]
        [String]$TargetName
    )

    [String]$SourcePath = -join ($BasePath, "\", "folders.csv")
    [String]$TargetPath = -join ($BasePath, "\", $TargetName)
    [String]$TargetCmd = -join ($TargetPath, "\", "_mkdirs.cmd")
    
    Copy-Item $SourcePath $TargetPath -Force
    
    Set-Location $TargetPath

    $MyCsv = New-JtIoFileCsv -Path $SourcePath
    $MyList = $MyCsv.GetSelection("Folder")

    foreach ($Line in $MyList) {
        # $Line

        [JtIoFolder]$MyFolder = New-JtIoFolder -Path $TargetPath
    
        $MyFolder.GetSubFolder($Line, $True)
        }

    Write-Host "TargetCmd:" $TargetCmd
    # start-process $TargetCmd
}

[String]$MyBasePath = "D:\Seafile\al-cad-20w\1.ABGABEN" 
New-JtAbgabeOrdner -BasePath $MyBasePath -TargetName "111.AUFGABE_1a\1119.AUFGABE_1A.ERGEBNISSE"
New-JtAbgabeOrdner -BasePath $MyBasePath -TargetName "121.AUFGABE_2a\1219.AUFGABE_2A.ERGEBNISSE"
New-JtAbgabeOrdner -BasePath $MyBasePath -TargetName "122.AUFGABE_2b\1229.AUFGABE_2B.ERGEBNISSE"
New-JtAbgabeOrdner -BasePath $MyBasePath -TargetName "123.AUFGABE_2c\1239.AUFGABE_2C.ERGEBNISSE"
New-JtAbgabeOrdner -BasePath $MyBasePath -TargetName "131.AUFGABE_3a\1319.AUFGABE_3A.ERGEBNISSE"
New-JtAbgabeOrdner -BasePath $MyBasePath -TargetName "132.AUFGABE_3b\1329.AUFGABE_3B.ERGEBNISSE"
New-JtAbgabeOrdner -BasePath $MyBasePath -TargetName "133.AUFGABE_3c\1339.AUFGABE_3C.ERGEBNISSE"
New-JtAbgabeOrdner -BasePath $MyBasePath -TargetName "141.AUFGABE_4a\1419.AUFGABE_4A.ERGEBNISSE"
New-JtAbgabeOrdner -BasePath $MyBasePath -TargetName "142.AUFGABE_4b\1429.AUFGABE_4B.ERGEBNISSE"
New-JtAbgabeOrdner -BasePath $MyBasePath -TargetName "143.AUFGABE_4c\1439.AUFGABE_4C.ERGEBNISSE"







