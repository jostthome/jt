using module JtImageMagick

function New-JtCustomizeBackgroundImages() {
    
    Param (
        [Parameter(Mandatory = $True)]
        [String]$Path
    )
    

    # if NOT exist "$WorkFolder" goto :$WorkFolder_existiert_nicht
            
    # $MyYear=%date:~6,4%
    # $MyMonth=%date:~3,2%
    # $MyDay=%date:~0,2%
    #  ... missing

    [String]$MyOutputFolder = $Path

    [String]$MyGeneration = "g"
    [String]$MySystem = "win10p"
    [String]$MyUser = "inventory"
    New-ImageMagickItemBackground -OutputFolder $MyOutputFolder -Generation $MyGeneration -System $MySystem -User $MyUser 

    $MyGeneration = "g"
    $MySystem = "win10p"
    $MyUser = "pool"
    New-ImageMagickItemBackground -OutputFolder $MyOutputFolder -Generation $MyGeneration -System $MySystem -User $MyUser 
        
    $MyGeneration = "g"
    $MySystem = "win10p-spezial"
    $MyUser = "inventory"
    New-ImageMagickItemBackground -OutputFolder $MyOutputFolder -Generation $MyGeneration -System $MySystem -User $MyUser 
        
    $MyGeneration = "g"
    $MySystem = "win10p-spezial"
    $MyUser = "pool"
    New-ImageMagickItemBackground -OutputFolder $MyOutputFolder -Generation $MyGeneration -System $MySystem -User $MyUser 
        
    $MyGeneration = "h"
    $MySystem = "win10p"
    $MyUser = "inventory"
    New-ImageMagickItemBackground -OutputFolder $MyOutputFolder -Generation $MyGeneration -System $MySystem -User $MyUser 
        
    $MyGeneration = "h"
    $MySystem = "win10p"
    $MyUser = "pool"
    New-ImageMagickItemBackground -OutputFolder $MyOutputFolder -Generation $MyGeneration -System $MySystem -User $MyUser 
        
    $MyGeneration = "h"
    $MySystem = "win10p-spezial"
    $MyUser = "inventory"
    New-ImageMagickItemBackground -OutputFolder $MyOutputFolder -Generation $MyGeneration -System $MySystem -User $MyUser 
        
    $MyGeneration = "h"
    $MySystem = "win10p-spezial"
    $MyUser = "pool"
    New-ImageMagickItemBackground -OutputFolder $MyOutputFolder -Generation $MyGeneration -System $MySystem -User $MyUser 
}


New-JtCustomizeBackgroundImages -Path "D:\Seafile\al-apps\apps\1.SETUP\111.CUSTOMIZE\1111.POOLS" 



