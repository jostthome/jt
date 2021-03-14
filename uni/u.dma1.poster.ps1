using module Jt  
using module JtImageMagick

Set-StrictMode -version latest
$ErrorActionPreference = "Stop"

Function New-JtPoster_Matrix_2020_0A {

    param(
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPathWork
    )

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Work = $FolderPathWork
    [JtImageMagick_Tool]$MyJtImageMagick_Tool = New-JtImageMagick_Tool -FolderPath_Input $MyFolderPath_Input -FolderPathWork $MyFolderPath_Work
    $MyJtImageMagick_Tool.DoStartIn("a")
    $MyJtImageMagick_Tool.DoPdf2Jpg("a", "b")
    $MyJtImageMagick_Tool.DoExtendJpgs("b", "c", 2100, 2100)
    $MyJtImageMagick_Tool.DoMatrixJpgs("c", "d", 10)
}
Function New-JtPoster_Matrix_2020_1A {

    param(
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPathWork
    )
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Work = $FolderPathWork
    [JtImageMagick_Tool]$MyJtImageMagick_Tool = New-JtImageMagick_Tool -FolderPath_Input $MyFolderPath_Input -FolderPathWork $MyFolderPath_Work
    $MyJtImageMagick_Tool.DoStartIn("a")
    $MyJtImageMagick_Tool.DoPdf2Jpg("a", "b")
    $MyJtImageMagick_Tool.DoExtendJpgs("b", "c", 2100, 2970)
    $MyJtImageMagick_Tool.DoCropJpgs("c", "d", 2100, 2100)
    $MyJtImageMagick_Tool.DoMatrixJpgs("d", "e", 10)
}
Function New-JtPoster_Matrix_2020_2A {

    param(
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPathWork
    )

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Work = $FolderPathWork
    [JtImageMagick_Tool]$MyJtImageMagick_Tool = New-JtImageMagick_Tool -FolderPath_Input $MyFolderPath_Input -FolderPathWork $MyFolderPath_Work
    $MyJtImageMagick_Tool.DoStartIn("a")
    $MyJtImageMagick_Tool.DoExtendJpgs("a", "b", 2000, 2000)
    $MyJtImageMagick_Tool.DoMatrixJpgs("b", "c", 10)
}
Function New-JtPoster_Matrix_2020_2B {

    param(
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPathWork
    )
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Work = $FolderPathWork
    [JtImageMagick_Tool]$MyJtImageMagick_Tool = New-JtImageMagick_Tool -FolderPath_Input $MyFolderPath_Input -FolderPathWork $MyFolderPath_Work
    $MyJtImageMagick_Tool.DoStartIn("a")
    $MyJtImageMagick_Tool.DoPdf2Jpg("a", "b")
    $MyJtImageMagick_Tool.DoExtendJpgs("b", "c", 2100, 2970)
    $MyJtImageMagick_Tool.DoCropJpgs("c", "d", 2100, 2100)
    $MyJtImageMagick_Tool.DoMatrixJpgs("d", "e", 10)
}
Function New-JtPoster_Matrix_2020_2C {

    param(
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPathWork
    )

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Work = $FolderPathWork
    [JtImageMagick_Tool]$MyJtImageMagick_Tool = New-JtImageMagick_Tool -FolderPath_Input $MyFolderPath_Input -FolderPathWork $MyFolderPath_Work
    $MyJtImageMagick_Tool.DoStartIn("a")
    $MyJtImageMagick_Tool.DoPdf2Jpg("a", "b")
    $MyJtImageMagick_Tool.DoExtendJpgs("b", "c", 2100, 2970)
    $MyJtImageMagick_Tool.DoCropJpgs("c", "d", 2100, 2100)
    $MyJtImageMagick_Tool.DoMatrixJpgs("c", "d", 8)
}
Function New-JtPoster_Matrix_2020_3a {
    param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPathWork
    )
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Work = $FolderPathWork
    [JtImageMagick_Tool]$MyJtImageMagick_Tool = New-JtImageMagick_Tool -FolderPath_Input $MyFolderPath_Input -FolderPathWork $MyFolderPath_Work
    $MyJtImageMagick_Tool.DoStartIn("a")
    $MyJtImageMagick_Tool.DoPdf2Jpg("a", "b")
    $MyJtImageMagick_Tool.DoExtendJpgs("b", "c", 2100, 2970)
    $MyJtImageMagick_Tool.DoMatrixJpgs("c", "d", 8)
}
Function New-JtPoster_Matrix_2020_3b {
    param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPathWork
    )
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Work = $FolderPathWork
    [JtImageMagick_Tool]$MyJtImageMagick_Tool = New-JtImageMagick_Tool -FolderPath_Input $MyFolderPath_Input -FolderPathWork $MyFolderPath_Work
    $MyJtImageMagick_Tool.DoStartIn("a")
    $MyJtImageMagick_Tool.DoPdf2Jpg("a", "b")
    $MyJtImageMagick_Tool.DoExtendJpgs("b", "c", 2100, 2970)
    $MyJtImageMagick_Tool.DoMatrixJpgs("c", "d", 8)
}
Function New-JtPoster_Matrix_2020_3c {
    param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPathWork
    )
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Work = $FolderPathWork
    [JtImageMagick_Tool]$MyJtImageMagick_Tool = New-JtImageMagick_Tool -FolderPath_Input $MyFolderPath_Input -FolderPathWork $MyFolderPath_Work
    $MyJtImageMagick_Tool.DoStartIn("a")
    $MyJtImageMagick_Tool.DoPdf2Jpg("a", "b")
    $MyJtImageMagick_Tool.DoExtendJpgs("b", "c", 2100, 2970)
    $MyJtImageMagick_Tool.DoMatrixJpgs("c", "d", 8)
}
Function New-JtPoster_Matrix_2020_4a {
    param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPathWork
    )
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Work = $FolderPathWork
    [JtImageMagick_Tool]$MyJtImageMagick_Tool = New-JtImageMagick_Tool -FolderPath_Input $MyFolderPath_Input -FolderPathWork $MyFolderPath_Work
    $MyJtImageMagick_Tool.DoStartIn("a")
    $MyJtImageMagick_Tool.DoPdf2Jpg("a", "b")
    $MyJtImageMagick_Tool.DoExtendJpgs("b", "c", 2100, 2970)
    $MyJtImageMagick_Tool.DoMatrixJpgs("c", "d", 8)
}
Function New-JtPoster_Matrix_2020_4b {
    param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPathWork
    )
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Work = $FolderPathWork
    [JtImageMagick_Tool]$MyJtImageMagick_Tool = New-JtImageMagick_Tool -FolderPath_Input $MyFolderPath_Input -FolderPathWork $MyFolderPath_Work
    $MyJtImageMagick_Tool.DoStartIn("a")
    $MyJtImageMagick_Tool.DoPdf2Jpg("a", "b")
    $MyJtImageMagick_Tool.DoExtendJpgs("b", "c", 2100, 2970)
    $MyJtImageMagick_Tool.DoMatrixJpgs("c", "d", 8)
}
Function New-JtPoster_Matrix_2020_4c {
    param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPathWork
    )
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Work = $FolderPathWork
    [JtImageMagick_Tool]$MyJtImageMagick_Tool = New-JtImageMagick_Tool -FolderPath_Input $MyFolderPath_Input -FolderPathWork $MyFolderPath_Work
    $MyJtImageMagick_Tool.DoStartIn("a")
    $MyJtImageMagick_Tool.DoPdf2Jpg("a", "b")
    $MyJtImageMagick_Tool.DoExtendJpgs("b", "c", 2100, 2970)
    $MyJtImageMagick_Tool.DoMatrixJpgs("c", "d", 8)
}
Function New-JtPoster_Matrix_2019_4c {
    param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPathWork
    )
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Work = $FolderPathWork
    [JtImageMagick_Tool]$MyJtImageMagick_Tool = New-JtImageMagick_Tool -FolderPath_Input $MyFolderPath_Input -FolderPathWork $MyFolderPath_Work
    $MyJtImageMagick_Tool.DoInitFolderPathWork()
    $MyJtImageMagick_Tool.DoStartIn("a")
    $MyJtImageMagick_Tool.DoPdf2Jpg("a", "b")
    $MyJtImageMagick_Tool.DoExtendJpgs("b", "c", 2100, 2970)
    $MyJtImageMagick_Tool.DoMatrixJpgs("c", "d", 8)
}
Function New-JtPosterRect {
    param(
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPathWork
    )

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Work = $FolderPathWork
    [JtImageMagick_Tool]$MyJtImageMagick_Tool = New-JtImageMagick_Tool -FolderPath_Input $MyFolderPath_Input -FolderPathWork $MyFolderPath_Work
    $MyJtImageMagick_Tool.DoStartIn("a")
    $MyJtImageMagick_Tool.DoMatrixJpgs("a", "b", 8)
}
Function New-JtPosterSquare {
    param(
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPathWork
    )
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Work = $FolderPathWork
    [JtImageMagick_Tool]$MyJtImageMagick_Tool = New-JtImageMagick_Tool -FolderPath_Input $MyFolderPath_Input -FolderPathWork $MyFolderPath_Work
    $MyJtImageMagick_Tool.DoStartIn("a")
    $MyJtImageMagick_Tool.DoMatrixJpgs("a", "b", 10)
}

New-JtPoster_Matrix_2020_4c -FolderPath_Input "D:\Seafile\al-cad\9.POSTER\9.POSTER.2020WS.4c\input" -FolderPathWork "C:\_inventory\out\poster_matrix\ws2020_4c"
New-JtPoster_Matrix_2020_4b -FolderPath_Input "D:\Seafile\al-cad\9.POSTER\9.POSTER.2020WS.4b\input" -FolderPathWork "C:\_inventory\out\poster_matrix\ws2020_4b"
New-JtPoster_Matrix_2020_4a -FolderPath_Input "D:\Seafile\al-cad\9.POSTER\9.POSTER.2020WS.4a\input" -FolderPathWork "C:\_inventory\out\poster_matrix\ws2020_4a"
New-JtPoster_Matrix_2020_3c -FolderPath_Input "D:\Seafile\al-cad\9.POSTER\9.POSTER.2020WS.3c\input" -FolderPathWork "C:\_inventory\out\poster_matrix\ws2020_3c"
New-JtPoster_Matrix_2020_3b -FolderPath_Input "D:\Seafile\al-cad\9.POSTER\9.POSTER.2020WS.3b\input" -FolderPathWork "C:\_inventory\out\poster_matrix\ws2020_3b"
New-JtPoster_Matrix_2020_3a -FolderPath_Input "D:\Seafile\al-cad\9.POSTER\9.POSTER.2020WS.3a\input" -FolderPathWork "C:\_inventory\out\poster_matrix\ws2020_3a"
New-JtPoster_Matrix_2020_2c -FolderPath_Input "D:\Seafile\al-cad\9.POSTER\9.POSTER.2020WS.2c\input" -FolderPathWork "C:\_inventory\out\poster_matrix\ws2020_2c"
New-JtPoster_Matrix_2020_2b -FolderPath_Input "D:\Seafile\al-cad\9.POSTER\9.POSTER.2020WS.2b\input" -FolderPathWork "C:\_inventory\out\poster_matrix\ws2020_2b"
New-JtPoster_Matrix_2020_2a -FolderPath_Input "D:\Seafile\al-cad\9.POSTER\9.POSTER.2020WS.2a\input" -FolderPathWork "C:\_inventory\out\poster_matrix\ws2020_2a"
New-JtPoster_Matrix_2020_1a -FolderPath_Input "D:\Seafile\al-cad\9.POSTER\9.POSTER.2020WS.1a\input" -FolderPathWork "C:\_inventory\out\poster_matrix\ws2020_1a"
New-JtPoster_Matrix_2020_0a -FolderPath_Input "D:\Seafile\al-cad\9.POSTER\9.POSTER.2020WS.0a\input" -FolderPathWork "C:\_inventory\out\poster_matrix\ws2020_0a"
New-JtPoster_Matrix_2019_4c -FolderPath_Input "D:\Seafile\al-cad\9.POSTER\9.POSTER.2019WS.4c\input" -FolderPathWork "C:\_inventory\out\poster_matrix\ws2019_4c"

# New-JtPosterRect -FolderPath_Input "D:\Seafile\al-cad-20w\3.POSTER\39.DUMMY_SQUARE.POSTER\a.square_2100x2100" -FolderPathWork "C:\_inventory\temp\dummy_square"
# New-JtPosterRect -FolderPath_Input "D:\Seafile\al-cad-20w\3.POSTER\39.DUMMY_RECT.POSTER\a.rect_2970x2100" -FolderPathWork "C:\_inventory\temp\dummy_rect"
# New-JtPosterRect -FolderPath_Input "D:\Seafile\al-apps\apps\Documents\poster_rect\a" -FolderPathWork "C:\_inventory\temp\poster_rect"
# New-JtPosterSquare -FolderPath_Input "D:\Seafile\al-apps\apps\Documents\poster_square\a" -FolderPathWork "C:\_inventory\temp\poster_square"
