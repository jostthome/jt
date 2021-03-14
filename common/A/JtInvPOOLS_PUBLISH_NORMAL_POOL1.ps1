# using module .\Pools.psm1

Clear-Host

Set-StrictMode -Version latest
$ErrorActionPreference = "Stop"

Function New-JtPoolsPublishPoo1Normal {
    
    [Pools]$MyPools = [Pools]::new()
    $MyPools.DoPublish_Normal_Pool1()
}
New-JtPoolsPublishPoo1Normal

