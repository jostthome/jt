using module JtIo
using module JtInf

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"


Function Test-JtInfi2 {
    [String]$MyTestPath = "D:\backup\oslo\reports\al-dek-nb-dek03.c-win10p"
    [JtInfi]$MyJtInfi = New-JtInfi -FolderPath $MyTestPath
    $MyJtInfi 

    [JtInf_AFolder]$MyJtInf = $MyJtInfi.GetJtInf_AFolder()
    [String]$MyName = $MyJtInf.GetName()
    # [Int]$IntCount = $MyJtInf.count
    [String]$MyType = $MyJtInf.GetType()
    Write-JtLog -Text "NAME: $MyName - TYPE: $MyType"
    
    [JtInf_Bitlocker]$MyJtInf = $MyJtInfi.GetJtInf_Bitlocker()
    [String]$MyName = $MyJtInf.GetName()
    # [Int]$IntCount = $MyJtInf.count
    [String]$MyType = $MyJtInf.GetType()
    Write-JtLog -Text "NAME: $MyName - TYPE: $MyType"
    
    [JtInf_Soft]$MyJtInf = $MyJtInfi.GetJtInf_Soft()
    [String]$MyName = $MyJtInf.GetName()
    # [Int]$IntCount = $MyJtInf.count
    [String]$MyType = $MyJtInf.GetType()
    Write-JtLog -Text "NAME: $MyName - TYPE: $MyType"
    
    [JtInf_Win32Bios]$MyJtInf = $MyJtInfi.GetJtInf_Win32Bios()
    [String]$MyName = $MyJtInf.GetName()
    # [Int]$IntCount = $MyJtInf.count
    [String]$MyType = $MyJtInf.GetType()
    Write-JtLog -Text "NAME: $MyName - TYPE: $MyType"
    
    [JtInf_Win32ComputerSystem]$MyJtInf = $MyJtInfi.GetJtInf_Win32ComputerSystem()
    [String]$MyName = $MyJtInf.GetName()
    # [Int]$IntCount = $MyJtInf.count
    [String]$MyType = $MyJtInf.GetType()
    Write-JtLog -Text "NAME: $MyName - TYPE: $MyType"
    
    [JtInf_Win32LogicalDisk]$MyJtInf = $MyJtInfi.GetJtInf_Win32LogicalDisk()
    [String]$MyName = $MyJtInf.GetName()
    # [Int]$IntCount = $MyJtInf.count
    [String]$MyType = $MyJtInf.GetType()
    Write-JtLog -Text "NAME: $MyName - TYPE: $MyType"
    
    [JtInf_Win32NetworkAdapter]$MyJtInf = $MyJtInfi.GetJtInf_Win32NetworkAdapter()
    [String]$MyName = $MyJtInf.GetName()
    # [Int]$IntCount = $MyJtInf.count
    [String]$MyType = $MyJtInf.GetType()
    Write-JtLog -Text "NAME: $MyName - TYPE: $MyType"
    
    [JtInf_Win32OperatingSystem]$MyJtInf = $MyJtInfi.GetJtInf_Win32OperatingSystem()
    [String]$MyName = $MyJtInf.GetName()
    # [Int]$IntCount = $MyJtInf.count
    [String]$MyType = $MyJtInf.GetType()
    Write-JtLog -Text "NAME: $MyName - TYPE: $MyType"
    
    [JtInf_Win32Processor]$MyJtInf = $MyJtInfi.GetJtInf_Win32Processor()
    [String]$MyName = $MyJtInf.GetName()
    # [Int]$IntCount = $MyJtInf.count
    [String]$MyType = $MyJtInf.GetType()
    Write-JtLog -Text "NAME: $MyName - TYPE: $MyType"
    
    [JtInf_Win32VideoController]$MyJtInf = $MyJtInfi.GetJtInf_Win32VideoController()
    [String]$MyName = $MyJtInf.GetName()
    # [Int]$IntCount = $MyJtInf.count
    [String]$MyType = $MyJtInf.GetType()
    Write-JtLog -Text "NAME: $MyName - TYPE: $MyType"
    
    
}
Test-JtInfi2


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

   
