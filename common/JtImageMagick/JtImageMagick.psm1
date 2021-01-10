using module JtClass
using module JtTbl
using module JtIo

class JtImageMagick : JtClass {
    
    [JtTblRow]$JtTblRow = $Null
    [String]$ConvertExe = "c:\apps\tools\ImageMagick\convert.exe"
    [String]$CompositeExe = "c:\apps\tools\ImageMagick\composite.exe"
    [String]$InputFolder = ""
    [String]$OutputFolder = ""
    [String]$InputFileName = ""
    [String]$OutputFileName = ""
    
    JtImageMagick([String]$MyInputFolder, [String]$MyInputFilename, [String]$MyOutputFolder, [String]$MyOutputFilename) {
        $This.ClassName = "JtImageMagick"
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
        [String]$MyFilename = -join("img", $ThreeDigits, ".jpg")
        return $MyFilename
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

class JtImageMagickComposite : JtImageMagick {
    
    [String]$Params = ""
    [String]$Output = ""
    [String]$Source2Folder = ""
    [String]$Source2Filename = ""
    
    JtImageMagickComposite([String]$MyInputFolder, [String]$MyInputFilename,  [String]$MySource2Folder, [String]$MySource2Filename, [String]$MyOutputFolder, [String]$MyOutputFilename) : Base ([String]$MyInputFolder, [String]$MyInputFilename, [String]$MyOutputFolder, [String]$MyOutputFilename) {
        $This.ClassName = "JtImageMagickComposite"
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
        Write-JtIo -Text ( -join ("JtImageMagick composite: ", $OutputFilePath))
        Start-Process  -FilePath $This.CompositeExe  -ArgumentList $ArgumentList -NoNewWindow  -Wait
        return $True
    }
}

function New-JtImageMagickComposite {

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

    [JtImageMagickComposite]::new($InputFolder, $InputFilename, $OutputFolder, $OutputFilename, $Source2Folder, $Source2Filename)
}


class JtImageMagickConvert : JtImageMagick {
    
    [String]$Params = ""
    
    JtImageMagickConvert([String]$MyInputFolder, [String]$MyInputFilename, [String]$MyOutputFolder, [String]$MyOutputFilename) : Base ([String]$MyInputFolder, [String]$MyInputFilename, [String]$MyOutputFolder, [String]$MyOutputFilename) {
        $This.ClassName = "JtImageMagickConvert"
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
        
        
        Write-JtIo -Text ( -join ("JtImageMagick convert: ", $OutputFilePath))
        Write-JtLog -Text ( -join ("ArgumentList: ", $ArgumentList))
        Start-Process  -FilePath $This.ConvertExe  -ArgumentList $ArgumentList -NoNewWindow  -Wait
        return $True
    }
}

function New-JtImageMagickConvert {

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

    [JtImageMagickConvert]::new($InputFolder, $InputFilename, $OutputFolder, $OutputFilename)
}

class JtImageMagickItem : JtClass {

    JtImageMagickItem() {
        $This.ClassName = "JtImageMagickItem"
    }

    [Boolean]DoWrite() {
        Throw "Should be overwrittten..."

        return $False
    }
}

class JtImageMagickItemBackground : JtImageMagickItem {

    [String]$Generation = $Null
    [String]$System = $Null
    [String]$User = $Null
    [String]$OutputFolder = $Null
    [String]$TemplateFolder
    
    JtImageMagickItemBackground([String]$MyOutputFolder, [String]$MyGeneration, [String]$MySystem, [String]$MyUser) : Base() {
        $This.ClassName = "JtImageMagickItemBackground"
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
        
        [JtImageMagickConvert]$JtImageMagickConvert = New-JtImageMagickConvert  -OutputFolder $MyOutputFolder  -OutputFilename $MyOutputFilename
        $JtImageMagickConvert.SetSize(1500, 30)
        $JtImageMagickConvert.SetFont("Arial")
        $JtImageMagickConvert.SetGravity("NorthWest")
        $JtImageMagickConvert.SetPointsize(20)
        $JtImageMagickConvert.SetBackground("black")
        $JtImageMagickConvert.SetFill("white")
        
        $D = Get-Date
        $MyLabel = -join ("             System: ", $This.System, "     User: ", $This.User, "     Version: ", $D.toString("yyyy-MM-dd"))
        $JtImageMagickConvert.SetLabel($MyLabel)
        $JtImageMagickConvert.DoWrite()
        
        return $MyOutputFilename
    }
    
    [String]DoWriteImageDisclaimer() {
        [String]$MyFilenameDisclaimer = -join ("_", $This.Generation, ".", $This.System, ".", $This.User, ".", "disclaimer.jpg")
        [String]$MyOutputFolder = -join ($This.OutputFolder)
        
        [String]$MyOutputFilename = $MyFilenameDisclaimer
        [JtImageMagickConvert]$JtImageMagickConvert = New-JtImageMagickConvert  -OutputFolder $MyOutputFolder -OutputFilename $MyOutputFilename
        $JtImageMagickConvert.SetSize(1500, 30)
        $JtImageMagickConvert.SetFont("Arial")
        $JtImageMagickConvert.SetGravity("NorthEast")
        $JtImageMagickConvert.SetPointsize(20)
        $JtImageMagickConvert.SetBackground("black")
        $JtImageMagickConvert.SetFill("white")

        [String]$MyLabel = ""
        if ($This.System -eq "win10p") {
            $MyLabel = "Normales System" 
        }
        else {
            $MyLabel = "Bitte Computer neu starten, um auf ALLE Anwendungen Zugriff zu haben..." 
        }
        $JtImageMagickConvert.SetLabel($MyLabel)
        $JtImageMagickConvert.DoWrite()
        return $MyOutputFilename
    }
    

    [String]DoWriteImageTitleLeft([String]$MyFilename, [String]$Folder2, [String]$File2) {
        [String]$MyOutputFolder = -join ($This.OutputFolder)
        [String]$MyOutputFilename = -join ("_", $This.Generation, ".", $This.System, ".", $This.User, ".", "title.jpg")

        [JtImageMagickComposite]$JtImageMagickComposite = New-JtImageMagickComposite -InputFolder $MyOutputFolder -InputFileName $MyFilename -OutputFolder $MyOutputFolder -OutputFilename $MyOutputFilename -Source2Folder $Folder2 -Source2Filename $File2
        $JtImageMagickComposite.SetGravity("NorthWest")
        $JtImageMagickComposite.DoWrite()
        return $MyOutputFilename
    }

    [String]DoWriteImageTitleRight([String]$MyFilename, [String]$Folder2, [String]$File2) {
        [String]$MyOutputFolder = -join ($This.OutputFolder)
        [String]$MyOutputFilename = -join ($This.Generation, ".", $This.System, ".", $This.User, ".", "background.jpg")

        [JtImageMagickComposite]$JtImageMagickComposite = New-JtImageMagickComposite -InputFolder $MyOutputFolder -InputFileName $MyFilename -OutputFolder $MyOutputFolder -OutputFilename $MyOutputFilename -Source2Folder $Folder2 -Source2Filename $File2
        $JtImageMagickComposite.SetGravity("NorthEast")
        $JtImageMagickComposite.DoWrite()
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

function New-JtImageMagickItemBackground {
    
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

    [JtImageMagickItemBackground]$JtImageMagickItemBackground = [JtImageMagickItemBackground]::new($OutputFolder, $Generation, $System, $User)
    $JtImageMagickItemBackground.DoWrite()

}


function New-JtImageMagickItemIcon {

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

    [JtImageMagickConvert]$JtImageMagickConvert = New-JtImageMagickConvert -OutputFolder $OutputFolder -OutputFilename $OutputFilename
    $JtImageMagickConvert.SetFont("Arial")
    $JtImageMagickConvert.SetSize($X, $Y)
    $JtImageMagickConvert.SetGravity("Center")
        
    # Pointsize??
    $JtImageMagickConvert.SetPointsize($Size)
    if ($Null -eq $Background) {
        $Background = "red"
    }
    $JtImageMagickConvert.SetBackground($Background)
    $JtImageMagickConvert.SetFill("white")

    $JtImageMagickConvert.SetLabel($Label)

    $JtImageMagickConvert.DoWrite()
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

    [String]$MyFilename = -join ($Generation, ".", $System, ".", $User, ".png")
    [JtImageMagickConvert]$JtImageMagickConvert = New-JtImageMagickConvert -OutputFolder $MyOutputFolder -OutputFilename $MyFilename
    $JtImageMagickConvert.SetFont("Arial")
    $JtImageMagickConvert.SetSize(250, 250)
    $JtImageMagickConvert.SetGravity("Center")
        
    # Pointsize??
    $JtImageMagickConvert.SetPointsize(65)
    $JtImageMagickConvert.SetBackground($Background)
    $JtImageMagickConvert.SetFill("white")

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
    $JtImageMagickConvert.SetLabel($Label)

    $JtImageMagickConvert.DoWrite()
    return $False
}

function New-JtImageMagickItemPdf {

    param (
        [Parameter(Mandatory = $True)]
        [String]$InputFolder, 
        [Parameter(Mandatory = $True)]
        [String]$InputFilename,
        [Parameter(Mandatory = $True)]
        [String]$OutputFolder

    )

    [String]$MyInputFilename = -join ($InputFilename, "[0]")
    [String]$OutputFilename = $InputFilename.Replace(".pdf", ".jpg")

    [JtImageMagickConvert]$JtImageMagickConvert = New-JtImageMagickConvert -InputFolder $Inputfolder -InputFilename $MyInputFilename -OutputFolder $OutputFolder -OutputFilename $OutputFilename
    Write-JtLog ( -join ("... New-JtImageMagickItemPdf - InputFolder:", $InputFolder, " InputFilename:", $MyInputFilename))
        
    $JtImageMagickConvert.SetColorspace("rgb")
    $JtImageMagickConvert.SetDepth(8)
    $JtImageMagickConvert.SetDensity(300)
    $JtImageMagickConvert.DoWrite()
}

function New-JtImageMagickItemCover {

    param (
        [Parameter(Mandatory = $True)]
        [String]$InputFolder, 
        [Parameter(Mandatory = $True)]
        [String]$InputFilename,
        [Parameter(Mandatory = $True)]
        [String]$FolderWork
    )

    New-JtIoFolder -Path $FolderWork -Force $True
    
    [String]$FolderWorkA = -join ($FolderWork, "\", "a")
    New-JtIoFolder -Path $FolderWorkA -Force $True
    
    [String]$FolderWorkB = -join ($FolderWork, "\", "b")
    New-JtIoFolder -Path $FolderWorkB -Force $True
    
    [String]$FolderWorkC = -join ($FolderWork, "\", "c")
    New-JtIoFolder -Path $FolderWorkC -Force $True

    New-JtImageMagickItemPdf -InputFolder $Inputfolder -InputFilename $InputFilename -OutputFolder $FolderWorkA 

    New-JtImageMagickItemResize -InputFolder $FolderWorkA  -InputFilename $InputFilename -OutputFolder $FolderWorkB -X1 1920 -Y1 1080
    
    New-JtImageMagickItemResize -InputFolder $FolderWorkB -InputFilename $InputFilename -OutputFolder $FolderWorkC -X1 384 -Y1 216
}

function New-JtImageMagickItemResize {

    param (
        [Parameter(Mandatory = $True)]
        [String]$InputFolder, 
        [Parameter(Mandatory = $True)]
        [String]$InputFilename,
        [Parameter(Mandatory = $True)]
        [String]$OutputFolder, 
        [Parameter(Mandatory = $True)]
        [Int16]$X1,
        [Parameter(Mandatory = $True)]
        [Int16]$Y1
    )

    [String]$InputFilename = $InputFilename
    [String]$OutputFilename = $InputFilename
    [JtImageMagickConvert]$JtImageMagickConvert = New-JtImageMagickConvert -InputFolder $InputFolder -InputFilename $InputFilename -OutputFolder $OutputFolder -OutputFilename $OutputFilename
    $JtImageMagickConvert.SetResize($X1, $Y1)
    $JtImageMagickConvert.SetExtent($X1, $Y1)
    $JtImageMagickConvert.DoWrite()
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
            
            [String]$MyFilename = $File.name
            

            $Msg = -join ("   ... creating: ", $MyFilename, " in: ", $TargetJpg)
            Write-Host $Msg
            
            # [String]$Args1 = -Join ("  -extend ", $MyY1, "x", $MyY1, "! -crop ", $MyY1, "x", $MyY1, " -background red ", $Source, " ", $Target )

            [JtImageMagickConvert]$JtImageMagickConvert = New-JtImageMagickConvert -InputFolder $SourceJpg -OutputFolder $TargetJpg -InputFilename $MyFilename -OutputFilename $MyFilename
            $JtImageMagickConvert.SetCrop($MyX1, $MyY1)
            $JtImageMagickConvert.SetBackground("white")
            $JtImageMagickConvert.DoWrite()
            
            #    c:\apps\tools\JtImageMagick\convert.exe %1.jpg %1.jpg.pdf
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
            [String]$MyFilename = $File.name
            
            # [String]$Args1 = -Join ("  -extend ", $MyY1, "x", $MyY1, "! -crop ", $MyY1, "x", $MyY1, " -background red ", $Source, " ", $Target )
            
            [JtImageMagickConvert]$JtImageMagickConvert = New-JtImageMagickConvert -InputFolder $SourceJpg -OutputFolder $TargetJpg -InputFilename $MyFilename -OutputFilename $MyFilename
            $JtImageMagickConvert.SetResize($MyY1, $MyY1)
            $JtImageMagickConvert.SetExtent($MyY1, $MyX1)
            $JtImageMagickConvert.SetGravity("center")
            $JtImageMagickConvert.SetBackground("white")
            $JtImageMagickConvert.DoWrite()
            
            #    c:\apps\tools\JtImageMagick\convert.exe %1.jpg %1.jpg.pdf
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
            
            [String]$MyFilename = $File.name

            New-JtImageMagickItemPdf -InputFolder $SourcePdf -InputFilename $MyFilename -OutputFolder $TargetJpg 
            
            # Start-Process -FilePath $This.ConvertExe  -ArgumentList $Args1 -NoNewWindow -Wait
            #    c:\apps\tools\JtImageMagick\convert.exe %1.jpg %1.jpg.pdf
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
