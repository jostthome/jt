Set-StrictMode -version latest
$ErrorActionPreference = "Stop"


New-JtInvClientClean
New-JtInvClientConfig
New-JtInvClientReport
New-JtInvClientObjects
New-JtInvClientErrors
New-JtInvClientCsvs
New-JtInvData
New-JtInvFiles
New-JtInvFolder
New-JtInvLengths
New-JtInvLines
New-JtInvMd
New-JtInvMirror
New-JtInvReports
New-JtInvCombine

