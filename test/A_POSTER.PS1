# [String]$PathCommonDev = -join($env:OneDrive, "\", "0.INVENTORY", "\", "common")
# [String]$PathCommonLive = "C:\apps\inventory\common"

# [String]$PathCommon = ""
# if(Test-Path $PathCommonDev) {
#     $PathCommon = $PathCommonDev
# } else {
#     $PathCommon = $PathCommonLive
# }

# Import-Module (-join($PathCommon, "\", "Jt", "\", "JtClient.psm1")) -Verbose

Set-StrictMode -version latest
$ErrorActionPreference = "Stop"

New-JtClient_Poster

