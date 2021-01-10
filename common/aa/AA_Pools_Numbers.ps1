using module JtImageMagick

function New-JtImageMagickItemNumbers {
    [String]$Background = "silver"

    [String]$OutputFolder = "D:\Seafile\al-apps\apps\Documents\numbers\0_to_9"
    foreach ($i in 0..9) {
        [String]$Filename = -join("number", $i, ".jpg")
        [String]$Label = $i
        New-ImageMagickItemIcon -OutputFolder $OutputFolder -OutputFilename $filename -Label $Label -Background $Background -Size 192 -X 256 -Y 256
    }

    [String]$OutputFolder = "D:\Seafile\al-apps\apps\Documents\numbers\0_to_99"
    foreach ($i in 0..99) {
        [String]$Label = [ImageMagick]::GetTwoDigitsForNumber($i)
        [String]$Filename = -join("number", $Label, ".jpg")
        New-ImageMagickItemIcon -OutputFolder $OutputFolder -OutputFilename $filename -Label $Label -Background $Background -Size 192 -X 256 -Y 256
    }
}

New-JtImageMagickItemNumbers