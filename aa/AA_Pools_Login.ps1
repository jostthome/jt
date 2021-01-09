using module JtImageMagick


function New-CustomizeLoginImages() {
    
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
    New-ImageMagickItemLogin -OutputFolder $OutputFolder -Generation $MyGeneration -System $MySystem -User $MyUser -Background $MyBackground


    $MyGeneration = "g"
    $MySystem = "win10p"
    $MyUser = "pool"
    $MyBackground = $BackgroundNormal
    New-ImageMagickItemLogin -OutputFolder $OutputFolder -Generation $MyGeneration -System $MySystem -User $MyUser -Background $MyBackground

        
    $MyGeneration = "g"
    $MySystem = "win10p"
    $MyUser = "inventory"
    $MyBackground = $MyBackgroundInventory
    New-ImageMagickItemLogin -OutputFolder $OutputFolder -Generation $MyGeneration -System $MySystem -User $MyUser -Background $MyBackground

        
    $MyGeneration = "g"
    $MySystem = "win10p-spezial"
    $MyUser = "pool"
    $MyBackground = $BackgroundSpezial
    New-ImageMagickItemLogin -OutputFolder $OutputFolder -Generation $MyGeneration -System $MySystem -User $MyUser -Background $MyBackground

        
    $MyGeneration = "g"
    $MySystem = "win10p-spezial"
    $MyUser = "inventory"
    $MyBackground = $MyBackgroundInventory
    New-ImageMagickItemLogin -OutputFolder $OutputFolder -Generation $MyGeneration -System $MySystem -User $MyUser -Background $MyBackground

        
    $MyGeneration = "h"
    $MySystem = "win10p"
    $MyUser = "pool"
    $MyBackground = $BackgroundNormal
    New-ImageMagickItemLogin -OutputFolder $OutputFolder -Generation $MyGeneration -System $MySystem -User $MyUser -Background $MyBackground

        
    $MyGeneration = "h"
    $MySystem = "win10p"
    $MyUser = "inventory"
    $MyBackground = $MyBackgroundInventory
    New-ImageMagickItemLogin -OutputFolder $OutputFolder -Generation $MyGeneration -System $MySystem -User $MyUser -Background $MyBackground

        
    $MyGeneration = "h"
    $MySystem = "win10p-spezial"
    $MyUser = "pool"
    $MyBackground = $BackgroundSpezial
    New-ImageMagickItemLogin -OutputFolder $OutputFolder -Generation $MyGeneration -System $MySystem -User $MyUser -Background $MyBackground

        
    $MyGeneration = "h"
    $MySystem = "win10p-spezial"
    $MyUser = "inventory"
    $MyBackground = $MyBackgroundInventory
    New-ImageMagickItemLogin -OutputFolder $OutputFolder -Generation $MyGeneration -System $MySystem -User $MyUser -Background $MyBackground

}

New-CustomizeLoginImages -Path "D:\Seafile\al-apps\apps\1.SETUP\111.CUSTOMIZE\1111.POOLS" 
