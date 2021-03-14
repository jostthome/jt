Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"


Function New-JtPublish_OneDrive_To_Sea {
    Write-JtIoFile_Meta_Version -FolderPath_Output "%OneDrive%\1.UNI\11.DMA1"

    [String]$MyFolderPath_Input = -join($env:OneDrive, "\1.UNI\11.DMA1")
    [String]$MyFolderPath_Output = "D:\Seafile\al-cad\1.DMA1\11.DMA1.mirror"
    New-JtRobocopy -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
    
    
    [String]$MyFolderPath_Input = -join($env:OneDrive, "\1.UNI\12.DOKU")
    [String]$MyFolderPath_Output = "D:\Seafile\al-cad\1.DMA1\12.DOKU.mirror"
    New-JtRobocopy -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
    
    [String]$MyFolderPathTarget_FOLDER = "D:\Seafile\al-public\SUPPORT\TIPPS_UND_TOOLS\COMPUTER_FUER_DAS_STUDIUM\DOWNLOAD.COMPUTER_FUER_DAS_STUDIUM"
    [String]$FilePath_Input = -join($env:OneDrive, "\1.UNI\12.DOKU\e01.doku.eigene_hardware\*.pdf")
    Copy-Item -Path $FilePath_Input -Destination $MyFolderPathTarget_FOLDER
    
    [String]$FilePath_Input = -join($env:OneDrive, "\1.UNI\12.DOKU\e02.doku.eigene_software\*.pdf")
    Copy-Item -Path $FilePath_Input -Destination $MyFolderPathTarget_FOLDER
    
    [String]$FilePath_Input = -join($env:OneDrive, "\1.UNI\12.DOKU\e03.doku.eigene_konfiguration\*.pdf")
    Copy-Item -Path $FilePath_Input -Destination $MyFolderPathTarget_FOLDER
    
    
}

New-JtPublish_OneDrive_To_Sea


