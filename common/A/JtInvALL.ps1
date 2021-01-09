Set-StrictMode -version latest
$ErrorActionPreference = "Stop"


New-JtInvClientClean
New-JtInvClientUpdate 
New-JtInvClientConfig
New-JtInvClientReport
New-JtInvClientObjects
New-JtInvClientErrors
New-JtInvClientCsvs
New-JtInvData
New-JtInvFiles
New-JtInvFolders
New-JtInvLengths
New-JtInvLines
New-JtInvMarkdown
New-JtInvMirror
New-JtInvReports
New-JtInvCombine

