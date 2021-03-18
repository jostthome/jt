# using module JtIo

<# 
    FARBEN
    
    Black 
    White

    DarkBlue 
    DarkCyan 
    DarkGray 
    DarkGreen 
    DarkMagenta 
    DarkRed 
    DarkYellow 
    
    Blue 
    Cyan 
    Gray 
    Green 
    Magenta 
    Red 
    Yellow
    
    #> 


class JtClass {

    hidden [String]$ClassName = "CLASSNAME not set!!!"

    hidden [Boolean]$BlnWriteLogToFile = $False
    hidden [Boolean]$BlnDevMode = $False

    static [System.Char]$Delimiter = ";"

    # not used? 
    static [System.Collections.Specialized.OrderedDictionary]GetDic($Hash) {
        $dictionary = [ordered]@{ }
        if ($Hash -is [System.Collections.Hashtable]) {
            $keys = $Hash.keys | Sort-Object
            foreach ($key in $keys) {
                $dictionary.add($key, $Hash[$key])
            }
            return $dictionary
        }
        elseif ($Hash -is [System.Array]) {
            for ($i = 0; $i -lt $hash.count; $i++) {
                $dictionary.add($i, $hash[$i])
            }
            return $dictionary
        }
        elseif ($Hash -is [System.Collections.Specialized.OrderedDictionary]) {
            return $dictionary
        }

        elseif ($Null -eq $Hash ) {
            Write-JtLog_Error -Text "STATIC GetDic. Hash is null!"
            return $dictionary
        }
        else {
            Write-JtLog_Error -Text "STATIC GetDic. Enter a hash table or an array. GetType: $Hash.getType()"
            return $dictionary
        }

        <# 
 .SYNOPSIS
 Converts a hash table or an array to an ordered dictionary. 
 
 .DESCRIPTION
 ConvertTo-OrderedDictionary takes a hash table or an array and 
 returns an ordered dictionary. 
 
 If you enter a hash table, the keys in the hash table are ordered 
 alphanumerically in the dictionary. If you enter an array, the keys 
 are integers 0 - n.
 
 .PARAMETER $hash
 Specifies a hash table or an array. Enter the hash table or array, 
 or enter a variable that contains a hash table or array.

 .INPUTS
 System.Collections.Hashtable
 System.Array

 .MyOUTPUTS
 System.Collections.Specialized.OrderedDictionary

 .EXAMPLE
 PS c:\> $myHash = @{a=1; b=2; c=3}
 PS c:\> .\ConvertTo-OrderedDictionary.ps1 -Hash $myHash

 Name Value     
 ---- -----     
 a 1     
 b 2     
 c 3 

 .EXAMPLE
 PS c:\> $myHash = @{a=1; b=2; c=3}
 PS c:\> $myHash = .\ConvertTo-OrderedDictionary.ps1 -Hash $myHash
 PS c:\> $myHash

 Name Value     
 ---- -----     
 a 1     
 b 2     
 c 3
 

 PS c:\> $myHash | Get-Member
 
 TypeName: System.Collections.Specialized.OrderedDictionary
 . . .

 .EXAMPLE
 PS c:\> $colors = "red", "green", "blue"
 PS c:\> $colors = .\ConvertTo-OrderedDictionary.ps1 -Hash $colors
 PS c:\> $colors

 Name Value     
 ---- -----     
 0 red     
 1 green     
 2 blue 

 
 .LINK
 about_hash_tables
#>

    }

    JtClass() {
    }
} 

class JtLog {
    
    static [String]$FolderPath_C_inventory = "c:\_inventory"
    static [String]$FolderPath_C_inventory_Report = "c:\_inventory\report"

    static [String]$FilePathError = $Null
    static [String]$FileFolderPath = $Null
    static [String]$FilePathLog = $Null
    static [String]$FilePathIo = $Null
    
    static [int32]$CounterError = 0
    static [int32]$CounterFolder = 0
    static [int32]$CounterIo = 0
    static [int32]$CounterLog = 0

    [String]$Text = ""
    [String]$Where = ""
    [Boolean]$BlnWriteLogToFile = $True

    JtLog([String]$MyText) {
        $This.Text = $MyText
        $This.Where = "not set"
    }

    JtLog([String]$MyText, [String]$MyWhere) {
        $This.Text = $MyText
        $This.Where = $MyWhere
    }

    static [String]GetFilename_Log_Error([String]$TheValue) {
        [String]$MyValue = $TheValue

        [String]$MyName = -join ("log", ".", $MyValue, ".", "error", ".md")
        return $MyName
    }
    
    static [String]GetFilename_Log_Io([String]$TheValue) {
        [String]$MyValue = $TheValue
        [String]$MyName = -join ("log", ".", $MyValue, ".", "io", ".md")
        return $MyName
    }
    
    static [String]GetFilename_Log_Log([String]$TheValue) {
        [String]$MyValue = $TheValue
        [String]$MyName = -join ("log", ".", $MyValue, ".", "log", ".md")
        return $MyName
    }

    static [String]GetFilename_Check_Folder([String]$TheValue) {
        # [String]$MyValue = $TheValue
        # [String]$MyName = -join ("log", ".", $MyValue, ".", "folder", ".bat")
        # Do not use timestamp in name. Always use the same name...
        [String]$MyName = -join ("check", ".", "folder", ".bat")
        return $MyName
    }

    static [String]GetFilePathError() {
        if (([JtLog]::FilePathError).Length -lt 1) {
            [String]$MyTimestamp = Get-JtTimestamp 
            [String]$MyName = [JtLog]::GetFilename_Log_Error($MyTimestamp)
            [String]$MyPath = -join ([JtLog]::FolderPath_C_inventory_Report, "\", $MyName)
            [JtLog]::FilePathError = $MyPath
        }
        return [JtLog]::FilePathError
    }

    static [String]GetFilePathIo() {
        if (([JtLog]::FilePathIo).Length -lt 1) {
            [String]$MyTimestamp = Get-JtTimestamp
            [String]$MyName = [JtLog]::GetFilename_Log_Io($MyTimestamp)
            [String]$MyPath = -join ([JtLog]::FolderPath_C_inventory_Report, "\", $MyName)
            [JtLog]::FilePathIo = $MyPath
        }
        return [JtLog]::FilePathIo
    }

    static [String]GetFilePath_Check_Folder() {
        if (([JtLog]::FileFolderPath).Length -lt 1) {
            [String]$MyTimestamp = Get-JtTimestamp
            [String]$MyFilename = [JtLog]::GetFilename_Check_Folder($MyTimestamp)
            [String]$MyFilePath = -join ([JtLog]::FolderPath_C_inventory_Report, "\", $MyFilename)
            [JtLog]::FileFolderPath = $MyFilePath
        }
        return [JtLog]::FileFolderPath
    }
    
    static [String]GetFilePathLog() {
        if (([JtLog]::FilePathLog).Length -lt 1) {
            [String]$FolderPathLog = [JtLog]::FolderPath_C_inventory_Report
            New-Item -ItemType Directory -Force -Path $FolderPathLog 
        }
        if (([JtLog]::FilePathLog).Length -lt 1) {
            [String]$MyTimestamp = Get-JtTimestamp
            [String]$MyFilename = [JtLog]::GetFilename_Log_Log($MyTimestamp)
            [String]$MyFilePath = -join ([JtLog]::FolderPath_C_inventory_Report, "\", $MyFilename)
            [JtLog]::FilePathLog = $MyFilePath
        }
        return [JtLog]::FilePathLog
    }
 

    DoPrintError() {
        [String]$MyFilePath = [JtLog]::GetFilePathError()
        
        [JtLog]::CounterError = [JtLog]::CounterError + 1
        [String]$MyCounter = [JtLog]::CounterError
        
        [String]$MyOutput = $This.Text
        [String]$MyType = "ERROR"

        Write-JtLog_Message -Text $MyOutput -Type $MyType -Counter $MyCounter -FilePath_Output $MyFilePath
    } 
    

    DoPrintFolder([String]$TheFilePath, [String]$TheFilePath_Output) {
        [String]$MyOutput = $This.Text
        [String]$MyFilePath = $TheFilePath
        [String]$MyFilePath_FolderFile = $TheFilePath_Output
        
        [JtLog]::CounterFolder = [JtLog]::CounterFolder + 1
        [String]$MyCounter = [JtLog]::CounterFolder

        [String]$MyType = "FOLDER"
        [String]$MyOutput = $This.Text

        Write-JtLog_Message -Text $MyOutput -Path $MyFilePath_FolderFile -Type $MyType -Counter $MyCounter -FilePath_Output $MyFilePath

        [String]$MyLine = -join ('explorer.exe', ' ', '/select,"', $MyFilePath, '"')
        Add-content -path $MyFilePath_FolderFile -value $MyLine

        [String]$MyLine = "@echo -----------------------------------------"
        Add-content -path $MyFilePath_FolderFile -value $MyLine
        [String]$MyLine = "@echo $MyCounter - $MyOutput"
        Add-content -path $MyFilePath_FolderFile -value $MyLine
        [String]$MyLine = "@echo -----------------------------------------"
        Add-content -path $MyFilePath_FolderFile -value $MyLine

        [String]$MyLine = "pause"
        Add-content -path $MyFilePath_FolderFile -value $MyLine
        
        [String]$MyLine = "cls"
        Add-content -path $MyFilePath_FolderFile -value $MyLine

    } 

    DoPrintIo([String]$ThePath) {
        [String]$MyFilePath = [JtLog]::GetFilePathIo()
        
        [String]$MyPath = $ThePath
        
        [JtLog]::CounterIo = [JtLog]::CounterIo + 1
        [String]$MyCounter = [JtLog]::CounterIo
        
        [String]$MyType = "IO"
        [String]$MyOutput = $This.Text
        
        Write-JtLog_Message -Text $MyOutput -Path $MyPath -Type $MyType -Counter $MyCounter -FilePath_Output $MyFilePath
    } 

    DoPrintIoIntern() {
        [String]$MyOutput = $This.Text
        [String]$MyFilePath = [JtLog]::GetFilePathIo()

        [JtLog]::CounterIo = [JtLog]::CounterIo + 1
        [String]$MyCounter = [JtLog]::CounterIo
        
        [String]$MyType = "INTERN"
        [String]$MyOutput = $This.Text

        Write-JtLog_Message -Text $MyOutput -Type $MyType -Counter $MyCounter -FilePath_Output $MyFilePath
    } 
    
    DoPrintLog() {
        [String]$MyFilePath = [JtLog]::GetFilePathLog()
        
        [JtLog]::CounterLog = [JtLog]::CounterLog + 1
        [Int16]$MyCounter = [JtLog]::CounterLog
        
        [String]$MyType = "LOG"
        [String]$MyOutput = $This.Text
        [String]$MyWhere = $This.Where

        Write-JtLog_Message -Text $MyOutput -Where $MyWhere -Type $MyType -Counter $MyCounter -FilePath_Output $MyFilePath
    } 
}



class JtToolWol : JtClass {

    [String]$FilePath_Wol_Exe = -join ("c:\apps\tools\wol\wol.exe")
    [String]$Label = ""
    [String]$Mac = ""

    JtToolWol([String]$MyLabel, [String]$MyMac) {
        $This.ClassName = "JtToolWol"
        $This.Label = $MyLabel
        $This.Mac = $MyMac
    }

    JtToolWol([String]$TheComputername) {
        $This.ClassName = "JtToolWol"
        $This.Label = $TheComputername

        [String]$MyMac = Get-JtMac -Computername $TheComputername

        if ($MyMac.Length -lt 1) {
            Write-JtLog_Error -Where $This.ClassName -Text "No MAC address found for computer: $TheComputername"
        }

        $This.Mac = $MyMac
    }    

    [Boolean]DoIt() {
        [String]$TheLabel = $This.Label
        [String]$TheMac = $This.Mac
        Write-JtLog -Where $This.ClassName -Text "Label: $TheLabel; MAC: $TheMac"

        [String]$TheArgs = -join (" ", $This.Mac)

        if (Test-JtIoFilePath -FilePath $This.FilePath_Wol_Exe) {
            Write-JtLog -Where $This.ClassName -Text "WOL args: $TheArgs"
            Start-Process -NoNewWindow -FilePath $This.FilePath_Wol_Exe -ArgumentList $TheArgs -Wait 
            return $True
        }
        else {
            [String]$MyFilePath_Wol_Exe = $This.FilePath_Wol_Exe
            Write-JtLog_Error -Where $This.ClassName -Text "ERROR! wol.exe is missing. MyFilePath_Wol_Exe: $MyFilePath_Wol_Exe"

            if ($This.ExitOnError -eq $True) {
                Exit
            }
            return $False
        }
    }
}




Class JtTimer : JtClass {

    [String]$Name = ""
    [Boolean]$BlnStop

    $TimeStart
    $TimeEnd
    $TimeDuration

    JtTimer([String]$MyName) {
        $This.ClassName = "JtTimer"
        $This.Name = $MyName
        $This.BlnStop = $False
        $This.TimeStart = Get-Date
    }

    Sleep([int32]$Seconds) {
        Start-Sleep -Seconds $Seconds
    }

    Measure() {
        $This.TimeEnd = Get-Date
        $This.BlnStop = $True
        $This.TimeDuration = $This.TimeEnd - $This.TimeStart
    }

    Report() {
        if ($This.BlnStop -eq $False) {
            $Null = $This.Measure()
        }
        Write-Host "=================================="
        Write-Host "Timer   :" $This.Name
        Write-Host "=================================="
        Write-Host "Start   :" $This.TimeStart
        Write-Host "End     :" $This.TimeEnd
        Write-Host "=================================="
        Write-Host "Duration:" $This.TimeDuration
        Write-Host "=================================="
    }
}

Function Convert-JtEnvironmentVariables {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Text
    )

    [String]$MyResult = $Text
    $MyResult = $MyResult.Replace("%OneDrive%", $env:OneDrive)
    $MyResult = $MyResult.Replace("%COMPUTERNAME%", $env:COMPUTERNAME)
    $MyResult = $MyResult.Replace("%temp%", $env:TEMP)
    return $MyResult
}

Function Convert-JtDecimal_To_String2 {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][Decimal]$Decimal
    )

    [Decimal]$MyDec = $Decimal
    
    [String]$MyResult = $MyDec.ToString("0.00")
    $MyResult = $MyResult.Replace(".", ",")
    return $MyResult
}

Function Convert-JtDecimal_To_String3 {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][Decimal]$Decimal
    )

    [String]$MyResult = $Decimal.ToString("0.000")
    $MyResult = $MyResult.Replace(".", ",")
    return $MyResult
}

Function Convert-JtDotter {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Text,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$PatternOut,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$SeparatorOut,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][Switch]$Reverse,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][Switch]$Default
    )

    [String]$MyFunctionName = "Convert-JtDotter"

    [String]$MyDefault = "xxx"
    if ($Default) {
        $MyDefault = $Default
    }

    [String]$MyText = $Text
    [String]$MySeparatorOut = "."
    if ($SeparatorOut) {
        $MySeparatorOut = $SeparatorOut
    }

    $MyAlPartsText = $MyText.Split(".")
    [Int16]$MyIntPartsCount = $MyAlPartsText.Count
    $MyAlPartsIds = $PatternOut.Split(".")
    [JtList]$MyJtList = New-JtList
    ForEach ($MyId in $MyAlPartsIds) {
        [Int16]$MyPosInArray = $MyId - 1

        [String]$MyValue = $MyDefault
        if ($MyPosInArray -le $MyIntPartsCount) {
            [Int16]$MyIntPos = $MyId - 1
            if ($Reverse) {
                $MyIntPos = $MyIntPartsCount - $MyId
            }
            [String]$MyValue = $MyAlPartsText[$MyIntPos]
            if ($MyValue.Length -lt 1) {
                Write-JtLog_Error -Where $MyFunctionName -Text "EMPTY ELEMENT. Problem with MyText: $MyText"
                $MyValue = $MyDefault
            }
        }
        $MyJtList.Add($MyValue)
    }
    $MyAlPartsResult = $MyJtList.GetValues()
    [String]$MyResult = $MyAlPartsResult -Join $MySeparatorOut
    Return $MyResult
}

Function Convert-JtFilename_To_DecBetrag {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Filename
    )

    # [String]$MyFunctionName = "Convert-JtFilename_To_DecBetrag"

    [String]$MyFilename = $Filename

    [String]$MyElement = Convert-JtDotter -Text $MyFilename -PatternOut "2" -Reverse
    [String]$MyPreis = $MyElement.Replace("_", ".")
    [Decimal]$MyDecPreis = [Decimal]$MyPreis
    return $MyDecPreis
}

Function Convert-JtFilename_To_IntAlter {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Filename
    )

    [String]$MyFunctionName = "Convert-JtFilename_To_IntAlter"
    [String]$MyFilename = $Filename

    [Int16]$MyIntYear = Convert-JtFilename_To_IntJahr -Filename $MyFilename
    if ($MyIntYear -gt 0 ) {
        $MyDateCurrent = Get-Date
        $MyYearCurrent = $MyDateCurrent.Year
        [Int16]$MyIntYearCurrent = [Int16]$MyYearCurrent

        [Int16]$MyIntAlter = $MyIntYearCurrent - $MyIntYear
    }
    else {
        Write-JtLog_Error -Where $MyFunctionName -Text "Not valid!!! MyFilename: $MyFilename"
    }
    return $MyIntAlter
}

Function Convert-JtFilename_To_IntAnzahl {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Filename
    )

    # [String]$MyFunctionName = "Convert-JtFilename_To_IntAnzahl"
    
    # [String]$MyPath = $This.GetPath()
    [String]$MyFilename = $Filename
    [String]$MyCount = Convert-JtDotter -Text $MyFilename -PatternOut "2" -Reverse
    return $MyCount
}

Function Convert-JtInt_To_00 {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][Int]$Int
    )

    [Int16]$Thousand = 1000 + $Int
    [String]$MyResult = -join ("", $Thousand )
    $MyResult = [String]$MyResult.SubString(2, 2)
    return $MyResult
}

Function Convert-JtInt_To_000 {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][Int]$Int
    )

    [Int16]$MyThousand = 1000 + $Int
    [String]$MyResult = -join ("", $MyThousand)
    $MyResult = [String]$MyResult.SubString(1, 3)
    return $MyResult
}

Function Convert-JtIp_To_Ip3 {
    Param (
        [Parameter(Mandatory = $False)][ValidateNotNull()][String]$Ip
    )

    [String]$MyFullIp = $Ip
    $MyAlParts = $MyFullIP.Split(".")        
    
    [String]$MyIp3 = ""
    if ($MyAlParts.Count -eq 4) {
        $MyIP3 = $MyAlParts[3]
    }
    else {
        $MyIp3 = "ERROR: $MyFullIP"
    }
    return $MyIp3
}

Function Convert-JtFilename_To_DecQm {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Filename
    )

    [String]$MyFunctionName = "Convert-JtFilename_To_DecQm"

    [String]$MyFilename = $Filename
    try {
        [String]$MySize = Convert-JtDotter -Text $MyFilename -PatternOut "2" -Reverse
        $MyAlSizeParts = $MySize.Split("x")
        if ($MyAlSizeParts.Count -lt 2) {
            Write-JtLog_Error -Where $MyFunctionName -Text "Problem with FLAECHE. MyFilename: $MyFilename"
            return 999
        }
        else {
            [String]$MyBreite = $MyAlSizeParts[0]
            [String]$MyHoehe = $MyAlSizeParts[1]
            [Int32]$MyIntBreite = [Int32]$MyBreite
            [Int32]$MyIntHoehe = [Int32]$MyHoehe
            [Int32]$MyIntFlaeche = $MyIntBreite * $MyIntHoehe
            [Decimal]$MyDecFlaeche = [Decimal]$MyIntFlaeche / 1000 / 1000
            [Decimal]$MyDecFlaeche = [math]::round($MyDecFlaeche, 3, 1)
            # [Decimal]$DecFlaeche = [Decimal]$IntFlaeche
            # [String]$MyFlaeche = $MyDecFlaeche.ToString("0.000")
            # [String]$MyFlaeche = $DecFlaeche.ToString("0")
            # $MyFlaeche = $MyFlaeche.Replace(",", ".")
        }
    }
    catch {
        Write-JtLog_Error -Where $MyFunctionName -Text "Problem with FLAECHE in file: $MyFilename"
    }
    return $MyDecFlaeche
}

Function Convert-JtFilename_To_Info_With_Template {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FilenameTemplate,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Filename,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Field
    )
        
    [String]$MyFilename_Template = $FilenameTemplate
    [String]$MyFilename = $Filename
    [String]$MyField = $Field

    [String]$MyResult = ""
    $MyAlTemplateParts = $MyFilename_Template.Split(".")

    for ([Int16]$i = 0; $i -lt $MyAlTemplateParts.Count; $i = $i + 1 ) {
        $MyResult = Convert-JtDotter -Text $MyFilename -PatternOut "$i"

    }
    return $MyResult
}

Function Convert-JtFilename_To_IntJahr {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Filename
    )

    [String]$MyFunctionName = "Convert-JtFilename_To_IntJahr"

    [String]$MyFilename = $Filename

    if ($MyFilename.Length -lt 4) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Illegal value MyFilename: $MyFilename"
        return 9999
    }

    [Int16]$MyIntJahr = 9999

    [String]$MyJahr = $MyFilename.substring(0, 4)
    
    try {
        # Aus "20-04" soll "2020" werden.
        $MySep = $MyJahr.substring(2, 1)
        if ($MySep -eq "-") {
            $MyJahr = -join ("20", $MyJahr.substring(0, 2))
        } 
    }
    catch {
        $MyJahr = ""
        Write-JtLog_Error -Where $MyFunctionName -Text "Problem with MyFilename: $MyFilename"
        return 9998
    }

    try {
        [Int16]$MyIntJahr = [Int16]$MyJahr
    }
    catch {
        Write-JtLog_Error -Where $MyFunctionName -Text "Illegal value. Problem with MyFilename: $MyFilename"
        return 9997
    }
    return $MyIntJahr
}

Function Convert-JtFilename_To_Jahr {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Filename
    )

    [Int16]$MyIntJahr = Convert-JtFilename_To_IntJahr -Filename $Filename
    [String]$MyJahr = -Join ($MyIntJahr, "")
    return $MyJahr
}

Function Convert-JtFilename_To_Papier {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Filename
    )

    [String]$MyFunctionName = "Convert-JtFilename_To_Papier"

    # [JtIoFile]$TheJtIoFile
    # [String]$MyPath = $This.GetPath()

    [String]$MyFilename = $Filename
    [String]$MyPaper = "xxxx"
    try {
        [String]$MyPaper = Convert-JtDotter -Text $MyFilename -PatternOut "3" -Reverse
    }
    catch {
        Write-JtLog_Error -Where $MyFunctionName -Text "Problem with PAPIER in file: $MyFilename"
    }
    return $MyPaper
}

Function Convert-JtFilePathExpanded {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FilePath
    )

    [String]$MyResult = $FilePath
    $MyResult = Convert-JtEnvironmentVariables -Text $MyResult
    return $MyResult
} 

Function Convert-JtFolderPathExpanded {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath
    )

    [String]$MyResult = $FolderPath
    $MyResult = Convert-JtEnvironmentVariables -Text $MyResult
    return $MyResult
} 


Function Convert-JtPart_To_Decimal {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Part
    )

    [String]$MyFunctionName = "Convert-JtPart_To_Decimal"

    [String]$MyText = $Part

    if ($Part) {
        $MyText = $MyText.Replace("_", ",")
    }
    # $MyText = $MyText.Replace(".", "")
    $MyText = $MyText.Replace(",", ".")
    if ($MyText.Length -lt 1) {
        Write-JtLog -Where $MyFunctionName -Text "MyText is empty. Not expected..."
        return 0
    }

    [Decimal]$MyDec = $MyText
    return [Decimal]$MyDec
}




Function Convert-JtPart_To_DecBetrag {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Part
    )

    [String]$MyPart = $Part

    [Boolean]$BlnValid = Test-JtPart_Is_Valid_Betrag -Part $MyPart
    if(! ($BlnValid)) {
        return 999999
    }

    [String]$MyText = $MyPart.Replace("_", ".")
    [Decimal]$MyDecResult = Convert-JtString_To_Betrag -Text $MyText

    Return $MyDecResult
}


Function Convert-JtPath_To_Parts {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Path,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$PatternOut,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$SeparatorOut
    )

    [String]$MyFunctionName = "Convert-JtPath_To_Parts"
    [String]$MyDefault = "_-_"
    [String]$MyText = $Path
    [String]$MySeparatorOut = "."
    if ($SeparatorOut) {
        $MySeparatorOut = $SeparatorOut
    }

    $MyAlPartsText = $MyText.Split("\")
    [Int16]$MyIntPartsCount = $MyAlPartsText.Count
    $MyAlPartsIds = $PatternOut.Split(".")
    [JtList]$MyJtList = New-JtList
    ForEach ($Id in $MyAlPartsIds) {
        [Int16]$MyId = $Id
        [Int16]$MyPosInArray = $MyId - 1

        [String]$MyValue = $MyDefault
        if ($MyPosInArray -le $MyIntPartsCount) {
            [String]$MyValue = $MyAlPartsText[$MyId - 1]
            if ($MyValue.Length -lt 1) {
                Write-JtLog_Error -Where $MyFunctionName -Text "EMPTY ELEMENT for MyId: $MyId. Problem with MyText: $MyText"
                $MyValue = "."
            }
        }
        $MyJtList.Add($MyValue)
    }
    $MyAlPartsResult = $MyJtList.GetValues()
    [String]$MyResult = $MyAlPartsResult -Join $MySeparatorOut
    Return $MyResult
}


Function Convert-JtLabel_To_Filename {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Label
    )

    [String]$MyResult = $Label
    $MyResult = Convert-JtText_German_To_International $MyResult
    $MyResult = $MyResult.Replace(",", "_")
    $MyResult = $MyResult.Replace(" ", "_")
    $MyResult = $MyResult.Replace("+", "_plus_")
    $MyResult = $MyResult.Replace("&", "_und_")
    $MyResult = $MyResult.Replace("__", "_")
    $MyResult = $MyResult.Trim()
    return $MyResult
}


Function Convert-JtString_To_Betrag {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Text
    )

    [String]$MyFunctionName = "Convert-JtString_To_Betrag"

    [String]$MyText = $Text 
    [String]$MyResult = $MyText
    $MyResult = $MyResult.Replace("_", "")
    $MyResult = $MyResult.Replace(".", "")
    $MyResult = $MyResult.Replace(",", "")

    try {
        [Int32]$MyInti = [Decimal]$MyResult
        [Decimal]$MyDecimal = $MyInti / 100
        # [String]$MyResult = $MyDecimal.ToString("N2")
        [String]$MyResult = $MyDecimal.ToString("0.00")
    }
    catch {
        Write-JtLog_Error -Where $MyFunctionName -Text "Convert problem. MyText: $MyText"
        return [String]"0,00".ToString()
    }
    return $MyResult
}


Function Convert-JtString_To_ColHeader {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Text,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Prefix,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Suffix
    )

    [String]$MyPrefix = ""
    [String]$MySuffix = ""
    [String]$MyText = $Text

    if ($Prefix) {
        $MyPrefix = $Prefix
    }

    if ($Suffix) {
        $MySuffix = $Suffix
    }

     
    $MyText = $MyText.Replace(".", "")


    [String]$MyResult = -Join ($MyPrefix, $MyText, $MySuffix)
    $MyResult = Convert-JtText_German_To_International -Text $MyResult
    return $MyResult
}

Function Convert-JtString_To_Decimal {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Text,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][Switch]$Part
    )

    [String]$MyFunctionName = "Convert-JtString_To_Decimal"

    [String]$MyText = $Text

    if ($Part) {
        [String]$MyDecResult = Convert-JtPart_To_Decimal -Part $MyText
        Return $MyDecResult
    }
    # $MyText = $MyText.Replace(".", "")
    $MyText = $MyText.Replace(",", ".")
    if ($MyText.Length -lt 1) {
        Write-JtLog -Where $MyFunctionName -Text "MyText is empty. Not expected..."
        return 0
    }

    [Decimal]$MyDec = $MyText
    return [Decimal]$MyDec
}

Function Convert-JtString_To_DecGb {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Text
    )

    [String]$MyFunctionName = "Convert-JtString_To_DecGb"

    [String]$MyInput = $Text
    [int64]$MyIntNum = 0
    if ($Null -eq $MyInput) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Problem; MyInput was NULL"
        return $Null
    }
    try {
        [int64]$MyIntNum = $MyInput.ToInt64($Null)
    }
    catch {
        Write-JtLog_Error -Where $MyFunctionName -Text "Problem; MyInput: $MyInput"
        return $Null
    }
    [Decimal]$MyMini = $MyIntNum / 1024 / 1024 / 1024

    # 0,5625 -> 0,563
    [Decimal]$MyGiga = [math]::Round($MyMini, 3, 1)
    [Decimal]$MyDecGiga = $MyGiga
    return $MyDecGiga
} 


# quelle https://www.datenteiler.de/powershell-umlaute-ersetzen/
# needs file encoding UTF8 with BOM
Function Convert-JtText_German_To_International {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Text
    )

    $UmlautObject = New-Object PSObject | Add-Member -MemberType NoteProperty -Name Name -Value $Text -PassThru
    
    # hash tables are by default case insensitive
    # we have to create a new hash table object for case sensitivity 
    
    $characterMap = New-Object system.collections.hashtable
    $characterMap.ä = "ae"
    $characterMap.ö = "oe"
    $characterMap.ü = "ue"
    $characterMap.Ä = "Ae"
    $characterMap.Ö = "Oe"
    $characterMap.Ü = "Ue"         
    $characterMap.ß = "ss"
    
    foreach ($property  in 'Name') { 
        foreach ($key in $characterMap.Keys) {
            $UmlautObject.$property = $UmlautObject.$property -creplace $key, $characterMap[$key] 
        }
    }
    
    # $UmlautObject
    return $UmlautObject.Name
} # Replace-Umlaute 


Function Convert-JtText_Remove_Digits {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Text
    )

    [String]$MyText = $Text
    [String]$MyResult = $MyText
$MyResult = $MyResult.Replace("0", "")
$MyResult = $MyResult.Replace("1", "")
$MyResult = $MyResult.Replace("2", "")
$MyResult = $MyResult.Replace("3", "")
$MyResult = $MyResult.Replace("4", "")
$MyResult = $MyResult.Replace("5", "")
$MyResult = $MyResult.Replace("6", "")
$MyResult = $MyResult.Replace("7", "")
$MyResult = $MyResult.Replace("8", "")
$MyResult = $MyResult.Replace("9", "")
    return $MyResult
}



Function Convert-JtText_Template {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Text,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Table,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Path,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Url

    )

    # [String]$MyFunctionName = "Convert-JtText_Template"

    [String]$MyText = $Text 
    [String]$MyResult = $MyText

    [String]$MyPath = $Path
    if($MyPath) {
        [String]$MyPath_Output = $MyPath.Replace("\", "/")
    $MyResult = $MyResult.Replace("<path>", $MyPath_Output)
    }

    [String]$MyUrl = $Url
    if($MyUrl) {
    [String]$MyUrl_Output = -join("<", $MyUrl, ">")
    $MyResult = $MyResult.Replace("<url>", $MyUrl_Output)
    }

    [String]$MyTable = $Table
    if($MyTable) {
    $MyResult = $MyResult.Replace("<table>", $MyTable)
    }

    [String]$MyDate = Get-JtDateNormal
    $MyResult = $MyResult.Replace("<date>", $MyDate)

    return $MyResult
}



Function Get-JtDate {
    
    $D = Get-Date
    [String]$MyDate = $D.toString("yyyy-MM-dd")
    Return $MyDate
 
}

Function Get-JtDateNormal {
    
    $D = Get-Date
    [String]$MyDate = $D.toString("dd.MM.yyyy")
    Return $MyDate
 
}

# is in development mode?
Function Get-JtDevMode {

    [String]$MyFunctionName = "Get-JtDevMode"

    Write-JtLog -Where $MyFunctionName -Text "DEV__________________________________"
    if ($env:COMPUTERNAME -eq "AL-DEK-NB-DEK05") {
        return $True
    }
    elseif ($env:COMPUTERNAME -eq "G13-AL-PC-DELL") {
        return $True
    }
    else {
        return $False
    }
}


Function Get-JtFolderPath_Base() {
    Return Get-Location
}


Function Get-JtMac {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$ComputerName
    )

    [Hashtable]$Macs = [ordered]@{
        "al-its-pc-g01" = "18:66:DA:31:6C:DB"
        "al-its-pc-g02" = "18:66:DA:31:76:D0"
        "al-its-pc-g03" = "18:66:DA:31:7B:77"
        "al-its-pc-g04" = "18:66:DA:31:7E:FC"
        "al-its-pc-g05" = "18:66:DA:31:7B:46"
        "al-its-pc-g06" = "18:66:DA:31:70:5D"
        "al-its-pc-g07" = "18:66:DA:31:79:0C"
        "al-its-pc-g08" = "18:66:DA:31:7D:E1"
        "al-its-pc-g09" = "18:66:DA:31:7E:EB"
        "al-its-pc-g10" = "18:66:DA:31:84:1E"
        "al-its-pc-g11" = "18:66:DA:31:7D:C9"
        "al-its-pc-g12" = "18:66:DA:31:7B:A4"
        "al-its-pc-g13" = "18:66:DA:31:7B:6B"
        "al-its-pc-g14" = "18:66:DA:31:79:63"
        "al-its-pc-g15" = "18:66:DA:31:72:F7"
        "al-its-pc-g16" = "18:66:DA:31:7C:7F"
        "al-its-pc-g17" = "18:66:DA:31:7D:7D"
        "al-its-pc-g18" = "18:66:DA:31:83:06"
        "al-its-pc-g19" = "18:66:DA:31:7B:8B"
        "al-its-pc-h01" = "00:4E:01:A0:DD:4A"
        "al-its-pc-h02" = "00:4E:01:A0:C1:D8"
        "al-its-pc-h03" = "00:4E:01:A0:72:21"
        "al-its-pc-h04" = "00:4E:01:A1:0D:F8"
        "al-its-pc-h05" = "00:4E:01:A0:6A:CD"
        "al-its-pc-h06" = "00:4E:01:A0:DC:69"
        "al-its-pc-h07" = "00:4E:01:9F:07:96"
        "al-its-pc-h08" = "00:4E:01:A0:93:28"
        "al-its-pc-h09" = "00:4E:01:9F:03:8A"
        "al-its-pc-h10" = "00:4E:01:A0:95:7B"
        "al-its-pc-h11" = "00:4E:01:9F:03:FB"
        "al-its-pc-h12" = "00:4E:01:A0:DB:9E"
        "al-its-pc-h13" = "00:4E:01:9F:03:7F"
        "al-its-pc-h14" = "00:4E:01:A0:DC:E3"
        "al-its-pc-h15" = "00:4E:01:9F:03:9E"
        "al-its-pc-h16" = "00:4E:01:A0:93:BB"
        "al-its-pc-h17" = "00:4E:01:A0:FF:7E"
        "al-its-pc-h18" = "00:4E:01:9F:35:9E"
        "al-its-pc-h19" = "00:4E:01:A1:08:E3"
        "al-its-pc-h20" = "00:4E:01:A1:08:D6"
        "al-its-pc-h21" = "00:4E:01:9F:04:92"
        "al-its-pc-h22" = "00:4E:01:A0:FF:A2"
        "al-its-pc-h23" = "00:4E:01:A0:93:39"
        "al-its-pc-h24" = "00:4E:01:9F:04:1A"
        "al-its-pc-h25" = "00:4E:01:A1:08:DF"
        "al-its-pc-h26" = "00:4E:01:A0:DD:21"
        "al-its-pc-h27" = "00:4E:01:9F:32:5C"
        "al-its-pc-h28" = "00:4E:01:A0:67:91"
        "al-its-pc-h29" = "00:4E:01:A0:DB:83"
        "al-its-pc-h30" = "00:4E:01:9F:03:90"
        "al-its-pc-h31" = "00:4e:01:a0:c1:2b"
        "al-its-pc-h32" = "00:4E:01:A1:0C:B6"
        "al-its-pc-h33" = "00:4E:01:9F:04:7D"
        "al-its-pc-h34" = "00:4E:01:A0:FF:C3"
        "al-its-pc-h35" = "00:4E:01:A0:C9:45"
        "al-its-pc-h36" = "00:4E:01:A0:BA:E3"
        "al-its-pc-h37" = "00:4E:01:A0:93:7E"
        "al-its-pc-h38" = "00:4E:01:A0:B6:BE"
    }
    [String]$MyMac = $Macs.$Computername 

    return $MyMac
}


Function Get-JtRandom6 {
    [int16]$Stellen = 6
    [Int32]$Zufallszahl = Get-Random
    [String]$Zufallswort = "" + $Zufallszahl
    [String]$MyZufall = $Zufallswort.Substring(0, $Stellen)
    return $MyZufall
}


Function Get-JtTimestamp {
    
    $D = Get-Date
    [String]$MyTimestamp = $D.toString("yyyy-MM-dd_HH-mm-ss")
    Return $MyTimestamp
 
}

Function Get-JtVersion {
    return "2021-03-18"
}



Class JtList {

    [System.Collections.Specialized.OrderedDictionary]$HashTable = $Null
    
    JtList () {
        # $This.HashTable = New-Object HashTable
        $This.HashTable = New-Object System.Collections.Specialized.OrderedDictionary
    }
    
    Add([String]$TheValue) {
        [String]$MyValue = $TheValue
        if ($This.HashTable.Contains($MyValue)) {
            $MyHashValue = $This.HashTable.$MyValue
            [Int16]$MyInt = $MyHashValue + 1
            $This.HashTable.$MyValue = $MyInt
        }
        else {
            $This.HashTable.$MyValue = 1
        }
    }
    
    [System.Collections.ArrayList]GetValues() {
        [System.Collections.ArrayList]$Al = New-Object System.Collections.ArrayList


        ForEach ($MyKey in $This.HashTable.Keys) {
            $Al.Add($MyKey)
        }

        return $Al
    }
    
    ToString() {
        $This.HashTable.Keys
    }
    
}
    
Function New-JtList () {
    
    [JtList]::New()
}



class JtTimeStop : JtClass {

    hidden [String]$Label
    hidden [DateTime]$TimeBegin
    hidden [DateTime]$TimeEnd
    hidden [timespan]$Duration 

    JtTimeStop() {
        $This.ClassName = "JtTimeStop"

    } 

    [String]GetMessageBegin([DateTime]$Time) {
        [String]$MyMessage = ""
        $MyMessage = -join ("___ Timer ", $Time, " --- ", "(Begin)", " ", " --- ", $This.Label)
        return $MyMessage
    } 

    [String]GetMessageDuration([Timespan]$Timespan) {
        [String]$MyMessage = ""
        $MyMessage = -join ("=== Timer ", " ", $Timespan, " --- ", "(Duration)", " --- ", $This.Label)
        return $MyMessage
    } 

    [String]GetMessageEnd([DateTime]$Time) {
        [String]$MyMessage = ""
        $MyMessage = -join ("___ Timer ", $Time, " --- ", "(End) ", " ", " --- ", $This.Label)
        return $MyMessage
    } 


    Start([String]$Label) {
        $This.Label = $Label
        [DateTime]$D = Get-Date
        [String]$MyTimeBegin = $D
        $This.TimeBegin = $D
        Write-JtLog -Where $This.ClassName -Text $This.GetMessageBegin($MyTimeBegin)
    } 
    
    Stop() {
        [DateTime]$D = Get-Date
        [String]$MyTimeEnd = $D
        $This.TimeEnd = $MyTimeEnd
        
        Write-JtLog -Where $This.ClassName -Text $This.GetMessageEnd($MyTimeEnd)
        $This.Duration = $This.TimeEnd - $This.TimeBegin

        [String]$MyDuration = $This.Duration

        Write-JtLog -Where $This.ClassName -Text $This.GetMessageDuration($MyDuration)
    } 
} 

Function New-JtTimeStop {
    [JtTimeStop]::new()
}


Function Rename-JtComputerpoolPc {
    $MySn = Get-WmiObject -Class win32_bios | Select-Object -ExpandProperty SerialNumber
    Write-Host "SN:"$MySn

    [String]$MyComputername_Old = $env:computername
    [String]$MyComputername_New = $env:computername

    Switch ($MySn) {
        8YH8032 { $MyComputername_New = "al-its-pc-f01"; break }
        1XH8032 { $MyComputername_New = "al-its-pc-f02"; break }
        CZH8032 { $MyComputername_New = "al-its-pc-f03"; break }
        FVH8032 { $MyComputername_New = "al-its-pc-f04"; break }
        GWH8032 { $MyComputername_New = "al-its-pc-f05"; break }
        DRH8032 { $MyComputername_New = "al-its-pc-f06"; break }
        7SH8032 { $MyComputername_New = "al-its-pc-f07"; break }
        FTH8032 { $MyComputername_New = "al-its-pc-f08"; break }
        HTH8032 { $MyComputername_New = "al-its-pc-f09"; break }
        CVH8032 { $MyComputername_New = "al-its-pc-f10"; break }
        7VH8032 { $MyComputername_New = "al-its-pc-f11"; break }
        1WH8032 { $MyComputername_New = "al-its-pc-f12"; break }
        9ZH8032 { $MyComputername_New = "al-its-pc-f13"; break }
        7TH8032 { $MyComputername_New = "al-its-pc-f14"; break }
        6WH8032 { $MyComputername_New = "al-its-pc-f15"; break }
        3ZH8032 { $MyComputername_New = "al-its-pc-f16"; break }
        6XH8032 { $MyComputername_New = "al-its-pc-f17"; break }
        5TH8032 { $MyComputername_New = "al-its-pc-f18"; break }
        6SH8032 { $MyComputername_New = "al-its-pc-f19"; break }
        9TH8032 { $MyComputername_New = "al-its-pc-f20"; break }
        JXH8032 { $MyComputername_New = "al-its-pc-f21"; break }
        3VH8032 { $MyComputername_New = "al-its-pc-f22"; break }
        FXH8032 { $MyComputername_New = "al-its-pc-f23"; break }
        CTH8032 { $MyComputername_New = "al-its-pc-f24"; break }
        5VH8032 { $MyComputername_New = "al-its-pc-f25"; break }
        DYH8032 { $MyComputername_New = "al-its-pc-f26"; break }
        3SH8032 { $MyComputername_New = "al-its-pc-f27"; break }
        1TH8032 { $MyComputername_New = "al-its-pc-f28"; break }
        GSH8032 { $MyComputername_New = "al-its-pc-f29"; break }
        2SH8032 { $MyComputername_New = "al-its-pc-f30"; break }
        BSH8032 { $MyComputername_New = "al-its-pc-f31"; break }
        HYH8032 { $MyComputername_New = "al-its-pc-f32"; break }
        4TH8032 { $MyComputername_New = "al-its-pc-f33"; break }
        1VH8032 { $MyComputername_New = "al-its-pc-f34"; break }
        6ZH8032 { $MyComputername_New = "al-its-pc-f35"; break }
 
        H3LX3G2 { $MyComputername_New = "al-its-pc-g01"; break }
        H3M04G2 { $MyComputername_New = "al-its-pc-g02"; break }
        H3M24G2 { $MyComputername_New = "al-its-pc-g03"; break }
        H3M44G2 { $MyComputername_New = "al-its-pc-g04"; break }
        H3MX3G2 { $MyComputername_New = "al-its-pc-g05"; break }
        H3MY3G2 { $MyComputername_New = "al-its-pc-g06"; break }
        H3N14G2 { $MyComputername_New = "al-its-pc-g07"; break }
        H3NX3G2 { $MyComputername_New = "al-its-pc-g08"; break }
        H3P04G2 { $MyComputername_New = "al-its-pc-g09"; break }
        H3P44G2 { $MyComputername_New = "al-its-pc-g10"; break }
        H3PY3G2 { $MyComputername_New = "al-its-pc-g11"; break }
        # Nach Mainboard-Tausch in 10.2018 Namen getauscht: g12 und g19
        H3SW3G2 { $MyComputername_New = "al-its-pc-g12"; break }
        H3QY3G2 { $MyComputername_New = "al-its-pc-g13"; break }
        H3R14G2 { $MyComputername_New = "al-its-pc-g14"; break }
        H3R34G2 { $MyComputername_New = "al-its-pc-g15"; break }
        H3RX3G2 { $MyComputername_New = "al-its-pc-g16"; break }
        H3RZ3G2 { $MyComputername_New = "al-its-pc-g17"; break }
        H3S14G2 { $MyComputername_New = "al-its-pc-g18"; break }
        # Nach Mainboard-Tausch in 10.2018 Namen getauscht: g12 und g19
        H3Q34G2 { $MyComputername_New = "al-its-pc-g19"; break }
        H3SZ3G2 { $MyComputername_New = "al-its-pc-g20"; break }

        1WM7MZ2 { $MyComputername_New = "al-its-pc-h01"; break }
        JWM7MZ2 { $MyComputername_New = "al-its-pc-h02"; break } 
        JVM7MZ2 { $MyComputername_New = "al-its-pc-h03"; break } 
        HWM7MZ2 { $MyComputername_New = "al-its-pc-h04"; break } 
        HVM7MZ2 { $MyComputername_New = "al-its-pc-h05"; break } 
        GWM7MZ2 { $MyComputername_New = "al-its-pc-h06"; break } 
        GVM7MZ2 { $MyComputername_New = "al-its-pc-h07"; break } 
        FWM7MZ2 { $MyComputername_New = "al-its-pc-h08"; break } 
        FVM7MZ2 { $MyComputername_New = "al-its-pc-h09"; break } 

        DWM7MZ2 { $MyComputername_New = "al-its-pc-h10"; break } 
        DVM7MZ2 { $MyComputername_New = "al-its-pc-h11"; break } 
        CWM7MZ2 { $MyComputername_New = "al-its-pc-h12"; break } 
        CVM7MZ2 { $MyComputername_New = "al-its-pc-h13"; break } 
        BWM7MZ2 { $MyComputername_New = "al-its-pc-h14"; break } 
        BVM7MZ2 { $MyComputername_New = "al-its-pc-h15"; break } 
        9XM7MZ2 { $MyComputername_New = "al-its-pc-h16"; break } 
        9WM7MZ2 { $MyComputername_New = "al-its-pc-h17"; break } 
        9VM7MZ2 { $MyComputername_New = "al-its-pc-h18"; break } 
        8XM7MZ2 { $MyComputername_New = "al-its-pc-h19"; break } 
        8WM7MZ2 { $MyComputername_New = "al-its-pc-h20"; break } 

        8VM7MZ2 { $MyComputername_New = "al-its-pc-h21"; break } 
        7XM7MZ2 { $MyComputername_New = "al-its-pc-h22"; break }
        7WM7MZ2 { $MyComputername_New = "al-its-pc-h23"; break }
        7VM7MZ2 { $MyComputername_New = "al-its-pc-h24"; break }
        6XM7MZ2 { $MyComputername_New = "al-its-pc-h25"; break }
        6WM7MZ2 { $MyComputername_New = "al-its-pc-h26"; break }
        6VM7MZ2 { $MyComputername_New = "al-its-pc-h27"; break }
        5XM7MZ2 { $MyComputername_New = "al-its-pc-h28"; break }
        5WM7MZ2 { $MyComputername_New = "al-its-pc-h29"; break }
        5VM7MZ2 { $MyComputername_New = "al-its-pc-h30"; break }

        4XM7MZ2 { $MyComputername_New = "al-its-pc-h31"; break }
        4WM7MZ2 { $MyComputername_New = "al-its-pc-h32"; break }
        4VM7MZ2 { $MyComputername_New = "al-its-pc-h33"; break }
        3XM7MZ2 { $MyComputername_New = "al-its-pc-h34"; break }
        3WM7MZ2 { $MyComputername_New = "al-its-pc-h35"; break }
        2XM7MZ2 { $MyComputername_New = "al-its-pc-h36"; break }
        2WM7MZ2 { $MyComputername_New = "al-its-pc-h37"; break }
        1XM7MZ2 { $MyComputername_New = "al-its-pc-h38"; break }

        76WLBS2 { $MyComputername_New = "g13-al-pc-g13"; break }

        Default { "Serial not defined."; $MyComputername_New = $MyComputername_Old }
    }


    Write-Host "Aktueller Name:" $env:computername
    Write-Host "Neuer     Name:" $MyComputername_New 

    Switch ($MyComputername_New ) {
        $MyComputername_Old { Write-Host "Keine Aenderung." ; break }
        Default { Write-Host "Umbenennen in:" $MyComputername_New; RENAME-COMPUTER -computer $MyComputername_Old -newname $MyComputername_New; RESTART-COMPUTER -force }
    }
    return $True
}

Function Test-JtFilename_Anzahl_IsValid {
    
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Filename
    )

    [String]$MyFunctionName = "Test-JtFilename_Anzahl_IsValid"

    [Boolean]$MyResult = $True
    [String]$MyFilename = $Filename
    $MyAlParts = $MyFilename.Split(".")
    [String]$MyCount = "0"
    try {
        [String]$MyInt = $MyAlParts[$MyAlParts.count - 2]
        [Decimal]$MyDecInt = [Decimal]$MyInt / 1
        $MyCount = $MyDecInt
    }
    catch {
        Write-JtLog_Error -Where $MyFunctionName -Text "Problem with COUNT - not valid - in file: $MyFilename"
        $MyResult = $False
    }
    return $MyResult
}


Function Test-JtFilename_Betrag_IsValid {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Filename
    )

    [String]$MyFunctionName = "Test-JtFilename_Betrag_IsValid"

    [Boolean]$MyResult = $True
    [String]$MyFilename = $Filename
    $Parts = $MyFilename.Split(".")
    [String]$MyEuro = ""
    try {
        [String]$MyCents = $Parts[$Parts.count - 2]
        $MyCents = $MyCents.Replace("_", "")
        [Decimal]$MyEuroDec = [Decimal]$MyCents / 100
        [String]$MyEuro = $MyEuroDec.ToString("0.00")
        $MyEuro = $MyEuro.Replace(".", ",")
    }
    catch {
        Write-JtLog_Error -Where $MyFunctionName -Text "Problem with EURO - not valid - in MyFilename: $MyFilename"
        $MyResult = $False
    }
    return $MyResult
}


Function Test-JtPart_Is_Valid_Decimal {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Part
    )

    # valid: "0_0", "10_0"
    # not valid: "0_", "a", "1a", "1,0", "2.0"

    $MyFunctionName = "Test-JtPart_Is_Valid_Decimal"
  
    [String]$MyValue = $Part

    if ($MyValue.Length -lt 3) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Too short. Length: $MyValue.Length. MyValue: $MyValue"
        return $False
    }
    
    [String]$MyTest = Convert-JtText_Remove_Digits -Text $MyValue
    if("_" -ne $MyTest) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Not valid. MyValue: $MyValue"
        return $False
    }


    $MyAlParts = $MyValue.Split("_")
    if (2 -ne $MyAlParts.Count) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Wrong number of parts - MyAlParts.Count: $MyAlParts.Count -  MyValue: $MyValue"
        return $False
    }
    [String]$MyFirstPart = $MyAlParts[0]
    if (1 -gt $MyFirstPart.length) {
        Write-JtLog_Error -Where $MyFunctionName -Text "MyFirstPart is empty  -  MyValue: $MyValue"
        return $False
    }

    [String]$MySecondPart = $MyAlParts[1]
    if (2 -ne $MySecondPart.length) {
        Write-JtLog_Error -Where $MyFunctionName -Text "MySecondPart: $MySecondPart -  MyValue: $MyValue"
        return $False
    }

    return $True
}

Function Test-JtPart_Is_Valid_Betrag {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Part
    )
    # valid: "23_23", "0_00"
    # not valid: "23,23", "12.23", "1.234,56", "1,234.56"

    $MyFunctionName = "Test-JtIsValid_Betrag"
  
    [String]$MyValue = $Part

    if(! (Test-JtPart_Is_Valid_Decimal -Part $MyValue)) {
        return $False
    }

    if ($MyValue.Length -lt 4) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Too short. Length: $MyValue.Length. MyValue: $MyValue"
        return $False
    }

    [String]$MyUnderscore = $MyValue.Substring($MyValue.Length - 3, 1)
    if (! ($MyUnderScore = "_")) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Missing underscore. Finding - MyUnderscore: $MyUnderscore -  MyValue: $MyValue"
        return $False
    }

    $MyAlParts = $MyValue.Split("_")
    if (2 -ne $MyAlParts.Count) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Wrong number of parts - MyAlParts.Count: $MyAlParts.Count -  MyValue: $MyValue"
        return $False
    }

    [String]$MySecondPart = $MyAlParts[1]
    if (2 -ne $MySecondPart.length) {
        Write-JtLog_Error -Where $MyFunctionName -Text "MySecondPart -  MyValue: $MyValue"
        return $False
    }

    return $True
}
Function Test-JtIsValid_Betrag {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Text
    )

    $MyFunctionName = "Test-JtIsValid_Betrag"

    [String]$MyValue = $Text
    [String]$MyWithoutUnderscore = $MyValue.Replace("_", "")
    try {
        [Int32]$MyIntValue = [Int32]$MyWithoutUnderscore
    }
    catch {
        Write-JtLog_Error -Where $MyFunctionName -Text "Value is not valid (int check). Value: $MyValue"
        return $False
    }
    try {
        $MyValue = $MyValue.Replace("_", ".")
        [Decimal]$MyDecValue = [Decimal]$MyValue
    }
    catch {
        Write-JtLog_Error -Where $MyFunctionName -Text "Value is not valid (decimal check). Value: $MyValue"
        return $False
    }
    try {
        $MyValue = $MyValue.Replace("_", ".")
        [Decimal]$MyDecValue = [Decimal]$MyValue
        [Int32]$MyIntValue = [Int32]$MyWithoutUnderscore
        [Decimal]$MyValueThroughInt = $MyIntValue / 100
        if (0 -ne ($MyValueThroughInt - $MyDecValue)) {
            Write-JtLog_Error -Where $MyFunctionName -Text "Value is not valid (comma check). Value: $MyValue"
            return $False
        }
    }
    catch {
        Write-JtLog_Error -Where $MyFunctionName -Text "Value is not valid (decimal check). Value: $MyValue"
        return $False
    }
    return $True
}



Function Test-JtIsValid_Integer {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Text
    )


    [String]$MyFunctionName = "Test-JtIsValid_Integer"

    [String]$MyText = $Text
    try {
        [Int16]$MyInt = [Int16]$MyText
        $MyInt | Out-Null
    }
    catch {
        Write-JtLog_Error -Where $MyFunctionName -Text "Not valid INTEGER. Problem with MyText: $MyText"
        return $False
    }

    return $True

}





Function Write-JtLog_Error {

    Param (
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Where,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Text
    )

    [String]$MyText = $Text
    [String]$MyWhere = $Where
    if ($Where) {
        [JtLog]$MyJtLog = [JtLog]::new($MyText, $MyWhere)
        $MyJtLog.DoPrintError()
    }
    else {
        [JtLog]$MyJtLog = [JtLog]::new($MyText)
        $MyJtLog.DoPrintError()
    }


}


Function Write-JtLog_Folder_Error {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Where,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Text,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FilePath,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$FilePath_Output

    )

    [String]$MyText = $Text
    [String]$MyWhere = $Where
    [String]$MyFilePath = $FilePath
    [JtLog]$MyJtLog = [JtLog]::new($MyText, $MyWhere)

    [String]$MyFilePath_Output = $FilePath_Output
    if ($MyFilePath_Output) {
        $MyJtLog.DoPrintFolder($MyFilePath, $MyFilePath_Output)
    }
    else {
        [String]$MyFilePath_Check = [JtLog]::GetFilePath_Check_Folder()
        [JtLog]$MyJtLog = [JtLog]::new($MyText)
        $MyJtLog.DoPrintFolder($MyFilePath, $MyFilePath_Check)
    }
}

Function Write-JtLog_File {

    Param (
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Where,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Text,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FilePath
    )
    
    [String]$MyText = $Text
    [String]$MyWhere = $Where
    [String]$MyFilePath = $FilePath

    if ($Where) {
        [JtLog]$MyJtLog = [JtLog]::new($MyText, $MyWhere)
        $MyJtLog.DoPrintIo($MyFilePath)
    }
    else {
        [JtLog]$MyJtLog = [JtLog]::new($MyText)
        $MyJtLog.DoPrintIo($MyFilePath)
    }
}

Function Write-JtLog_Folder {

    Param (
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Where,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Text,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath
    )
    
    [String]$MyText = $Text
    [String]$MyWhere = $Where
    [String]$MyFolderPath = $FolderPath

    if ($Where) {
        [JtLog]$MyJtLog = [JtLog]::new($MyText, $MyWhere)
        $MyJtLog.DoPrintIo($MyFolderPath)
    }
    else {
        [JtLog]$MyJtLog = [JtLog]::new($MyText)
        $MyJtLog.DoPrintIo($MyFolderPath)
    }
    
}
Function Write-JtLog {
    Param (
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Where,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Text
    )

    [String]$MyText = $Text
    [String]$MyWhere = $Where
    if ($Where) {
        [JtLog]$MyJtLog = [JtLog]::new($MyText, $MyWhere)
        $MyJtLog.DoPrintLog()
    }
    else {
        [JtLog]$MyJtLog = [JtLog]::new($MyText)
        $MyJtLog.DoPrintLog()
    }
}

Function Write-JtLog_Message {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Text,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Where,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Path,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Type,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][Int32]$Counter,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FilePath_Output
    )

    # [String]$MyFunctionName = "Write-JtLog_Message"
    # Write-Host "-----------------------------------------------------------------"

    [Boolean]$MyBlnLogToFile = $True

    [String]$MyFilePath_Output = $FilePath_Output
    [String]$MyType = $Type
    [String]$MyPath = ""
    if($Path) {
        $MyPath = $Path
        $MyPath = $MyPath.Replace("\", "/")
    }

    [String]$MyBackgroundColor = "Blue"
    [String]$MyForegroundColor = "Green"

    if ($MyType -eq "LOG") {
        $MyBackgroundColor = "Yellow"
        $MyForegroundColor = "Black"
    }
    elseif ($MyType -eq "IO") {
        $MyBackgroundColor = "Cyan"
        $MyForegroundColor = "Black"
    }
    elseif ($MyType -eq "FOLDER") {
        $MyBackgroundColor = "Magenta"
        $MyForegroundColor = "Black"
    }
    elseif ($MyType -eq "ERROR") {
        $MyBackgroundColor = "Red"
        $MyForegroundColor = "Black"
    }

    [String]$MyBackgroundColor_Path = "Black"
    [String]$MyForegroundColor_Path = "Cyan"

    # [String]$MyBackgroundColor_Sep = "Gray"
    # [String]$MyForegroundColor_Sep = "Black"

    [String]$MyOutput = $Text
    [String]$MyWhere = $Where
    [String]$MyTimestamp = Get-JtTimestamp

    [String]$MyCounter = "0000" + $Counter
    [String]$MyCounter = $MyCounter.Substring(($MyCounter.length) - 4, 4)
    
    [String]$MyMessage1 = "$MyCounter  .  $MyTimestamp  .  $MyType  .  $MyWhere"
    [String]$MyMessage2 = $MyOutput
    [String]$MyLine1 = "* $MyMessage1"
    [String]$MyLine2 = "* $MyMessage2"
    [String]$MyLine3 = "$MyPath "

    Write-Host -ForegroundColor "DarkGray" -BackgroundColor $MyBackgroundColor $MyMessage1
    Write-Host -ForegroundColor $MyForegroundColor -BackgroundColor "Dark$MyBackgroundColor" $MyMessage2
    Write-Host -ForegroundColor $MyForegroundColor_Path -BackgroundColor $MyBackgroundColor_Path "$Path "
    # Write-Host -ForegroundColor $MyForegroundColor_Sep  -BackgroundColor $MyBackgroundColor_Sep  "."
    # Write-Host "."

    if ($MyBlnLogToFile) {
        Add-content -path $MyFilePath_Output -value $MyLine1
        Add-content -path $MyFilePath_Output -value $MyLine2
        Add-content -path $MyFilePath_Output -value " "
        Add-content -path $MyFilePath_Output -value $MyLine3
        
        
        Add-content -path $MyFilePath_Output -value "$MyPath "
    }    
    
}


Export-ModuleMember -Function Convert-JtEnvironmentVariables

Export-ModuleMember -Function Convert-JtDecimal_To_String2
Export-ModuleMember -Function Convert-JtDecimal_To_String3
Export-ModuleMember -Function Convert-JtDotter

Export-ModuleMember -Function Convert-JtFilename_To_IntAnzahl
Export-ModuleMember -Function Convert-JtFilename_To_IntAlter
Export-ModuleMember -Function Convert-JtFilename_To_DecBetrag
Export-ModuleMember -Function Convert-JtFilename_To_DecQm
Export-ModuleMember -Function Convert-JtFilename_To_Info_With_Template
Export-ModuleMember -Function Convert-JtFilename_To_Jahr
Export-ModuleMember -Function Convert-JtFilename_To_Papier
Export-ModuleMember -Function Convert-JtFilePathExpanded
Export-ModuleMember -Function Convert-JtFolderPathExpanded

Export-ModuleMember -Function Convert-JtInt_To_00
Export-ModuleMember -Function Convert-JtInt_To_000
Export-ModuleMember -Function Convert-JtIp_To_Ip3
Export-ModuleMember -Function Convert-JtLabel_To_Filename
Export-ModuleMember -Function Convert-JtPath_To_Parts
Export-ModuleMember -Function Convert-JtPart_To_DecBetrag
Export-ModuleMember -Function Convert-JtText_German_To_International
Export-ModuleMember -Function Convert-JtString_To_Betrag
Export-ModuleMember -Function Convert-JtString_To_ColHeader
Export-ModuleMember -Function Convert-JtString_To_Decimal
Export-ModuleMember -Function Convert-JtString_To_DecGb
Export-ModuleMember -Function Convert-JtText_Template

Export-ModuleMember -Function Get-JtDate
Export-ModuleMember -Function Get-JtDateNormal
Export-ModuleMember -Function Get-JtDevMode
Export-ModuleMember -Function Get-JtFolderPath_Base
Export-ModuleMember -Function Get-JtMac
Export-ModuleMember -Function Get-JtRandom6
Export-ModuleMember -Function Get-JtTimestamp
Export-ModuleMember -Function Get-JtVersion

Export-ModuleMember -Function New-JtList
Export-ModuleMember -Function New-JtTimeStop

Export-ModuleMember -Function Rename-JtComputerpoolPc

Export-ModuleMember -Function Test-JtFilename_Anzahl_IsValid
Export-ModuleMember -Function Test-JtFilename_Betrag_IsValid
Export-ModuleMember -Function Test-JtIsValid_Betrag
Export-ModuleMember -Function Test-JtPart_Is_Valid_Betrag
Export-ModuleMember -Function Test-JtIsValid_Integer


Export-ModuleMember -Function Write-JtLog
Export-ModuleMember -Function Write-JtLog_Error
Export-ModuleMember -Function Write-JtLog_File
Export-ModuleMember -Function Write-JtLog_Folder
Export-ModuleMember -Function Write-JtLog_Folder_Error
Export-ModuleMember -Function Write-JtLog_Message



