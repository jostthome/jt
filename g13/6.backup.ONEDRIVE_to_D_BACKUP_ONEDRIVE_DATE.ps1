using module JtIo

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"

New-JtRobocopy_Date -FolderPath_Input "%OneDrive%" -FolderPath_Output "D:\backup\OneDrive"
