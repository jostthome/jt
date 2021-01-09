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

Set-StrictMode -version latest
$ErrorActionPreference = "Stop"

New-JtClient_Mirror




