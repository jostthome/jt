# using module .\JtConfig\JtConfig.psm1
# using module .\Pools.psm1

Clear-Host

Set-StrictMode -Version latest
$ErrorActionPreference = "Stop"

[JtConfig]$JtConfig = New-JtConfig

[Pools]$Pools = [Pools]::new($JtConfig)
$Pools.DoPublish_Normal_Pool1()

