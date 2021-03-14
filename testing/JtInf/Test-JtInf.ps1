using module JtIo
using module JtInf

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"
Function Test-JtInf {
    # New-JtInf

    # Get-JtInf_AFolder
    # Get-JtInf_AFolder -FolderPath "D:\backup\oslo\reports\al-dek-nb-dek03.c-win10p"

    Get-JtInf_Win32LogicalDisk -FolderPath "c:\_inventory\report"

    # Get-JtInf_Soft
    # Get-JtInf_Soft -FolderPath "D:\backup\oslo\reports\al-dek-nb-dek03.c-win10p"
}

Test-JtInf


