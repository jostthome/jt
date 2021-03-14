using module jt

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"

Get-JtVersion

.\Jt\Test-Jt.ps1
.\JtColRen\Test-JtColRen.ps1
.\JtCsv\Test-JtCsv.ps1
.\JtFilename\Test-JtFilename.ps1
.\JtFolder\Test-JtFolder.ps1
.\JtImageMagick\Test-JtImageMagick.ps1
.\JtIndex\Test-JtIndex.ps1
.\JtInf\Test-JtInf.ps1
.\JtInfi\Test-JtInfi.ps1
.\JtInvClient\Test-JtInvClient.ps1
.\JtInvData\Test-JtInvData.ps1
.\JtInvFiles\Test-JtInvFiles.ps1
.\JtInvFolder\Test-JtInvFolder.ps1
.\JtInvLengths\Test-JtInvLengths.ps1
.\JtInvLines\Test-JtInvLines.ps1
.\JtInvMd\Test-JtInvMd.ps1
.\JtInvPoster\Test-JtInvPoster.ps1
.\JtInvReportsCombine\Test-JtInvReportsCombine.ps1
.\JtInvReportsUpdate\Test-JtInvReportsUpdate.ps1
.\JtIo\Test-JtIo.ps1
.\JtRep\Test-JtRep.ps1
.\JtSnapshot\Test-JtSnapshot.ps1
.\JtTbl\Test-JtTbl.ps1

