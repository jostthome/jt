using module Inf_Soft


Clear-Host

Set-StrictMode -version latest
$ErrorActionPreference = "Stop"


[Inf_Soft]$Inf_Soft = [Inf_Soft]::new()

$Inf_Soft.GetFields()


