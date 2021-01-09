using module JtClass
using module JtIo

class JtConfig : JtClass {

    [JtIoFolder]$JtIoFolder_Base
    [JtIoFolder]$JtIoFolder_Report
    [JtIoFolder]$JtIoFolder_Inv
    
    JtConfig() {
        $This.ClassName = "JtConfig"
        Write-JtLog -Text "START!"
        
        [String]$MyProjectPath = Get-JtBasePath

        $This.JtIoFolder_Base = [JtIoFolder]::new($MyProjectPath)
        $This.JTIoFolder_Report = New-JtIofolderReport
        $This.JTIoFolder_Inv = New-JtIofolderInv
    }

    [Boolean]DoPrintInfo() {
#        Write-Host "SHOULD BE LIKE: Get_JtIoFolder_Base   : D:\Seafile\al-apps\apps\inventory"
        Write-JtLog (-join("Get_JtIoFolder_Base   : ", $This.Get_JtIoFolder_Base().GetPath()))
        return $True
    }
    
    # --------------------------------------------------------------------------------------

    
    [JtIoFolder]Get_JtIoFolder_Base() {
        return $This.JtIoFolder_Base
    }

    [JtIoFolder]Get_JtIoFolder_Inv() {
        return $This.JtIoFolder_Inv
    }

    [JtIoFolder]Get_JtIoFolder_Report() {
        return $This.JtIoFolderReport
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