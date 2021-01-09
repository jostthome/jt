using module JtClass
using module JtIo

class JtConfig : JtClass {

    [JtIoFolder]$JtIoFolder_Base
    
    JtConfig() {
        $This.ClassName = "JtConfig"
        Write-JtLog -Text "START!"
        
        [String]$MyProjectPath = ""
        $MyProjectPath = Get-JtBasePath

        Write-JtLog -Text ( -join ("ProjectPath:", $MyProjectPath))

        [JtIoFolder]$This.JtIoFolder_Base = [JtIoFolder]::new($MyProjectPath)
        $This.DoPrintInfo()
    }

    [Boolean]DoPrintInfo() {
        Write-Host "SHOULD BE LIKE: Get_JtIoFolder_Base   : D:\Seafile\al-apps\apps\inventory"
        Write-Host "SHOULD BE LIKE: Get_JtIoFolder_Common : c:\apps\inventory\common"
        # Write-Host "SHOULD BE LIKE: Get_JtIoFolder_Inv    : c:\_inventory"
        # Write-Host "SHOULD BE LIKE: Get_JtIoFolder_Report : c:\_inventory\report"
        
        Write-JtLog (-join("Get_JtIoFolder_Base   : ", $This.Get_JtIoFolder_Base().GetPath()))
        Write-JtLog (-join("Get_JtIoFolder_Common : ", $This.Get_JtIoFolder_Common().GetPath()))
        # Write-JtLog (-join("Get_JtIoFolder_Inv    : ", $This.Get_JtIoFolder_Inv().GetPath()))
        # Write-JtLog (-join("Get_JtIoFolder_Report : ", $This.Get_JtIoFolder_Report().GetPath()))

        return $True
    }
    
    # --------------------------------------------------------------------------------------

    
    [JtIoFolder]Get_JtIoFolder_Base() {
        return $This.JtIoFolder_Base
    }
    
    [JtIoFolder]Get_JtIoFolder_Common() {
        [JtIoFolder]$Result = $null
        [JtIoFolder]$Folder_C_Apps_Inventory = [JtIoFolder]::new("c:\apps\inventory")
        [JtIoFolder]$Folder_C_Apps_Inventory_Common = $Folder_C_Apps_Inventory.GetSubfolder("common")
        $Result = $Folder_C_Apps_Inventory_Common
        return $Result
    }

    [JtIoFolder]Get_JtIoFolder_Inv() {
        return New-JtIoFolderInv
    }

    [JtIoFolder]Get_JtIoFolder_Report() {
        return New-JtIoFolderReport
    }
    
}

Function New-JtConfig {

    [JtConfig]::new()
}


function Get-JtScriptDirectory {
    Split-Path -parent $PSCommandPath
}

function Get-JtBasePath {
    return Get-Location
}