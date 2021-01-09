using module JtIo

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"


function PrepareMyDir([String]$TargetName) {

    [String]$BasePath = "D:\Seafile\al-cad-20w\1.ABGABEN"
    [String]$SourcePath = -join ($BasePath, "\", "folders.csv")
    [String]$TargetPath = -join ($BasePath, "\", $TargetName)
    [String]$TargetCmd = -join ($TargetPath, "\_mkdirs.cmd")
    
    Copy-Item $SourcePath $TargetPath -Force
    
    Set-Location $TargetPath

    $MyCsv = New-JtIoFileCsv -Path $SourcePath
    $MyList = $MyCsv.GetSelection("Folder")

    foreach ($Line in $MyList) {
        # $Line

        [JtIoFolder]$MyFolder = New-JtIoFolder -Path $TargetPath
    
        $MyFolder.GetSubFolder($Line, $True)
        }
    }

    Write-Host "TargetCmd:" $TargetCmd
    # start-process $TargetCmd
}





PrepareMyDir -TargetName "111.AUFGABE_1a\1119.AUFGABE_1A.ERGEBNISSE"
PrepareMyDir -TargetName "121.AUFGABE_2a\1219.AUFGABE_2A.ERGEBNISSE"
PrepareMyDir -TargetName "122.AUFGABE_2b\1229.AUFGABE_2B.ERGEBNISSE"
PrepareMyDir -TargetName "123.AUFGABE_2c\1239.AUFGABE_2C.ERGEBNISSE"
PrepareMyDir -TargetName "131.AUFGABE_3a\1319.AUFGABE_3A.ERGEBNISSE"
PrepareMyDir -TargetName "132.AUFGABE_3b\1329.AUFGABE_3B.ERGEBNISSE"
PrepareMyDir -TargetName "133.AUFGABE_3c\1339.AUFGABE_3C.ERGEBNISSE"
PrepareMyDir -TargetName "141.AUFGABE_4a\1419.AUFGABE_4A.ERGEBNISSE"
PrepareMyDir -TargetName "142.AUFGABE_4b\1429.AUFGABE_4B.ERGEBNISSE"
PrepareMyDir -TargetName "143.AUFGABE_4c\1439.AUFGABE_4C.ERGEBNISSE"







