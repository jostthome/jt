using module Jt
using module JtImageMagick

Function New-JtImageMagick_Item_Letters {
    [String]$MyBackground = "blue"

    [String]$MyFolderPath_Output = "c:\_inventory\out\letters"

    [String]$MyText = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    for ($i = 0; $i -lt $MyText.length; $i ++) {
        [String]$MyLabel = $MyText.Substring($i, 1)

        [String]$MyFilename = -join($MyLabel, ".ico")
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

New-JtImageMagick_Item_Letters