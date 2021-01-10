using module JtClass
using module JtTbl
using module JtIo

class ImageMagick : JtClass {
    
    [JtTblRow]$JtTblRow = $Null
    [String]$ConvertExe = "c:\apps\tools\imageMagick\convert.exe"
    [String]$CompositeExe = "c:\apps\tools\imageMagick\composite.exe"
    [String]$InputFolder = ""
    [String]$OutputFolder = ""
    [String]$InputFileName = ""
    [String]$OutputFileName = ""
    
    ImageMagick([String]$MyInputFolder, [String]$MyInputFilename, [String]$MyOutputFolder, [String]$MyOutputFilename) {
        $This.ClassName = "ImageMagick"
        $This.JtTblRow = New-JtTblRow
        $This.InputFolder = $MyInputFolder
        $This.OutputFolder = $MyOutputFolder

        if($MyInputFolder) {
            if(!(Test-Path -path $MyInputFolder)) {
                Throw "Path does not exist MyInputFolder: $MyInputFolder"
            }
        }
        
        
        if($MyOutputFolder) {
        if(!(Test-Path -path $MyOutputFolder)) {
            Throw "Path does not exist MyOutputFolder: $MyOutputFolder"
        }
        }

        $This.InputFilename = $MyInputFilename
        $This.OutputFilename = $MyOutputFilename
    }

    static [String]GetTwoDigitsForNumber([Int16]$I) {
        [Int16]$Thousand = 1000 + $I
        [String]$ThreeDigits = -join("", $Thousand )
        $ThreeDigits = [String]$ThreeDigits.SubString(2,2)
        return $ThreeDigits
    }

    static [String]GetThreeDigitsForNumber([Int16]$I) {
        [Int16]$Thousand = 1000 + $I
        [String]$ThreeDigits = -join("", $Thousand )
        $ThreeDigits = [String]$ThreeDigits.SubString(1,3)
        return $ThreeDigits
    }

    static [String]GetFilenameForNumber([Int16]$I) {
        [Int16]$Thousand = 1000 + $I
        [String]$ThreeDigits = -join("", $Thousand )
        $ThreeDigits = [String]$ThreeDigits.SubString(1,3)
        $Filename = -join("img", $ThreeDigits, ".jpg")
        return $Filename
    }

    AddParameter([String]$Parameter, [String]$Value) {
        # return $This.JtTableRow.AddField($Parameter, $Value)
        $This.Params = -join ($This.Params, " ", "-", $Parameter, " ", $Value)
    }

    AddParameterSpecial([String]$Parameter, [String]$Value) {
        # return $This.JtTableRow.AddField($Parameter, $Value)
        $This.Params = -join ($This.Params, " ", $Parameter, ":", """", $Value, """")
    }
    
    SetFont([String]$Value) {
        # "-font Arial"
        $This.AddParameter("font", $Value)
    }
        
    SetFill([String]$Value) {
        # "-fill white"
        $This.AddParameter("fill", $Value)
    }
        
    SetGravity([String]$Value) {
        # "-gravity NorthWest"
        $This.AddParameter("gravity", $Value)
    }
            
    SetLabel([String]$Value) {
        # "-fill white"
        $This.AddParameterSpecial("label", $Value)
    }

    SetPointsize([String]$Value) {
        # "-pointsize 20"
        $This.AddParameter("pointsize", $Value)
    }

    SetSize([Int16]$X, [Int16]$Y) {
        # -size ", $MyX1, "x", $MyY1

        [String]$Value = -join ($X, "x", $Y)
        $This.AddParameter("size", $Value)
    }
    

    [String]GetParams() {
        return $This.Params
    }

}

class ImageMagickComposite : ImageMagick {
    
    [String]$Params = ""
    [String]$Output = ""
    [String]$Source2Folder = ""
    [String]$Source2Filename = ""
    
    ImageMagickComposite([String]$MyInputFolder, [String]$MyInputFilename,  [String]$MySource2Folder, [String]$MySource2Filename, [String]$MyOutputFolder, [String]$MyOutputFilename) : Base ([String]$MyInputFolder, [String]$MyInputFilename, [String]$MyOutputFolder, [String]$MyOutputFilename) {
        $This.ClassName = "ImageMagickComposite"
        $This.Source2Folder = $MySource2Folder
        $This.Source2Filename = $MySource2Filename
    }
    
    [Boolean]DoWrite() {

        # [String]$Args1 = -Join (" -crop ", $MyX1, "x", $MyY1, "+0+0 -background white ", $Source, " ", $Target )
        
        [String]$FilePathInput1 = -join ($This.InputFolder, "\", $This.InputFileName)
        [String]$FilePathInput2 = -join ($This.Source2Folder, "\", $This.Source2Filename)
        [String]$OutputFilePath = -join ($This.OutputFolder, "\", $This.OutputFileName)
        
        [String]$ArgumentList = -join ($This.GetParams(), " ", $FilePathInput1, " ", $FilePathInput2, " ", $OutputFilePath)
        
        Write-JtLog -Text ($ArgumentList)
        Write-JtIo -Text ( -join ("ImageMagick composite: ", $OutputFilePath))
        Start-Process  -FilePath $This.CompositeExe  -ArgumentList $ArgumentList -NoNewWindow  -Wait
        return $True
    }
}

function New-ImageMagickComposite {

    param (
        [Parameter()]
        [String]$InputFolder, 
        [Parameter()]
        [String]$InputFilename,
        [Parameter()]
        [String]$Source2Folder,
        [Parameter()]
        [String]$Source2Filename,
        [Parameter()]
        [String]$OutputFolder, 
        [Parameter()]
        [String]$OutputFilename
    )

    [ImageMagickComposite]::new($InputFolder, $InputFilename, $OutputFolder, $OutputFilename, $Source2Folder, $Source2Filename)
}


class ImageMagickConvert : ImageMagick {
    
    [String]$Params = ""
    
    ImageMagickConvert([String]$MyInputFolder, [String]$MyInputFilename, [String]$MyOutputFolder, [String]$MyOutputFilename) : Base ([String]$MyInputFolder, [String]$MyInputFilename, [String]$MyOutputFolder, [String]$MyOutputFilename) {
        $This.ClassName = "ImageMagickConvert"
    }

    SetBackground([String]$Value) {
        $This.AddParameter("background", $Value)
    }

    SetColorspace([String]$Value) {
        # -colorspace rgb 
        $This.AddParameter("colorspace", $Value)
    }
    
    [Boolean]SetCrop([Int16]$X, [Int16]$Y) {
        # -crop ", $MyX1, "x", $MyY1

        [String]$Value = -join ($X, "x", $Y, "+0+0")
        return $This.AddParameter("crop", $Value)
    }

    [Boolean]SetDepth([int16]$Number) {
        # -depth 8 
        [String]$Value = -join ("", $Number)
        return $This.AddParameter("depth", $Value)
    }
    
    [Boolean]SetDensity([Int16]$Number) {
        # -density 300 
        [String]$Value = -join ("", $Number)
        return $This.AddParameter("density", $Value)
    }

    [Boolean]SetExtent([Int16]$X, [Int16]$Y) {
        # -extent ", $MyX1, "x", $MyY1

        [String]$Value = -join ($X, "x", $Y)
        return $This.AddParameter("extent", $Value)
    }

    [Boolean]SetResize([Int16]$X, [Int16]$Y) {
        # -resize ", $MyX1, "x", $MyY1

        [String]$Value = -join ($X, "x", $Y, "+0+0")
        return $This.AddParameter("resize", $Value)
    }

    [Boolean]DoWrite() {
        # [String]$Args1 = -Join (" -crop ", $MyX1, "x", $MyY1, "+0+0 -background white ", $Source, " ", $Target )

        [String]$InputFilePath = ""
        if ($This.InputFolder.Length -gt 0) {
            [String]$InputFilePath = -join ($This.InputFolder, "\", $This.InputFileName)
        }
        else {
            [String]$InputFilePath = ""
        }
        [String]$OutputFilePath = -join ($This.OutputFolder, "\", $This.OutputFileName)
        [String]$ArgumentList = -join ($This.GetParams(), " ", $InputFilePath, "  ", $OutputFilePath)
        
        
        Write-JtLog -Text ($ArgumentList)
        Write-JtIo -Text ( -join ("ImageMagick convert: ", $OutputFilePath))
        Start-Process  -FilePath $This.ConvertExe  -ArgumentList $ArgumentList -NoNewWindow  -Wait
        return $True
    }
}

function New-ImageMagickConvert {

    param(
        [Parameter(Mandatory = $false)]
        [String]$InputFolder,
        [Parameter(Mandatory = $false)]
        [String]$InputFilename,
        [Parameter(Mandatory = $true)]
        [String]$OutputFolder,
        [Parameter(Mandatory = $true)]
        [String]$OutputFilename
    )

    [ImageMagickConvert]::new($InputFolder, $InputFilename, $OutputFolder, $OutputFilename)
}

class ImageMagickItem : JtClass {

    ImageMagickItem() {
        $This.ClassName = "ImageMagickItem"
    }

    [Boolean]DoWrite() {
        Throw "Should be overwrittten..."

        return $False
    }
}

class ImageMagickItemBackground : ImageMagickItem {

    [String]$Generation = $Null
    [String]$System = $Null
    [String]$User = $Null
    [String]$OutputFolder = $Null
    [String]$TemplateFolder
    
    ImageMagickItemBackground([String]$MyOutputFolder, [String]$MyGeneration, [String]$MySystem, [String]$MyUser) : Base() {
        $This.ClassName = "ImageMagickItemBackground"
        $This.OutputFolder = -join ($MyOutputfolder, "\", "BACKGROUND")
        New-JtIoFolder -Path $This.OutputFolder -Force $True
        $This.TemplateFolder = -join ($MyOutputfolder, "\", "TEMPLATE")
        
        $This.System = $MySystem
        $This.User = $MyUser
        $This.Generation = $MyGeneration
    }

        
    [String]DoWriteImageDate() {
        [String]$MyOutputFolder = -join ($This.OutputFolder)
        
        New-JtIoFolder -Path $MyOutputFolder -Force $True
        
        [String]$MyDateFilename = -join ("_", $This.Generation, ".", $This.System, ".", $This.User, ".", "date.jpg")
        [String]$MyOutputFilename = $MyDateFilename
        
        [ImageMagickConvert]$ImageMagickConvert = New-ImageMagickConvert  -OutputFolder $MyOutputFolder  -OutputFilename $MyOutputFilename
        $ImageMagickConvert.SetSize(1500, 30)
        $ImageMagickConvert.SetFont("Arial")
        $ImageMagickConvert.SetGravity("NorthWest")
        $ImageMagickConvert.SetPointsize(20)
        $ImageMagickConvert.SetBackground("black")
        $ImageMagickConvert.SetFill("white")
        
        $D = Get-Date
        $MyLabel = -join ("             System: ", $This.System, "     User: ", $This.User, "     Version: ", $D.toString("yyyy-MM-dd"))
        $ImageMagickConvert.SetLabel($MyLabel)
        $ImageMagickConvert.DoWrite()
        
        return $MyOutputFilename
    }
    
    [String]DoWriteImageDisclaimer() {
        [String]$MyFilenameDisclaimer = -join ("_", $This.Generation, ".", $This.System, ".", $This.User, ".", "disclaimer.jpg")
        [String]$MyOutputFolder = -join ($This.OutputFolder)
        
        [String]$MyOutputFilename = $MyFilenameDisclaimer
        [ImageMagickConvert]$ImageMagickConvert = New-ImageMagickConvert  -OutputFolder $MyOutputFolder -OutputFilename $MyOutputFilename
        $ImageMagickConvert.SetSize(1500, 30)
        $ImageMagickConvert.SetFont("Arial")
        $ImageMagickConvert.SetGravity("NorthEast")
        $ImageMagickConvert.SetPointsize(20)
        $ImageMagickConvert.SetBackground("black")
        $ImageMagickConvert.SetFill("white")

        [String]$MyLabel = ""
        if ($This.System -eq "win10p") {
            $MyLabel = "Normales System" 
        }
        else {
            $MyLabel = "Bitte Computer neu starten, um auf ALLE Anwendungen Zugriff zu haben..." 
        }
        $ImageMagickConvert.SetLabel($MyLabel)
        $ImageMagickConvert.DoWrite()
        return $MyOutputFilename
    }
    

    [String]DoWriteImageTitleLeft([String]$Filename, [String]$Folder2, [String]$File2) {
        [String]$MyOutputFolder = -join ($This.OutputFolder)
        [String]$MyOutputFilename = -join ("_", $This.Generation, ".", $This.System, ".", $This.User, ".", "title.jpg")

        [ImageMagickComposite]$ImageMagickComposite = New-ImageMagickComposite -InputFolder $MyOutputFolder -InputFileName $Filename -OutputFolder $MyOutputFolder -OutputFilename $MyOutputFilename -Source2Folder $Folder2 -Source2Filename $File2
        $ImageMagickComposite.SetGravity("NorthWest")
        $ImageMagickComposite.DoWrite()
        return $MyOutputFilename
    }

    [String]DoWriteImageTitleRight([String]$Filename, [String]$Folder2, [String]$File2) {
        [String]$MyOutputFolder = -join ($This.OutputFolder)
        [String]$MyOutputFilename = -join ($This.Generation, ".", $This.System, ".", $This.User, ".", "background.jpg")

        [ImageMagickComposite]$ImageMagickComposite = New-ImageMagickComposite -InputFolder $MyOutputFolder -InputFileName $Filename -OutputFolder $MyOutputFolder -OutputFilename $MyOutputFilename -Source2Folder $Folder2 -Source2Filename $File2
        $ImageMagickComposite.SetGravity("NorthEast")
        $ImageMagickComposite.DoWrite()
        return $MyOutputFilename
    }
    
    
    [Boolean]DoWrite() {
        [String]$FilenameDate = $This.DoWriteImageDate()
        [String]$FilenameDisclaimer = $This.DoWriteImageDisclaimer()
        
        [String]$FilenameEmpty = -join ($This.Generation, ".", $This.System, ".", $This.User, ".jpg")
        [String]$FilenameTitleLeft = $This.DoWriteImageTitleLeft($FilenameDate, $This.TemplateFolder, $FilenameEmpty)
        [String]$FilenameTitleRight = $This.DoWriteImageTitleRight($FilenameDisclaimer, $This.OutputFolder, $FilenameTitleLeft)
       
        return $True
    }
}

function New-ImageMagickItemBackground {
    
    param (
        [Parameter(Mandatory = $true)]
        [String]$OutputFolder, 
        [Parameter(Mandatory = $true)]
        [String]$Generation, 
        [Parameter(Mandatory = $true)]
        [String]$System, 
        [Parameter(Mandatory = $true)]
        [String]$User
    )

    [ImageMagickItemBackground]$ImageMagickItemBackground = [ImageMagickItemBackground]::new($OutputFolder, $Generation, $System, $User)
    $ImageMagickItemBackground.DoWrite()

}


function New-ImageMagickItemIcon {

    param (
        [Parameter(Mandatory = $true)]
        [String]$OutputFolder, 
        [Parameter(Mandatory = $true)]
        [String]$OutputFilename, 
        [Parameter(Mandatory = $true)]
        [Int16]$Size,
        [Parameter(Mandatory = $true)]
        [Int16]$X,
        [Parameter(Mandatory = $true)]
        [Int16]$Y,
        [Parameter(Mandatory = $true)]
        [String]$Label,
        [Parameter(Mandatory = $false)]
        [String]$Background
    )

    New-JtIoFolder -Path $OutputFolder -Force $True

    [ImageMagickConvert]$ImageMagickConvert = New-ImageMagickConvert -OutputFolder $OutputFolder -OutputFilename $OutputFilename
    $ImageMagickConvert.SetFont("Arial")
    $ImageMagickConvert.SetSize($X, $Y)
    $ImageMagickConvert.SetGravity("Center")
        
    # Pointsize??
    $ImageMagickConvert.SetPointsize($Size)
    if ($Null -eq $Background) {
        $Background = "red"
    }
    $ImageMagickConvert.SetBackground($Background)
    $ImageMagickConvert.SetFill("white")

    $ImageMagickConvert.SetLabel($Label)

    $ImageMagickConvert.DoWrite()
    return $False
}


function New-JtImageMagickItemLogin {

    param (
        [Parameter()]
        [String]$OutputFolder, 
        [Parameter()]
        [String]$Generation, 
        [Parameter()]
        [String]$System, 
        [Parameter()]
        [String]$User,
        [Parameter()]
        [String]$Background
    )
    [String]$MyOutputFolder = -join ($OutputFolder, "\", "LOGIN")

    if(!(Test-Path -Path $MyOutputFolder)) {
        Throw "Path does not exist: $MyOutputFolder"
    }

    New-JtIoFolder -Path $MyOutputFolder -Force $True

    [String]$Filename = -join ($Generation, ".", $System, ".", $User, ".png")
    [ImageMagickConvert]$ImageMagickConvert = New-ImageMagickConvert -OutputFolder $MyOutputFolder -OutputFilename $Filename
    $ImageMagickConvert.SetFont("Arial")
    $ImageMagickConvert.SetSize(250, 250)
    $ImageMagickConvert.SetGravity("Center")
        
    # Pointsize??
    $ImageMagickConvert.SetPointsize(65)
    $ImageMagickConvert.SetBackground($Background)
    $ImageMagickConvert.SetFill("white")

    [String]$Classification = ""
    if ($System -eq "win10p") {
        $Classification = "normal" 
    }
    else {
        $Classification = "spezial" 
    }

    [String]$Label = ""
    if ($User -eq "pool") {
        $Label = -join ($User, "\n", $Classification, "\n", $Generation) 
    }
    else {
        $D = Get-Date
        $Label = -join ($D.toString("yyyy"), "\n", $D.toString("MM"), "\n", $D.toString("dd"))
    }
    $ImageMagickConvert.SetLabel($Label)

    $ImageMagickConvert.DoWrite()
    return $False
}

function New-ImageMagickItemPdf {

    param (
        [Parameter(Mandatory = $True)]
        [String]$InputFolder, 
        [Parameter(Mandatory = $True)]
        [String]$InputFilename,
        [Parameter(Mandatory = $True)]
        [String]$OutputFolder

    )

    [String]$MyInputFilename = -join ($InputFilename, "[0]")
    [String]$OutputFilename = $Filename.Replace(".pdf", ".jpg")

    [ImageMagickConvert]$ImageMagickConvert = New-ImageMagickConvert -InputFolder $Inputfolder -InputFilename $MyInputFilename -OutputFolder $OutputFolder -OutputFilename $OutputFilename
    Write-JtLog ( -join ("... New-ImageMagickItemPdf - InputFolder:", $InputFolder, " InputFilename:", $MyInputFilename))
        
    $ImageMagickConvert.SetColorspace("rgb")
    $ImageMagickConvert.SetDepth(8)
    $ImageMagickConvert.SetDensity(300)
    $ImageMagickConvert.DoWrite()
}

function New-ImageMagickItemCover {

    param (
        [Parameter(Mandatory = $True)]
        [String]$InputFolder, 
        [Parameter(Mandatory = $True)]
        [String]$FolderWork,
        [Parameter(Mandatory = $True)]
        [String]$OutputFilename
    )

    New-JtIoFolder -Path $FolderWork -Force $True
    
    [String]$FolderWorkA = -join ($FolderWork, "\", "a")
    New-JtIoFolder -Path $FolderWorkA -Force $True
    
    [String]$FolderWorkB = -join ($FolderWork, "\", "b")
    New-JtIoFolder -Path $FolderWorkB -Force $True
    
    [String]$FolderWorkC = -join ($FolderWork, "\", "c")
    New-JtIoFolder -Path $FolderWorkC -Force $True

    New-ImageMagickItemPdf -InputFolder $Inputfolder -OutputFolder $FolderWorkA -OutputFilename $OutputFilename

    New-ImageMagickItemResize -InputFolder $FolderWorkA -OutputFolder $FolderWorkB -OutputFilename $OutputFilename -X1 1920 -Y1 1080
    
    New-ImageMagickItemResize -InputFolder $FolderWorkB -OutputFolder $FolderWorkC -OutputFilename $OutputFilename -X1 384 -Y1 216
}

function New-ImageMagickItemResize {

    param (
        [Parameter(Mandatory = $True)]
        [String]$InputFolder, 
        [Parameter(Mandatory = $True)]
        [String]$Filename,
        [Parameter(Mandatory = $True)]
        [String]$OutputFolder, 
        [Parameter(Mandatory = $True)]
        [Int16]$X1,
        [Parameter(Mandatory = $True)]
        [Int16]$Y1
    )

    [String]$InputFilename = $Filename
    [String]$OutputFilename = $Filename
    [ImageMagickConvert]$ImageMagickConvert = New-ImageMagickConvert -InputFolder $InputFolder -InputFilename $InputFilename -OutputFolder $OutputFolder -OutputFilename $OutputFilename
    $ImageMagickConvert.SetResize($X1, $Y1)
    $ImageMagickConvert.SetExtent($X1, $Y1)
    $ImageMagickConvert.DoWrite()
    return $False
}

class JtImageTool : JtClass {

    [String]$SourceFolder = $Null
    [String]$FolderWork = $Null

    JtImageTool([String]$MyFolderSource, [String]$MyFolderWork) {
        $This.ClassName = "JtImageTool"
        Write-JtLog -Text ("JtImageTool")

        $This.SourceFolder = $MyFolderSource
        $Msg = -join ("FolderSource:", "'", $This.SourceFolder, "'")
        Write-JtLog -Text ($Msg)
        
        $This.FolderWork = $MyFolderWork
        $Msg = -join ("FolderWork:", "'", $This.FolderWork, "'")
        Write-JtLog -Text ($Msg)
    }

    [Boolean]DoCropJpgs([String]$MySourceSubJpg, [String]$MyTagetSubJpg, [int16]$MyX1, [int16]$MyY1) {
        Write-JtLog -Text ("DoCropJpgs")

        $Msg = -join ("Dimensions: ", $MyY1, " x ", $MyX1)
        Write-JtLog -Text ($Msg)
    
        [String]$SourceJpg = $This.DoUseWorkSub($MySourceSubJpg)
        [String]$TargetJpg = $This.DoUseWorkSub($MyTagetSubJpg)
        
        $Files = Get-ChildItem -Path $SourceJpg
        
        foreach ($File in $Files) {
            # [String]$Source = $File.Fullname
            
            [String]$Filename = $File.name
            

            $Msg = -join ("   ... creating: ", $Filename, " in: ", $TargetJpg)
            Write-Host $Msg
            
            # [String]$Args1 = -Join ("  -extend ", $MyY1, "x", $MyY1, "! -crop ", $MyY1, "x", $MyY1, " -background red ", $Source, " ", $Target )

            [ImageMagickConvert]$ImageMagickConvert = New-ImageMagickConvert -InputFolder $SourceJpg -OutputFolder $TargetJpg -InputFilename $Filename -OutputFilename $Filename
            $ImageMagickConvert.SetCrop($MyX1, $MyY1)
            $ImageMagickConvert.SetBackground("white")
            $ImageMagickConvert.DoWrite()
            
            #    c:\apps\tools\imageMagick\convert.exe %1.jpg %1.jpg.pdf
        }
        return $True
    }

    [Boolean]DoExtendJpgs([String]$MySourceSubJpg, [String]$MyTagetSubJpg, [int16]$MyX1, [int16]$MyY1) {
        Write-JtLog -Text ("DoExtendJpgs")

        $Msg = -join ("Dimensions: ", $MyY1, " x ", $MyX1)
        Write-JtLog -Text ($Msg)
    
        [String]$SourceJpg = $This.DoUseWorkSub($MySourceSubJpg)
        [String]$TargetJpg = $This.DoUseWorkSub($MyTagetSubJpg)
        
        $Files = Get-ChildItem -Path $SourceJpg
        
        foreach ($File in $Files) {
            [String]$Filename = $File.name
            
            # [String]$Args1 = -Join ("  -extend ", $MyY1, "x", $MyY1, "! -crop ", $MyY1, "x", $MyY1, " -background red ", $Source, " ", $Target )
            
            [ImageMagickConvert]$ImageMagickConvert = New-ImageMagickConvert -InputFolder $SourceJpg -OutputFolder $TargetJpg -InputFilename $Filename -OutputFilename $Filename
            $ImageMagickConvert.SetResize($MyY1, $MyY1)
            $ImageMagickConvert.SetExtent($MyY1, $MyX1)
            $ImageMagickConvert.SetGravity("center")
            $ImageMagickConvert.SetBackground("white")
            $ImageMagickConvert.DoWrite()
            
            #    c:\apps\tools\imageMagick\convert.exe %1.jpg %1.jpg.pdf
        }
        return $True
    }
    

    [Boolean]DoMatrixJpgs([String]$MySourceSubJpg, [String]$MyTargetSubJpg, [int16]$Columns) {
        Write-JtLog -Text ("DoMatrixJpgs")

        $Msg = -join ("    Columns: ", $Columns)
        Write-JtLog -Text ($Msg)

        [String]$SourceJpg = $This.DoUseWorkSub($MySourceSubJpg)
        [String]$TargetJpg = $This.DoUseWorkSub($MyTargetSubJpg)
        
        [int16]$Col = 0
        [int16]$Row = 0
        $Files = Get-ChildItem -Path $SourceJpg
        
        $Col = 0;    
        $Row = 1;
        foreach ($File in $Files) {
            $Col = $Col + 1
            [String]$NewFilename = -join ("img_", $Row.toString("000"), "_x_", $Col.toString("000"), ".jpg")
            
            [String]$Source = $File.FullName
            [String]$Target = -Join ($TargetJpg, "\", $NewFilename)
            $Source
            $Target
            
            if ($Col -ge $Columns) {
                $Col = 0
                $Row = $Row + 1
            }
            
            $Msg = -join ("    ... creating: ", $Target)
            Write-JtLog -Text ($Msg)
            Copy-Item -Path $Source -Destination $Target
        }
        return $True
    }

    [Boolean]DoPdf2Jpg([String]$MySubPdf, [String]$MySubJpg) {
        [String]$SourcePdf = $This.DoUseWorkSub($MySubPdf)
        [String]$TargetJpg = $This.DoUseWorkSub($MySubJpg)
        
        Write-JtLog -Text ("DoPdf2Jpg")
        
        [String]$Msg = -join ("   Source (PDF):", $SourcePdf)
        Write-JtLog -Text ($Msg)
        
        $Msg = -join ("   Target (JPG):", $TargetJpg)
        
        $Files = Get-ChildItem -Path $SourcePdf
        $Files
        
        foreach ($File in $Files) {
            [String]$Source = $File.Fullname
            # Use only first page in pdf
            
            [String]$Filename = $File.name

            New-ImageMagickItemPdf -InputFolder $SourcePdf -OutputFolder $TargetJpg -Filename $Filename 
            
            # Start-Process -FilePath $This.ConvertExe  -ArgumentList $Args1 -NoNewWindow -Wait
            #    c:\apps\tools\imageMagick\convert.exe %1.jpg %1.jpg.pdf
        }
        return $True
    }

    [Boolean]DoStartIn([String]$MySub) {
        Write-JtLog -Text ("DoStartIn")
    
        [String]$Source = -join ($This.SourceFolder, "\", "*.*")
        [String]$Target = -join ($This.FolderWork, "\", $MySub)
        New-Item -ItemType Directory -Force -Path $Target
    
        $Msg = -join ("Copying ... '", $Source, "' to '", $Target, "'")
        Write-JtLog -Text ($Msg)
    
        Copy-Item -Path $Source  -Destination $Target -Recurse
        return $True
    }


    
    [String]DoUseWorkSub([String]$MySub) {
        Write-JtLog -Text ("DoUseWorkSub")
        
        $Msg = -join ("Using sub dir ", $MySub, " in FolderWork: ", $This.FolderWork)
        Write-JtLog -Text ($Msg)
        
        [String]$MyPath = -join ($This.FolderWork, "\", $MySub)
        New-Item -ItemType Directory -Force -Path $MyPath
        
        return $MyPath
    }
}

function New-JtImageTool {

    param(
        [Parameter()]
        [String]$FolderSource,
        [Parameter()]
        [String]$FolderWork
    )

    [JtImageTool]::new($FolderSource, $FolderWork)
}
