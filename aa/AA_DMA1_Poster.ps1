using module JtClass
using module JtImageMagick


Set-StrictMode -version latest
$ErrorActionPreference = "Stop"

function New-Overview_0A {

    param(
        [Parameter()]
        [String]$FolderSource,
        [Parameter()]
        [String]$FolderWork
    )

    [JtImageTool]$JtImageTool = New-JtImageTool -FolderSource $FolderSource -FolderWork $FolderWork
    $JtImageTool.DoStartIn("a")
    $JtImageTool.DoPdf2Jpg("a", "b")
    $JtImageTool.DoExtendJpgs("b", "c", 2100, 2100)
    $JtImageTool.DoMatrixJpgs("c", "d", 10)
}


function New-Overview_1A {

    param(
        [Parameter()]
        [String]$FolderSource,
        [Parameter()]
        [String]$FolderWork
    )

    [JtImageTool]$JtImageTool = New-JtImageTool -FolderSource $FolderSource -FolderWork $FolderWork
    $JtImageTool.DoStartIn("a")
    $JtImageTool.DoPdf2Jpg("a", "b")
    $JtImageTool.DoExtendJpgs("b", "c", 2100, 2970)
    $JtImageTool.DoCropJpgs("c", "d", 2100, 2100)
    $JtImageTool.DoMatrixJpgs("d", "e", 10)
}

function New-Overview_2A {

    param(
        [Parameter()]
        [String]$FolderSource,
        [Parameter()]
        [String]$FolderWork
    )

    [JtImageTool]$JtImageTool = New-JtImageTool -FolderSource $FolderSource -FolderWork $FolderWork
    $JtImageTool.DoStartIn("a")
    $JtImageTool.DoExtendJpgs("a", "b", 2000, 2000)
    $JtImageTool.DoMatrixJpgs("b", "c", 10)
}

function New-Overview_2B {

    param(
        [Parameter()]
        [String]$FolderSource,
        [Parameter()]
        [String]$FolderWork
    )

    [JtImageTool]$JtImageTool = New-JtImageTool -FolderSource $FolderSource -FolderWork $FolderWork
    $JtImageTool.DoStartIn("a")
    $JtImageTool.DoPdf2Jpg("a", "b")
    $JtImageTool.DoExtendJpgs("b", "c", 2100, 2970)
    $JtImageTool.DoCropJpgs("c", "d", 2100, 2100)
    $JtImageTool.DoMatrixJpgs("d", "e", 10)
}



function New-Overview_2C {

    param(
        [Parameter()]
        [String]$FolderSource,
        [Parameter()]
        [String]$FolderWork
    )

    [JtImageTool]$JtImageTool = New-JtImageTool -FolderSource $FolderSource -FolderWork $FolderWork
    $JtImageTool.DoStartIn("a")
    $JtImageTool.DoPdf2Jpg("a", "b")
    $JtImageTool.DoExtendJpgs("b", "c", 2100, 2970)
    $JtImageTool.DoCropJpgs("c", "d", 2100, 2100)
    $JtImageTool.DoMatrixJpgs("c", "d", 8)
}

function New-Overview_3a {
    param (
        [Parameter()]
        [String]$FolderSource, 
        [Parameter()]
        [String]$FolderWork
    )

    [JtImageTool]$JtImageTool = New-JtImageTool -FolderSource $FolderSource -FolderWork $FolderWork
    $JtImageTool.DoStartIn("a")
    $JtImageTool.DoPdf2Jpg("a", "b")
    $JtImageTool.DoExtendJpgs("b", "c", 2100, 2970)
    $JtImageTool.DoMatrixJpgs("c", "d", 8)
}

function New-Overview_3b {
    param (
        [Parameter()]
        [String]$FolderSource, 
        [Parameter()]
        [String]$FolderWork
    )

    [JtImageTool]$JtImageTool = New-JtImageTool -FolderSource $FolderSource -FolderWork $FolderWork
    $JtImageTool.DoStartIn("a")
    $JtImageTool.DoPdf2Jpg("a", "b")
    $JtImageTool.DoExtendJpgs("b", "c", 2100, 2970)
    $JtImageTool.DoMatrixJpgs("c", "d", 8)
}


function New-Overview_3c {
    param (
        [Parameter()]
        [String]$FolderSource, 
        [Parameter()]
        [String]$FolderWork
    )

    [JtImageTool]$JtImageTool = New-JtImageTool -FolderSource $FolderSource -FolderWork $FolderWork
    $JtImageTool.DoStartIn("a")
    $JtImageTool.DoPdf2Jpg("a", "b")
    $JtImageTool.DoExtendJpgs("b", "c", 2100, 2970)
    $JtImageTool.DoMatrixJpgs("c", "d", 8)
}


function New-PosterRect {

    param(
        [Parameter()]
        [String]$FolderSource,
        [Parameter()]
        [String]$FolderWork
    )

    [JtImageTool]$JtImageTool = New-JtImageTool -FolderSource $FolderSource -FolderWork $FolderWork
    $JtImageTool.DoStartIn("a")
    $JtImageTool.DoMatrixJpgs("a", "b", 8)
}

function New-PosterSquare {

    param(
        [Parameter()]
        [String]$FolderSource,
        [Parameter()]
        [String]$FolderWork
    )

    [JtImageTool]$JtImageTool = New-JtImageTool -FolderSource $FolderSource -FolderWork $FolderWork
    $JtImageTool.DoStartIn("a")
    $JtImageTool.DoMatrixJpgs("a", "b", 10)
}
New-Overview_3c -FolderSource "D:\Seafile\al-cad-20w\3.POSTER\POSTER.3C\a.aX_quer_pdf"    -FolderWork "C:\_inventory\temp\poster\aufgabe_3c"
pause
New-Overview_0a -FolderSource "D:\Seafile\al-cad-20w\3.POSTER\POSTER.0A\a.a4_pdf"         -FolderWork "C:\_inventory\temp\poster\aufgabe_0a"
New-Overview_1a -FolderSource "D:\Seafile\al-cad-20w\3.POSTER\POSTER.1A\a.a4_pdf"         -FolderWork "C:\_inventory\temp\poster\aufgabe_1a"
New-Overview_2a -FolderSource "D:\Seafile\al-cad-20w\3.POSTER\POSTER.2A\a.3000x3000_jpg"  -FolderWork "C:\_inventory\temp\poster\aufgabe_2a"
New-Overview_2b -FolderSource "D:\Seafile\al-cad-20w\3.POSTER\POSTER.2B\a.a4_pdf"         -FolderWork "C:\_inventory\temp\poster\aufgabe_2b"
New-Overview_2c -FolderSource "D:\Seafile\al-cad-20w\3.POSTER\POSTER.2C\a.aX_quer_pdf"    -FolderWork "C:\_inventory\temp\poster\aufgabe_2c"
New-Overview_3a -FolderSource "D:\Seafile\al-cad-20w\3.POSTER\POSTER.3A\a.a3_quer_pdf"    -FolderWork "C:\_inventory\temp\poster\aufgabe_3a"
New-Overview_3b -FolderSource "D:\Seafile\al-cad-20w\3.POSTER\POSTER.3B\a.a3_quer_pdf"    -FolderWork "C:\_inventory\temp\poster\aufgabe_3b"




# New-PosterRect -FolderSource "D:\Seafile\al-cad-20w\3.POSTER\39.DUMMY_SQUARE.POSTER\a.square_2100x2100" -FolderWork "C:\_inventory\temp\dummy_square"
# New-PosterRect -FolderSource "D:\Seafile\al-cad-20w\3.POSTER\39.DUMMY_RECT.POSTER\a.rect_2970x2100" -FolderWork "C:\_inventory\temp\dummy_rect"
# New-PosterRect -FolderSource "D:\Seafile\al-apps\apps\Documents\poster_rect\a" -FolderWork "C:\_inventory\temp\poster_rect"
# New-PosterSquare -FolderSource "D:\Seafile\al-apps\apps\Documents\poster_square\a" -FolderWork "C:\_inventory\temp\poster_square"
