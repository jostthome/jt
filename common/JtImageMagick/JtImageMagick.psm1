using module Jt  
using module JtTbl
using module JtIo

class JtImageMagick : JtClass {
    
    [String]$ConvertExe = "c:\apps\tools\ImageMagick\convert.exe"
    [String]$CompositeExe = "c:\apps\tools\ImageMagick\composite.exe"
    [String]$FolderPath_Output = ""
    [String]$Filename_Output = ""
    
    JtImageMagick([String]$TheFolderPath_Output, [String]$TheFilename_Output) {
        $This.ClassName = "JtImageMagick"

        [String]$MyFolderPath_Output = $TheFolderPath_Output
        [String]$MyFilename_Output = $TheFilename_Output

        if ($MyFolderPath_Output) {
            if (!(Test-JtIoFolderPath -FolderPath $MyFolderPath_Output)) {
                # Throw "Path does not exist MyFolderPath_Output: $MyFolderPath_Output"
                New-JtIoFolder -FolderPath $MyFolderPath_Output -Force
            }
        }
        else {
            Throw "Problem with parameter: MyFolderPath_Output!"
        }
        [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $MyFolderPath_Output -Force

        $This.FolderPath_Output = $MyJtIoFolder.GetPath()
        $This.Filename_Output = $MyFilename_Output
    }

    static [String]GetFilenameForNumber([Int16]$I) {
        [Int16]$Thousand = 1000 + $I
        [String]$ThreeDigits = -join ("", $Thousand )
        $ThreeDigits = [String]$ThreeDigits.SubString(1, 3)
        [String]$MyFilename = -join ("img", $ThreeDigits, ".jpg")
        return $MyFilename
    }

    [Void]AddParameter([String]$TheParameter, [String]$TheValue) {
        $This.Params = -join ($This.Params, " ", "-", $TheParameter, " ", $TheValue)
    }

    [Void]AddParameterSpecial([String]$TheParameter, [String]$TheValue) {
        $This.Params = -join ($This.Params, " ", $TheParameter, ":", """", $TheValue, """")
    }
    
    [Void]SetFont([String]$TheValue) {
        # "-font Arial"
        $This.AddParameter("font", $TheValue)
    }
        
    [Void]SetFill([String]$TheValue) {
        # "-fill white"
        $This.AddParameter("fill", $TheValue)
    }
        
    [Void]SetGravity([String]$TheValue) {
        # "-gravity NorthWest"
        $This.AddParameter("gravity", $TheValue)
    }
            
    [Void]SetLabel([String]$TheValue) {
        # "-fill white"
        $This.AddParameterSpecial("label", $TheValue)
    }

    [Void]SetPointsize([String]$TheValue) {
        # "-pointsize 20"
        $This.AddParameter("pointsize", $TheValue)
    }

    [Void]SetSize([Int16]$X, [Int16]$Y) {
        # -size ", $MyX1, "x", $MyY1

        [String]$MyValue = -join ($X, "x", $Y)
        $This.AddParameter("size", $MyValue)
    }
    

    [String]GetParams() {
        return $This.Params
    }

}

class JtImageMagick_Composite : JtImageMagick {
    
    [String]$Params = ""
    [String]$Output = ""
    [String]$FolderPath_Input1 = ""
    [String]$FolderPath_Input2 = ""
    [String]$Filename_Input1 = ""
    [String]$Filename_Input2 = ""

    JtImageMagick_Composite([String]$TheFolderPath_Input1, [String]$TheFilename_Input1, [String]$TheFolderPath_Input2, [String]$TheFilename_Input2, [String]$TheFolderPath_Output, [String]$TheFilename_Output) : Base ([String]$TheFolderPath_Output, [String]$TheFilename_Output) {
        $This.ClassName = "JtImageMagick_Composite"

        $This.FolderPath_Input1 = $TheFolderPath_Input1
        $This.Filename_Input1 = $TheFilename_Input1
        $This.FolderPath_Input2 = $TheFolderPath_Input2
        $This.Filename_Input2 = $TheFilename_Input2
    }
    
    [String]DoWrite() {
        # [String]$Args1 = -Join (" -crop ", $MyX1, "x", $MyY1, "+0+0 -background white ", $FolderPath_Input, " ", $FilePathTarget )
 
        [String]$MyFilePath_Input1 = -join ($This.FolderPath_Input1, "\", $This.Filename_Input1)
        [String]$MyFilePath_Input2 = -join ($This.FolderPath_Input2, "\", $This.Filename_Input2)
        [String]$MyFilePath_Output = -join ($This.FolderPath_Output, "\", $This.Filename_Output)
        
        [String]$MyArgumentList = -join ($This.GetParams(), " ", $MyFilePath_Input1, " ", $MyFilePath_Input2, " ", $MyFilePath_Output)
        
        Write-JtLog -Where $This.ClassName -Text $MyArgumentList
        Write-JtLog_File -Where $This.ClassName -Text "DoWrite..." -FilePath $MyFilePath_Output
        Start-Process -FilePath $This.CompositeExe  -ArgumentList $MyArgumentList -NoNewWindow  -Wait
        return $MyFilePath_Output
    }
}



Function New-JtImageAttachRight {

    param (
        [String]$FolderPath_Input1,
        [Int16]$InputFileX1,
        [Int16]$InputFileY1,
        [String]$FolderPath_Input2,
        [Int16]$InputFileX2,
        [Int16]$InputFileY2,
        [String]$FolderPath_Output,
        [String]$Filename_Output
    )
        
    [String]$MyFunctionName = "New-JtImageAttachRight"
    # [JtIoFolder]$MyJtIoFolder_Work = Get-JtIoFolder_Work -Name $MyFunctionName
    [String]$MyFilename_Output = $Filename_Output
    [String]$MyFolderPath_Input1 = $FolderPath_Input1
    [String]$MyFolderPath_Input2 = $FolderPath_Input2
    [String]$MyFolderPath_Output = $FolderPath_Output
    

    [String]$MyFilename_OutputBlank = $MyFilename_Output.replace(".jpg", "_blank.jpg")
    [JtImageMagick_Image]$MyJtImageMagick_Image = New-JtImageMagick_Image -FolderPath_Output $MyFolderPath_Output -Filename_Output $MyFilename_OutputBlank

    [Int16]$IntSizeX = [Int16]$InputFileX1 + [Int16]$InputFileX2
    $MyJtImageMagick_Image.SetSize($IntSizeX, $InputFileY1)
    $MyJtImageMagick_Image.SetFont("Arial")
    $MyJtImageMagick_Image.SetGravity("NorthEast")
    $MyJtImageMagick_Image.SetPointsize(20)
    $MyJtImageMagick_Image.SetBackground("green")
    $MyJtImageMagick_Image.SetFill("yellow")
    $MyJtImageMagick_Image.SetLabel(".")
    [String]$MyFilePathWorkImageBlank = $MyJtImageMagick_Image.DoWrite()
    

    [String]$MyFilename_OutputLeft = $Filename_Output.replace(".jpg", "_left.jpg")
    $MyParameters = @{
        FolderPath_Input1 = $MyFolderPath_Input1
        FolderPath_Input2 = $MyFilePathWorkImageBlank
        FolderPath_Output = $MyJtIoFolder_Work.GetPath()
        Filename_Output   = $MyFilename_OutputLeft
    }
    
    [JtImageMagick_Composite]$MyJtImageMagick_Composite = New-JtImageMagick_Composite @MyParameters
    $MyJtImageMagick_Composite.SetGravity("NorthWest")
    [String]$MyFilePathWorkImageLeft = $MyJtImageMagick_Composite.DoWrite()
    
    [String]$MyFilename_OutputRight = $MyFilename_Output.replace(".jpg", "_east.jpg")
    $MyParameters = @{
        FolderPath_Input1 = $MyFolderPath_Input2
        FolderPath_Input2 = $MyFilePathWorkImageLeft
        FolderPath_Output = $MyJtIoFolder_Work.GetPath()
        Filename_Output = $MyFilename_OutputRight
    }

    [JtImageMagick_Composite]$MyJtImageMagick_Composite = New-JtImageMagick_Composite @MyParameters
    $MyJtImageMagick_Composite.SetGravity("NorthEast")
    [String]$MyFilePathWorkImageRight = $MyJtImageMagick_Composite.DoWrite()

    [String]$MyFolderPath_Output = $MyJtIoFolder_Work.GetPath()
    [String]$MyFilename_Output = $MyFilename_Output
    [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyFolderPath_Output -Force
    [String]$MyFilePath_Output = $MyJtIoFolder_Output.GetFilePath($MyFilename_Output)

    Write-JtLog -Where $This.ClassName -Text "MyFilePathWorkImageRight: $MyFilePathWorkImageRight"
    Write-JtLog -Where $This.ClassName -Text "MyFilePath_Output: $MyFilePath_Output"
    Copy-Item $MyFilePathWorkImageRight $MyFilePath_Output

    return $MyFilePath_Output
}


Function New-JtImageMagick_Composite {

    param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input1, 
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Filename_Input1, 
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input2,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Filename_Input2,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output, 
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Filename_Output
    )

    [JtImageMagick_Composite]::new($FolderPath_Input1, $Filename_Input1, $FolderPath_Input2, $Filename_Input2, $FolderPath_Output, $Filename_Output)
}


class JtImageMagick_Convert : JtImageMagick {
    
    [String]$Params = ""
    [String]$FolderPath_Input = ""
    [String]$Filename_Input = ""
    
    JtImageMagick_Convert([String]$TheFolderPath_Input, [String]$TheFilename_Input, [String]$TheFolderPath_Output, [String]$TheFilename_Output) : Base ([String]$TheFolderPath_Output, [String]$TheFilename_Output) {
        $This.ClassName = "JtImageMagick_Convert"

        $This.FolderPath_Input = $TheFolderPath_Input
        $This.Filename_Input = $TheFilename_Input
    }

    [Void]SetBackground([String]$TheValue) {
        $This.AddParameter("background", $TheValue)
    }

    [Void]SetCrop([Int16]$X, [Int16]$Y) {
        # -crop ", $MyX1, "x", $MyY1

        [String]$MyValue = -join ($X, "x", $Y, "+0+0")
        $This.AddParameter("crop", $MyValue)
    }

    [Void]SetExtent([Int16]$X, [Int16]$Y) {
        # -extent ", $MyX1, "x", $MyY1

        [String]$MyValue = -join ($X, "x", $Y)
        $This.AddParameter("extent", $MyValue)
    }

    [Void]SetResize([Int16]$X, [Int16]$Y) {
        # -resize ", $MyX1, "x", $MyY1

        [String]$MyValue = -join ($X, "x", $Y, "+0+0")
        $This.AddParameter("resize", $MyValue)
    }

    [String]DoWrite() {
        # [String]$Args1 = -Join (" -crop ", $MyX1, "x", $MyY1, "+0+0 -background white ", $FolderPath_Input, " ", $FilePathTarget )
        [String]$MyFolderPath_Input = $This.FolderPath_Input
        [String]$MyFilename_Input = $This.Filename_Input
        [String]$MyFilePath_Input = -join ($MyFolderPath_Input, "\", $MyFilename_Input)

        if (!(Test-JtIoFilePath -FilePath $MyFilePath_Input)) {
            Write-JtLog_Error -Where $This.ClassName -Text "DoWrite... Not existing. MyFilePath_Input: $MyFilePath_Input"
#            Throw "FolderPath_Input does not exist! $MyFolderPath_Input"
        }

        [String]$MyFolderPath_Output = $This.FolderPath_Output
        [String]$MyFilename_Output= $This.Filename_Output

        [String]$MyFilePath_Output = -join ($MyFolderPath_Output, "\", $MyFilename_Output)
        [String]$MyArgumentList = -join ($This.GetParams(), " ", $MyFilePath_Input, "  ", $MyFilePath_Output)
        
        
        Write-JtLog_File -Where $This.ClassName -Text "DoWrite... " -FilePath $MyFilePath_Output
        Write-JtLog -Where $This.ClassName -Text "DoWrite... ArgumentList: $MyArgumentList"
        Start-Process -FilePath $This.ConvertExe  -ArgumentList $MyArgumentList -NoNewWindow  -Wait
        return $MyFilePath_Output
    }
}

Function New-JtImageMagick_Convert {

    param(
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Filename_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Filename_Output
    )

    [JtImageMagick_Convert]::new($FolderPath_Input, $Filename_Input, $FolderPath_Output, $Filename_Output)
}

class JtImageMagick_Convert_PdfToJpg : JtImageMagick {
    
    [String]$Params = ""
    [String]$FolderPath_Input = ""
    [String]$Filename_Input = ""
    
    JtImageMagick_Convert_PdfToJpg([String]$TheFolderPath_Input, [String]$TheFilename_Input, [String]$TheFolderPath_Output, [String]$TheFilename_Output) : Base ([String]$TheFolderPath_Output, [String]$TheFilename_Output) {
        $This.ClassName = "JtImageMagick_Convert_PdfToJpg"

        $This.FolderPath_Input = $TheFolderPath_Input
        $This.Filename_Input = $TheFilename_Input
    }


    [String]DoWrite() {
        # [String]$Args1 = -Join (" -crop ", $MyX1, "x", $MyY1, "+0+0 -background white ", $FolderPath_Input, " ", $FilePathTarget )
        [String]$MyFolderPath_Input = $This.FolderPath_Input
        [String]$MyFilename_Input = $This.Filename_Input
        [String]$MyFilePath_Input = -join($MyFolderPath_Input, "\", $MyFilename_Input)

        if (!(Test-JtIoFilePath -FilePath $MyFilePath_Input)) {
            Write-JtLog_Error -Where $This.ClassName -Text "DoWrite... FilePath does not exist. MyFilePath_Input: $MyFilePath_Input"
#            Throw "FolderPath_Input does not exist! $MyFolderPath_Input"
        }

        [String]$MyFilePath_Input = -join ($MyFolderPath_Input, "\", $MyFilename_Input, "[0]")
        [String]$MyFolderPath_Output = $This.FolderPath_Output
        [String]$MyFilename_Output = $This.Filename_Output
        [String]$MyFilePath_Output = -join ($MyFolderPath_Output, "\", $MyFilename_Output)
        [String]$MyArgumentList = -join ($This.GetParams(), " ", $MyFilePath_Input, "  ", $MyFilePath_Output)
        
        Write-JtLog_File -Where $This.ClassName -Text "DoWrite..." -FilePath $MyFilePath_Output
        Write-JtLog -Where $This.ClassName -Text "DoWrite... ArgumentList: $MyArgumentList"
        Start-Process -FilePath $This.ConvertExe  -ArgumentList $MyArgumentList -NoNewWindow  -Wait
        return $MyFilePath_Output
    }

    [Void]SetColorspace([String]$TheValue) {
        # -colorspace rgb 
        $This.AddParameter("colorspace", $TheValue)
    }
    
    [Void]SetDepth([int16]$TheIntNumber) {
        # -depth 8 
        [String]$MyValue = -join ("", $TheIntNumber)
        $This.AddParameter("depth", $MyValue)
    }
    
    [Void]SetDensity([Int16]$TheIntNumber) {
        # -density 300 
        [String]$MyValue = -join ("", $TheIntNumber)
        $This.AddParameter("density", $MyValue)
    }
}

Function New-JtImageMagick_Convert_JpgToPdf {

    param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input, 
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Filename_Input, 
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFilename_Input = $Filename_Input
    
    [String]$MyFolderPath_Output = $FolderPath_Output
    [String]$MyFilename_Output = $MyFilename_Input.Replace(".jpg", ".pdf")
    
    [JtImageMagick_Convert]$MyJtImageMagick_Convert = New-JtImageMagick_Convert -FolderPath_Input $MyFolderPath_Input -Filename_Input $MyFilename_Input -FolderPath_Output $MyFolderPath_Output -Filename_Output $MyFilename_Output
    $MyJtImageMagick_Convert.DoWrite()
}

Function New-JtImageMagick_Convert_PdfToJpg {

    param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input, 
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Filename_Input, 
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "New-JtImageMagick_Convert_PdfToJpg"
    
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFilename_Input = $Filename_Input
    
    [String]$MyFolderPath_Output = $FolderPath_Output
    [String]$MyFilename_Output = $MyFilename_Input.Replace(".pdf", ".jpg")

    [JtImageMagick_Convert_PdfToJpg]$MyJtImageMagick_Convert_PdfToJpg = [JtImageMagick_Convert_PdfToJpg]::new($MyFolderPath_Input, $MyFilename_Input, $MyFolderPath_Output, $MyFilename_Output)
    Write-JtLog -Where $MyFunctionName -Text "FolderPath_Input: $MyFolderPath_Input"
        
    $MyJtImageMagick_Convert_PdfToJpg.SetColorspace("rgb")
    $MyJtImageMagick_Convert_PdfToJpg.SetDepth(8)
    $MyJtImageMagick_Convert_PdfToJpg.SetDensity(300)
    $MyJtImageMagick_Convert_PdfToJpg.DoWrite()
}

class JtImageMagickItem : JtClass {

    JtImageMagickItem() {
        $This.ClassName = "JtImageMagickItem"
    }

    [Boolean]DoWrite() {
        Throw "Should be overwritten..."

        return $False
    }
}


class JtImageMagick_Image : JtImageMagick {
    
    [String]$Params = ""
    [String]$FolderPath_Input = $Null
    [String]$Filename_Input = $Null

    
    JtImageMagick_Image([String]$TheFolderPath_Input, [String]$TheFilename_Input, [String]$TheFolderPath_Output, [String]$TheFilename_Output) : Base ([String]$TheFolderPath_Output, [String]$TheFilename_Output) {
        $This.ClassName = "JtImageMagick_Image"
        $This.FolderPath_Input = $TheFolderPath_Input
        $This.Filename_Input = $TheFilename_Input
    }

    JtImageMagick_Image([String]$TheFolderPath_Output, [String]$TheFilename_Output) : Base ([String]$TheFolderPath_Output, [String]$TheFilename_Output) {
        $This.ClassName = "JtImageMagick_Image"
        $This.FolderPath_Input = $Null
        $This.Filename_Input = $Null
    }

    [Void]SetBackground([String]$TheValue) {
        $This.AddParameter("background", $TheValue)
    }

    [Void]SetColorspace([String]$TheValue) {
        # -colorspace rgb 
        $This.AddParameter("colorspace", $TheValue)
    }
    
    [Void]SetCrop([Int16]$X, [Int16]$Y) {
        # -crop ", $MyX1, "x", $MyY1

        [String]$MyValue = -join ($X, "x", $Y, "+0+0")
        $This.AddParameter("crop", $MyValue)
    }

    [Void]SetDepth([int16]$Number) {
        # -depth 8 
        [String]$MyValue = -join ("", $Number)
        $This.AddParameter("depth", $MyValue)
    }
    
    [Void]SetDensity([Int16]$Number) {
        # -density 300 
        [String]$MyValue = -join ("", $Number)
        $This.AddParameter("density", $MyValue)
    }

    [Void]SetExtent([Int16]$X, [Int16]$Y) {
        # -extent ", $MyX1, "x", $MyY1

        [String]$MyValue = -join ($X, "x", $Y)
        $This.AddParameter("extent", $MyValue)
    }

    [Void]SetResize([Int16]$X, [Int16]$Y) {
        # -resize ", $MyX1, "x", $MyY1

        [String]$MyValue = -join ($X, "x", $Y, "+0+0")
        $This.AddParameter("resize", $MyValue)
    }

    [String]DoWrite() {
        # [String]$Args1 = -Join (" -crop ", $MyX1, "x", $MyY1, "+0+0 -background white ", $FolderPath_Input, " ", $FilePathTarget )
        
        [String]$MyFilePath_Input = ""


        if ($This.Filename_Input) {
            [String]$MyFolderPath_Input = $This.FolderPath_Input
            [String]$MyFilename_Input = $This.Filename_Input
            [String]$MyFilePath_Input = -join ($MyFolderPath_Input, "\", $MyFilename_Input)
        }
        
        [String]$MyFolderPath_Output = $This.FolderPath_Output
        [String]$MyFilename_Output = $This.Filename_Output
        [String]$MyFilePath_Output = -join ($MyFolderPath_Output, "\", $MyFilename_Output)

    
        [String]$MyArgumentList = -join ($This.GetParams(), " ", $MyFilePath_Input, "  ", $MyFilePath_Output)
        
        Write-JtLog_File -Where $This.ClassName -Text "DoWrite... MyFilename_Output: $MyFilename_Output" -FilePath $MyFilePath_Output
        Write-JtLog -Where $This.ClassName -Text "MyArgumentList: $MyArgumentList"
        Start-Process -FilePath $This.ConvertExe  -ArgumentList $MyArgumentList -NoNewWindow  -Wait
        return $MyFilePath_Output
    }
}


Function New-JtImageMagick_Image {

    param(
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Filename_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Filename_Output
    )

    [JtImageMagick_Image]::new($FolderPath_Input, $Filename_Input, $FolderPath_Output, $Filename_Output)
}


class JtImageMagick_Item_Background : JtImageMagickItem {

    [String]$Generation = $Null
    [String]$System = $Null
    [String]$User = $Null
    [String]$FolderPath_Output = $Null
    [String]$FolderPath_Template
    
    JtImageMagick_Item_Background([String]$TheFolderPath_Input, [String]$TheFolderPath_Output, [String]$TheGeneration, [String]$TheSystem, [String]$TheUser) : Base() {
        $This.ClassName = "JtImageMagick_Item_Background"

        [String]$MyFolderPath_Input = $TheFolderPath_Input
        [String]$MyFolderPath_Output = $TheFolderPath_Output

        New-JtIoFolder -FolderPath $MyFolderPath_Output -Force
        $This.FolderPath_Output = -join ($MyFolderPath_Output, "\", "BACKGROUND")
        # was: C:\apps\1.SETUP\111.CUSTOMIZE\1111.POOLS\TEMPLATE
        $This.FolderPath_Template = $MyFolderPath_Input

        
        $This.System = $TheSystem
        $This.User = $TheUser
        $This.Generation = $TheGeneration
    }

    [String]DoWriteImageBase() {
        [String]$MyFolderPath_Output = $This.FolderPath_Output
        [String]$MyFilename_Output = -join ("_", $This.Generation, ".", $This.System, ".", $This.User, ".", "base.jpg")
        
        [JtImageMagick_Image]$MyJtImageMagick_Image = New-JtImageMagick_Image -FolderPath_Output $MyFolderPath_Output -Filename_Output $MyFilename_Output
        $MyJtImageMagick_Image.SetSize(2560, 30)
        $MyJtImageMagick_Image.SetFont("Arial")
        $MyJtImageMagick_Image.SetGravity("NorthWest")
        $MyJtImageMagick_Image.SetPointsize(20)
        $MyJtImageMagick_Image.SetBackground("green")
        $MyJtImageMagick_Image.SetFill("white")
        
        $MyLabel = "..."
        $MyJtImageMagick_Image.SetLabel($MyLabel)
        $MyJtImageMagick_Image.DoWrite()
        
        return $MyFilename_Output
    }

        
    [String]DoWriteImageDate() {
        [String]$MyFolderPath_Output = $This.FolderPath_Output
        [String]$MyFilename_Output = -join ("_", $This.Generation, ".", $This.System, ".", $This.User, ".", "date.jpg")
        
        [JtImageMagick_Image]$MyJtImageMagick_Image = New-JtImageMagick_Image -FolderPath_Output $MyFolderPath_Output -Filename_Output $MyFilename_Output
        $MyJtImageMagick_Image.SetSize(1500, 30)
        $MyJtImageMagick_Image.SetFont("Arial")
        $MyJtImageMagick_Image.SetGravity("NorthWest")
        $MyJtImageMagick_Image.SetPointsize(20)
        $MyJtImageMagick_Image.SetBackground("black")
        $MyJtImageMagick_Image.SetFill("white")
        
        $D = Get-Date
        $MyLabel = -join (".  System: ", $This.System, "     User: ", $This.User, "     Version: ", $D.toString("yyyy-MM-dd"))
        $MyJtImageMagick_Image.SetLabel($MyLabel)
        $MyJtImageMagick_Image.DoWrite()
        
        return $MyFilename_Output
    }
    
    [String]DoWriteImageDisclaimer() {
        [String]$MyFolderPath_Output = $This.FolderPath_Output
        
        [String]$MyFilename_Output = -join ("_", $This.Generation, ".", $This.System, ".", $This.User, ".", "disclaimer.jpg")
        [JtImageMagick_Image]$MyJtImageMagick_Image = New-JtImageMagick_Image -FolderPath_Output $MyFolderPath_Output -Filename_Output $MyFilename_Output
        $MyJtImageMagick_Image.SetSize(1500, 30)
        $MyJtImageMagick_Image.SetFont("Arial")
        $MyJtImageMagick_Image.SetGravity("NorthEast")
        $MyJtImageMagick_Image.SetPointsize(20)
        $MyJtImageMagick_Image.SetBackground("black")
        $MyJtImageMagick_Image.SetFill("white")

        [String]$MyLabel = ""
        if ($This.System -eq "win10p") {
            $MyLabel = "Normales System" 
        }
        else {
            $MyLabel = "Bitte Computer neu starten, um auf ALLE Anwendungen Zugriff zu haben...   " 
        }
        $MyJtImageMagick_Image.SetLabel($MyLabel)
        $MyJtImageMagick_Image.DoWrite()
        return $MyFilename_Output
    }

    [String]DoWriteImageTitleLeft([String]$TheFilename_Input2) {
        [String]$MyFolderPath_Input1 = $This.FolderPath_Output
        [String]$MyFilename_Input1 = $TheFilename_Input2
        [String]$MyFolderPath_Input2 = $This.FolderPath_Template
        [String]$MyFilename_Input2 = $This.GetFilename_Template()

        [String]$MyFolderPath_Output = $This.FolderPath_Output
        [String]$MyFilename_Output = -join ("_", $This.Generation, ".", $This.System, ".", $This.User, ".jpg")
        
        $MyParameters = @{
            FolderPath_Input1 = $MyFolderPath_Input1
            Filename_Input1 = $MyFilename_Input1
            FolderPath_Input2 = $MyFolderPath_Input2
            Filename_Input2 = $MyFilename_Input2
            FolderPath_Output = $MyFolderPath_Output
            Filename_Output = $MyFilename_Output
        }
        Write-JtLog -Where $This.ClassName -Text "DoWriteImageTitleLeft. Before composite"
        [JtImageMagick_Composite]$MyJtImageMagick_Composite = New-JtImageMagick_Composite @MyParameters
        $MyJtImageMagick_Composite.SetGravity("NorthWest")
        $MyJtImageMagick_Composite.DoWrite()
        return $MyFilename_Output
    }
    
    [String]DoWriteImageTitleRight([String]$TheFilename_Input1, [String]$TheFilename_Input2) {
        [String]$MyFolderPath_Input1 = $This.FolderPath_Output
        [String]$MyFilename_Input1 = $TheFilename_Input1
        [String]$MyFolderPath_Input2 = $This.FolderPath_Output
        [String]$MyFilename_Input2 = $TheFilename_Input2
        
        [String]$MyFolderPath_Output = $This.FolderPath_Output
        [String]$MyFilename_Output = -join ($This.Generation, ".", $This.System, ".", $This.User, ".", "background.jpg")
        
        Write-JtLog -Where $This.ClassName -Text "DoWriteImageTitleRight. Before composite"
        $MyParameters = @{
            FolderPath_Input1 = $MyFolderPath_Input1
            Filename_Input1 = $MyFilename_Input1
            FolderPath_Input2 = $MyFolderPath_Input2
            Filename_Input2 = $MyFilename_Input2
            FolderPath_Output = $MyFolderPath_Output
            Filename_Output = $MyFilename_Output
        }
        [JtImageMagick_Composite]$MyJtImageMagick_Composite = New-JtImageMagick_Composite @MyParameters
        $MyJtImageMagick_Composite.SetGravity("NorthEast")
        $MyJtImageMagick_Composite.DoWrite()
        return $MyFilename_Output
    }

    [String]GetFilename_Template() {
        [String]$MyFilename_Template = -join ($This.Generation, ".", $This.System, ".", $This.User, ".jpg")
        return $MyFilename_Template
    }
    
    
    [Void]DoWrite() {
        # [String]$FilenameBase = $This.DoWriteImageBase()
        [String]$MyFilename_Date = $This.DoWriteImageDate()
        [String]$MyFilename_Disclaimer = $This.DoWriteImageDisclaimer()

        [String]$MyFilename_TitleLeft = $This.DoWriteImageTitleLeft($MyFilename_Date)
        [String]$MyFilename_Background = $This.DoWriteImageTitleRight($MyFilename_Disclaimer, $MyFilename_TitleLeft)
        [String]$MyFilename_Background
    }
}

Function New-JtImageMagick_Item_Background {
    
    param (
        [Parameter(Mandatory = $True)]
        [String]$FolderPath_Input, 
        [Parameter(Mandatory = $True)]
        [String]$FolderPath_Output, 
        [Parameter(Mandatory = $True)]
        [String]$Generation, 
        [Parameter(Mandatory = $True)]
        [String]$System, 
        [Parameter(Mandatory = $True)]
        [String]$User
    )

    [JtImageMagick_Item_Background]$MyJtImageMagick_Item_Background = [JtImageMagick_Item_Background]::new($FolderPath_Input, $FolderPath_Output, $Generation, $System, $User)
    $MyJtImageMagick_Item_Background.DoWrite()

}


Function New-JtImageMagick_Item_Icon {

    param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output, 
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Filename_Output, 
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][Int16]$Pointsize,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][Int16]$X,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][Int16]$Y,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Label,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Background
    )

    [String]$MyFolderPath_Output = $FolderPath_Output
    [String]$MyFilename_Output = $Filename_Output
    New-JtIoFolder -FolderPath $MyFolderPath_Output -Force

    [JtImageMagick_Image]$MyJtImageMagick_Image = New-JtImageMagick_Image -FolderPath_Output $MyFolderPath_Output -Filename_Output $MyFilename_Output
    $MyJtImageMagick_Image.SetFont("Arial")
    $MyJtImageMagick_Image.SetSize($X, $Y)
    $MyJtImageMagick_Image.SetGravity("Center")
        
    $MyJtImageMagick_Image.SetPointsize($Pointsize)
    if ($Null -eq $Background) {
        $Background = "red"
    }
    $MyJtImageMagick_Image.SetBackground($Background)
    $MyJtImageMagick_Image.SetFill("white")
    $MyJtImageMagick_Image.SetLabel($Label)
    $MyJtImageMagick_Image.DoWrite()
    return $False
}


Function New-JtImageMagick_Item_Login {

    param (
        [Parameter(Mandatory = $True)]
        [String]$FolderPath_Output, 
        [Parameter(Mandatory = $True)]
        [String]$Generation, 
        [Parameter(Mandatory = $True)]
        [String]$System, 
        [Parameter(Mandatory = $True)]
        [String]$User,
        [Parameter(Mandatory = $True)]
        [String]$Background
    )
    [String]$MyFolderPath_Output = -join ($FolderPath_Output, "\", "LOGIN")

    # if (!(Test-JtIoFolderPath -FolderPath $MyFolderPath_Output)) {
    #     Throw "Path does not exist: $MyFolderPath_Output"
    # }

    New-JtIoFolder -FolderPath $MyFolderPath_Output -Force

    [String]$MyFilename_Output = -join ($Generation, ".", $System, ".", $User, ".png")
    [JtImageMagick_Image]$MyJtImageMagick_Image = New-JtImageMagick_Image -FolderPath_Output $MyFolderPath_Output -Filename_Output $MyFilename_Output
    $MyJtImageMagick_Image.SetFont("Arial")
    $MyJtImageMagick_Image.SetSize(250, 250)
    $MyJtImageMagick_Image.SetGravity("Center")
        
    # Pointsize??
    $MyJtImageMagick_Image.SetPointsize(65)
    $MyJtImageMagick_Image.SetBackground($Background)
    $MyJtImageMagick_Image.SetFill("white")

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
    $MyJtImageMagick_Image.SetLabel($Label)

    $MyJtImageMagick_Image.DoWrite()
    return $False
}


Function New-JtImageMagick_Item_Cover {

    param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input, 
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Filename_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "New-JtImageMagick_Item_Cover"

    [String]$MyFilename_Pdf = $Filename_Input
    [String]$MyFilename_Jpg = $MyFilename_Pdf.ToLower()
    [String]$MyFilename_Jpg = $MyFilename_Jpg.Replace([JtIo]::FileExtension_Pdf, [JtIo]::FileExtension_Jpg)

    [JtIoFolder]$MyJtIoFolder_Input_Base = New-JtIoFolder -FolderPath $FolderPath_Input
    [JtIoFolder]$MyJtIoFolder_Output_Base = New-JtIoFolder -FolderPath $FolderPath_Output -Force


    [JtIoFolder]$MyJtIoFolder_A = $MyJtIoFolder_Output_Base.GetJtIoFolder_Sub("A", $True)

    [JtIoFolder]$MyJtIoFolder_Input = $MyJtIoFolder_Input_Base
    [JtIoFolder]$MyJtIoFolder_Output = $MyJtIoFolder_A
    
[String]$MyFilename_Input = $MyFilename_Pdf
[String]$MyFilename_Output = $MyFilename_Pdf

    [String]$MyFilePath_Input  = $MyJtIoFolder_Input.GetFilePath($MyFilename_Input)
    [String]$MyFilePath_Output = $MyJtIoFolder_Output.GetFilePath($MyFilename_Output)
    Write-JtLog -Where $MyFunctionName -Text "Copying... MyFilePath_Input: $MyFilePath_Input MyFilePath_Output: $MyFilePath_Output"
    Copy-Item $MyFilePath_Input $MyFilePath_Output
    
    [JtIoFolder]$MyJtIoFolder_B = $MyJtIoFolder_Output_Base.GetJtIoFolder_Sub("B", $True)

    [JtIoFolder]$MyJtIoFolder_Input  = $MyJtIoFolder_A
    [JtIoFolder]$MyJtIoFolder_Output = $MyJtIoFolder_B

    [String]$MyFilename_Input = $MyFilename_Pdf
    [String]$MyFilename_Output = $MyFilename_Jpg
    
    [String]$MyFolderPath_Input = $MyJtIoFolder_Input.GetPath()
    [String]$MyFolderPath_Output = $MyJtIoFolder_Output.GetPath()
    
    New-JtImageMagick_Convert_PdfToJpg -FolderPath_Input $MyFolderPath_Input -Filename_Input $MyFilename_Input -FolderPath_Output $MyFolderPath_Output
    
    [JtIoFolder]$MyJtIoFolder_C = $MyJtIoFolder_Output_Base.GetJtIoFolder_Sub("C", $True)

    [JtIoFolder]$MyJtIoFolder_Input  = $MyJtIoFolder_B
    [JtIoFolder]$MyJtIoFolder_Output = $MyJtIoFolder_C

    [String]$MyFilename_Input = $MyFilename_Jpg
    [String]$MyFilename_Output = $MyFilename_Jpg

    [String]$MyFolderPath_Input = $MyJtIoFolder_Input.GetPath()
    [String]$MyFolderPath_Output = $MyJtIoFolder_Output.GetPath()
    New-JtImageMagick_Resize -FolderPath_Input $MyFolderPath_Input -Filename_Input $MyFilename_Input -FolderPath_Output $MyFolderPath_Output -X1 1920 -Y1 1080
    
    
    [JtIoFolder]$MyJtIoFolder_D = $MyJtIoFolder_Output_Base.GetJtIoFolder_Sub("D", $True)

    [JtIoFolder]$MyJtIoFolder_Input = $MyJtIoFolder_C
    [JtIoFolder]$MyJtIoFolder_Output = $MyJtIoFolder_D

    [String]$MyFilename_Input = $MyFilename_Jpg
    [String]$MyFilename_Output = $MyFilename_Jpg

    [String]$MyFolderPath_Input = $MyJtIoFolder_Input.GetPath()
    [String]$MyFolderPath_Output = $MyJtIoFolder_Output.GetPath()
    New-JtImageMagick_Resize -FolderPath_Input $MyFolderPath_Input -Filename_Input $MyFilename_Input -FolderPath_Output $MyFolderPath_Output -X1 384 -Y1 216

}



Function New-JtImageMagick_Resize {

    param (
        [Parameter(Mandatory = $True)]
        [String]$FolderPath_Input, 
        [Parameter(Mandatory = $True)]
        [String]$Filename_Input, 
        [Parameter(Mandatory = $True)]
        [String]$FolderPath_Output, 
        [Parameter(Mandatory = $True)]
        [Int16]$X1,
        [Parameter(Mandatory = $True)]
        [Int16]$Y1
    )

    $MyFunctionName = "New-JtImageMagick_Resize"

    Write-JtLog -Where $MyFunctionName -Text "Starting..."

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFilename_Input = $Filename_Input

    [String]$MyFolderPath_Output = $FolderPath_Output
    [String]$MyFilename_Output = $MyFilename_Input

    [JtImageMagick_Convert]$MyJtImageMagick_Convert = New-JtImageMagick_Convert -FolderPath_Input $MyFolderPath_Input -Filename_Input $MyFilename_Input -FolderPath_Output $MyFolderPath_Output -Filename_Output $MyFilename_Output
    $MyJtImageMagick_Convert.SetResize($X1, $Y1)
    $MyJtImageMagick_Convert.SetExtent($X1, $Y1)
    $MyJtImageMagick_Convert.DoWrite()
    return
}

class JtImageMagick_Tool : JtClass {

    [String]$FolderPath_Input = $Null
    [String]$FolderPathWork = $Null

    JtImageMagick_Tool([String]$MyFolderPath_Input, [String]$MyFolderPath_Work) {
        $This.ClassName = "JtImageMagick_Tool"
        Write-JtLog -Where $This.ClassName -Text "Starting..."

        $This.FolderPath_Input = $MyFolderPath_Input
        Write-JtLog -Where $This.ClassName -Text "MyFolderPath_Input: $MyFolderPath_Input"
        
        $This.FolderPathWork = $MyFolderPath_Work
        Write-JtLog -Where $This.ClassName -Text "MyFolderPathWork: $MyFolderPath_Work"
    }

    [Void]DoCropJpgs([String]$MyInputSubJpg, [String]$MyTagetSubJpg, [int16]$MyX1, [int16]$MyY1) {
        Write-JtLog -Where $This.ClassName -Text "DoCropJpgs..."
        Write-JtLog -Where $This.ClassName -Text "Dimensions: $MyY1  x $MyX1"
    
        [String]$MyFolderPath_Input = $This.DoUseWorkSub($MyInputSubJpg)
        [String]$MyFolderPath_Output = $This.DoUseWorkSub($MyTagetSubJpg)

        [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input
        
        $MyAlJtIoFiles = $MyJtIoFolder_Input.GetIoFiles()
        foreach ($File in $MyAlJtIoFiles) {
            [String]$MyFilename_Input = $File.GetName()
            [String]$MyFilename_Output = $MyFilename_Input
            
            Write-JtLog -Where $This.ClassName -Text "Creating JPG... MyFilename_Output: $MyFilename_Output in MyFolderPath_Output: $MyFolderPath_Output"
            
            [JtImageMagick_Convert]$MyJtImageMagick_Convert = New-JtImageMagick_Convert -FolderPath_Input $MyFolderPath_Input -Filename_Input $MyFilename_Input -FolderPath_Output $MyFolderPath_Output -Filename_Output $MyFilename_Output
            $MyJtImageMagick_Convert.SetCrop($MyX1, $MyY1)
            $MyJtImageMagick_Convert.SetBackground("white")
            $MyJtImageMagick_Convert.DoWrite()
            
            #    c:\apps\tools\JtImageMagick\convert.exe %1.jpg %1.jpg.pdf
        }
    }

    [Void]DoExtendJpgs([String]$MyInputSubJpg, [String]$MyTagetSubJpg, [int16]$MyX1, [int16]$MyY1) {
        Write-JtLog -Where $This.ClassName -Text "DoExtendJpgs..."

        $Msg = -join ("Dimensions: ", $MyY1, " x ", $MyX1)
        Write-JtLog -Where $This.ClassName -Text $Msg
    
        [String]$MyFolderPath_Input = $This.DoUseWorkSub($MyInputSubJpg)
        [String]$MyFolderPath_Output = $This.DoUseWorkSub($MyTagetSubJpg)

        [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input
        
        $MyJtIoAlFiles = Get-JtChildItem -FolderPath $MyJtIoFolder_Input
        
        foreach ($File in $MyJtIoAlFiles) {
            [String]$MyFilename_Input = $File.GetName()
            [String]$MyFilename_Output = $MyFilename_Input

            [JtImageMagick_Image]$MyJtImageMagick_Image = New-JtImageMagick_Image -FolderPath_Input $MyFolderPath_Input -Filename_Input $MyFilename_Input -FolderPath_Output $MyFolderPath_Output -Filename_Output $MyFilename_Output
            $MyJtImageMagick_Image.SetResize($MyY1, $MyY1)
            $MyJtImageMagick_Image.SetExtent($MyY1, $MyX1)
            $MyJtImageMagick_Image.SetGravity("center")
            $MyJtImageMagick_Image.SetBackground("white")
            $MyJtImageMagick_Image.DoWrite()
            
            #    c:\apps\tools\JtImageMagick\convert.exe %1.jpg %1.jpg.pdf
        }
    }

    [Void]DoInitFolderPathWork() {
        Write-JtLog -Where $This.ClassName -Text "DoInitFolderPathWork..."

        [JtIoFolder]$MyFolderPath_Work = $This.FolderPathWork
        $MyFolderPath_Work.DoRemoveEverything()
    }


    [Void]DoMatrixJpgs([String]$MyInputSubJpg, [String]$MyTargetSubJpg, [int16]$MyColumns) {
        Write-JtLog -Where $This.ClassName -Text "DoMatrixJpgs... Columns: $MyColumns, Source: $MyInputSubJpg, Target: $MyTargetSubJpg "

        [String]$MyFolderPath_InputJpg = $This.DoUseWorkSub($MyInputSubJpg)
        [String]$MyFolderPath_OutputJpg = $This.DoUseWorkSub($MyTargetSubJpg)
        
        [int16]$Col = 0
        [int16]$Row = 0

        [JtIoFolder]$MyJtIoFolder_InputJpg = New-JtIoFolder -FolderPath $MyFolderPath_InputJpg

        [String]$MyFilter = -join("*", [JtIo]::FileExtension_Jpg)
        [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder_InputJpg -Filter $MyFilter 

        
        $Col = 0;    
        $Row = 1;
        foreach ($File in $MyAlJtIoFiles) {
            $Col = $Col + 1
            [String]$MyFilenameNew = -join ("img_", $Row.toString("000"), "_x_", $Col.toString("000"), ".jpg")
            
            [String]$MyFolderPath_Input = $File.GetPath()
            [String]$MyFolderPath_Output = -Join ($MyFolderPath_OutputJpg, "\", $MyFilenameNew)
            $MyFolderPath_Input
            $MyFolderPath_Output
            
            if ($Col -ge $MyColumns) {
                $Col = 0
                $Row = $Row + 1
            }
            
            Write-JtLog -Where $This.ClassName -Text "Copying from  MyFolderPath_Input: $MyFolderPath_Input to MyFolderPath_Output: $MyFolderPath_Output"
            Copy-Item -Path $MyFolderPath_Input -Destination $MyFolderPath_Output
        }
    }

    [Void]DoPdf2Jpg([String]$MySubPdf, [String]$MySubJpg) {
        [String]$MyFolderPath_Input = $This.DoUseWorkSub($MySubPdf)
        [String]$MyFolderPath_Output = $This.DoUseWorkSub($MySubJpg)
        
        Write-JtLog -Where $This.ClassName -Text "DoPdf2Jpg...   MyFolderPath_Input  (PDF): $MyFolderPath_Input"
        Write-JtLog -Where $This.ClassName -Text "DoPdf2Jpg...   MyFolderPath_Output (JPG): $MyFolderPath_Output"
        
        $MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyFolderPath_Input
        foreach ($File in $MyAlJtIoFiles) {
            [String]$MyFilename_Input = $File.GetName()
            New-JtImageMagick_Convert_PdfToJpg -FolderPath_Input $MyFolderPath_Input -Filename_Input $MyFilename_Input -FolderPath_Output $MyFolderPath_Output
        }
    }

    [Void]DoStartIn([String]$TheSub) {
        [String]$MySub = $TheSub
        Write-JtLog -Where $This.ClassName -Text "DoStartIn... MySub: $MySub"
        
        [String]$MyFolderPath_Input = -join ($This.FolderPath_Input, "\", "*.*")
        [String]$MyFolderPath_Output = -join ($This.FolderPathWork, "\", $MySub)
        
        New-JtIoFolder -FolderPath $MyFolderPath_Output -Force
        
        $MyMsg = "Copying ... $MyFolderPath_Input to $MyFolderPath_Output"
        Write-JtLog -Where $This.ClassName -Text $MyMsg
    
        Copy-Item -Path $MyFolderPath_Input  -Destination $MyFolderPath_Output -Recurse


        [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyFolderPath_Output


        Convert-JtIoFilenamesAtFolderPath -FolderPath_Input $MyJtIoFolder_Output.GetPath()
    }
        [String]DoUseWorkSub([String]$TheSub) {
            [String]$MySub = $TheSub
            Write-JtLog -Where $This.ClassName -Text "DoUseWorkSub"
            
            $MyMsg = "Using sub dir $MySub in FolderPathWork: $This.FolderPathWork"
            Write-JtLog -Where $This.ClassName -Text $MyMsg
            
            [String]$MyFolderPath = -join ($This.FolderPathWork, "\", $MySub)
            New-JtIoFolder -FolderPath $MyFolderPath -Force
            
            return $MyFolderPath
        }
}

Function New-JtImageMagick_Tool {

    param(
        [Parameter(Mandatory = $True)]
        [String]$FolderPath_Input,
        [Parameter(Mandatory = $True)]
        [String]$FolderPathWork
    )

    [JtImageMagick_Tool]::new($FolderPath_Input, $FolderPathWork)
}

Function New-JtImageTwin {

    param (
        [String]$FolderPath_Input1,
        [Int16]$InputFileX1,
        [Int16]$InputFileY1,
        [String]$FolderPath_Output,
        [String]$Filename_Output
    )

    [String]$MyFunctionName = "New-JtImageTwin"
    [String]$MyFolderPath_Input1 = $FolderPath_Input1
    [String]$MyFolderPath_Output = $FolderPath_Output
    [String]$MyFilename_Output = $Filename_Output
    
    [JtIoFolder]$MyJtIoFolder_Work = Get-JtIoFolder_Work -Name $MyFunctionName
    [String]$MyFolderPath_Output_Work = $MyJtIoFolder_Work.GetPath()

    [String]$MyFolderPath_Output = $FolderPath_Output
    [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyFolderPath_Output -Force

    [String]$MyFilename_OutputBlank = $MyFilename_Output.replace(".jpg", "_blank.jpg")
    [JtImageMagick_Image]$MyJtImageMagick_Image = New-JtImageMagick_Image -FolderPath_Output $MyFolderPath_Output_Work -Filename_Output $MyFilename_OutputBlank

    [Int16]$IntSizeX = [Int16]$InputFileX1 + [Int16]$InputFileX1
    $MyJtImageMagick_Image.SetSize($IntSizeX, $InputFileY1)
    $MyJtImageMagick_Image.SetFont("Arial")
    $MyJtImageMagick_Image.SetGravity("NorthWest")
    $MyJtImageMagick_Image.SetPointsize(20)
    $MyJtImageMagick_Image.SetBackground("green")
    $MyJtImageMagick_Image.SetFill("yellow")
    $MyJtImageMagick_Image.SetLabel(".")
    [String]$MyFilePathImageWorkBlank = $MyJtImageMagick_Image.DoWrite()
    

    [String]$MyFilename_OutputLeft = $MyFilename_Output.replace(".jpg", "_left.jpg")
    $MyParameters = @{
        FolderPath_Input1 = $MyFolderPath_Input1
        FolderPath_Input2 = $MyFilePathImageWorkBlank
        FolderPath_Output = $MyJtIoFolder_Work.GetPath()
        Filename_Output = $MyFilename_OutputLeft
    }
    
    [JtImageMagick_Composite]$MyJtImageMagick_Composite = New-JtImageMagick_Composite @MyParameters
    $MyJtImageMagick_Composite.SetGravity("NorthWest")
    [String]$MyFilePathWorkImageLeft = $MyJtImageMagick_Composite.DoWrite()
    
    [String]$MyFilename_OutputRight = $MyFilename_Output.replace(".jpg", "_right.jpg")
    $MyParameters = @{
        FolderPath_Input1 = $MyFolderPath_Input1
        Filename_Input1 = $MyFilename_OutputLeft
        FolderPath_Input2 = $MyFolderPath_Output_Work
        Filename_Input2 = $MyFilename_Input
        FolderPath_Output   = $MyJtIoFolder_Work.GetPath()
        Filename_Output = $MyFilename_OutputRight
    }

    [JtImageMagick_Composite]$MyJtImageMagick_Composite = New-JtImageMagick_Composite @MyParameters
    $MyJtImageMagick_Composite.SetGravity("NorthEast")
    [String]$MyFilePathImageWorkFinal = $MyJtImageMagick_Composite.DoWrite()
    [String]$MyFilePath_Output = $MyJtIoFolder_Output.GetFilePath($MyFilename_Output)

    Write-JtLog_File -Where $MyFunctionName -Text "Copying $MyFilePathImageWorkFinal to ..." -FilePath $MyFilePath_Output
    Copy-Item $MyFilePathImageWorkFinal $MyFilePath_Output

    return $MyFilePath_Output
}


Export-ModuleMember -Function New-JtImageAttachRight

Export-ModuleMember -Function New-JtImageMagick_Composite
Export-ModuleMember -Function New-JtImageMagick_Convert
Export-ModuleMember -Function New-JtImageMagick_Convert_JpgToPdf 
Export-ModuleMember -Function New-JtImageMagick_Convert_PdfToJpg
Export-ModuleMember -Function New-JtImageMagick_Image
Export-ModuleMember -Function New-JtImageMagick_Item_Background
Export-ModuleMember -Function New-JtImageMagick_Item_Icon
Export-ModuleMember -Function New-JtImageMagick_Item_Login
Export-ModuleMember -Function New-JtImageMagick_Item_Cover
Export-ModuleMember -Function New-JtImageMagick_Resize
Export-ModuleMember -Function New-JtImageMagick_Tool

Export-ModuleMember -Function New-JtImageTwin