using module JtClass
using module JtCsv
using module JtIo
using module JtInfi
using module JtRep
using module JtReps
using module JtTbl

class JtCsvGenerator : JtClass {

    [JtIoFolder]$JtIoFolder 
    [String]$Label

    JtCsvGenerator([JtIoFolder]$MyJtIoFolder, [String]$MyLabel) : Base() {
        $This.ClassName = "JtCsvGenerator"
        $This.JtIoFolder = $MyJtIoFolder
        $This.Label = $MyLabel
    
        [JtInfi]$JtInfi = New-JtInfi -JtIoFolder $This.JtIoFolder

        [System.Collections.ArrayList]$MyReps = [JtReps]::GetReps()

        foreach ($MyRep in $MyReps) {
            [JtRep]$Rep = $MyRep

            [Boolean]$UseLine = $True
            if ($True -eq $Rep.HideSpezial ) {
                if ($JtInfi.GetIsNormalBoot()) {
                    $UseLine = $True
                }
                else {
                    $UseLine = $False
                }
            }
            else {
                $UseLine = $True
            }
            
            # test it
            [Boolean]$UseLine = $True
            # test it
            
            [JtTblTable]$JtTblTable = New-JtTblTable -Label $Rep.GetLabel()
            if ($True -eq $UseLine) {
                [JtTblRow]$JtTblRow = $Rep.GetJtTblRow($JtInfi)
                $JtTblTable.AddRow($JtTblRow) | Out-Null
            }

            [String]$TheLabel = $JtTblTable.GetLabel()
            [JtIoFolder]$TheFolderCsv = $This.GetFolderCsv()

            New-JtCsvWriteTbl -Label $TheLabel -JtIoFolder $TheFolderCsv -JtTblTable $JtTblTable
        }
    }


    [JtIoFolder]GetFolderCsv() {
        [JtIoFolder]$FolderCsv = $This.JtIoFolder.GetSubfolder("csv", $True)
        return $FolderCsv
    }
}

function New-JtCsvGenerator {

    Param (
        [Parameter(Mandatory = $true)]
        [JtIoFolder]$JtIoFolder,
        [Parameter(Mandatory = $false)]
        [String]$Label
    )
    [String]$MyLabel = ""
    if (!($Label)) {
        $MyLabel = "NO LABEL"
    }
    else {
        $MyLabel = $Label
    }


    [JtCsvGenerator]::new($JtIoFolder, $MyLabel) 
}
