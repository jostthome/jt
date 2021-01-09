# [String]$PathCommonDev = -join($env:OneDrive, "\", "0.INVENTORY", "\", "common")
# [String]$PathCommonLive = "C:\apps\inventory\common"

# [String]$PathCommon = ""
# if(Test-Path $PathCommonDev) {
#     $PathCommon = $PathCommonDev
# } else {
#     $PathCommon = $PathCommonLive
# }

# $env:PSModulePath = $env:PSModulePath + "$([System.IO.Path]::PathSeparator)$PathCommon"
# Import-Module Jt -Verbose -NoClobber

# Set-PSDebug
Set-StrictMode -version latest
$ErrorActionPreference = "Stop"


New-JtClient_Clean
New-JtClient_Export 
New-JtClient_Update 
New-JtClient_Config
New-JtClient_Report
New-JtClient_Objects
New-JtClient_Errors
New-JtClient_Csvs
New-JtClient_Data
New-JtClient_Files
New-JtClient_Folders
New-JtClient_Lengths
New-JtClient_Lines
New-JtClient_Markdown
New-JtClient_Mirror
New-JtClient_Export 
New-JtMaster_Reports
New-JtMaster_Combine

