using module JtImageMagick


function New-JtImageJtMagickItemIcons {
    [String]$Background = "grey"

    [String]$OutputFolder = "D:\Seafile\al-cad-20w\3.POSTER\39.DUMMY_SQUARE.POSTER\a.square_2100x2100"
    for ($i = 1; $i -le 150; $i++) {
        $MyFilename = [JtImageMagick]::GetFilenameForNumber($i)
        $Label = [JtImageMagick]::GetThreeDigitsForNumber($i)
        New-JtImageMagickItemIcon -OutputFolder $OutputFolder -OutputFilename $MyFilename -Label $Label -Background $Background -Size 1200 -X 2100 -Y 2100
    }

    [String]$OutputFolder = "D:\Seafile\al-cad-20w\3.POSTER\39.DUMMY_RECT.POSTER\a.rect_2970x2100"
    for ($i = 1; $i -le 150; $i++) {
        $MyFilename = [JtImageMagick]::GetFilenameForNumber($i)
        $Label = [JtImageMagick]::GetThreeDigitsForNumber($i)
        New-JtImageMagickItemIcon -OutputFolder $OutputFolder -OutputFilename $MyFilename -Label $Label -Background $Background -Size 1500 -X 2970 -Y 2100
    }
    
    [String]$OutputFolder = "C:\temp\icons\square_2100x2100"
    for ($i = 1; $i -le 150; $i++) {
        $MyFilename = [JtImageMagick]::GetFilenameForNumber($i)
        $Label = [JtImageMagick]::GetThreeDigitsForNumber($i)
        New-JtImageMagickItemIcon -OutputFolder $OutputFolder -OutputFilename $MyFilename -Label $Label -Background $Background -Size 1250 -X 2100 -Y 2100
    }
    
    [String]$OutputFolder = "c:\temp\icons\rect_2970x2100"
    for ($i = 1; $i -le 150; $i++) {
        $MyFilename = [JtImageMagick]::GetFilenameForNumber($i)
        $Label = [JtImageMagick]::GetThreeDigitsForNumber($i)
        New-JtImageMagickItemIcon -OutputFolder $OutputFolder -OutputFilename $MyFilename -Label $Label -Background $Background -Size 1500 -X 2970 -Y 2100
    }

}

New-JtImageJtMagickItemIcons