using module JtIo

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"


Function Test-JtIoFile_Meta {
    $MyParams = @{
        FolderPath_Input = "%temp%"
        FolderPath_Output = "%temp%"
        Prefix = [JtIo]::FilePrefix_Report
        Label = "test1234"
        Value = "hallo2b"
        Extension2 = [JtIo]::FileExtension_Meta_Report
        OnlyOne = $True
        Overwrite = $True
    }
    Write-JtIoFile_Meta @MyParams
}
Test-JtIoFile_Meta

return 

Function Test-JtConfig {

    # [JtIoFolder]$JtIoFolder = New-JtIoFolder -FolderPath "D:\backup\oslo\reports\al-dek-nb-dek09.c-win10p"
    New-JtConfig
}
Test-JtConfig




Function Test-JtIo {
    [String]$MyFolderPath_Test = "%OneDrive%"
    [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $MyFolderPath_Test 
    $MyJtIoFolder.GetPath()

    [String]$MyFilter = "*.folder"
    [System.Collections.ArrayList]$MyFiles = Get-JtChildItem -FolderPath $MyFolderPath_Test -Filter $MyFilter -Recurse

    [Hashtable]$Ext = New-Object Hashtable

    foreach ($File in $MyFiles) {
        $File.GetPath()
        # $File.GetName()
        # $File.GetExtension()
        # $File.GetExtension2()    
        $MyValue = $File.GetExtension2()
        if (!($Ext.Contains($MyValue))) {
            $Ext.add($MyValue, $MyValue)
        }
    }

    Write-Host "Extensions"
    $Ext.Keys

}

Test-JtIo

