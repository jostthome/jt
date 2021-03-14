using module JtImageMagick

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"


Function New-JtImageJtMagickItemIcons {
    [String]$MyBackground = "grey"

    [String]$MyFolderPath_Output = "D:\Seafile\al-cad-20w\3.POSTER\39.DUMMY_SQUARE.POSTER\a.square_2100x2100"
    for ($i = 1; $i -le 150; $i++) {
        $MyFilename_Output = [JtImageMagick]::GetFilenameForNumber($i)
        $MyLabel = Convert-JtInt_To_000 -Int $i
        New-JtImageMagick_Item_Icon -FolderPath_Output $MyFolderPath_Output -Filename_Output $MyFilename_Output -Label $MyLabel -Background $MyBackground -Pointsize 1200 -X 2100 -Y 2100
    }

    [String]$FolderPath_Output = "D:\Seafile\al-cad-20w\3.POSTER\39.DUMMY_RECT.POSTER\a.rect_2970x2100"
    for ($i = 1; $i -le 150; $i++) {
        $MyFilename_Output = [JtImageMagick]::GetFilenameForNumber($i)
        $MyLabel = Convert-JtInt_To_000 -Int $i
        New-JtImageMagick_Item_Icon -FolderPath_Output $MyFolderPath_Output -Filename_Output $MyFilename_Output -Label $MyLabel -Background $MyBackground -Pointsize 1500 -X 2970 -Y 2100
    }

    [String]$MyFolderPath_Output = "D:\Seafile\al-cad-20w\3.POSTER\39.DUMMY_SQUARE.POSTER\a.square_2100x2100"
    for ($i = 1; $i -le 150; $i++) {
        $MyFilename_Output = [JtImageMagick]::GetFilenameForNumber($i)
        $MyLabel = Convert-JtInt_To_000 -Int $i
        New-JtImageMagick_Item_Icon -FolderPath_Output $MyFolderPath_Output -Filename_Output $MyFilename_Output -Label $MyLabel -Background $MyBackground -Pointsize 1200 -X 2100 -Y 2100
    }

    [String]$FolderPath_Output = "D:\Seafile\al-cad-20w\3.POSTER\39.DUMMY_RECT.POSTER\a.rect_2970x2100"
    for ($i = 1; $i -le 150; $i++) {
        $MyFilename_Output = [JtImageMagick]::GetFilenameForNumber($i)
        $MyLabel = Convert-JtInt_To_000 -Int $i
        New-JtImageMagick_Item_Icon -FolderPath_Output $MyFolderPath_Output -Filename_Output $MyFilename_Output -Label $MyLabel -Background $MyBackground -Pointsize 1500 -X 2970 -Y 2100
    }
    
    [String]$FolderPath_Output = "C:\temp\icons\square_2100x2100"
    for ($i = 1; $i -le 150; $i++) {
        $MyFilename_Output = [JtImageMagick]::GetFilenameForNumber($i)
        $MyLabel = Convert-JtInt_To_000 -Int $i
        New-JtImageMagick_Item_Icon -FolderPath_Output $MyFolderPath_Output -Filename_Output $MyFilename_Output -Label $MyLabel -Background $MyBackground -Pointsize 1250 -X 2100 -Y 2100
    }
    
    [String]$FolderPath_Output = "c:\temp\icons\rect_2970x2100"
    for ($i = 1; $i -le 150; $i++) {
        $MyFilename_Output = [JtImageMagick]::GetFilenameForNumber($i)
        $MyLabel = Convert-JtInt_To_000 -Int $i
        New-JtImageMagick_Item_Icon -FolderPath_Output $MyFolderPath_Output -Filename_Output $MyFilename_Output -Label $MyLabel -Background $MyBackground -Pointsize 1500 -X 2970 -Y 2100
    }
}

New-JtImageJtMagickItemIcons