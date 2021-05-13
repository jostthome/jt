using module JtIo
using module JtInf

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"


Describe "Inf" {

    BeforeAll {
        [String]$MyTestPath = "D:\backup\oslo\reports\al-dek-nb-dek03.c-win10p"
        [JtInfi]$MyJtInfi = New-JtInfi -FolderPath $MyTestPath
        $MyJtInfi 
    }

    It "Should return Inf_AFolder" {
        [JtInf_AFolder]$MyJtInf = $MyJtInfi.GetJtInf_AFolder()
        $MyJtInf | Should -BeOfType JtInf_AFolder
    }
    
    It "Should return JtInf_Bitlocker" {
        [JtInf_Bitlocker]$MyJtInf = $MyJtInfi.GetJtInf_Bitlocker()
        $MyJtInf | Should -BeOfType JtInf_Bitlocker
    }
    
    It "Should return JtInf_Soft" {
        [JtInf_Soft]$MyJtInf = $MyJtInfi.GetJtInf_Soft()
        $MyJtInf | Should -BeOfType JtInf_Soft
    }

    It "Should return JtInf_Win32Bios" {
        [JtInf_Win32Bios]$MyJtInf = $MyJtInfi.GetJtInf_Win32Bios()
        $MyJtInf | Should -BeOfType JtInf_Win32Bios
    }
    
    It "Should return JtInf_Win32ComputerSystem" {
        [JtInf_Win32ComputerSystem]$MyJtInf = $MyJtInfi.GetJtInf_Win32ComputerSystem()
        $MyJtInf | Should -BeOfType JtInf_Win32ComputerSystem
    }
    
    It "Should return JtInf_Win32LogicalDisk" {
        [JtInf_Win32LogicalDisk]$MyJtInf = $MyJtInfi.GetJtInf_Win32LogicalDisk()
        $MyJtInf | Should -BeOfType JtInf_Win32LogicalDisk
    }
    
    It "Should return JtInf_Win32NetworkAdapter" {
        [JtInf_Win32NetworkAdapter]$MyJtInf = $MyJtInfi.GetJtInf_Win32NetworkAdapter()
        $MyJtInf | Should -BeOfType JtInf_Win32NetworkAdapter
    }
    
    It "Should return JtInf_Win32OperatingSystem" {
        [JtInf_Win32OperatingSystem]$MyJtInf = $MyJtInfi.GetJtInf_Win32OperatingSystem()
        $MyJtInf | Should -BeOfType JtInf_Win32OperatingSystem
    }
    
    It "Should return JtInf_Win32Processor" {
        [JtInf_Win32Processor]$MyJtInf = $MyJtInfi.GetJtInf_Win32Processor()
        $MyJtInf | Should -BeOfType JtInf_Win32Processor
    }
    
    It "Should return JtInf_Win32VideoController" {
        [JtInf_Win32VideoController]$MyJtInf = $MyJtInfi.GetJtInf_Win32VideoController()
        $MyJtInf | Should -BeOfType JtInf_Win32VideoController
    }
    
}


Function Test-JtInfi {
    # New-JtInf

    # Get-JtInf_AFolder -FolderPath "D:\backup\oslo\reports\al-dek-nb-dek03.c-win10p"
    # Get-JtInf_AFolder -FolderPath "D:\backup\oslo\reports\al-dek-nb-dek03.c-win10p"

    [String]$MyTestPath = "D:\backup\oslo\reports\al-dek-nb-dek03.c-win10p"
    [JtInfi]$MyJtInfi = New-JtInfi -FolderPath $MyTestPath

    $MyJtInfi 

    $MyJtInfi.GetJtInf_Win32Bios()
    $MyJtInfi.GetJtInf_Soft()
}

Test-JtInfi

   
