using module JtClass
using module JtUtil

class JtIo : JtClass {

    hidden [String]$Path = ""
    hidden [Boolean]$BlnExists = $true

    static [String]$FilenamePrefix_Anzahl = "zzz"
    static [String]$FilenamePrefix_Area = "zzz"
    static [String]$FilenamePrefix_Count = "zzz"
    static [String]$FilenamePrefix_Csv = "zzz"
    static [String]$FilenamePrefix_Files = "files"
    static [String]$FilenamePrefix_Folder = "zzz"
    static [String]$FilenamePrefix_Report = "report"
    static [String]$FilenamePrefix_Sum = "zzz"
    
    static [String]$FilenameSuffix_Time = "time"
    static [String]$FilenameSuffix_Errors = "errors"
    
    static [String]$FilenameExtension_Anzahl_Meta = ".anzahl.meta"
    static [String]$FilenameExtension_Area = ".area"
    static [String]$FilenameExtension_Betrag_Meta = ".betrag.meta"
    static [String]$FilenameExtension_Count = ".count"
    static [String]$FilenameExtension_Csv = ".csv"
    static [String]$FilenameExtension_Folder = ".folder"
    static [String]$FilenameExtension_Md = ".md"
    static [String]$FilenameExtension_Meta = ".meta"
    static [String]$FilenameExtension_Poster = ".poster"
    static [String]$FilenameExtension_BxH_Meta = ".bxh.meta"
    static [String]$FilenameExtension_BxH_Md = ".bxh.md"
    static [String]$FilenameExtension_Sum = ".sum"
    static [String]$FilenameExtension_Sum_Meta = ".sum.meta"
    static [String]$FilenameExtension_Whg = ".whg"
    static [String]$FilenameExtension_Zahlung_Meta = ".zahlung.meta"
    static [String]$FilenameExtension_Zahlung_Md = ".zahlung.md"
    static [String]$FilenameExtension_Xml = ".xml"
    

    static hidden [String]$TimestampFormat = "yyyy-MM-dd_HH-mm-ss"
    static [String]GetComputername() {
        [String]$Result = ""
        $Result = $env:COMPUTERNAME
        $Result = $Result.ToLower()
        $Computername = $Result
        return $Computername
    }

    static [String]ConvertPathToLabel([String]$Path) {
        [String]$Result = $Path
        $Result = $Result.Replace("%COMPUTERNAME%", $env:COMPUTERNAME)
        $Result = $Result.Replace(":", "")
        $Result = $Result.Replace("*", "")
        $Result = $Result.Replace("\.", "")
        $Result = $Result.Replace("\", "_")
        $Result = $Result.Replace(".", "_")
        $Result = $Result.Replace("__", "_")
        return $Result
    }

    static [String]GetErrors([String]$Path) {
        [String]$Result = "---"
        
        [String]$Match = -join ([JtIo]::FilenamePrefix_Report, '.*', '.', [JtIo]::FilenameSuffix_Errors, [JtIo]::FilenameExtension_Meta)
        
        $MyFiles = Get-ChildItem -Path $Path | Where-Object { $_.Name -match $Match }
        
        if ($Null -ne $MyFiles) {
            if ($MyFiles.Length -gt 0) {
                $Filename = $MyFiles[0].Name
                [String[]]$Parts = $Filename.Split(".")
                $Result = $Parts[1]
            }
        }
        return $Result
    }

    static [String]GetLabelC() {
        $MyLabel = Get-WMIObject -Class Win32_Volume | Where-Object -Property DriveLetter -eq "C:" | Select-Object Label
        
        [String] $LabelC = $MyLabel.Label
        
        return $LabelC
    }

    static [String]GetMediaTypeForValue($Value) {
        [String]$Result = ""

        $Result = switch ($Value) { 
            3 { "HDD" }
            4 { "SSD" } 
            default { $Value }
        } 

        return $Result
    }

    static [String]GetSystemId() {
        $LabelC = [JtIo]::GetLabelC()
        $Computername = $env:COMPUTERNAME
        
        [String]$SystemId = ""
        
        $SystemId = -join ($Computername, ".", $LabelC)
        $SystemId = $SystemId.ToLower()
        return $SystemId
    }


    static [System.Collections.ArrayList]GetSelectedJtIoFiles([System.Array]$Folders, [System.Collections.ArrayList]$MySelection) {
        [System.Collections.ArrayList]$Result = [System.Collections.ArrayList]@()
        foreach ($Folder in $Folders) {
            [JtIoFolder]$JtIoFolder = $Folder
            $FullPath = $JtIoFolder.GetPath()
            if ($Null -eq $MySelection) {
                [JtIoFile]$JtIoFile = New-JtIoFile -Path $FullPath
                $Result.Add($FullPath)
            }
            else {
                [Boolean]$Compare = [JtIo]::IsJtIoFolderInSelection($JtIoFolder, $MySelection)
                if ($True -eq $Compare) {
                    [JtIoFile]$JtIoFile = New-JtIoFile -Path $FullPath
                    $Result.Add($FullPath)
                }
            } 
        }
        return $Result
    }
    

    static [Boolean]IsJtIoFolderInSelection([JtIoFolder]$TheFolder, [System.Collections.ArrayList]$Sel) {
        if ($Null -eq $Sel) {
            return $False
        }
        [Boolean]$Result = $False
        foreach ($Element in $Sel) {
            [String]$TheName = $Element.ToString()
            [String]$Search = -join ("*", $TheName, "*")

            [String]$FullPath = $TheFolder.GetPath()

            if ($FullPath -like $Search) {
                return $True
            }
        }
        return $Result
    }

    static [System.Collections.ArrayList]GetSelectedJtIoFolders([System.Array]$Folders, [System.Collections.ArrayList]$MySelection) {
        [System.Collections.ArrayList]$Result = [System.Collections.ArrayList]@()
        foreach ($Folder in $Folders) {
            [JtIoFolder]$JtIoFolder = $Folder
            if ($Null -eq $MySelection) {
                $Result.Add($JtIoFolder)
            }
            else {
                [Boolean]$Compare = [JtIo]::IsJtIoFolderInSelection($JtIoFolder, $MySelection)
                if ($True -eq $Compare) {
                    $Result.Add($JtIoFolder)
                }
            } 
        }
        return $Result
    }


    JtIo() {
        $This.ClassName = "JtIo"
    }

    
    [String]GetName() {
        Throw "GetName should be overwritten"
        return $Null
    }
    
    [String]GetLabelForName() {
        [String]$MyName = $This.GetName()
        [String]$Result = $MyName
        $Result = $Result.Replace(":", "")
        $Result = $Result.Replace("\", "_")
        $Result = $Result.Replace("%COMPUTERNAME%", $env:COMPUTERNAME)
        return $Result
    }
    
    [String]GetLabelForPath() {
        [String]$MyPath = $This.GetPath()
        [String]$Result = [JtIo]::ConvertPathToLabel($MyPath)
        return $Result
    }
    
    [String]GetPath() {
        [String]$MyPath = $This.Path
        return $MyPath
    }
}
    


Function New-JtIo {
    
    [JtIo]::new()
}


class JtIoFile : JtIo {

    hidden [Boolean]$BlnExists = $true

    
    JtIoFile([String]$MyPath) {
        $This.ClassName = "JtIoFile"
        $This.Path = ConvertTo-JtExpandedPath -Path $MyPath
        $This.BlnExists = Test-Path -Path $MyPath
    }
    
    [Boolean]DoRenameFile([String]$NewName) {
        Write-JtIo -Text ( -join ("Renaming file to ", $NewName, " at path ", $This.GetPath()))
        Rename-Item -Path $This.GetPath() -NewName $NewName
        # [JtIoFile]$NewFile = [JtIoFile]::new($This.)
        return $True
    }

    [Boolean]IsExisting() {
        $This.BlnExists = [System.IO.File]::Exists($This.GetPath())
        return $This.BlnExists
    }

    [Boolean]IsSpecialFile() {
        [Boolean]$IsSpecial = $False
        if ($This.GetName().Equals("desktop.ini")) {
            $IsSpecial = $True
            return $IsSpecial
        }  
        
        [String]$MyExtension = $This.GetExtension()
        
        $MyList = New-Object System.Collections.Generic.List[System.Object]
        $MyList.Add([JtIo]::FilenameExtension_Area)
        $MyList.Add([JtIo]::FilenameExtension_Count)
        $MyList.Add([JtIo]::FilenameExtension_Csv)
        $MyList.Add([JtIo]::FilenameExtension_Folder)
        $MyList.Add([JtIo]::FilenameExtension_Md)
        $MyList.Add([JtIo]::FilenameExtension_Meta)
        $MyList.Add([JtIo]::FilenameExtension_Whg)
        $MyList.Add([JtIo]::FilenameExtension_Poster)
        $MyList.Add([JtIo]::FilenameExtension_Sum)
        
        foreach ($Extension in $MyList) {
            if ($Extension.Equals($MyExtension)) {
                $IsSpecial = $True
                return $IsSpecial
            }
        }
        
        return $IsSpecial
    }
    
   
    [String]GetExtension() {
        [String]$Result = [System.IO.Path]::GetExtension($This.Path)
        Return $Result
    }


    [String]GetExtension2() {
        [String]$Path1 = $This.Path
        [String]$Extension1 = [System.IO.Path]::GetExtension($Path1)
        [String]$Path2 = $Path1.Replace($Extension1, "")
        [String]$Extension2 = [System.IO.Path]::GetExtension($Path2)

        [String]$Result = -join ($Extension2, $Extension1)
        Return $Result
    }

    [String]GetFileTimestamp() {
        [String]$Timestamp = ""
        [Boolean]$FileOk = $This.IsExisting
 
        if ($FileOk) {
            [System.Object[]]$JtObjects = Get-ChildItem -Path $This.Path
            [System.IO.FileSystemInfo]$File = $JtObjects[0]
            $Timestamp = $File.LastWriteTime.ToString([JtIo]::TimestampFormat)
        }
        return $Timestamp
    }

    # First column has number 0
    [String]GetFieldAtPos([String]$MyInput, [Int16]$MyPos) {
        $MyInputParts = $MyInput.Split(".")

        if ($MyInputParts.Count -lt $MyPos) {
            return ""
        }

        return $MyInputParts[$MyPos]
    }
    
    [String]GetInfoFromFileName_Age() {
        [String]$TheFilename = $This.GetName()

        [String]$MyAlter = "0"
        
        [String]$Year = $This.GetInfoFromFilename_Year()
        if ($Year.Length -gt 0 ) {
            $ThisDate = Get-Date
            $ThisYear = $ThisDate.Year
    
            # Aus "20-04" soll "2020" werden.
            $MySep = $Year.substring(2, 1)
            if ($MySep -eq "-") {
                $Year = -join ("20", $Year.substring(0, 2))
            } 
            try {
                $MyAlter = $ThisYear - $Year
            }
            catch {
                $MyAlter = "0"
                Write-JtError -Text ( -join ("Problem with ThisYear:", $ThisYear, " in Filename:", $TheFilename))
            }
        }
        else {
            return "0"
        }
        return $MyAlter
    }

  
    
    [String]GetInfoFromFileName_Count() {
        [String]$TheFilename = $This.GetName()
        $Parts = $TheFilename.Split(".")
        [String]$MyCount = "0"
        try {
            [String]$MyInt = $Parts[$Parts.count - 2]
            [Decimal]$DecInt = [Decimal]$MyInt / 1
            $MyCount = $DecInt
        }
        catch {
            Write-JtError -Text ( -join ("Problem with COUNT in file:", $TheFilename))
            Write-JtError -Text ( -join ("FilePath:", $This.GetPath()))
        }
        return $MyCount
    }

    [Boolean]GetInfoFromFileName_Count_IsValid() {
        [Boolean]$Result = $True
        [String]$TheFilename = $This.GetName()
        $Parts = $TheFilename.Split(".")
        [String]$MyCount = "0"
        try {
            [String]$MyInt = $Parts[$Parts.count - 2]
            [Decimal]$DecInt = [Decimal]$MyInt / 1
            $MyCount = $DecInt
        }
        catch {
            Write-JtError -Text ( -join ("Problem with COUNT - not valid - in file:", $TheFilename))
            $Result = $False
        }
        return $Result
    }
    
    [String]GetInfoFromFileName_Dim() {
        [String]$TheFilename = $This.GetName()
        $Parts = $TheFilename.Split(".")
        [String]$MyDim = ""
        try {
            [String]$MyDim = $Parts[$Parts.count - 2]
            $MyDim = $MyDim.Replace("x", " x ")
        }
        catch {
            Write-JtError -Text ( -join ("Problem with Dim in file:", $TheFilename))
            Write-JtError -Text ( -join ("FilePath:", $This.GetPath()))
        }
        return $MyDim
    }

    [String]GetInfoFromFileName([String]$JtTemplateFileName, [String]$TheFilename, [String]$Field) {
        [String]$Result = ""
        $TemplateParts = $JtTemplateFileName.Split(".")

        for ([Int16]$i = 0; $i -lt $TemplateParts.Count; $i = $i + 1 ) {
            [String]$TemplatePart = $TemplateParts[$i]
            if ($TemplatePart -eq $Field) {
                $Result = $This.GetFieldAtPos($TheFilename, $i)
            }

        }
        return $Result
    }
    
    [String]GetInfoFromFileName_Euro() {
        [String]$TheFilename = $This.GetName()
        $Parts = $TheFilename.Split(".")
        [String]$MyEuro = ""
        try {
            [String]$MyCents = $Parts[$Parts.count - 2]
            $MyCents = $MyCents.Replace("_", "")
            [Decimal]$MyEuroDec = [Decimal]$MyCents / 100
            [String]$MyEuro = $MyEuroDec.ToString("0.00")
            $MyEuro = $MyEuro.Replace(".", ",")
        }
        catch {
            Write-JtError -Text ( -join ("Problem with EURO in file:", $TheFilename))
            Write-JtError -Text ( -join ("FilePath:", $This.GetPath()))
        }
        return $MyEuro
    }
    
    [Boolean]GetInfoFromFileName_Euro_IsValid() {
        [Boolean]$Result = $True
        [String]$TheFilename = $This.GetName()
        $Parts = $TheFilename.Split(".")
        [String]$MyEuro = ""
        try {
            [String]$MyCents = $Parts[$Parts.count - 2]
            $MyCents = $MyCents.Replace("_", "")
            [Decimal]$MyEuroDec = [Decimal]$MyCents / 100
            [String]$MyEuro = $MyEuroDec.ToString("0.00")
            $MyEuro = $MyEuro.Replace(".", ",")
        }
        catch {
            Write-JtError -Text ( -join ("Problem with EURO - not valid - in file:", $TheFilename))
            $Result = $False
        }
        return $Result
    }
    
    [String]GetInfoFromFileName_Paper() {
        [String]$TheFilename = $This.GetName()
        $Parts = $TheFilename.Split(".")
        [String]$MyPaper = "xxxx"
        try {
            [String]$MyPaper = $Parts[$Parts.count - 3]
        }
        catch {
            Write-JtError -Text ( -join ("Problem with PAPIER in file:", $TheFilename))
            Write-JtError -Text ( -join ("FilePath:", $This.GetPath()))
        }
        return $MyPaper
    }
    
    [String]GetInfoFromFilename_Year() {
        [String]$TheFilename = $This.GetName()
        
        [String]$MyJahr = $TheFilename.substring(0, 4)
        
        try {
            # Aus "20-04" soll "2020" werden.
            $MySep = $MyJahr.substring(2, 1)
            if ($MySep -eq "-") {
                $MyJahr = -join ("20", $MyJahr.substring(0, 2))
            } 
        }
        catch {
            $MyJahr = ""
            Write-JtError -Text ( -join ("Problem with file:", $TheFilename))
        }
        return $MyJahr
    }

    [String]GetLabelForFilename() {
        [String]$Result = ""
        $Elements = $This.GetName().Split(".")
        [String]$Result = $Elements[0]
                
        return $Result
    }

    [String]GetName() {
        [String]$Result = [System.IO.Path]::GetFileName($This.Path)
        Return $Result
    }

    [String]GetNameWithoutExtension() {
        [String]$Result = $This.GetName()

        $Result = $Result.Replace($This.GetExtension(), "")

        Return $Result
    }  
    
    
    [String]GetPathOfFolder() {
        [String]$Result = $This.GetPath()
        $Result = $Result.Replace( -join ("\", $This.GetName()), "")
        return $Result
    }
}

Function New-JtIoFile {
    
    Param (
        [Parameter(Mandatory = $true)]
        [String]$Path
    )

    [JtIoFile]::new($Path)
}

class JtIoFileCsv : JtIoFile {
    
    JtIoFileCsv([String]$MyPath) : Base($MyPath) {
        $This.ClassName = "JtIoFileCsv"
    }

    [System.Collections.ArrayList]GetSelection([String]$Column) {
        $MyArrayList = [System.Collections.ArrayList]@()

        $Csv = Import-Csv -Path $This.Path -Delimiter ([JtUtil]::Delimiter)
        $Elements = $Csv | Select-Object -Property $Column | Sort-Object -Property $Column

        foreach ($Element in $Elements) {
            [String]$TheElement = $Element.$Column
            # [JtIoFile]$MyFile = [JtIoFile]::new($Element)
            $MyArrayList.Add($TheElement)
        }
        return $MyArrayList
    }
}

Function New-JtIoFileCsv {
    
    Param (
        [Parameter(Mandatory = $true)]
        [String]$Path
    )

    [JtIoFileCsv]::new($Path)
}


class JtIoFolder : JtIo {

    [System.IO.FileSystemInfo]$File = $Null

    static hidden [DateTime]GetReportFolderDateTime([String]$Path) {
        [String]$ThePath = ConvertTo-JtExpandedPath -Path $Path
        [System.DateTime]$FileDate = Get-Date
        [Boolean]$FileOk = Test-Path -Path $ThePath

        [String]$MyFilter = -join ("*", [JtIo]::FilenameExtension_Md)
 
        if ($FileOk) {
            [System.Object[]]$JtObjects = Get-ChildItem -Path $ThePath -File -Filter $MyFilter 
            if ($JtObjects.Count -gt 0) {
                [System.IO.FileSystemInfo]$MyFile = $JtObjects[0]
                [System.DateTime]$MyDate = $MyFile.LastWriteTime
                $FileDate = $MyDate
            }
        }
        return $FileDate
    }
    
    JtIoFolder([String]$MyPath) {
        $This.ClassName = "JtIoFolder"
        $This.Path = ConvertTo-JtExpandedPath -Path $MyPath
        $This.BlnExists = Test-Path -Path $This.Path
        if ($False -eq $This.BlnExists) {
            Write-JtError -Text ( -join ("JtIoFolder does NOT exist:", $This.Path))
        }
        else {
            [System.Object[]]$JtObjects = Get-ChildItem -Path $This.Path 
            if ($Null -eq $JtObjects) {
                # Write-JtError -Text ( -join ("Array of dirs is null:", $This.Path))
            }
            else {
                $This.File = $JtObjects[0]
            }
        }
    }

    JtIoFolder([String]$MyPath, [Boolean]$BlnCreate) {
        $This.ClassName = "JtIoFolder"
        $This.Path = ConvertTo-JtExpandedPath -Path $MyPath
        $This.BlnExists = Test-Path -Path $This.Path

        if ($False -eq $This.BlnExists) {
            if ($True -eq $BlnCreate) {
                Write-JtIo -Text ( -join ("Creating new folder (when calling JtIoFolder):", $This.Path))
                if ($This.Path.StartsWith("\\")) {
                    Write-JtError -Text ( -join ("Trying to create folder on server:", $This.Path))
                }
                else {
                    New-Item -type Directory -Force -Path $This.Path
                }
                $This.BlnExists = Test-Path -Path $This.Path
            }
        }

        $This.BlnExists = Test-Path -Path $This.Path

        if ($False -eq $This.BlnExists) {

        }
        else {
            [System.Object[]]$JtObjects = Get-Item -Path $This.Path
            $This.File = $JtObjects[0]
        }
    }

    JtIoFolder([JtIoFile]$JtIoFile) {
        $This.ClassName = "JtIoFolder"

        [String]$FilePath = $JtIoFile.GetPath()
        [String]$ParentPath = (Get-Item $FilePath).Directory.FullName

        $This.Path = ConvertTo-JtExpandedPath -Path $ParentPath
        $This.BlnExists = Test-Path -Path $This.Path
        if ($False -eq $This.BlnExists) {
            Write-JtError -Text ( -join ("JtIoFolder (from file). Path does NOT exist:", $This.Path))
        }
        else {
            # [System.Object[]]$JtObjects = Get-Item -Path $This.Path 
            # $This.File = $JtObjects[0]

            $This.File = Get-Item -Path $This.Path 
        }
    }
    

    [Boolean]DoCleanFiles([String]$ThePrefix, [String]$TheExtension) { 
        [String]$OutputFilePrefix = $ThePrefix
        [String]$OutputFileExtension = $TheExtension
    
        # [String]$MyFolderName = $This.GetName()
        # [String]$MyFilter = -join ($OutputFilePrefix, ".", $MyFolderName, ".", "*", $OutputFileExtension)
        [String]$MyFilter = -join ($OutputFilePrefix, ".", "*", $OutputFileExtension)
        return $This.DoDeleteAllFiles($MyFilter)
    }


    [Boolean]DoDeleteAllFiles() {
        if ($This.IsExisting()) {
            [String]$AllFiles = -join ($This.GetPath(), "\", "*.*")
            Write-JtIo -Text ( -join ("Deleting content of:", $AllFiles))
            try {
                Get-ChildItem -Path $AllFiles -File | Remove-Item -Force
            }
            catch {
                [String]$Msg = -join ("Error while deleting files in ", $This.GetPath())
                Write-JtError -Text ($Msg)
                return $False
            }
            
            return $True
        }
        else {
            Write-JtError -Text ( -join ("Trying to delete all files in folder, but folder does not exist:", $This.GetPath()))
            return $False
        }
    }

    [Boolean]DoDeleteAllFiles([String]$Filter) {
        Write-JtIo -Text ( -join ("Deleting content of:", $This.GetPath(), " using filter:", $Filter))
        try {
            Get-Childitem -Path $This.Path -Filter $Filter -File | Remove-Item -Filter $Filter -Force
        }
        catch {
            [String]$Msg = -join ("Error while deleting files in ", $This.GetPath())
            Write-JtError -Text ($Msg)
            return $False
        }
        
        return $True
    }
    
    [Boolean]DoDeleteEverything() {
        [String]$AllFiles = -join ($This.GetPath(), "\", "*")
        Write-JtIo -Text ( -join ("Deleting all files in:", $AllFiles))
    
        try {
            Remove-Item  $AllFiles -Include "*.*" -Recurse -Force
        }
        catch {
            [String]$Msg = -join ("Error while deleting EVERYTHING in ", $This.GetPath())
            Write-JtError -Text ($Msg)
            Write-JtIo -Text ($Msg)
            return $False
        }
        return $True
    }

    [Boolean]DoOptimizeFilenames() {
        [Boolean]$Result = $True
        foreach ($TheNFile in $This.GetNormalFiles()) {
            [JtIoFile]$TheNormalFile = [JtIoFile]$TheNFile
            [String]$MyFilename = $TheNormalFile.GetName()
                
            $OptimalFilename = ConvertTo-LabelToFilename $MyFilename
                
            if ($MyFilename -eq $OptimalFilename) {
                Write-JtLog -Text ( -join ($MyFilename, " is ok."))
            }
            else {
                Write-JtError -Text ( -join ($MyFilename, " should is renamed to:", $OptimalFilename))
                $TheNormalFile.DoRenameFile($OptimalFilename)
            }
        }
        return $Result
    }
    
    [JtIoFile]GetJtIoFile([String]$MyFilename) {
        [String]$NewPath = -join ($This.GetPath(), "\", $MyFilename)
        [JtIoFile]$JtIoFile = [JtIoFile]::new($NewPath)
        
        return $JtIoFile
    }
    
    [System.Collections.ArrayList]GetJtIoFiles() {
        return $This.GetJtIoFiles($False)
    }

    [System.Collections.ArrayList]GetJtIoFiles([Boolean]$DoRecurse) {
        if (!($This.IsExisting())) {
            Write-JtError -Text ( -join ("GetJtIoFiles. Folder does not exist:", $This.GetPath()))
            Write-JtError -Text ("GetJtIoFiles. Please edit XML in lines!!!!")
            #            Throw $ErrorMsg
            #            Exit
        }
        
        [System.Object[]]$Files = $Null
        
        if ($True -eq $DoRecurse) {
            $Files = Get-ChildItem -Path $This.GetPath() -file -Recurse | Sort-Object -Property Name
        }
        else {
            $Files = Get-ChildItem -Path $This.GetPath() -file | Sort-Object -Property Name
        }
        
        [System.Collections.ArrayList]$MyFiles = [System.Collections.ArrayList]::new()
        
        foreach ($File in $Files) {
            [String]$ThePath = $File.fullname
            [JtIoFile]$JtIoFile = [JtIoFile]::new($ThePath)
            $MyFiles.Add($JtIoFile)
        }
        return $MyFiles
    }

    [System.Collections.ArrayList]GetJtIoFilesWithExtension([String]$MyExtension) {
        [String]$MyFilter = -join ("*", $MyExtension)
        return $This.GetJtIoFilesWithFilter($MyFilter, $False)
    }

    [System.Collections.ArrayList]GetJtIoFilesWithFilter([String]$MyFilter) {
        return $This.GetJtIoFilesWithFilter($MyFilter, $False)
    }

    [System.Collections.ArrayList]GetJtIoFilesWithFilter([String]$MyFilter, [Boolean]$DoRecurse) {
        [System.Collections.ArrayList]$Result = [System.Collections.ArrayList]::new()
        
        if (!($This.IsExisting())) {
            [String]$ErrorMsg =  -join ("GetJtIoFilesWithFilter. Not existing. PATH:", $This.GetPath(), " FILTER:", $Myfilter)
            Write-JtError -Text $ErrorMsg
            Write-JtError -Text ("GetJtIoFilesWithFilter. Please edit XML in lines!!!!")
            Throw $ErrorMsg
            #            Exit
            return $Result
        }
        if ($Null -eq $MyFilter) {
            Write-JtError -Text ("Filter is null in GetJtIoFiles!!!")
        }
        else {
            [System.Object[]]$MyFiles = $Null
            if ($MyFilter.Length -gt 0) {
                if ($True -eq $DoRecurse) {
                    [System.Object[]]$MyFiles = Get-ChildItem -Path $This.GetPath() -file -Filter $MyFilter -Recurse | Sort-Object -Property Name
                }
                else {
                    Write-JtLog ( -join ("GetJtIoFilesWithFilter - Path:", $This.GetPath(), " Filter:", $MyFilter))
                    [System.Object[]]$MyFiles = Get-ChildItem -Path $This.GetPath() -file -Filter $MyFilter | Sort-Object -Property Name
                }
            }
            else {
                if ($True -eq $DoRecurse) {
                    [System.Object[]]$MyFiles = Get-ChildItem -Path $This.GetPath() -file -Recurse | Sort-Object -Property Name
                }
                else {
                    [System.Object[]]$MyFiles = Get-ChildItem -Path $This.GetPath() -file | Sort-Object -Property Name
                }

            }
            foreach ($File in $MyFiles) {
                [String]$ThePath = $File.fullname
                [JtIoFile]$JtIoFile = [JtIoFile]::new($ThePath)
                $Result.Add($JtIoFile)
            }
        }
        return $Result
    }
    
    [System.Collections.ArrayList]GetJtIoFilesCsv() {
        [String]$MyFilter = "*.csv"
        return $This.GetJtIoFilesWithFilter($MyFilter)
    }
    
    [System.Collections.ArrayList]GetJtIoFilesXml() {
        [String]$MyFilter = "*.xml"
        return $This.GetJtIoFilesWithFilter($MyFilter)
    }

    [String]GetFilePath([String]$Filename) {
        [String]$ThePath = $This.GetPath()
        [String]$Result = -join ($ThePath, "\", $Filename)
        return $Result
    }
    
    [String]GetFileTimestamp() {
        [String]$Timestamp = ""
        [Boolean]$FileOk = $This.IsExisting()
        
        if ($FileOk) {
            
            $Timestamp = $This.File.LastWriteTime.ToString([JtIo]::TimestampFormat)
        }
        return $Timestamp
    }

    # Case sensitive
    # .pdf, .PDF are different types
    [System.Collections.ArrayList]JtTblTable() {
        [System.Collections.ArrayList]$Folders = $This.GetSubFolders()

        $Filetypes = [System.Collections.ArrayList]::new()

        foreach ($AnyFolder in $Folders) {
            [System.Collections.ArrayList]$FileTypesInFolder = $AnyFolder.GetFiletypesInFolder()
            foreach ($Type in $FileTypesInFolder) {
                [String]$MyType = $Type
                if ($Filetypes.contains($MyType)) {

                }
                else {
                    $Filetypes.add($MyType)
                }
            }
        }
        return $Filetypes
    }

    # Case insensitive
    # .pdf, .PDF are the same
    [System.Collections.ArrayList]GetFiletypesInFolder() {
        $Filetypes = [System.Collections.ArrayList]::new()

        $Files = $This.GetJtIoFiles()
        foreach ($AnyFile in $Files) {
            [JtIoFile]$MyFile = $AnyFile
            # $File.GetPath()
            $Type = $MyFile.GetExtension()
            $Type = $Type.ToLower()
            if ($Filetypes.contains($Type)) {

            }
            else {
                $Filetypes.add($Type)
            }
        }
        return $Filetypes
    }


    [System.Collections.ArrayList]GetFiletypesInSubFolders() {
        [System.Collections.ArrayList]$AllTypes = [System.Collections.ArrayList]::new()

        [System.Collections.ArrayList]$Subfolders = $This.GetSubFolders()
        foreach ($AnyFolder in $Subfolders) {
            [JtIoFolder]$MyFolder = $AnyFolder

            [System.Collections.ArrayList]$Types = $MyFolder.GetFileTypesInFolder() 
            foreach ($AnyType in $Types) {
                # $File.GetPath()
                [String]$Type = [String]$AnyType
                if ($AllTypes.contains($Type)) {

                }
                else {
                    $AllTypes.add($Type)
                }
            }
        }
        return $AllTypes
    }

    [System.Collections.ArrayList]GetFolderFiles() {
        [String]$MyFilter = -join ("*", [JtIo]::FilenameExtension_Folder)
        [System.Collections.ArrayList]$FolderFiles = $This.GetJtIoFilesWithFilter($MyFilter, $True) 
        return $FolderFiles
    }

    [String]GetFolderSize() {
        $sum = 0
        if ( (Test-Path $This.GetPath()) -and (Get-Item $This.GetPath()).PSIsContainer ) {
            $Measure = Get-ChildItem $This.GetPath() -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum
            
            $Sum = $Measure.Sum
        }
        # "{0:N2} GB" -f ((gci Downloads | measure Length -s).Sum /1GB)
        [String]$Result = "{0:N2} MB" -f ($Sum / 1MB)
        return $Result
    }
    
    [DateTime]GetLastModified() {
        return [JtIoFolder]::GetReportFolderDateTime($This.GetPath())
    }
    
    [String]GetName() {
        return (Get-Item -Path $This.Path).Name
    }
    
    [System.Collections.ArrayList]GetNormalFiles() {
        [System.Collections.ArrayList]$AllFiles = $This.GetJtIoFiles($False)
        
        [System.Collections.ArrayList]$TheFiles = [System.Collections.ArrayList]::new()
        foreach ($MyFile in $AllFiles) {
            [JtIoFile]$JtIoFile = $MyFile
            
            [Boolean]$IsSpecial = $JtIoFile.IsSpecialFile()
            
            if ($False -eq $IsSpecial) {
                # Write-Host "No special file: " $JtIoFile.GetName()
                $TheFiles.Add($JtIoFile)
            }
        }
        return $TheFiles
    }
    
    [JtIoFolder]GetParentFolder() {
        [String]$ParentPath = (Get-Item $This.GetPath()).parent.FullName
        [JtIoFolder]$ParentFolder = [JtIoFolder]::new($ParentPath)
        return $ParentFolder
    }
    
    [JtIoFolder]GetSubfolder([String]$MyName, [Boolean]$BlnCreate) {
        [String]$NewPath = -join ($This.GetPath(), "\", $MyName)
        if (Test-Path -Path $NewPath) {
            [JtIoFolder]$JtIoFolder = [JtIoFolder]::new($NewPath)
            return $JtIoFolder
        }
        if ($True -eq $BlnCreate) {
            Write-JtIo -Text ( -join ("Creating new folder (when calling GetSubfolder):", $NewPath))
            [JtIoFolder]$JtIoFolder = [JtIoFolder]::new($NewPath, $True)
            if (Test-Path -Path $NewPath) {
                [JtIoFolder]$JtIoFolder = [JtIoFolder]::new($NewPath)
                return $JtIoFolder
            }
            else {
                Write-JtError -Text ( -join ("Error while creating folder (when calling GetSubfolder):", $NewPath))
                return $null
            }
        }
        return $Null
    }

    [JtIoFolder]GetSubfolder([String]$MyName) {
        return $This.GetSubfolder($MyName, $False)
    }
    
    
    [System.Collections.ArrayList]GetSubfolders() {
        return $This.GetSubfolders($False)
    }

    [System.Collections.ArrayList]GetSelectedSubfolders([System.Collections.ArrayList]$MySelection) {
        [System.Collections.ArrayList]$TheSubfolders = $This.GetSubfolders($False)
        [System.Collections.ArrayList]$TheSelectedFolders = [JtIo]::GetSelectedJtIoFolders($TheSubfolders, $MySelection)
        return $TheSelectedFolders
    }
    
    [System.Collections.ArrayList]GetSubfolders([Boolean]$Recurse) {
        [System.Collections.ArrayList]$Output = [System.Collections.ArrayList]::new()
        
        if ($This.IsExisting()) {
            if ($True -eq $Recurse) {
                $Subfolders = Get-ChildItem -Path $This.GetPath() -Directory -Recurse
                foreach ($MyLine In $Subfolders) {
                    [JtIoFolder]$JtIoFolder = [JtIoFolder]::new($MyLine.fullname)
                    $Output.add( $JtIoFolder)
                }    
            }
            else {
                $Subfolders = Get-ChildItem -Path $This.GetPath() -Directory 
                foreach ($MyLine In $Subfolders) {
                    [JtIoFolder]$JtIoFolder = [JtIoFolder]::new($MyLine.fullname)
                    $Output.add( $JtIoFolder)
                }    
            }
        }
        return $Output
    }
    
    [Boolean]IsExisting() {
        $This.BlnExists = [System.IO.Directory]::Exists($This.GetPath())
        return $This.BlnExists
    }
}


function New-JtIoFileMeta {
        
    Param (
        [Parameter(Mandatory = $true)]
        [String]$Path,
        [Parameter(Mandatory = $true)]
        [String]$Label,
        [Parameter(Mandatory = $False)]
        [String]$Content
    )

    [String]$MyContent
    if (!($Content)) {
        $MyContent = "Hello World!"
    }
    else {
        $MyContent = $Content
    }

    [String]$Extension = [JtIo]::FilenameExtension_Meta
    [String]$FileName = -join ($Label, $Extension)
    [JtIoFolder]$MyFolder = New-JtIoFolder -Path $Path
    
    [String]$OutputFilePath = $MyFolder.GetFilePath($FileName)
    Write-JtIo -Text ( -join ("Writing file:", $OutputFilePath))
    $Content | Out-File -FilePath $OutputFilePath -Encoding utf8
}

function New-JtIoFileVersionMeta {
        
    Param (
        [Parameter(Mandatory = $true)]
        [String]$Path,
        [Parameter(Mandatory = $False)]
        [String]$Content
    )

    [String]$MyContent
    if (!($Content)) {
        $MyContent = "Hello World!"
    }
    else {
        $MyContent = $Content
    }

    [String]$MyPath = ConvertTo-JtExpandedPath -Path $Path
    

    [String]$MyType = "version"
    [String]$MyTimestamp = Get-JtDate
    [String]$MyLabel = -join ("_", $MyTimestamp, ".", "version")
    [String]$MyFilter = -join ("*", ".", $MyType, [JtIo]::FilenameExtension_Meta)
    [JtIoFolder]$TargetFolder = New-JtIoFolder -Path $MyPath
    
    $TargetFolder.DoDeleteAllFiles($MyFilter)

    New-JtIoFileMeta -Path $MyPath -Label $MyLabel -Content $MyContent

}


Function ConvertTo-JtIoBetterFilenames {
    Param (
        [Parameter(Mandatory = $true)]
        [String]$Path
    )

    [JtIoFolder]$TheFolder = [JtIoFolder]::new($Path)

    $TheFolder.DoOptimizeFilenames()
}

Function New-JtIoFolder {
    Param (
        [Parameter(Mandatory = $true)]
        [String]$Path,
        [Parameter(Mandatory = $false)]
        [Boolean]$Force
    )

    [JtIoFolder]::new($Path, $Force)
}

Function New-JtIoFolderInv {

    New-JtIoFolder -Path "c:\_inventory" -Force $True
}

Function New-JtIoFolderReport {

    New-JtIoFolder -Path "c:\_inventory\report" -Force $True
}

Function Get-JtIoFolderTypes {
    Param (
        [Parameter(Mandatory = $true)]
        [String]$Path
    )

    [String]$MyFilter = "*.folder"
    [JtIoFolder]$MyFolder = New-JtIoFolder -Path $Path
    [System.Collections.ArrayList]$MyFiles = $MyFolder.GetJtIoFilesWithFilter($MyFilter, $True)

    [Hashtable]$Ext = New-Object Hashtable

    foreach ($File in $MyFiles) {
        $File.GetPath()
        # $File.GetName()
        # $File.GetExtension()
        # $File.GetExtension2()    
        $Value = $File.GetExtension2()
        if (!($Ext.Contains($Value))) {
            $Ext.add($Value, $Value)
        }

    }
    return $Ext.Keys

}



Export-ModuleMember -Function ConvertTo-JtIoBetterFilenames, Get-JtIoFolderTypes, New-JtIo, New-JtIoFile, New-JtIoFileCsv, New-JtIoFileMeta, New-JtIoFileVersionMeta, New-JtIoFolder, New-JtIoFolderInv, New-JtIofolderReport

