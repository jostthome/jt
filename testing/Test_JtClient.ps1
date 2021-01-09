Set-StrictMode -version latest
$ErrorActionPreference = "Stop"

New-JtInvPoster
exit
New-JtInvFolders

New-JtInvLines
exit


New-JtInvClientClean
New-JtInvClientExport 
New-JtInvClientUpdate 
New-JtInvClientConfig
New-JtInvClientReport
New-JtInvClientObjects
New-JtInvClientErrors
New-JtInvClientCsvs
New-JtInvClientExport 
New-JtInvData
New-JtInvFiles
New-JtInvFolders
New-JtInvLengths
New-JtInvLines
New-JtInvMarkdown
New-JtInvMirror
New-JtInvMiete
New-JtInvPoster

New-JtInvClientReports
New-JtInvCombine