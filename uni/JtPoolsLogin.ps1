using module JtImageMagick


Function Update-JtPoolsIcons {
    
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath
    )

    # [String]$WorkFolder = $This.WorkFolder
    [String]$MyFolderPath_Output = $FolderPath

    [String]$MyBackgroundSpezial = "orange"
    [String]$MyBackgroundNormal = "blue"

    [String]$MyBackgroundInventory = "red"

    $MyAlGenerations = ("g", "h")
    $MyAlUsers = ("pool", "inventory")

    $MyParams = @{
        FolderPath_Output = $MyFolderPath_Output
        Generation        = "0"
        System            = "win10p"
        User              = "inventory"
        Background        = $MyBackgroundInventory
    }
    New-JtImageMagick_Item_Login @MyParams


    foreach ($Gen in $MyAlGenerations) {
        [String]$MyGeneration = $Gen
        foreach ($User in $MyAlUsers) {
            [String]$MyUser = $User

            $MyParams = @{
                FolderPath_Output = $MyFolderPath_Output
                Generation = $MyGeneration
                System     = "win10p"
                User       = $MyUser
                Background = $MyBackgroundNormal
            }
            New-JtImageMagick_Item_Login @MyParams

            $MyParams = @{
                FolderPath_Output = $MyFolderPath_Output
                Generation = $MyGeneration
                System     = "win10p-spezial"
                User       = $MyUser
                Background = $MyBackgroundSpezial
            }
            New-JtImageMagick_Item_Login @MyParams
        }     
    }
}

Update-JtPoolsIcons -FolderPath "C:\_archland" 
#Update-JtPoolsIcons -FolderPath "D:\Seafile\al-apps\apps\1.SETUP\111.CUSTOMIZE\1111.POOLS" 
