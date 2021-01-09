

class JtClass {
    
    hidden [String]$ClassName = "CLASSNAME not set!!!"

    static [String]$Version = "2021-01-03"

    [String]GetVersion() {
        [String]$Result = [JtClass]::Version
        return $Result
    } 
    

    
    JtClass() {
    }
} 



class JtLog {
    
    static [String]$C_inventory = "c:\_inventory"
    static [String]$C_inventory_Report = "c:\_inventory\report"

    static [String]$FilePathError = $Null
    static [String]$FilePathFolder = $Null
    static [String]$FilePathLog = $Null
    static [String]$FilePathIo = $Null
    
    static [int32]$CounterError = 0
    static [int32]$CounterFolder = 0
    static [int32]$CounterIo = 0
    static [int32]$CounterLog = 0

    [String]$Text = ""

    JtLog([String]$MyText) {
        $This.Text = $MyText
    }

    static [String]GetFileNameError([String]$Value) {
        [String]$MyName = -join ("log", ".", $Value, ".", "error", ".md")
        return $MyName
    }
    
    static [String]GetFileNameFolder([String]$Value) {
        # [String]$MyName = -join ("log", ".", $Value, ".", "folder", ".bat")
        # Do not use timestamp in name. Always use the same name...
        [String]$MyName = -join ("check", ".", "folder", ".bat")
        return $MyName
    }
    
    static [String]GetFileNameIo([String]$Value) {
        [String]$MyName = -join ("log", ".", $Value, ".", "io", ".md")
        return $MyName
    }
    
    static [String]GetFileNameLog([String]$Value) {
        [String]$MyName = -join ("log", ".", $Value, ".", "log", ".md")
        return $MyName
    }

    static [String]GetFilePathError() {
        if (([JtLog]::FilePathError).Length -lt 1) {
            [String]$Timestamp = Get-JtTimestamp 
            [String]$MyName = [JtLog]::GetFileNameError($Timestamp)
            [String]$MyPath = -join ([JtLog]::C_inventory_Report, "\", $MyName)
            [JtLog]::FilePathError = $MyPath
        }
        return [JtLog]::FilePathError
    }

    static [String]GetFilePathIo() {
        if (([JtLog]::FilePathIo).Length -lt 1) {
            [String]$Timestamp = Get-JtTimestamp
            [String]$MyName = [JtLog]::GetFileNameIo($Timestamp)
            [String]$MyPath = -join ([JtLog]::C_inventory_Report, "\", $MyName)
            [JtLog]::FilePathIo = $MyPath
        }
        return [JtLog]::FilePathIo
    }

    static [String]GetFilePathFolder() {
        if (([JtLog]::FilePathFolder).Length -lt 1) {
            [String]$Timestamp = Get-JtTimestamp
            [String]$MyName = [JtLog]::GetFileNameFolder($Timestamp)
            [String]$MyPath = -join ([JtLog]::C_inventory_Report, "\", $MyName)
            [JtLog]::FilePathFolder = $MyPath
        }
        return [JtLog]::FilePathFolder
    }
    
    static [String]GetFilePathLog() {
        if (([JtLog]::FilePathLog).Length -lt 1) {
            [String]$LogFolderPath = [JtLog]::C_inventory_Report
            New-Item -ItemType Directory -Force -Path $LogFolderPath 
        }
        if (([JtLog]::FilePathLog).Length -lt 1) {
            [String]$Timestamp = Get-JtTimestamp
            [String]$MyName = [JtLog]::GetFileNameLog($Timestamp)
            [String]$MyPath = -join ([JtLog]::C_inventory_Report, "\", $MyName)
            [JtLog]::FilePathLog = $MyPath
        }
        return [JtLog]::FilePathLog
    }
 

    DoPrintError() {
        [String]$Output = $This.Text
        # $This.DoPrintLog( -join ("ERROR_____: ", $Output))
        $This.DoPrintLog()

        [String]$MyFilePathError = [JtLog]::GetFilePathError()
        
        if ([JtLog]::CounterError -lt 1) {
            [String]$Filter = -join("*", [JtLog]::FileNameError)
            [String]$PathReport = [JtLog]::C_inventory_Report
            Write-Host -Text ( -join ("DoPrintError. Deleting content of:", $PathReport, " using filter:", $Filter))
            try {
                Get-Childitem -Path $PathReport -Filter $Filter -File | Remove-Item -Filter $Filter -Force
            }
            catch {
                Write-Host "Error while deleting file...."
            }
        }
        
        [JtLog]::CounterError = [JtLog]::CounterError + 1
        [String]$Type = "ERROR"
        [String]$Message = -join ($Type, " in: ", "...", "NR: ", [JtLog]::CounterError, " : ", $Output)
        [String]$MyLine = -join ("* ", $Message)
        
        Add-content -path $MyFilePathError -value $MyLine
        Write-Host -ForegroundColor Black -BackgroundColor Red $Message
        
        [String]$Timestamp = Get-JtTimestamp
        [String]$MyTime = -join ("  * Time ", $Timestamp)
        Add-content -path $MyFilePathError  -value $MyTime
    } 
    
    DoPrintFolder([String]$Path) {
        [String]$Output = $This.Text
        [String]$MyFilePathFolder = [JtLog]::GetFilePathFolder()
        
        if ([JtLog]::CounterFolder -lt 1) {
            [String]$Filter = [JtLog]::GetFileNameFolder("*")
            [String]$PathReport = [JtLog]::C_inventory_Report
            Write-Host -Text ( -join ("DoPrintFolder. Deleting content of:", $PathReport, " using filter:", $Filter))
            try {
                Get-Childitem -Path $PathReport -Filter $Filter | Remove-Item -Filter $Filter -Force
            }
            catch {
                Write-Host "Error while deleting file...."
            }
        }

        [JtLog]::CounterFolder = [JtLog]::CounterFolder + 1
        [String]$Type = "FOLDER"
        [String]$Message = -join ($Type, " in: ", "...", ", NR: ", [JtLog]::CounterFolder, " : ", $Output)
        [String]$MyLine = -join ("@echo ", $Output)
        
        Add-content -path $MyFilePathFolder -value $MyLine
        Write-Host -ForegroundColor White -BackgroundColor Magenta $Message
        
        [String]$MyLine = -join ('explorer.exe', ' ', '"', $Path, '"')
        Add-content -path $MyFilePathFolder  -value $MyLine

        [String]$MyLine = -join ('@echo -----------------------------------------')
        Add-content -path $MyFilePathFolder  -value $MyLine

        [String]$MyLine = -join ('pause')
        Add-content -path $MyFilePathFolder  -value $MyLine
        
        [String]$MyLine = -join ('cls')
        Add-content -path $MyFilePathFolder  -value $MyLine
    } 

    DoPrintIo() {
        [String]$Output = $This.Text
        [String]$MyFilePathIo = [JtLog]::GetFilePathIo()

        if ([JtLog]::CounterIo -lt 1) {
            [String]$Filter = [JtLog]::GetFileNameIo("*")
            [String]$PathReport = [JtLog]::C_inventory_Report
            Write-Host -ForegroundColor Black -BackgroundColor DarkYellow -Text ( -join ("DoPrintIo. Deleting content of:", $PathReport, " using filter:", $Filter))
            try {
                Get-Childitem -Path $PathReport -Filter $Filter | Remove-Item -Filter $Filter -Force
            }
            catch {
                Write-Host "Error while deleting file...."
            }
        }
        
        [JtLog]::CounterIo = [JtLog]::CounterIo + 1
        [String]$Type = "IO"
        [String]$Message = -join ($Type, " in: ", "...", ", NR: ", [JtLog]::CounterIo, " : ", $Output)
        [String]$MyLine = -join ("* ", $Message)
        
        Add-content -path $MyFilePathIo -value $MyLine
        Write-Host -ForegroundColor Black -BackgroundColor DarkYellow $Message
        
        [String]$Timestamp = Get-JtTimestamp
        [String]$MyTime = -join ("  * Time ", $Timestamp)
        Add-content -path $MyFilePathIo  -value $MyTime
    } 
    
    DoPrintLog() {
        [String]$Output = $This.Text
        [String]$MyFilePathLog = [JtLog]::GetFilePathLog()

        if ([JtLog]::CounterLog -lt 1) {
            [String]$Filter = [JtLog]::GetFileNameLog("*")
            [String]$PathReport = [JtLog]::C_inventory_Report
            Write-Host -Text ( -join ("DoPrintLog. Deleting content of:", $PathReport, " using filter:", $Filter))
            try {
                Get-Childitem -Path $PathReport -Filter $Filter | Remove-Item -Filter $Filter -Force
            }
            catch {
                Write-Host "Error while deleting file...."
            }
        }
        
        [JtLog]::CounterLog = [JtLog]::CounterLog + 1
        [String]$Type = "LOG"
        [String]$Message = -join ($Type, " in: ", "...", ", NR: ", [JtLog]::CounterLog, " : ", $Output)
        [String]$MyLine = -join ("* ", $Message)

        Add-content -path $MyFilePathLog -value $MyLine
        Write-Host -ForegroundColor Black -BackgroundColor Blue $Message
        [String]$Timestamp = Get-JtTimestamp
        [String]$MyTime = -join ("  * Time ", $Timestamp)
        Add-content -path $MyFilePathLog -value $MyTime
    } 
}


Function Write-JtLog {

    Param (
        [Parameter(Mandatory=$true)]
        [String]$Text
    )

    [JtLog]$JtLog = [JtLog]::new($Text)
    $JtLog.DoPrintLog()

}

Function Write-JtError {

    Param (
        [Parameter(Mandatory=$true)]
        [String]$Text
    )

    [JtLog]$JtLog = [JtLog]::new($Text)
    $JtLog.DoPrintError()

}


function Write-JtFolder {

    Param (
        [Parameter(Mandatory=$true)]
        [String]$Text,

        [Parameter(Mandatory=$true)]
        [String]$Path


    )

    
    [JtLog]$JtLog = [JtLog]::new($Text)
    $JtLog.DoPrintFolder($Path)

}


Function Write-JtIo {

    Param (
        [Parameter(Mandatory=$true)]
        [String]$Text

    )

    
    [JtLog]$JtLog = [JtLog]::new($Text)
    $JtLog.DoPrintIo()

}

function Get-JtTimestamp {
    
    $D = Get-Date
    [String]$Timestamp = $D.toString("yyyy-MM-dd_HH-mm-ss")
    Return $Timestamp
 
}

