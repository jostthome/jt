Set-StrictMode -Version "2.0"
# $ErrorActionPreference = "Inquire"
$ErrorActionPreference = "Stop"

Function Test-JtOneDrive {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath
    ) 
    [String]$MyFolderPath = $FolderPath

    [String]$MyFilePath_Output = "$MyFolderPath\check.$env:COMPUTERNAME.bat"
    if(Test-JtIoFilePath $MyFilePath_Output) {
        Remove-Item -LiteralPath $MyFilePath_Output
    }
    Test-JtFolder -FolderPath_Input $MyFolderPath -FilePath_Output $MyFilePath_Output
}

Test-JtOneDrive -FolderPath "D:\Seafile\al-it"
Test-JtOneDrive -FolderPath "$env:OneDrive"

