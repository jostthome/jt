New-JtConfig

$G = New-JtIoFolderReport


$O = Get-JtXmlReportObject -JtIoFolder $G -Name "Win32_Processor"
New-JtInit_Inf_Win32Processor -JtIoFolder $G

#New-Infi
New-JtInvClientCsvs

