using module JtIndex

Write-JtIoFile_Meta_Version -FolderPath_Output "%OneDrive%\jt"
Write-JtIoFile_Meta_Version -FolderPath_Output "%OneDrive%\jt\common"
Write-JtIoFile_Meta_Version -FolderPath_Output "D:\Seafile\al-apps\apps"

New-JtRobocopy -FolderPath_Input "%OneDrive%\jt\common" -FolderPath_Output "D:\Seafile\al-apps\apps\jt\common"
New-JtRobocopy -FolderPath_Input "%OneDrive%\jt\uni"    -FolderPath_Output "D:\Seafile\al-apps\apps\jt\uni"



