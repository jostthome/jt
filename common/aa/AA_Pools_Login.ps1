using module JtImageMagick


function New-JtCustomizeLoginImages() {
    
    Param (
        [Parameter(Mandatory = $True)]
        [String]$Path
    )

    # [String]$WorkFolder = $This.WorkFolder
    [String]$OutputFolder = $Path

    [String]$BackgroundSpezial = "orange"
    [String]$BackgroundNormal = "blue"

    [String]$MyBackgroundInventory = "black"

    $MyGeneration = "0"
    $MySystem = "win10p"
    $MyUser = "inventory"
    $MyBackground = "red"
    New-JtImageMagickItemLogin -OutputFolder $OutputFolder -Generation $MyGeneration -System $MySystem -User $MyUser -Background $MyBackground


    $MyGeneration = "g"
    $MySystem = "win10p"
    $MyUser = "pool"
    $MyBackground = $BackgroundNormal
    New-JtImageMagickItemLogin -OutputFolder $OutputFolder -Generation $MyGeneration -System $MySystem -User $MyUser -Background $MyBackground

        
    $MyGeneration = "g"
    $MySystem = "win10p"
    $MyUser = "inventory"
    $MyBackground = $MyBackgroundInventory
    New-JtImageMagickItemLogin -OutputFolder $OutputFolder -Generation $MyGeneration -System $MySystem -User $MyUser -Background $MyBackground

        
    $MyGeneration = "g"
    $MySystem = "win10p-spezial"
    $MyUser = "pool"
    $MyBackground = $BackgroundSpezial
    New-JtImageMagickItemLogin -OutputFolder $OutputFolder -Generation $MyGeneration -System $MySystem -User $MyUser -Background $MyBackground

        
    $MyGeneration = "g"
    $MySystem = "win10p-spezial"
    $MyUser = "inventory"
    $MyBackground = $MyBackgroundInventory
    New-JtImageMagickItemLogin -OutputFolder $OutputFolder -Generation $MyGeneration -System $MySystem -User $MyUser -Background $MyBackground

        
    $MyGeneration = "h"
    $MySystem = "win10p"
    $MyUser = "pool"
    $MyBackground = $BackgroundNormal
    New-JtImageMagickItemLogin -OutputFolder $OutputFolder -Generation $MyGeneration -System $MySystem -User $MyUser -Background $MyBackground

        
    $MyGeneration = "h"
    $MySystem = "win10p"
    $MyUser = "inventory"
    $MyBackground = $MyBackgroundInventory
    New-JtImageMagickItemLogin -OutputFolder $OutputFolder -Generation $MyGeneration -System $MySystem -User $MyUser -Background $MyBackground

        
    $MyGeneration = "h"
    $MySystem = "win10p-spezial"
    $MyUser = "pool"
    $MyBackground = $BackgroundSpezial
    New-JtImageMagickItemLogin -OutputFolder $OutputFolder -Generation $MyGeneration -System $MySystem -User $MyUser -Background $MyBackground

        
    $MyGeneration = "h"
    $MySystem = "win10p-spezial"
    $MyUser = "inventory"
    $MyBackground = $MyBackgroundInventory
    New-JtImageMagickItemLogin -OutputFolder $OutputFolder -Generation $MyGeneration -System $MySystem -User $MyUser -Background $MyBackground

}

New-JtCustomizeLoginImages -Path "D:\Seafile\al-apps\apps\1.SETUP\111.CUSTOMIZE\1111.POOLS" 
