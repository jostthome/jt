using module JtInv

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"

Function Test-JtInvClient {

    # New-JtInvClientTimestamp -Label "test2"
    New-JtInvClient

}
Test-JtInvClient

Function Test-JtInvClient2 {

    #    New-JtInvClientClean
    New-JtInvClientErrors
    New-JtInvClientExport 
    New-JtInvClientConfig
    New-JtInvClientReport
    New-JtInvClientObjects
    New-JtInvClientCsvs
    New-JtInvClientExport 
    New-JtInvData
    New-JtInvFiles
    New-JtInvFolder
    New-JtInvLengths
    New-JtInvLines
    #New-JtInvMd
    New-JtInvMirror
    New-JtInvPoster

    New-JtInvReportsUpdate
    New-JtInvReportsCombine
}
Test-JtInvClient2



