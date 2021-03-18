using module JtImageMagick
using module JtIo

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"
Function New-JtPosterPlaceholders {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][Int]$From,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][Int]$To,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][Int]$Pointsize,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][Int]$X,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][Int]$Y
    )

    [String]$Background = "grey"

    [String]$MyFunctionName = "New-JtPosterPlaceholders"

    [JtIoFolder]$MyJtIoFolder_Work = Get-JtIoFolder_Work -Name $MyFunctionName


    [String]$MyLabel = -join($X, "x", $Y, ".", $From, "to", $To)

    [String]$MyLabelJpg = "jpg.$MyLabel"
    [String]$MyLabelPdf = "pdf.$MyLabel"
    [JtIoFolder]$MyJtIoFolder_WorkJpg = $MyJtIoFolder_Work.GetJtIoFolder_Sub($MyLabelJpg)
    [JtIoFolder]$MyJtIoFolder_WorkPdf = $MyJtIoFolder_Work.GetJtIoFolder_Sub($MyLabelPdf)
    for ($i = $From; $i -le $To; $i++) {
        # for ($i = 1; $i -le 150; $i++) {
            [String]$MyFolderPath_Output = $MyJtIoFolder_WorkJpg.GetPath()
            [String]$MyFilename_Output = [JtImageMagick]::GetFilenameForNumber($i)
            $Label = Convert-JtInt_To_000 -Int $i
            New-JtImageMagick_Item_Icon -FolderPath_Output $MyFolderPath_Output -Filename_Output $MyFilename_Output -Label $Label -Background $Background -Pointsize $Pointsize -X $X -Y $Y
            
            [String]$MyFolderPath_Input = $MyFolderPath_Output
            [String]$MyFilename_Input = $MyFilename_Output
            [String]$MyFolderPath_Output = $MyJtIoFolder_WorkPdf
            New-JtImageMagick_Convert_JpgToPdf -FolderPath_Input $MyFolderPath_Input -Filename_Input $MyFilename_Input -FolderPath_Output $MyFolderPath_Output
    }

    # [String]$MyFolderPath_Output = "D:\Seafile\al-cad\9.POSTER\PLACEHOLDER\jpg.297x210.1to200"
    # for ($i = 1; $i -le 200; $i++) {
    #     # for ($i = 1; $i -le 150; $i++) {
    #     $MyFilename_Output = [JtImageMagick]::GetFilenameForNumber($i)
    #     $Label = Convert-JtInt_To_000 -Int $i
    #     New-JtImageMagick_Item_Icon -FolderPath_Output $MyFolderPath_Output -Filename_Output $MyFilename_Output -Label $Label -Background $Background -Pointsize 120 -X 297 -Y 210
    # }
}
New-JtPosterPlaceholders -From 1 -To 3 -Pointsize 130 -X 297 -Y 210
