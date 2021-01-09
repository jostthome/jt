using module JtIo
using module JtTbl
using module JtInfi
using module JtRep

class JtRep_Timestamps : JtRep {

    JtRep_Timestamps () : Base("report.timestamps") {
        $This.HideSpezial = $False
    }

    [JtTblRow]GetJtTblRow([JtInfi]$JtInfi) {
        [JtIoFolder]$MyFolderBase = $JtInfi.GetFolder()
        [JtIoFolder]$MyFolder = $MyFolderBase.GetSubfolder("timestamp")
        [String]$Suffix = -join ("*.time", [JtIo]::FilenameExtension_Meta)

        [String]$MyLabel = ""
        [String]$MyValue = ""
        
        [String]$MyMaxTime = ""
        [String]$MyMaxDate = ""
        
        [int32]$i = 0

        $Files = $MyFolder.GetJtIoFilesWithFilter($Suffix)
        [JtTblRow]$JtTblRowFiles = New-JtTblRow
        Foreach ($File in $Files) {
            [String]$ColumnName = -join ("Time", $i)
    
            # example: report.2020-05-02_17-35-42.export.time.meta
            [String]$Filename = $File.GetName()


            [String]$Suffix = -join (".", [JtIo]::FilenameSuffix_Time, [JtIo]::FilenameExtension_Meta)
            [String]$TheName = $Filename.Replace($Suffix, "")
            [String]$TheName = $TheName.Replace( -join ([JtIo]::FilenamePrefix_Report, "."), "")

            $Parts = $TheName.Split(".")
            $MyLabel = -join ("Time", $i)

            $MyValue = $TheName
            $TimeInfo = ""
            try {

                $TimeInfo = [datetime]::ParseExact($Parts[0], "yyyy-MM-dd_HH-mm-ss", $null);  
                $MyMaxTime = $TimeInfo.ToString("HHmm")
                $MyMaxDate = $TimeInfo.ToString("yyyy-MM-dd")
            }
            catch {
                Write-JtError -Text ( -join ("Problem:", $Parts[0]))
            }

            $JtTblRowFiles.Add($MyLabel, $MyValue) | Out-Null

            $i = $i + 1
        }


        [JtTblRow]$JtTblRow = New-JtTblRow

        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().SystemId) | Out-Null
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().Errors) | Out-Null

        [String]$MyLabel = "TimeCount"
        [String]$MyValue = $i
        $JtTblRow.Add($MyLabel, $MyValue) | Out-Null

        [String]$MyLabel = "TimeTime"
        [String]$MyValue = $MyMaxTime
        $JtTblRow.Add($MyLabel, $MyValue) | Out-Null

        [String]$MyLabel = "TimeDate"
        [String]$MyValue = $MyMaxDate
        $JtTblRow.Add($MyLabel, $MyValue) | Out-Null

        [String]$MyLabel = "Errors"
        [String]$Path = $JtInfi.GetJtInf_AFolder().Get_FolderPath()
        [String]$intErrors = [JtIo]::GetErrors($Path)
        [String]$MyValue = $IntErrors
        $JtTblRow.Add($MyLabel, $MyValue) | Out-Null
        $JtTblRow.Join($JtTblRowFiles)
        return $JtTblRow
    }
}
function New-JtRep_Timestamps {

    [JtRep_Timestamps]::new() 

}
