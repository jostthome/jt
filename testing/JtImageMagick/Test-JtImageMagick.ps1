using module JtImageMagick
using module JtIo

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"

# Test-JtImageMagick_Init


# Test-JtImageMagick0

Function Get-JtImageLine {

    param (
        [String]$FolderPath_Input1,
        [String]$Filename_Input1,
        [String]$InputFileX1,
        [String]$InputFileY1,
        [String]$FolderPath_Input2,
        [String]$Filename_Input2,
        [String]$InputFileX2,
        [String]$InputFileY2,
        [String]$FolderPath_Output
    )
    [String]$MyFolderPath_Output = $FolderPath_Output
    [JtIoFolder]$MyFolderPath_Output = New-JtIoFolder -FolderPath $MyFolderPath_Output -Force
    [String]$MyFilename_Output = "imageline.jpg"

    [JtImageMagick_Image]$MyJtImageMagick_Image = New-JtImageMagick_Image -FolderPath_Output $MyFolderPath_Output -Filename_Output $MyFilename_Output

    [Int16]$IntSizeX = [Int16]$InputFileX1 + [Int16]$InputFileX2
    $MyJtImageMagick_Image.SetSize($IntSizeX, $InputFileY1)
    $MyJtImageMagick_Image.SetFont("Arial")
    $MyJtImageMagick_Image.SetGravity("NorthWest")
    $MyJtImageMagick_Image.SetPointsize(20)
    $MyJtImageMagick_Image.SetBackground("green")
    $MyJtImageMagick_Image.SetFill("yellow")
    $MyJtImageMagick_Image.SetLabel(".")
    [String]$FilePathImageWork = $MyJtImageMagick_Image.DoWrite()
    [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $FilePathImageWork
    [String]$MyFolderPath_Input2 = $MyJtIoFile.GetFolderPath()
    [String]$MyFilename_Input2 = $MyJtIoFile.GetName()

    $MyParameters = @{
        FolderPath_Input1 = $MyFolderPath_Input1
        Filename_Input1   = $MyFilename_Input1
        FolderPath_Input2 = $MyFolderPath_Input2
        Filename_Input2   = $MyFilename_Input2
        FolderPath_Output = $MyFolderPath_Output
        Filename_Output   = "step1.jpg"
    }
    $MyParameters

    [JtImageMagick_Composite]$MyJtImageMagick_Composite = New-JtImageMagick_Composite @MyParameters
    $MyJtImageMagick_Composite.SetGravity("NorthWest")
    return $MyJtImageMagick_Composite.DoWrite()

    [String]$FilePathImageWork = $MyJtImageMagick_Image.DoWrite()
    $MyParameters = @{
        FolderPath_Input1 = $MyFolderPath_Input1
        Filename_Input1   = $MyFilename_Input1
        FolderPath_Input2 = $MyFolderPath_Input2
        Filename_Input2   = $MyFilename_Input2
        FolderPath_Output = $MyFolderPath_Output
        Filename_Output   = "step2.jpg"
    }
    $MyParameters

    [JtImageMagick_Composite]$MyJtImageMagick_Composite = New-JtImageMagick_Composite @MyParameters
    $MyJtImageMagick_Composite.SetGravity("NorthEast")
    return $MyJtImageMagick_Composite.DoWrite()
}

Function Test-JtImageMagick1 {

    [JtIoFolder]$WorkFolder = Get-JtIoFolder_Work -Name "JtImageMagick" -Init $True
    [String]$MyFolderPath_Output = $WorkFolder 
    [String]$MyFilename_Output = "Test-JtImageMagick1.jpg"

    [JtImageMagick_Image]$MyJtImageMagick_Image = New-JtImageMagick_Image -FolderPath_Output $MyFolderPath_Output -Filename_Output $MyFilename_Output
    $MyJtImageMagick_Image.SetSize(500, 30)
    $MyJtImageMagick_Image.SetFont("Arial")
    $MyJtImageMagick_Image.SetGravity("NorthWest")
    $MyJtImageMagick_Image.SetPointsize(20)
    $MyJtImageMagick_Image.SetBackground("red")
    $MyJtImageMagick_Image.SetFill("white")
    
    $MyLabel = $MyFilename_Output
    $MyJtImageMagick_Image.SetLabel($MyLabel)
    return $MyJtImageMagick_Image.DoWrite()
}
# Test-JtImageMagick1

Function Test-JtImageMagick2 {

    [JtIoFolder]$MyJtIoFolderWork = Get-JtIoFolder_Work -Name "JtImageMagick" -Init $True
    [String]$MyFolderPath_Output = $MyJtIoFolderWork.GetPath()
    [String]$MyFilename_Output = "Test-JtImageMagick2.jpg"

    [JtImageMagick_Image]$MyJtImageMagick_Image = New-JtImageMagick_Image -FolderPath_Output $MyFolderPath_Output -Filename_Output $MyFilename_Output
    $MyJtImageMagick_Image.SetSize(1000, 300)
    $MyJtImageMagick_Image.SetFont("Arial")
    $MyJtImageMagick_Image.SetGravity("NorthWest")
    $MyJtImageMagick_Image.SetPointsize(20)
    $MyJtImageMagick_Image.SetBackground("green")
    $MyJtImageMagick_Image.SetFill("yellow")
    
    $MyLabel = $MyFilename_Output
    $MyJtImageMagick_Image.SetLabel($MyLabel)
    return $MyJtImageMagick_Image.DoWrite()

}
# Test-JtImageMagick2
Function Test-JtImageMagick3 {

    [JtIoFolder]$WorkFolder = Get-JtIoFolder_Work -Name "JtImageMagick" -Init $True

    $MyParameters = @{
        FilePath_Input1   = Test-JtImageMagick1
        FilePath_Input2   = Test-JtImageMagick2  
        FolderPath_Output = $WorkFolder.GetPath()
        Filename_Output   = "Test-JtImageMagick3.jpg"
    }

    $MyParameters

    [JtImageMagick_Composite]$MyJtImageMagick_Composite = New-JtImageMagick_Composite @MyParameters
    $MyJtImageMagick_Composite.SetGravity("NorthWest")
    return $MyJtImageMagick_Composite.DoWrite()
}
#Test-JtImageMagick3 

$TheParams = @{
    FilePath_Input1   = "d:\temp\twin\test1.jpg"
    InputFileX1      = 600
    InputFileY1      = 400
    FolderPath_Output = "d:\temp\twin"
    Filename_Output   = "New-JtImageTwin.jpg"
}

# New-JtImageTwin -params @TheParams

$TheParams = @{
    FilePath_Input1   = "d:\temp\twin\New-JtImageTwin.jpg"
    InputFileX1      = 1200
    InputFileY1      = 400
    FilePath_Input2   = "d:\temp\twin\test2.jpg"
    InputFileX2      = 600
    InputFileY2      = 400
    FolderPath_Output = "d:\temp\twin"
    Filename_Output   = "New-JtImageAttachRight.jpg"
}
# New-JtImageAttachRight -params @TheParams

Function Test-JtImageMagickPdfToJpg {

    [String]$MyFunctionName = "Test-JtImageMagickPdfToJpg"
    [JtIoFolder]$MyJtIoFolder_Output = Get-JtIoFolder_Work -Name $MyFunctionName
    [String]$MyFolderPath_Output = $MyJtIoFolder_Output.GetPath()

    $MyParam = @{
        FolderPath_Input    = "C:\apps\Documents"
        Filename_Input    = "test.pdf"
        FolderPath_Output = $MyFolderPath_Output
    }
    New-JtImageMagick_Convert_PdfToJpg @MyParam
}

Test-JtImageMagickPdfToJpg

Function Test-JtImageMagickJpgToPdf {

    [String]$MyFunctionName = "Test-JtImageMagickJpgToPdf"
    [JtIoFolder]$MyJtIoFolder_Output = Get-JtIoFolder_Work -Name $MyFunctionName
    [String]$MyFolderPath_Output = $MyJtIoFolder_Output.GetPath()

    $MyParam = @{
        FolderPath_Input    = "C:\apps\Documents"
        Filename_Input    = "test.jpg"
        FolderPath_Output = $MyFolderPath_Output
    }
    $MyParam
    New-JtImageMagick_Convert_JpgToPdf @MyParam
}

Test-JtImageMagickJpgToPdf

