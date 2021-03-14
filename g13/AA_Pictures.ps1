using module JtImageMagick
using module JtIo

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"

Function Get-JtPictures_Filename {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Label
    )

    return "pictures_$Label.jpg"
}

Function Get-JtRandomizedFiles {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $FolderPath_Input
    $MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder_Input

    foreach ($File in $MyAlJtIoFiles) {
        [String]$MyZufallszahl = Get-JtRandom6
        $MyFilenameOld = $File.GetName()
        $MyFilenameNew = -join ($MyZufallszahl, ".jpg")

        $MyFilePathOld = -join ($FolderPath_Input, "\", $MyFilenameOld)
        $MyFilePathNew = -join ($FolderPath_Output, "\", $MyFilenameNew)

        Write-JtLog_File -Text "copying $MyFilePathOld to $MyFilePathNew" -FilePath $MyFilePathNew
        Copy-Item $MyFilePathOld $MyFilePathNew
    }
    $MyAlJtIoFiles
}



Function Get-JtPictures_Grid {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [JtIoFolder]$MyFolderPath_Output = New-JtIoFolder -FolderPath $FolderPath_Output -Force

    $labels = (
        ".", "1", "2", "3", "4",
        "A", "a 1", "a 2", "a 3", "a 4",
        "B", "b 1", "b 2", "b 3", "b 4",
        "C", "c 1", "c 2", "c 3", "c 4",
        "D", "d 1", "d 2", "d 3", "d 4")

    $nr = 101
    
    foreach ($label in $labels) {
        [String]$MyFilename_Output = Get-JtPictures_Filename -Label $nr
        [JtImageMagick_Image]$MyJtImageMagick_Image = New-JtImageMagick_Image -FolderPath_Output $MyFolderPath_Output -Filename_Output $MyFilename_Output
        $MyJtImageMagick_Image.SetSize(150, 100)
        $MyJtImageMagick_Image.SetFont("Arial")
        $MyJtImageMagick_Image.SetGravity("North")
        $MyJtImageMagick_Image.SetPointsize(80)
        $MyJtImageMagick_Image.SetBackground("green")
        $MyJtImageMagick_Image.SetFill("yellow")
    
        $MyLabel = $label
        $MyJtImageMagick_Image.SetLabel($MyLabel)
        $MyJtImageMagick_Image.DoWrite()
        $nr ++
    }
}





Function Test-JtPictures {

    Param (
        [Parameter(Mandatory = $True)]
        [String]$FolderPath_Input,
        [Parameter(Mandatory = $True)]
        [String]$FolderPath_Output
    )
    [JtIoFolder]$MyFolderPath_Output = New-JtIoFolder -FolderPath $FolderPath_Output

    $MyJtReplace = (
        "107", "108", "109", "110",
        "111", "112", "113", "114",
        "116", "117", "118", "119",
        "121", "122", "123", "124")

    foreach ($item in $MyJtReplace) {
        [String]$MyOutName = Get-JtPictures_Filename -Label $item
        [String]$FolderPath_Output = $MyFolderPath_Output.GetFilePath($MyOutName)
        
        Write-JtLog_Folder -Text "Test-JtPictures. FolderPath_Output." -FolderPath $FolderPath_Output
    }
}

# $Pat = "C:\_inventory\testing\JtImageMagick\pictures\grid"
# $Pout = "C:\_inventory\testing\JtImageMagick\pictures\pout"
# $In1 = -join ($Pat, "\", "pictures101.jpg")
# $In2 = -join ($Pat, "\", "pictures102.jpg")


# Get-JtRandomizedFiles -FolderPath_Input "C:\_inventory\testing\JtImageMagick\in" -FolderPath_Output $FolderPathOut


Get-JtPictures_Grid -FolderPath_Output "C:\_inventory\testing\JtImageMagick\pictures\grid"

# Test-JtPictures -FolderPath_Input "C:\_inventory\testing\JtImageMagick\fotos" -FolderPath_Output "C:\_inventory\testing\JtImageMagick\pictures"




