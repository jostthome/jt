# using module .\Pools.psm1

Clear-Host

Set-StrictMode -Version latest
$ErrorActionPreference = "Stop"


[Pools]$Pools = [Pools]::new($JtConfig)
$Pools.DoPublish_Normal_Pool1()



if ($env:publish_action -eq "wakeAll") {
    $Computers.WakeAll()
    #   $Computers.CheckAll()
}

if ($env:publish_action -eq "wakeMod") {
    $Computers.wake("al-mod-pc-mod05")
    #   $Computers.CheckAll()
}


if ($env:publish_action -eq "status") {
    CheckImageStatusAll
}


if ($env:COMPUTERNAME -ne "al-its-se-oslo") {
    Write-Host "Task can only be run on al-its-se-oslo"
    Exit
}

# Black White
# Gray DarkGray
# Red DarkRed
# Blue DarkBlue
# Green DarkGreen
# Yellow DarkYellow
# Cyan DarkCyan
# Magenta DarkMagenta


