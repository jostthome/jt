using module JtFolderSummary

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"

Function New-JtResultsSummary{

    Param (
        [Parameter()]
        [String]$Label,
        [Parameter()]
        [String]$Path,
        [Parameter()]
        [String]$Sub
    )
    
    New-JtFolderSummaryMeta -Label $Label -Path $Path -Sub $Sub
}

New-JtResultsSummary -Label "021.PCS_NOTEBOOKS" -Path "D:\Seafile\al-it\0.INVENTORY\02.INPUT" -Sub "021.PCS_NOTEBOOKS"




