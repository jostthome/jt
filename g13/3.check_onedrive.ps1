Set-StrictMode -Version "2.0"
# $ErrorActionPreference = "Inquire"
$ErrorActionPreference = "Stop"

Function Test-JtOneDrive {
    Test-JtFolder -FolderPath_Input $env:OneDrive -FilePath_Output "$env:OneDrive\0.INVENTORY\01.OUTPUT\check.bat"
}

Test-JtOneDrive