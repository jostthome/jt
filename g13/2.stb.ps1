using module JtColRen
using module JtIo


Set-StrictMode -Version "2.0"
# $ErrorActionPreference = "Inquire"
$ErrorActionPreference = "Stop"




# D:\backup\stb\s2\MW.STE\MW.STE.IT.HARDWARE\MW.STE.IT.HARDWARE.RECHNUNG.jahr

Function Convert-JtStep_Check {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Element
    )
        
    [String]$MyFunctionName = "Convert-JtStep_Check"

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyElement = $Element
    [String]$MyFolderPath_Input_Element = "$MyFolderPath_Input\$MyElement"
    Write-JtLog -Where $MyFunctionName -Text "Checking source folder; MyFolderPath_Input_Element: $MyFolderPath_Input_Element"

    Test-JtFolder_Recurse -FolderPath_Input $MyFolderPath_Input_Element
}

Function Convert-JtStep_A {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Element
    )
    
    [String]$MyFunctionName = "Convert-JtStep_A"

    [String]$MyElement = $Element
    Write-JtLog -Where $MyFunctionName -Text "Creating FULL copy of source data with robocopy; MyElement: $MyElement"
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
        
    [String]$MyFunctionName = "Convert-JtStep_B"

    [String]$MyElement = $Element
    Write-JtLog -Where $MyFunctionName -Text "Copying only folders with template file; MyElement: $MyElement"
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
        # [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Element
    )
            
    [String]$MyFunctionName = "Convert-JtStep_C"

    [String]$MyElement = $Element
    Write-JtLog -Where $MyFunctionName -Text "Updating MD and META files; MyElement: $MyElement"
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
    
    [String]$MyFunctionName = "Convert-JtStep_D"
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
    [String]$MyElement = $Element
    Write-JtLog -Where $MyFunctionName -Text "Collecting all META files; MyElement: $MyElement"

    [String]$MyExtension = [JtIo]::FileExtension_Meta
    [String]$MyExtensionWithoutDot = $MyExtension.Replace(".", "")

    [String]$MyFolderPath_Input = "$MyFolderPath_Input\$MyElement"
    [String]$MyFolderPath_Output_Ext = -Join ($MyFolderPath_Output, "\", $MyExtensionWithoutDot, ".", $MyElement)
    
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
        
    [String]$MyFunctionName = "Convert-JtStep_E"
    [String]$MyElement = $Element
    Write-JtLog -Where $MyFunctionName -Text "Creating list from META files; MyElement: $MyElement"
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

# Function Convert-JtStep_F {

#     Param (
#         [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Element,
#         [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
#     )
    
#     [String]$MyElement = $Element

#     [String]$MyFolderPath_Work = $FolderPath_Output
#     [String]$MyFolderPath_Work_Data = "$MyFolderPath_Work\data"
#     [String]$MyFolderPath_Work_Csv = "$MyFolderPath_Work\csv"

#     [String]$MyFolderPath_Data_Element = "$MyFolderPath_Work_data\$Element"
#     [String]$MyFolderPath_Csv_Element = "$MyFolderPath_Work_csv\$MyElement"
    
#     $MyParams = @{
#         FolderPath_Input  = $MyFolderPath_Data_Element
#         FolderPath_Output = $MyFolderPath_Csv_Element 
#         Extension         = [JtIo]::FileExtension_Csv_Files
#     }
#     New-JtIoCollectFilesWithExtension @MyParams
# }

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
    

    Convert-JtStep_Check -FolderPath_Input $MyFolderPath_Source                                           -Element $MyElement
    Convert-JtStep_A -FolderPath_Input $MyFolderPath_Source    -FolderPath_Output "$MyFolderPath_Base\backup" -Element $MyElement
    Convert-JtStep_B -FolderPath_Input "$MyFolderPath_Base\backup" -FolderPath_Output "$MyFolderPath_Base\folder" -Element $MyElement
    # Convert-JtStep_C -FolderPath_Input "$MyFolderPath_Base\folder" -FolderPath_Output "$MyFolderPath_Base\meta\$MyElement" -Element $MyElement
    Convert-JtStep_C -FolderPath_Input "$MyFolderPath_Base\folder"  -Element $MyElement
    Convert-JtStep_D -FolderPath_Input "$MyFolderPath_Base\folder" -FolderPath_Output "$MyFolderPath_Base" -Element $MyElement
    Convert-JtStep_E -FolderPath_Input "$MyFolderPath_Base\meta" -FolderPath_Output "$MyFolderPath_Base\summary" -Element $MyElement
    # Convert-JtStep_F -FolderPath_Input "$MyFolderPath_Base\stb" -Element "MW.STE"
}

Function New-JtStb_all {
    
    [String]$MySource = $env:OneDrive

    [String]$MyComputername = $env:COMPUTERNAME

    Switch ($MyComputername) {
        "AL-DEK-NB-DEK05" { $MyBase = "d:\stb"; break }
        "G13-AL-PC-DELL" { $MyBase = "d:\stb"; break }
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

Function New-JtStb_Work {
    
    [String]$MySource = $env:OneDrive

    [String]$MyComputername = $env:COMPUTERNAME

    Switch ($MyComputername) {
        "AL-DEK-NB-DEK05" { $MyBase = "d:\stb.work"; break }
        "G13-AL-PC-DELL" { $MyBase = "d:\stb.work"; break }
        "AL-ITS-PC-FIO" { $MyBase = "j:\backup\stb"; break }
        Default { "This computername was not expected... - $MyComputername"; return }
    }

    $MyParams = @{
        Source = $MySource 
        Base   = $MyBase
    }

    New-JtStb @MyParams -Element "VERSICHERUNG"

    # New-JtStb @MyParams -Element "BANK"
    # New-JtStb @MyParams -Element "FAMILIE"
    # New-JtStb @MyParams -Element "GERHARD"
    # New-JtStb @MyParams -Element "IMMO"
    # New-JtStb @MyParams -Element "STEUER"
    # New-JtStb @MyParams -Element "VERSICHERUNG"
    # New-JtStb -Element "GT.STE"
    # New-JtStb -Element "JT.PRI"
    # New-JtStb -Element "GT.PRI"
}

# New-JtStb_all


function New-JtMenu {
    param (
        [string]$Title = 'Select Options'
    )
    Clear-Host
    Write-Host "================ $Title ================"
     
    Write-Host "1: Press '1' to check OneDrive."
    Write-Host "2: Press '2' for New-JtStb_All"
    Write-Host "3: Press '3' for New-JtStb_Work"
    Write-Host "Q: Press 'Q' to quit."

    Write-Host "================================"
    $MyInput = Read-Host "Please make a selection"
    Write-Host "================================"
    Write-Host

    switch ($MyInput) {
        '1' {
            Write-Host "Selected Option 1"
            Test-JtFolder_Recurse -FolderPath_Input $env:OneDrive -Label "OneDrive"
        }
        '2' {
            Write-Host "Selected Option 2"
            New-JtStb_All
        }
        '3' {
            Write-Host "Selected Option 3"
            New-JtStb_Work
        }
        '9' {
            Write-Host "Selected Option 9"
            #Add Code here            
            $MyFolderPath_Old = "D:\stb"
            $MyTimestamp = Get-JtTimestamp
            $MyFolderPath_New = -join ($MyFolderPath_Old, ".", $MyTimestamp)
            Move-Item $MyFolderPath_Old $MyFolderPath_New
        }
        'q' {

        }
        default {
            #Add CODE witch is run if the user enters a wrong number
            exit
        }
    }
}


New-JtMenu
