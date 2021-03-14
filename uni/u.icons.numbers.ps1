using module Jt
using module JtImageMagick

Function New-JtImageMagick_Item_Numbers {
    [String]$MyBackground = "silver"

    [String]$MyFolderPath_Output = "D:\Seafile\al-apps\apps\Documents\numbers\0_to_9"
    foreach ($i in 0..9) {
        [String]$MyLabel = $i
        [String]$MyFilename = -join($i, ".jpg")
        $MyIcon = @{
            FolderPath_Output = $MyFolderPath_Output
            Filename_Output = $MyFilename 
            Label = $MyLabel 
            Background = $MyBackground
            Pointsize = 192 
            X = 256 
            Y = 256
        }
        New-JtImageMagick_Item_Icon @MyIcon
    }

    [String]$MyFolderPath_Output = "D:\Seafile\al-apps\apps\Documents\numbers\0_to_19"
    foreach ($i in 0..19) {
        [String]$MyLabel = Convert-JtInt_To_00 -Int $i
        [String]$MyFilename = -join($MyLabel, ".jpg")
        $MyIcon = @{
            FolderPath_Output = $MyFolderPath_Output
            Filename_Output = $MyFilename 
            Label = $MyLabel 
            Background = $MyBackground
            Pointsize = 192 
            X = 256 
            Y = 256
        }
        New-JtImageMagick_Item_Icon @MyIcon
    }
}

New-JtImageMagick_Item_Numbers