using module JtClass
using module JtImageMagick


Set-StrictMode -version latest
$ErrorActionPreference = "Stop"

function New-JtOverview_0A {

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


function New-JtOverview_1A {

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

function New-JtOverview_2A {

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

function New-JtOverview_2B {

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



function New-JtOverview_2C {

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

function New-JtOverview_3a {
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

function New-JtOverview_3b {
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


function New-JtOverview_3c {
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


function New-JtPosterRect {

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

function New-JtPosterSquare {

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

New-JtOverview_4a -FolderSource "D:\Seafile\al-cad-20w\3.POSTER\POSTER.4A\a.aX_quer_pdf"    -FolderWork "C:\_inventory\temp\poster\aufgabe_4a"
pause
New-JtOverview_0a -FolderSource "D:\Seafile\al-cad-20w\3.POSTER\POSTER.0A\a.a4_pdf"         -FolderWork "C:\_inventory\temp\poster\aufgabe_0a"
New-JtOverview_1a -FolderSource "D:\Seafile\al-cad-20w\3.POSTER\POSTER.1A\a.a4_pdf"         -FolderWork "C:\_inventory\temp\poster\aufgabe_1a"
New-JtOverview_2a -FolderSource "D:\Seafile\al-cad-20w\3.POSTER\POSTER.2A\a.3000x3000_jpg"  -FolderWork "C:\_inventory\temp\poster\aufgabe_2a"
New-JtOverview_2b -FolderSource "D:\Seafile\al-cad-20w\3.POSTER\POSTER.2B\a.a4_pdf"         -FolderWork "C:\_inventory\temp\poster\aufgabe_2b"
New-JtOverview_2c -FolderSource "D:\Seafile\al-cad-20w\3.POSTER\POSTER.2C\a.aX_quer_pdf"    -FolderWork "C:\_inventory\temp\poster\aufgabe_2c"
New-JtOverview_3a -FolderSource "D:\Seafile\al-cad-20w\3.POSTER\POSTER.3A\a.a3_quer_pdf"    -FolderWork "C:\_inventory\temp\poster\aufgabe_3a"
New-JtOverview_3b -FolderSource "D:\Seafile\al-cad-20w\3.POSTER\POSTER.3B\a.a3_quer_pdf"    -FolderWork "C:\_inventory\temp\poster\aufgabe_3b"
New-JtOverview_3c -FolderSource "D:\Seafile\al-cad-20w\3.POSTER\POSTER.3C\a.aX_quer_pdf"    -FolderWork "C:\_inventory\temp\poster\aufgabe_3c"




# New-JtPosterRect -FolderSource "D:\Seafile\al-cad-20w\3.POSTER\39.DUMMY_SQUARE.POSTER\a.square_2100x2100" -FolderWork "C:\_inventory\temp\dummy_square"
# New-JtPosterRect -FolderSource "D:\Seafile\al-cad-20w\3.POSTER\39.DUMMY_RECT.POSTER\a.rect_2970x2100" -FolderWork "C:\_inventory\temp\dummy_rect"
# New-JtPosterRect -FolderSource "D:\Seafile\al-apps\apps\Documents\poster_rect\a" -FolderWork "C:\_inventory\temp\poster_rect"
# New-JtPosterSquare -FolderSource "D:\Seafile\al-apps\apps\Documents\poster_square\a" -FolderWork "C:\_inventory\temp\poster_square"
