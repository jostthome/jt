using module JtIo
using module JtCsv

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"

Get-JtInf_AFolder -FolderPath "C:\_inventory\report"
Get-JtInf_Bitlocker -FolderPath "C:\_inventory\report"
Get-JtInf_Soft -FolderPath "C:\_inventory\report"
Get-JtInf_Win32Bios -FolderPath "C:\_inventory\report"
Get-JtInf_Win32ComputerSystem -FolderPath "C:\_inventory\report"
Get-JtInf_Win32LogicalDisk -FolderPath "C:\_inventory\report"
Get-JtInf_Win32NetworkAdapter -FolderPath "C:\_inventory\report"
Get-JtInf_Win32OperatingSystem -FolderPath "C:\_inventory\report"
Get-JtInf_Win32Processor -FolderPath "C:\_inventory\report"
Get-JtInf_Win32VideoController -FolderPath "C:\_inventory\report"
Function Test-JtCsvGenerator {

    [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath "D:\backup\oslo\reports\al-its-pc-g20.c-win10p"
    New-JtCsvGenerator -FolderPath_Input $MyJtIoFolder -FolderPath_Output $MyJtIoFolder 
}
Test-JtCsvGenerator

Function Test-JtCsv {

    [String]$MyFolderPath_Input =  "d:\backup\stb"
    [String]$MyFolderPath_Output =  "C:\_inventory\out\Test-JtCsv"
    Convert-JtFolderPath_To_Csv_Filelist -FolderPath_Input $MyFolderPath_Input  -Filter "*.pdf" -Label "stb_pdf" -FolderPath_Output $MyFolderPath_Output
    
    [String]$MyFolderPath_Input =  "d:\backup\stb"
    [String]$MyFolderPath_Output =  "C:\_inventory\out\Test-JtCsv"
    Convert-JtFolderPath_To_Csv_Filelist -FolderPath_Input $MyFolderPath_Input  -Filter "*.meta" -Label "stb_meta" -FolderPath_Output $MyFolderPath_Output

}
Test-JtCsv








