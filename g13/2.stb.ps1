using module JtColRen
using module JtIo

Set-StrictMode -Version "2.0"
# $ErrorActionPreference = "Inquire"
$ErrorActionPreference = "Stop"



# D:\backup\stb\s2\MW.STE\MW.STE.IT.HARDWARE\MW.STE.IT.HARDWARE.RECHNUNGEN.jahr

Function Convert-JtStep_Check {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Element
    )
    
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyElement = $Element

    [String]$MyFolderPath_Input_Element = "$MyFolderPath_Input\$MyElement"
    Test-JtFolder_Recurse -FolderPath_Input $MyFolderPath_Input_Element
}

Function Convert-JtStep_A {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Element
    )
        
    [String]$MyElement = $Element
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
    [String]$MyFolderPath_Input_Element = "$MyFolderPath_Input\$MyElement"
    [String]$MyFolderPath_Output_Element = "$MyFolderPath_Output\$MyElement"
        
    $MyParams = @{
        FolderPath_Input  = $MyFolderPath_Input_Element 
        FolderPath_Output = $MyFolderPath_Output_Element
    }
    New-JtRobocopy @MyParams
}

Function Convert-JtStep_B {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Element
    )
        
    [String]$MyElement = $Element
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
        
    [String]$MyFolderPath_Input_Element = -Join ($MyFolderPath_Input, "\", $MyElement)
    [String]$MyFolderPath_Output_Element = -Join ($MyFolderPath_Output, "\", $MyElement)
        
    $MyParams = @{
        FolderPath_Input  = $MyFolderPath_Input_Element
        FolderPath_Output = $MyFolderPath_Output_Element
    }
    New-JtRobocopy_Element_Extension_Folder @MyParams
}
Function Convert-JtStep_C {
        
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Element
    )
            
    [String]$MyElement = $Element
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Input_Element = -Join ($MyFolderPath_Input, "\", $MyElement)
    # [String]$MyFolderPath_Output = "c:\temp\test"
    # [String]$MyFolderPath_Output = $FolderPath_Output

    # Update-JtFolderPath_Md_And_Meta -FolderPath_Input $MyFolderPath_Input_Element -FolderPath_Output $MyFolderPath_Output
    Update-JtFolderPath_Md_And_Meta -FolderPath_Input $MyFolderPath_Input_Element
}

Function Convert-JtStep_D {
    
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Element
    )
    
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
    [String]$MyElement = $Element

    [String]$MyExtension = [JtIo]::FileExtension_Meta
    [String]$MyExtensionWithoutDot = $MyExtension.Replace(".", "")

    [String]$MyFolderPath_Input = "$MyFolderPath_Input\$MyElement"
    [String]$MyFolderPath_Output_Ext = "$MyFolderPath_Output\$MyElement\$MyExtensionWithoutDot"
    
    $MyParams = @{
        FolderPath_Input  = $MyFolderPath_Input
        FolderPath_Output = $MyFolderPath_Output_Ext 
        Extension         = $MyExtension
    }
    New-JtIoCollectFilesWithExtension @MyParams
}


Function Convert-JtStep_E {
    
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Element
    )
        
    [String]$MyElement = $Element
    [String]$MyExtension = [JtIo]::FileExtension_Meta
    [String]$MyExtensionWithoutDot = $MyExtension.Replace(".", "")

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Input_Ext = "$MyFolderPath_Input\$MyElement\$MyExtensionWithoutDot"
    [String]$MyFolderPath_Output = $FolderPath_Output
    [String]$MyFilter = -Join ("*", $MyExtension)
    
    
    [String]$MyPrj1 = "betraege"
    $MyParams = @{
        FolderPath_Input  = $MyFolderPath_Input_Ext
        FolderPath_Output = $MyFolderPath_Output
        Filter            = $MyFilter
        Label             = "$MyElement.$MyPrj1" 
    }
    Convert-JtFolderPath_To_Csv_Filelist @MyParams
    #   Start-Process -FilePath "explorer.exe" "$MyFolderPath_Work"
}



Function Convert-JtStep_F {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Element,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )
    
    [String]$MyElement = $Element

    [String]$MyFolderPath_Work = $FolderPath_Output
    [String]$MyFolderPath_Work_Data = "$MyFolderPath_Work\data"
    [String]$MyFolderPath_Work_Csv = "$MyFolderPath_Work\csv"

    [String]$MyFolderPath_Data_Element = "$MyFolderPath_Work_data\$Element"
    [String]$MyFolderPath_Csv_Element = "$MyFolderPath_Work_csv\$MyElement"
    
    $MyParams = @{
        FolderPath_Input  = $MyFolderPath_Data_Element
        FolderPath_Output = $MyFolderPath_Csv_Element 
        Extension         = [JtIo]::FileExtension_Csv_Files
    }
    New-JtIoCollectFilesWithExtension @MyParams

}

Function New-JtStb {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Source,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Base,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Element
    )

    [String]$MyElement = $Element

    [String]$MyFolderPath_Source = $Source
    [String]$MyFolderPath_Base = $Base
    New-JtIoFolder -FolderPath $MyFolderPath_Base -Force
    
    # Convert-JtStep_C -FolderPath_Input "$MyFolderPath_Base\s2"  -FolderPath_Output "$MyFolderPath_Base\meta" -Element $MyElement
    Convert-JtStep_A -FolderPath_Input $MyFolderPath_Source    -FolderPath_Output "$MyFolderPath_Base\s1" -Element $MyElement
    Convert-JtStep_B -FolderPath_Input "$MyFolderPath_Base\s1" -FolderPath_Output "$MyFolderPath_Base\s2" -Element $MyElement
    Convert-JtStep_C -FolderPath_Input "$MyFolderPath_Base\s2" -FolderPath_Output "$MyFolderPath_Base\me.$MyElement" -Element $MyElement
    Convert-JtStep_D -FolderPath_Input "$MyFolderPath_Base\s2" -FolderPath_Output "$MyFolderPath_Base\s3" -Element $MyElement
    Convert-JtStep_E -FolderPath_Input "$MyFolderPath_Base\s3" -FolderPath_Output "$MyFolderPath_Base\s4" -Element $MyElement
    # Convert-JtStep_F -FolderPath_Input "$MyFolderPath_Base\stb" -Element "MW.STE"
}

Function New-JtStb_all {
    
    [String]$MySource = $env:OneDrive

    [String]$MyComputername = $env:COMPUTERNAME

    Switch ($MyComputername) {
        "AL-DEK-NB-DEK05" { $MyBase = "d:\backup\stb"; break }
        "G13-AL-PC-DELL" { $MyBase = "d:\backup\stb"; break }
        "AL-ITS-PC-FIO" { $MyBase = "j:\backup\stb"; break }
        Default { "This computername was not expected... - $MyComputername"; return }
    }

    $MyParams = @{
        Source = $MySource 
        Base   = $MyBase
    }

    New-JtStb @MyParams -Element "BANK"
    New-JtStb @MyParams -Element "FAMILIE"
    New-JtStb @MyParams -Element "GERHARD"
    New-JtStb @MyParams -Element "IMMO"
    New-JtStb @MyParams -Element "STEUER"
    New-JtStb @MyParams -Element "VERSICHERUNG"
    # New-JtStb -Element "GT.STE"
    # New-JtStb -Element "JT.PRI"
    # New-JtStb -Element "GT.PRI"

}

New-JtStb_all


