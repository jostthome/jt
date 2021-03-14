using module JtImageMagick

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"

Function Update-JtPoolsBackground() {
    
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    $MyAlGenerations = ("g", "h")
    $MyAlUsers = ("pool", "inventory")
    $MyAlSystems = ("win10p", "win10p-spezial")

    foreach ($Gen in $MyAlGenerations) {
        [String]$MyGeneration = $Gen
        foreach ($System in $MyAlSystems) {
            [String]$MySystem = $System
            foreach ($User in $MyAlUsers) {
                [String]$MyUser = $User
        
                $MyParams = @{
                    FolderPath_Input  = $FolderPath_Input
                    FolderPath_Output = $FolderPath_Output
                    Generation        = $MyGeneration
                    System            = $MySystem
                    User              = $MyUser
                }
                New-JtImageMagick_Item_Background @MyParams
            }
        }
    }
}   
    
# New-JtCustomizeBackgroundImages -FolderPath "D:\Seafile\al-apps\apps\1.SETUP\111.CUSTOMIZE\1111.POOLS" 
Update-JtPoolsBackground -FolderPath_Input "C:\apps\jt\uni\template\background" -FolderPath_Output "c:\_archland" 
    


