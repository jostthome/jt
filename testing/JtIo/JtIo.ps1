using module JtIo

[String]$TestPath = "%OneDrive%"
[JtIoFolder]$MyFolder = New-JtIoFolder -Path $TestPath
$MyFolder.GetPath()



[String]$MyFilter = "*.folder"
[System.Collections.ArrayList]$MyFiles = $MyFolder.GetJtIoFilesWithFilter($MyFilter, $True)

[Hashtable]$Ext = New-Object Hashtable

foreach($File in $MyFiles) {
$File.GetPath()
    # $File.GetName()
    # $File.GetExtension()
    # $File.GetExtension2()    
    $Value = $File.GetExtension2()
    if(!($Ext.Contains($Value))) {
        $Ext.add(    $Value, $Value)
    }
}

Write-Host "Extensions"
$Ext.Keys


