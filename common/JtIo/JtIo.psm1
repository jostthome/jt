using module Jt  


class JtConfig : JtClass {

    [JtIoFolder]$JtIoFolder_Base
    [JtIoFolder]$JtIoFolder_Report
    [JtIoFolder]$JtIoFolder_Inv
    
    JtConfig() {
        $This.ClassName = "JtConfig"
        Write-JtLog -Where $This.ClassName -Text "START!"
        
        [String]$MyProjectPath = Get-JtFolderPath_Base

        $This.JtIoFolder_Base = [JtIoFolder]::new($MyProjectPath)
        $This.JtIoFolder_Report = New-JtIoFolder_Report
        $This.JtIoFolder_Inv = New-JtIoFolder_Inv
    }

    [Boolean]DoPrintInfo() {
        #        Write-Host "SHOULD BE LIKE: Get_JtIoFolder_Base   : D:\Seafile\al-apps\apps\inventory"
        [String]$FolderPathBase = $This.Get_JtIoFolder_Base().GetPath()
        Write-JtLog -Where $This.ClassName -Text "Path of JtIoFolder_Base: $FolderPathBase"
        return $True
    }
    
    # --------------------------------------------------------------------------------------
    [JtIoFolder]Get_JtIoFolder_Base() {
        return $This.JtIoFolder_Base
    }

    [JtIoFolder]Get_JtIoFolder_Inv() {
        return $This.JtIoFolder_Inv
    }

    [JtIoFolder]Get_JtIoFolder_Report() {
        return $This.JtIoFolder_Report
    }
}





class JtIo : JtClass {

    hidden [String]$Path = ""
    hidden [Boolean]$BlnExists = $True

    static [String]$FilePart_Betrag = "betrag"
    static [String]$FilePart_Datum = "datum"
    static [String]$FilePart_Zahlung = "zahlung"

    static [String]$FilePrefix_Anzahl = "zzz"
    static [String]$FilePrefix_Betrag = "xxx"
    static [String]$FilePrefix_Buchung = "yyy"
    static [String]$FilePrefix_Count = "zzz"
    static [String]$FilePrefix_Csv = "zzz"
    static [String]$FilePrefix_Folder = "zzz"
    static [String]$FilePrefix_Report = "zzx"
    static [String]$FilePrefix_Selection = "selection"
    
    static [String]$FileSuffix_Time = "time"
    static [String]$FileSuffix_Errors = "errors"
    
    static [String]$Filename_Template_BxH = "_NACHNAME.VORNAME.LABEL.PAPIER.BxH.folder"
    static [String]$FileExtension_Csv = ".csv"
    static [String]$FileExtension_Csv_Filelist = ".filelist.csv"
    static [String]$FileExtension_Pdf = ".pdf"
    static [String]$FileExtension_Jpg = ".jpg"
    static [String]$FileExtension_Folder = ".folder"
    static [String]$FileExtension_Folder_Anzahl = ".ANZAHL.folder"
    static [String]$FileExtension_Folder_Betrag = ".BETRAG.folder"
    static [String]$FileExtension_Folder_BxH = ".BxH.folder"
    static [String]$FileExtension_Folder_Stand = ".STAND.folder"
    static [String]$FileExtension_Folder_Stunden = ".STUNDEN.folder"
    static [String]$FileExtension_Folder_Zahlung = ".ZAHLUNG.folder"
    static [String]$FileExtension_Meta = ".meta"
    static [String]$FileExtension_Meta_Anzahl = ".anzahl.meta"
    static [String]$FileExtension_Meta_Betrag = ".meta"
    static [String]$FileExtension_Meta_BxH = ".bxh.meta"
    static [String]$FileExtension_Meta_Choco = ".choco.meta"
    static [String]$FileExtension_Meta_Cmd = ".cmd.meta"
    static [String]$FileExtension_Meta_Computer = ".computer.meta"
    static [String]$FileExtension_Meta_Ip = ".ip.meta"
    static [String]$FileExtension_Meta_Errors = ".errors.meta"
    static [String]$FileExtension_Meta_Klon = ".klon.meta"
    static [String]$FileExtension_Meta_Obj = ".obj.meta"
    static [String]$FileExtension_Meta_Report = ".report.meta"
    static [String]$FileExtension_Meta_Systemid = ".systemid.meta"
    static [String]$FileExtension_Meta_Sum = ".sum.meta"
    static [String]$FileExtension_Meta_Time = ".time.meta"
    static [String]$FileExtension_Meta_User = ".user.meta"
    static [String]$FileExtension_Meta_Version = ".version.meta"
    static [String]$FileExtension_Meta_Win = ".win.meta"
    static [String]$FileExtension_Meta_Zahlung = ".zahlung.meta"
    static [String]$FileExtension_Md = ".md"
    static [String]$FileExtension_Md_Abrechnung = ".abrechnung.md"
    static [String]$FileExtension_Md_BxH = ".bxh.md"
    static [String]$FileExtension_Md_Zahlung = ".zahlung.md"
    static [String]$FileExtension_Txt = ".txt"
    static [String]$FileExtension_Xml = ".xml"

    static hidden [String]$TimestampFormat = "yyyy-MM-dd_HH-mm-ss"

    static [String]GetAliasForComputername([String]$Name) {
        [String]$MyOut = $Name
        # if ($In -eq "PC-3XTM5Y1") {
        #     $Out = "AL-DEK-PC-DEK05"
        # }
        return $MyOut
    }


    static [String]GetOrg1ForComputername([String]$TheComputername) {
        [String]$MyResult = ""
        if ($TheComputername) {
            [String[]]$MyAlParts = $TheComputername.Split("-")
            if ($MyAlParts.Count -gt 2) {
                $MyResult = $MyAlParts[0]
            }
        }
        return $MyResult
    }
    
    static [String]GetOrg2ForComputername([String]$TheComputername) {
        [String]$MyResult = ""
        if ($TheComputername) {
            [String[]]$MyAlParts = $TheComputername.Split("-")
            if ($MyAlParts.Count -gt 2) {
                $MyResult = $MyAlParts[1]
            }
        }
        return $MyResult
    }
    
    static [String]GetTypeForComputername([String]$TheComputername) {
        [String]$MyResult = ""
        if ($TheComputername) {
            [String[]]$MyAlParts = $TheComputername.Split("-")
            if ($MyAlParts.Count -gt 3) {
                $MyResult = $MyAlParts[2]
            }
        }
        return $MyResult
    }




    static [String]GetComputername() {
        [String]$MyResult = ""
        $MyResult = $env:COMPUTERNAME
        $MyResult = $MyResult.ToLower()
        $Computername = $MyResult
        return $Computername
    }



    static [String]GetErrors([String]$TheFolderPath) {
        [String]$MyFolderPath = $TheFolderPath


        [String]$MyResult = "---"
        
        [String]$MyMatch = -join ([JtIo]::FilePrefix_Report, '.*', '.', [JtIo]::FileSuffix_Errors, [JtIo]::FileExtension_Meta)
        
        $MyAlFiles = Get-ChildItem -Path $MyFolderPath | Where-Object { $_.Name -match $MyMatch }
        
        if ($Null -ne $MyAlFiles) {
            if ($MyAlFiles.Length -gt 0) {
                $MyFilename = $MyAlFiles[0].Name
                [String[]]$Parts = $MyFilename.Split(".")
                $MyResult = $Parts[1]
            }
        }
        return $MyResult
    }

    static [String]GetLabelC() {
        $MyLabel = Get-WMIObject -Class Win32_Volume | Where-Object -Property DriveLetter -eq "C:" | Select-Object Label
        
        [String] $MyLabelC = $MyLabel.Label
        
        return $MyLabelC
    }

    static [String]GetMediaTypeForValue($TheValue) {
        [String]$MyMediaType = ""

        $MyMediaType = switch ($TheValue) { 
            3 { "HDD" }
            4 { "SSD" } 
            default { $TheValue }
        } 

        return $MyMediaType
    }

    static [String]GetSystemId() {
        $MyLabelC = [JtIo]::GetLabelC()
        $MyComputername = $env:COMPUTERNAME
        
        [String]$MySystemId = ""
        
        $MySystemId = -join ($MyComputername, ".", $MyLabelC)
        $MySystemId = $MySystemId.ToLower()
        return $MySystemId
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
        [String]$MyResult = $MyName
        $MyResult = $MyResult.Replace(":", "")
        $MyResult = $MyResult.Replace("\", "_")
        $MyResult = $MyResult.Replace("%COMPUTERNAME%", $env:COMPUTERNAME)
        return $MyResult
    }
    
    [String]GetPath() {
        [String]$MyPath = $This.Path
        return $MyPath
    }

    [String]ToString() {
        return $this.GetPath()
    }
}


class JtIoFile : JtIo {

    hidden [Boolean]$BlnExists = $True

    JtIoFile([String]$TheFilePath) {
        $This.ClassName = "JtIoFile"
        $This.Path = Convert-JtFilePathExpanded -FilePath $TheFilePath
        $This.BlnExists = Test-JtIoPath -Path $TheFilePath
    }
    
    [Boolean]DoRenameFile([String]$FilenameNew) {
        [String]$MyFilePath = $This.GetPath()
        Write-JtLog_File -Where $This.ClassName -Text "Renaming file to $FilenameNew in ..." -FilePath $MyFilePath
        Rename-Item -Path $MyFilePath -NewName $FilenameNew
        # [JtIoFile]$NewFile = [JtIoFile]::new($This.)
        return $True
    }

    [Boolean]IsExisting() {
        $This.BlnExists = [System.IO.File]::Exists($This.GetPath())
        return $This.BlnExists
    }

    [String]GetExtension() {
        [String]$MyResult = [System.IO.Path]::GetExtension($This.Path)
        Return $MyResult
    }
    
    
    [String]GetExtension2() {
        [String]$MyPath1 = $This.Path
        [String]$MyExtension1 = [System.IO.Path]::GetExtension($MyPath1)
        [String]$MyPath2 = $MyPath1.Replace($MyExtension1, "")
        [String]$MyExtension2 = [System.IO.Path]::GetExtension($MyPath2)
        
        [String]$MyResult = -join ($MyExtension2, $MyExtension1)
        Return $MyResult
    }

    [String]GetFileTimestamp() {
        [String]$MyTimestamp = ""
        [Boolean]$MyBlnFileOk = $This.IsExisting()
        
        if ($MyBlnFileOk) {
            [System.Object[]]$MyAlJtObjects = Get-ChildItem -Path $This.Path
            [System.IO.FileSystemInfo]$MyFile = $MyAlJtObjects[0]
            $MyTimestamp = $MyFile.LastWriteTime.ToString([JtIo]::TimestampFormat)
        }
        return $MyTimestamp
    }
    

    [String]GetLabelForFilename() {
        [String]$MyResult = ""
        $Elements = $This.GetName().Split(".")
        [String]$MyResult = $Elements[0]
                
        return $MyResult
    }

    [String]GetName() {
        [String]$MyResult = [System.IO.Path]::GetFileName($This.Path)
        Return $MyResult
    }

    [String]GetNameWithoutExtension() {
        [String]$MyResult = $This.GetName()

        $MyResult = $MyResult.Replace($This.GetExtension(), "")

        Return $MyResult
    }  
    
    
    [String]GetPathOfFolder() {
        [String]$MyResult = $This.GetPath()
        $MyResult = $MyResult.Replace( -join ("\", $This.GetName()), "")
        return $MyResult
    }

    [JtIoFolder]GetJtIoFolder_Parent() {
        return [JtIoFolder]::new($This)
    }
}



class JtIoFileCsv : JtIoFile {
    
    JtIoFileCsv([String]$MyPath) : Base($MyPath) {
        $This.ClassName = "JtIoFileCsv"
    }

    [System.Collections.ArrayList]GetSelection([String]$MyColumn) {
        [String]$MyPath = $This.GetPath()

        $MyArrayList = [System.Collections.ArrayList]@()

        $Csv = Import-Csv -Path $MyPath -Delimiter ([JtClass]::Delimiter)
        $Elements = $Csv | Select-Object -Property $MyColumn | Sort-Object -Property $MyColumn

        foreach ($Element in $Elements) {
            [String]$MyEle = $Element.$MyColumn
            $MyArrayList.Add($MyEle)
        }
        return $MyArrayList
    }
}

class JtIoFolder : JtIo {

    static hidden [DateTime]GetReportFolderDateTime([String]$FolderPath) {
        [String]$MyFolderPath = Convert-JtFolderPathExpanded -FolderPath $FolderPath
        [System.DateTime]$MyFileDate = Get-Date

        [Boolean]$MyBlnFileOk = Test-JtIoFolderPath -FolderPath $MyFolderPath

        [String]$MyFilter = -join ("*", [JtIo]::FileExtension_Md)
 
        if ($MyBlnFileOk) {
            [System.Object[]]$MyAlJtObjects = Get-ChildItem -Path $MyFolderPath -File -Filter $MyFilter 
            if ($MyAlJtObjects.Count -gt 0) {
                [System.IO.FileSystemInfo]$MyFile = $MyalJtObjects[0]
                [System.DateTime]$MyDate = $MyFile.LastWriteTime
                $MyFileDate = $MyDate
            }
        }
        return $MyFileDate
    }
    
    JtIoFolder([String]$TheFolderPath) {
        $This.ClassName = "JtIoFolder"
        [String]$MyFolderPath = Convert-JtFolderPathExpanded -FolderPath $TheFolderPath

        [Boolean]$MyBlnExists = Test-JtIoPath -Path $MyFolderPath
        if (! ($MyBlnExists)) {
            Write-JtLog_Error -Where $This.ClassName -Text "Folder does NOT exist. MyFolderPath: $MyFolderPath"
        }
        $This.Path = $MyFolderPath
        $This.BlnExists = $MyBlnExists
    }

    JtIoFolder([String]$TheFolderPath, [Boolean]$BlnCreate) {
        $This.ClassName = "JtIoFolder"
        [String]$MyFolderPath = Convert-JtFolderPathExpanded -FolderPath $TheFolderPath
        $This.Path = $MyFolderPath
        [Boolean]$MyBlnExists = Test-JtIoPath -Path $MyFolderPath
        if (!($MyBlnExists)) {
            if ($BlnCreate) {
                if ($MyFolderPath.StartsWith("\\")) {
                    Write-JtLog_Error -Where $This.ClassName -Text "Trying to create folder on server: $MyFolderPath"
                    New-Item -type Directory -Path $MyFolderPath -Force 
                }
                else {
                    Write-JtLog_Folder -Where $This.ClassName -Text "Creating new folder." -FolderPath $MyFolderPath
                    New-Item -type Directory -Path $MyFolderPath -Force 
                }
            }
        }

        [Boolean]$MyBlnExists = Test-JtIoPath -Path $MyFolderPath
        $This.Path = $MyFolderPath
        $This.BlnExists = $MyBlnExists
    }

    JtIoFolder([JtIoFile]$TheJtIoFile) {
        $This.ClassName = "JtIoFolder"
        [JtIoFile]$MyJtIoFile = $TheJtIoFile
        if (!($MyJtIoFile.IsExisting())) {
            $This.Path = $Null
            $This.BlnExists = $True
        }
        else {
            [String]$MyFilePath = $MyJtIoFile.GetPath()
            [String]$MyFilename = $MyJtIoFile.GetName()
            [String]$MyReplace = -join ("\", $MyFilename)
            [String]$MyFolderPath = $MyFilePath.Replace($MyReplace, "")
            [String]$MyFolderPath_Parent = $MyFolderPath
            $This.Path = $MyFolderPath_Parent
            $This.BlnExists = $True
        }
    }

    [Boolean]DoRemoveFiles_All() {
        [String]$MyFolderPath = $This.GetPath()
        if (!($This.IsExisting())) {
            Write-JtLog_Error -Where $This.ClassName -Text "Trying to remove all files in folder, but folder does not exist: $MyFolderPath"
            return $False
        }

        [String]$MyFolderPath_FilesAll = -join ($MyFolderPath, "\", "*.*")
        Write-JtLog_Folder -Where $This.ClassName -Text "DoRemoveFiles_All. Deleting content." -FolderPath $MyFolderPath_FilesAll
        try {
            Get-ChildItem -Path $MyFolderPath_FilesAll -File | Remove-Item -Force
        }
        catch {
            Write-JtLog_Error -Where $This.ClassName -Text "Error while deleting files in MyFolderPath: $MyFolderPath"
            return $False
        }
            
        return $True
    }

    [Boolean]DoRemoveFiles_All([String]$TheFilter) {
        [String]$MyFilter = $TheFilter
        [String]$MyFolderPath = $This.GetPath()
        Write-JtLog_Folder -Where $This.ClassName -Text "Deleting content using filter: $MyFilter" -FolderPath $MyFolderPath
        try {
            Get-Childitem -Path $MyFolderPath -Filter $MyFilter -File | Remove-Item -Filter $MyFilter -Force
        }
        catch {
            Write-JtLog_Error -Where $This.ClassName -Text "Error while deleting files in $MyFolderPath"
            return $False
        }
        return $True
    }

    [Boolean]DoRemoveFiles_Some([String]$ThePrefix, [String]$TheExtension) { 
        [String]$MyFilePrefix = $ThePrefix
        [String]$MyExtension = $TheExtension
    
        # [String]$MyFolderName = $This.GetName()
        # [String]$MyFilter = -join ($FilePrefix, ".", $MyFolderName, ".", "*", $FileExtension)
        [String]$MyFilter = -join ($MyFilePrefix, ".", "*", $MyExtension)
        return $This.DoRemoveFiles_All($MyFilter)
    }
    
    [Boolean]DoRemoveEverything() {
        [String]$MyFolderPath = $This.GetPath()
        [String]$MyFolderPathFilesAll = -join ($MyFolderPath, "\", "*")
        Write-JtLog_Folder -Where $This.ClassName -Text "DoRemoveEverything. Deleting all files." -FolderPath $MyFolderPathFilesAll
    
        try {
            Remove-Item $MyFolderPathFilesAll -Include "*.*" -Recurse -Force
        }
        catch {
            [String]$MyMsg = "DoRemoveEverything. Error while deleting EVERYTHING."
            Write-JtLog_Error -Where $This.ClassName -Text $MyMsg 
            Write-JtLog_Folder -Where $This.ClassName -Text $MyMsg -FolderPath $MyFolderPath
            return $False
        }
        return $True
    }

    [JtIoFile]GetJtIoFile([String]$TheFilename) {
        [String]$MyFilename = $TheFilename
        [String]$MyFilePath = -join ($This.GetPath(), "\", $MyFilename)
        [JtIoFile]$MyJtIoFile = [JtIoFile]::new($MyFilePath)
        return $MyJtIoFile
    }
    
    [System.Collections.ArrayList]GetJtIoFiles() {
        return $This.GetJtIoFiles($False)
    }

    [System.Collections.ArrayList]GetJtIoFiles([Boolean]$TheBlnRecurse) {
        [System.Collections.ArrayList]$MyAlJtIoFiles = [System.Collections.ArrayList]::new()
        [Boolean]$MyBlnRecurse = $TheBlnRecurse
        [String]$MyFolderPath = $This.GetPath()
        if (!($This.IsExisting())) {
            Write-JtLog_Error -Where $This.ClassName -Text "GetJtIoFiles. Folder does not exist. FolderPath: $MyFolderPath"
            return $MyAlJtIoFiles
        }
        
        [System.Object[]]$MyAlFiles = $Null
        
        if ($True -eq $MyBlnRecurse) {
            $MyAlFiles = Get-ChildItem -Path $MyFolderPath -file -Recurse | Sort-Object -Property Name
        }
        else {
            $MyAlFiles = Get-ChildItem -Path $MyFolderPath -file | Sort-Object -Property Name
        }
        
        foreach ($File in $MyAlFiles) {
            [String]$MyFilePath = $File.fullname
            [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $MyFilePath
            $MyAlJtIoFiles.Add($MyJtIoFile)
        }
        return $MyAlJtIoFiles
    }

    [System.Collections.ArrayList]GetJtIoFiles_Filter([String]$TheFilter) {
        return $This.GetJtIoFiles_Filter($TheFilter, $False)
    }

    [System.Collections.ArrayList]GetJtIoFiles_Filter([String]$TheFilter, [Boolean]$TheBlnRecurse) {
        [String]$MyMethodName = "GetJtIoFiles_Filter"
        [String]$MyFolderPath = $This.GetPath()
        [String]$MyFilter = $TheFilter
        [Boolean]$MyBlnRecurse = $TheBlnRecurse
        
        # Write-JtLog -Where $This.ClassName -Text "$MyMethodName. MyFolderPath: $MyFolderPath FILTER: $MyFilter"
        if (!($This.IsExisting())) {
            [String]$MyMsg = "$MyMethodName. Not existing. MyFolderPath: $MyFolderPath FILTER: $MyFilter"
            Write-JtLog_Error -Where $This.ClassName -Text $MyMsg
            Throw $MyMsg
            #            Exit
            return $MyAlJtIoFiles
        }
        if ($Null -eq $MyFilter) {
            Write-JtLog_Error -Where $This.ClassName -Text "$MyMethodName. Filter is NULL!!!"
            $MyFilter = ""
        }
        
        [System.Object[]]$MyAlFiles = $Null
        if ($MyFilter.Length -gt 0) {
            if ($True -eq $MyBlnRecurse) {
                $MyAlFiles = Get-ChildItem -Path $MyFolderPath -file -Filter $MyFilter -Recurse | Sort-Object -Property Name
            }
            else {
                # Write-JtLog -Where $This.ClassName -Text "GetJtIoFiles_Filter. Filter: $MyFilter, Path: $MyPath"
                $MyAlFiles = Get-ChildItem -Path $MyFolderPath -file -Filter $MyFilter | Sort-Object -Property Name
            }
        }
        else {
            if ($True -eq $MyBlnRecurse) {
                # Write-JtLog -Where $This.ClassName -Text "GetJtIoFiles_Filter. Filter: empty, Recurse: TRUE, PATH: $MyPath"
                $MyAlFiles = Get-ChildItem -Path $MyFolderPath -file -Recurse | Sort-Object -Property Name
            }
            else {
                # Write-JtLog -Where $This.ClassName -Text "GetJtIoFiles_Filter. Filter: empty, Recurse: FALSE, PATH: $MyFolderPath"
                $MyAlFiles = Get-ChildItem -Path $MyFolderPath -file | Sort-Object -Property Name
            }
            
        }

        [System.Collections.ArrayList]$MyAlJtIoFiles = [System.Collections.ArrayList]::new()
        foreach ($File in $MyAlFiles) {
            [String]$MyFilePath = $File.fullname
            [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $MyFilePath
            $MyAlJtIoFiles.Add($MyJtIoFile)
        }
        return $MyAlJtIoFiles
    }

    [String]GetFilePath([String]$TheFilename) {
        [String]$MyFilename = $TheFilename
        [String]$MyPath = $This.GetPath()
        [String]$MyFilePath = -join ($MyPath, "\", $MyFilename)
        $MyFilePath = Convert-JtEnvironmentVariables -Text $MyFilePath
        return $MyFilePath
    }
    
    [String]GetFileTimestamp() {
        [String]$MyTimestamp = ""
        [Boolean]$MyBlnFileOk = $This.IsExisting()
        
        if ($MyBlnFileOk) {
            $MyFile = Get-Item -Path $This.GetPath()
            $MyTimestamp = $MyFile.LastWriteTime.ToString([JtIo]::TimestampFormat)
        }
        return $MyTimestamp
    }

    # Case insensitive
    # .pdf, .PDF are the same
    [System.Collections.ArrayList]GetAlExtensions() {
        $MyAlJtIoFiles = $This.GetJtIoFiles()
        
        [JtList]$MyJtList = New-JtList
        foreach ($File in $MyAlJtIoFiles) {
            [JtIoFile]$MyJtIoFile = $File
            # $File.GetPath()
            $MyExtension = $MyJtIoFile.GetExtension()
            $MyExtension = $MyExtension.ToLower()
            
            $MyJtList.Add($MyExtension)
        }
        [System.Collections.ArrayList]$MyAlFiletypes = $MyJtList.GetValues()
        return $MyAlFiletypes
    }


    [System.Collections.ArrayList]GetAlExtensions_Recurse() {
        [JtList]$MyJtList = New-JtList

        [System.Collections.ArrayList]$MyAlJtIoFolders_Sub = $This.GetAlJtIoFolders_Sub()
        foreach ($Folder in $MyAlJtIoFolders_Sub ) {
            [JtIoFolder]$MyJtIoFolder = $Folder

            [System.Collections.ArrayList]$MyAlTypes = $MyJtIoFolder.GetAlExtensions()
            foreach ($Extension in $MyAlTypes) {
                [String]$MyExtension = $Extension
                $MyJtList.Add($MyExtension)
            }
        }
        [System.Collections.ArrayList]$MyAlTypes = $MyJtList.GetValues()
        return $MyAlTypes
    }
    
    [DateTime]GetLastModified() {
        return [JtIoFolder]::GetReportFolderDateTime($This.GetPath())
    }
    
    [String]GetName() {
        return (Get-Item -Path $This.Path).Name
    }
    
    [JtIoFolder]GetJtIoFolder_Parent() {
        [String]$MyFolderPath_Parent = (Get-Item $This.GetPath()).parent.FullName
        [JtIoFolder]$MyJtIoFolder_Parent = New-JtIoFolder -FolderPath $MyFolderPath_Parent
        return $MyJtIoFolder_Parent
    }
    
    [JtIoFolder]GetJtIoFolder_Sub([String]$MyName, [Boolean]$BlnCreate) {
        [String]$MyFolderPath = $This.GetPath()
        [String]$MyFolderPath_New = -join ($MyFolderPath, "\", $MyName)
        [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $MyFolderPath_New
        if ($MyJtIoFolder.IsExisting()) {
            return $MyJtIoFolder
        }
        if ($BlnCreate) {
            # Write-JtLog_Folder -Where $This.ClassName -Text "GetJtIoFolder_Sub. Creating new folder." -FolderPath $MyFolderPath_New
            [JtIoFolder]$MyJtIoFolder = [JtIoFolder]::new($MyFolderPath_New, $True)
            if ($MyJtIoFolder.IsExisting()) {
                return $MyJtIoFolder
            }
        }
        if (!(Test-JtIoFolderPath -FolderPath $MyFolderPath_New)) {
            # Write-JtLog_Error -Where $This.ClassName -Text "GetJtIoFolder_Sub. Subfolder does not exist! PATH: $MyFolderPath_New"
        }
        return $MyJtIoFolder
    }

    [JtIoFolder]GetJtIoFolder_Sub([String]$TheFoldername) {
        [String]$MyFoldername = $TheFoldername
        return $This.GetJtIoFolder_Sub($MyFoldername, $False)
    }
    
    [System.Collections.ArrayList]GetAlJtIoFolders_Sub() {
        return $This.GetAlJtIoFolders_Sub($False)
    }

    [System.Collections.ArrayList]GetAlJtIoFolders_Sub([Boolean]$TheBlnRecurse) {
        [System.Collections.ArrayList]$MyAlJtIoFolders_Sub = [System.Collections.ArrayList]::new()
        [Boolean]$MyBlnRecurse = $TheBlnRecurse

        if (!($This.IsExisting())) {
            Write-JtLog_Error -Where $This.ClassName -Text "GetAlJtIoFolders_Sub. Folder is not existing! $This.Path"
            return $MyAlJtIoFolders_Sub
        }

        if ($True -eq $MyBlnRecurse) {
            $MyAlSubfolders = Get-ChildItem -Path $This.GetPath() -Directory -Recurse
            foreach ($Subfolder In $MyAlSubfolders) {
                $MySubfolder = $Subfolder
                [String]$MyFolderPath = $MySubfolder.fullname
                [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $MyFolderpath
                $MyAlJtIoFolders_Sub.add($MyJtIoFolder)
            }    
        }
        else {
            $MyAlSubfolders = Get-ChildItem -Path $This.GetPath() -Directory 
            foreach ($Subfolder In $MyAlSubfolders) {
                [String]$MyFolderPath = $Subfolder.fullname
                [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $MyFolderpath
                $MyAlJtIoFolders_Sub.add($MyJtIoFolder)
            }    
        }
        return $MyAlJtIoFolders_Sub
    }  

    [Boolean]IsExisting() {
        [Boolean]$MyBlnExists = [System.IO.Directory]::Exists($This.GetPath())
        $This.BlnExists = $MyBlnExists
        return $MyBlnExists
    }
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



Function Convert-JtFilename_To_DecBetrag {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Filename
    )

    # [String]$MyFunctionName = "Convert-JtFilename_To_DecBetrag"

    [String]$MyFilename = $Filename

    [String]$MyElement = Convert-JtDotter -Text $MyFilename -PatternOut "2" -Reverse
    [Decimal]$MyDecBetrag = Convert-JtPart_To_DecBetrag -Part $MyElement
    return $MyDecBetrag
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


Function Convert-JtFilePath_To_Value_Age {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FilePath
    )

    # [String]$MyFunctionName = "Convert-JtFilePath_To_Value_Age"

    [String]$MyFilePath = $FilePath
    [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $MyFilePath
    [String]$MyFilename = $MyJtIoFile.GetName()
    [String]$MyResult = Convert-JtFilename_To_IntAlter -Filename $MyFilename
    return $MyResult
}

Function Convert-JtFilePath_To_Value_DecQm {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FilePath
    )

    # [String]$MyFunctionName = "Convert-JtFilePath_To_Value_Age"

    [String]$MyFilePath = $FilePath
    [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $MyFilePath
    [String]$MyFilename = $MyJtIoFile.GetName()

    [Decimal]$MyDecResult = Convert-JtFilename_To_DecQm -Filename $MyFilename
    [String]$MyResult = Convert-JtDecimal_To_String3 -Decimal $MyDecResult
    return $MyResult
}


Function Convert-JtFilePath_To_Value_Year {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FilePath
    )

    # [String]$MyFunctionName = "Convert-JtFilePath_To_Value_Year"

    [String]$MyFilePath = $FilePath
    [String]$MyFilename = Convert-JtFilePath_To_Filename -FilePath $MyFilePath
    [String]$MyResult = Convert-JtFilename_To_Jahr -Filename $MyFilename
    return $MyResult
}



Function Convert-JtFilePath_To_Filename {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FilePath
    )
        
    [String]$MyFilePath = $FilePath
    [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $MyFilePath
    [String]$MyFilename = $MyJtIoFile.GetName()
    return $MyFilename
}


Function Convert-JtFolderPath_To_Foldername {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath
    )
        
    [String]$MyFolderPath = $FolderPath
    [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $MyFolderPath
    [String]$MyFoldername = $MyJtIoFolder.GetName()
    return $MyFoldername
}

Function Convert-JtFolderPath_To_Label {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath
    )
        
    [String]$MyFolderPath = $FolderPath
        
    [String]$MyResult = $MyFolderPath
    [String]$MyComputername = $env:COMPUTERNAME
    $MyResult = $MyResult.Replace("%COMPUTERNAME%", $MyComputername)
    $MyResult = $MyResult.Replace(":", "")
    $MyResult = $MyResult.Replace("*", "")
    $MyResult = $MyResult.Replace("\.", "")
    $MyResult = $MyResult.Replace("\", "_")
    $MyResult = $MyResult.Replace(".", "_")
    $MyResult = $MyResult.Replace("__", "_")
    return $MyResult
}

Function Convert-JtIoFilenamesAtFolderPath {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input
    )

    [String]$MyFunctionName = "Convert-JtFilenames"

    [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $FolderPath_Input
    $MyAlJtIoFiles = $MyJtIoFolder.GetJtIoFiles()

    foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFileNormal = $File
        [String]$MyFilename = $MyJtIoFileNormal.GetName()
            
        $MyFilenameOptimal = Convert-JtLabel_To_Filename -Label $MyFilename
            
        if ($MyFilename -eq $MyFilenameOptimal) {
            #            Write-JtLog -Where $MyFunctionName -Text "FILE: $MyFilename is ok."
        }
        else {
            Write-JtLog_Error -Where $MyFunctionName -Text "FILE: $MyFilename is renamed to FilenameOptimal: $MyFilenameOptimal"
            $MyJtIoFileNormal.DoRenameFile($MyFilenameOptimal)
        }
    }
}

Function Get-JtChildItem {

    Param (
        [Cmdletbinding()]
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Filter,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][Switch]$Recurse,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][Switch]$Normal
    )

    [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $FolderPath
    [String]$MyFilter = $Filter
    
    [System.Collections.ArrayList]$MyAlJtIoFiles = $MyJtIoFolder.GetJtIoFiles_Filter($MyFilter, $Recurse)

    if ($Normal) {
        [System.Collections.ArrayList]$MyAlJtIoFilesFiltered = [System.Collections.ArrayList]::new()
        [System.Collections.ArrayList]$MyAlJtIoFilesAll = $MyAlJtIoFiles
        foreach ($File in $MyAlJtIoFilesAll) {
            [JtIoFile]$MyJtIoFile = $File
            
            [Boolean]$MyBlnIsSpecial = Test-JtIoSpecial -FilePath $MyJtIoFile
            
            if (! ($MyBlnIsSpecial)) {
                $MyAlJtIoFilesFiltered.Add($MyJtIoFile) | Out-Null
            }
        }
        $MyAlJtIoFiles = $MyAlJtIoFilesFiltered
    }
    return , $MyAlJtIoFiles
}

Function Get-JtFolderPath_Info_FilesCount {
    Param (
        [Cmdletbinding()]
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath
    )

    [String]$MyFunctionName = "Get-JtFolderPath_Info_FilesCount"

    [String]$MyFolderPath = $FolderPath
    Write-JtLog -Where $MyFunctionName -Text "-- MyFolderPath: $MyFolderPath"

    if (!(Test-JtIoFolderPath -FolderPath $MyFolderPath)) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Not existing. MyFolderPath: $MyFolderPath"
        return -1
    }

    [Int32]$MyFilesCount = -1
    try {
        $MyResult = Get-ChildItem -Recurse $MyFolderPath | Where-Object { -not $_.PSIsContainer } | Measure-Object -Property Length -Sum
        [Int32]$MyFilesCount = $MyResult.Count
        
    }
    catch {
        Write-JtLog_Error -Where $MyFunctionName -Text "GetDataLine. Problem with MyFolderPath: $MyFolderPath"
    }
    # $MyJtTblRow.Add("Size", $MyResult.Sum)
    return $MyFilesCount
}

Function Get-JtFolderPath_Info_Level {
    Param (
        [Cmdletbinding()]
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath
    )

    [String]$MyFunctionName = "Get-JtFolderPath_Info_Level"

    [String]$MyFolderPath = $FolderPath

    if (!(Test-JtIoFolderPath -FolderPath $MyFolderPath)) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Not existing. MyFolderPath: $MyFolderPath"
        return -1
    }
    
    $MyAlLevels = $MyFolderPath.Split("\")
    [Int16]$MyIntLevel = $MyAlLevels.Count

    [Int16]$MyIntLevelInternal = $MyIntLevel - 3

    return $MyIntLevelInternal
}

Function Get-JtFolderPath_Info_SizeGb {
    Param (
        [Cmdletbinding()]
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath
    )

    [String]$MyFunctionName = "Get-JtFolderPath_Info_SizeGb"

    [String]$MyFolderPath = $FolderPath
    Write-JtLog -Where $MyFunctionName -Text "-- MyFolderPath: $MyFolderPath"
    [Decimal]$MyDecSizeGb = 0
    [Decimal]$MyValue = 99998
    if (!(Test-JtIoFolderPath -FolderPath $MyFolderPath)) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Not existing. MyFolderPath: $MyFolderPath"
        return -9999
    }
    try {
        $MyResult = Get-ChildItem -Recurse $MyFolderPath | Where-Object { -not $_.PSIsContainer } | Measure-Object -Property Length -Sum
        $MyValue = $MyResult.Sum
    }
    catch {
        Write-JtLog_Error -Where $MyFunctionName -Text "Problem with MyFolderPath: $MyFolderPath"
    }
    # $MyJtTblRow.Add("Size", $MyResult.Sum)
    
    [Decimal]$MyDecSizeGb = Convert-JtString_To_DecGb -Text $MyValue
    return $MyDecSizeGb
}

Function Get-JtFolderPath_inv {
    Return "c:\_inventory"
}

Function Get-JtFolderPath_inv_report {
    Return "c:\_inventory\report"
}

Function Get-JtFolderPath_inv_out {
    Return "c:\_inventory\out"
}

Function Get-JtIoFolder_Work {

    param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Name,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][Boolean]$Init
    )

    # [String]$FolderPathWork = -join ("%temp%", "\", "Jt", "\", $Name)
    [String]$MyFolderPath_Inv = Get-JtFolderPath_Inv
    [String]$MyFolderPath_Work = -join ($MyFolderPath_Inv, "\", "out", "\", $Name)
    [JtIoFolder]$MyJtIoFolder_Work = New-JtIoFolder -FolderPath $MyFolderPath_Work -Force

    if (!($MyJtIoFolder_Work.IsExisting())) {
        Throw "WorkFolder does not exist. MyJtIoFolder_Work: $MyJtIoFolder_Work"
    }

    if ($Init) {
        if ($True -eq $Init) {
            $MyJtIoFolder_Work.DeDeleteEveryThing()
        }
    }
    Return $MyJtIoFolder_Work
}


Function Get-JtReportLogDate {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath
    )

    [String]$MyFunctionName = "Get-JtReportLogDate"

    [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $FolderPath
    [String]$MyFolderPath = $MyJtIoFolder.GetPath()

    if (!($MyJtIoFolder.IsExisting())) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Folder does not exist! PATH: $MyFolderPath"
        return $Null
    }

    [String]$MyIsoDate = "2000-01-01"
    [DateTime]$MyDateFile = Get-Date $MyIsoDate

        
    [String]$MyFilter = -join ("*", ".", "log", [JtIo]::FileExtension_Md)

    $MyAlJtIoFiles = $MyJtIoFolder.GetJtIoFiles_Filter($MyFilter)
    if ($MyAlJtIoFiles.Count -gt 0) {
        [JtIoFile]$MyJtIoFile = $MyAlJtIoFiles[0]
        [String]$MyFilename = $MyJtIoFile.GetName()

        [String]$MyIsoDate = $MyFilename.Substring(4, 10)
        [datetime]$MyDateFile = Get-Date $MyIsoDate

    }
    else {
        Write-JtLog_Error -Where $MyFunctionName -Text "No log file found in PATH: $MyFolderPath"
    }
    return [DateTime]$MyDateFile
}

Function Get-JtReportLogDaysAgo {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath
    )

    [String]$MyFunctionName = "Get-JtReportLogDaysAgo"

    [String]$MyFolderPath = $FolderPath
    if (!(Test-JtIoFolderPath -FolderPath $MyFolderPath)) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Folder does not exist! MyFolderPath: $MyFolderPath"
        return 999
    }

    [int16]$MyIntAgo = 0

    $MyDateFile = Get-JtReportLogDate -FolderPath $MyFolderPath
    $MyTypeName = $MyDateFile.getType().Name

    if ($MyTypeName -eq "DateTime") {
        $MyTimeAgo = (Get-Date) - ($MyDateFile)
        $MyIntAgo = $MyTimeAgo.Days
    }
    else {
        $MyIntAgo = 998
    }
    return $MyIntAgo
}



class JtRobocopy : JtClass {

    [String]$RoboExe = -join ($env:windir, '\system32\', 'robocopy.exe')

    hidden [String]$FolderPath_Input = ""
    hidden [String]$FolderPath_Output = ""
    hidden [String]$Info = ""
    hidden [Boolean]$ExitOnError = $False
    
    JtRobocopy([JtIoFolder]$TheJtIoFolder_Input, [JtIoFolder]$TheJtIoFolder_Output) {
        $This.ClassName = "JtRobocopy"
        [JtIoFolder]$MyJtIoFolder_Input = $TheJtIoFolder_Input
        [JtIoFolder]$MyJtIoFolder_Output = $TheJtIoFolder_Output

        $This.DoInit([String]$MyJtIoFolder_Input, [String]$MyJtIoFolder_Output, $False) 
    }
    
    JtRobocopy([String]$TheFolderPath_Input, [String]$TheFolderPath_Output) {
        $This.ClassName = "JtRobocopy"
        $This.DoInit([String]$TheFolderPath_Input, [String]$TheFolderPath_Output, $False) 
    }
    
    JtRobocopy([String]$TheFolderPath_Input, [String]$TheFolderPath_Output, [Boolean]$ExitOnError) {
        $This.ClassName = "JtRobocopy"
        $This.DoInit([String]$TheFolderPath_Input, [String]$TheFolderPath_Output, $ExitOnError) 
    }
        
    hidden [Boolean]DoInit([String]$TheFolderPath_Input, [String]$TheFolderPath_Output, [Boolean]$ExitOnError) {
        $This.ExitOnError = $ExitOnError
        $This.FolderPath_Input = Convert-JtFolderPathExpanded -FolderPath $TheFolderPath_Input
        $This.FolderPath_Output = Convert-JtFolderPathExpanded -FolderPath $TheFolderPath_Output
        return $True
    }
    
    [Boolean]SetInfo([String]$MyInfo) {
        $This.Info = $MyInfo
        return $True
    }
    
    [Boolean]DoIt() {
        [String]$MyInfo = $This.Info
        Write-JtLog -Where $This.ClassName -Text "MyInfo: $MyInfo"
        [String]$MyFolderPath_Input = $This.FolderPath_Input 
        [String]$MyFolderPath_Output = $This.FolderPath_Output 
        Write-JtLog -Where $This.ClassName -Text "DoIt. MyFolderPath_Input: $MyFolderPath_Input ; MyFolderPath_Output: $MyFolderPath_Output"
        
        # [String]$BACKUP_NAME = "mirror"


        [String]$PARAMETER = ""
        <# 

        [String]$LOG_PATH = $env:TEMP
        [String]$LOG_FILENAME = 'mirror.log'
        [String]$LOG_FILE = -join ($LOG_PATH, "\", $LOG_FILENAME)

        # Bestimmte Verzeichnisse sollen nicht gesichert werden:
        [String]$EXCLUDE_DIRS = '$Recycle.Bin "System Volume Information" "Temporary Internet Files" nobackup'
 
        # Bestimmte Dateien sollen nicht gesichert werden:
        [String]$EXCLUDE_FILES = -join ($LOG_FILE, ' ', 'pagefile.sys hibernfil.sys thumbcache_32.db thumbcache_96.db thumbcache_256.db thumbcache_1024.db')

        # /A-:HS 
        # ... verhindert, dass unsichtbare Ordner entstehen.

        [String]$PARAMETER = -join ('/XJ /NP /FFT /TEE /S /COPY:DT /w:2 /r:2 /MIR /A-:HS /Log:', """", $LOG_FILE, """", ' ', '/XD', ' ', $EXCLUDE_DIRS, ' ', '/XF', ' ', $EXCLUDE_FILES)
        $PARAMETER = -join ('/w:2', ' ', '/r:2', ' ', '/MIR ')
 #>

        $MyArgs = -join (' /MIR ', ' /w:2 ', ' ', ' /r:2 ', ' ', '"', $This.FolderPath_Input, '"', ' ', '"', $This.FolderPath_Output, '"')

        [String]$TheFolderPath_Output = $This.FolderPath_Output
        [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $TheFolderPath_Output -Force
        [String]$MyFolderPath_Output = $MyJtIoFolder_Output.GetPath()
        if (Test-JtIoFolderPath -FolderPath $MyFolderPath_Output) {
            Write-JtLog -Where $This.ClassName -Text "DoIt. MyArgs: $MyArgs"
            Start-Process -NoNewWindow -FilePath $This.RoboExe -ArgumentList $MyArgs -Wait 
            return $True
        }
        else {
            Write-JtLog_Error -Where $This.ClassName -Text "ERROR! JtRobocopy. No access: $This.FolderPath_Output"
            if ($This.ExitOnError -eq $True) {
                Exit
            }
            return $False
        }
    }
}

Function New-JtConfig {
    [JtConfig]::new()
}

Function New-JtIo {
    [JtIo]::new()
}

Function New-JtIoFile {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FilePath
    )

    [JtIoFile]::new($FilePath)
}


Function New-JtIoFile_Csv {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FilePath
    )

    [JtIoFileCsv]::new($FilePath)
}




Function New-JtIoFolder {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][Switch]$Force
    )
 
    [JtIoFolder]::new($FolderPath, $Force)
}

Function New-JtIoFolder_Inv {

    [String]$MyFolderPath = Get-JtFolderPath_Inv

    New-JtIoFolder -FolderPath $MyFolderPath -Force
}

Function New-JtIoFolder_Report {


    [String]$MyFolderPath = Get-JtFolderPath_Inv_Report
    New-JtIoFolder -FolderPath $MyFolderPath -Force
}


Function New-JtNetConnection {
        
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Computer,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Username,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Share,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Passwd
    )

    [String]$MyFunctionName = "New-JtNetConnection"

    [String]$MyComputer = $Computer
    [String]$MyShare = $Share
    [String]$MyUsername = $Username
    [String]$MyPasswd = $Pass
            

    # $User = "Domain01\User01"
    # $PWord = ConvertTo-SecureString -String "P@sSwOrd" -AsPlainText -Force
    # $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
    
    # $MyPWord = ConvertTo-SecureString -String $MyPassword -AsPlainText -Force
    # $MyCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $MyUser, $MyPWord
    

    [String]$MyRoot = -join ("\\", $MyComputer, "\", $MyShare)
    $MyRoot
    # New-PSDrive -Name K -PSProvider FileSystem -Root $MyRoot -Persist -Credential $MyCredential -Scope Global


    # New-SmbMapping -LocalPath $shareletter -RemotePath $dhcpshare -Username $shareuser -Password $sharepasswd -Persistent $true


    New-SmbMapping -RemotePath $MyRoot -Username $MyUsername -Password $MyPasswd -Persistent $True


    Write-JtLog -Where $MyFunctionName -Text "Mapping network share. MyRoot: $MyRoot"
    [Boolean]$MyBlnExists = [System.IO.Directory]::Exists($MyRoot)
    Write-JtLog -Where $MyFunctionName -Text "Is share available? MyRoot: $MyRoot - MyBlnExists: $MyBlnExists"
}



Function New-JtRobocopy {
    
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Info
    )

    [JtRobocopy]$MyJtRobocopy = [JtRobocopy]::new($FolderPath_Input, $FolderPath_Output)
    if ($Info) {
        $MyJtRobocopy.SetInfo($Info)
    }
    $MyJtRobocopy.DoIt()

}

Function New-JtRobocopy_Date {
    
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Info
    )

    [String]$MyDate = Get-JtDate 
    [String]$MyFolderPath_OutputDate = -Join ($FolderPath_Output, ".", $MyDate)

    [JtRobocopy]$MyJtRobocopy = [JtRobocopy]::new($FolderPath_Input, $MyFolderPath_OutputDate)
    if (!($Info)) {
        
    }
    else {
        $MyJtRobocopy.SetInfo($Info)
    }
    $MyJtRobocopy.DoIt()

}

Function New-JtRobocopy_Element_Extension_Folder {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "New-JtRobocopy_Element_Extension_Folder"
    
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
    [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyFolderPath_Output -Force

    if (! (Test-JtIoFolderPath -FolderPath $MyFolderPath_Input)) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Folder does not exist. MyFolderPath_Input: $MyFolderPath_Input"
        return
    }

    if (! (Test-JtIoFolderPath -FolderPath $MyFolderPath_Input)) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Folder does not exist. MyJtIoFolder_Output: $MyJtIoFolder_Output"
        return
    }
    
    Write-JtLog -Where $MyFunctionName -Text "Preparing... MyJtIoFolder_Output: $MyJtIoFolder_Output"

    [String]$MyExtension = [JtIo]::FileExtension_Folder
    [String]$MyFilter = -join ("*", $MyExtension)
    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyFolderPath_Input -Filter $MyFilter -Recurse
    
    [Int16]$MyIntCount = $MyAlJtIoFiles.Count
    Write-JtLog -Where $MyFunctionName -Text "Number of files found with MyExtension: $MyExtension - MyIntCount: $MyIntCount"
    Write-JtLog -Where $MyFunctionName -Text "MyFolderPath_Input: $MyFolderPath_Input"

    foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile = $File
        [JtIoFolder]$MyJtIoFolder_Parent = $MyJtIoFile.GetJtIoFolder_Parent()

        [String]$MyFolderPath_Robo_Input = $MyJtIoFolder_Parent.GetPath()

        [String]$MySubPath = $MyFolderPath_Robo_Input -ireplace [regex]::Escape($MyFolderPath_Input), ""

        [String]$MyFolderPath_Robo_Output = -Join ($MyJtIoFolder_Output, $MySubPath)

        New-JtIoFolder -FolderPath $MyFolderPath_Robo_Output -Force
        Write-JtLog -Where $MyFunctionName -Text "MyFolderPath_Robo_Input: $MyFolderPath_Robo_Input"
        Write-JtLog -Where $MyFunctionName -Text "MyFolderPath_Robo_Output: $MyFolderPath_Robo_Output"

        New-JtRobocopy -FolderPath_Input $MyFolderPath_Robo_Input -FolderPath_Output $MyFolderPath_Robo_Output
    }
}

Function New-JtIoCollectFilesWithExtension {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Prefix,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Extension
    )

    [String]$MyFunctionName = "New-JtIoCollectFilesWithExtension"
    [String]$MyPrefix = $Prefix
    [String]$MyExtension = $Extension
    
    [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $FolderPath_Input
    [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $FolderPath_Output -Force

    [String]$MyFilter = -join ("*", $MyExtension)
    if ($MyPrefix) {
        $MyFilter = -join ($MyPrefix, $MyFilter)
    }

    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder_Input -Filter $MyFilter -Recurse

    [Int16]$IntCount = $MyAlJtIoFiles.Count
    Write-JtLog -Where $MyFunctionName -Text "Number of files found with EXTENSION: $MyExtension - COUNT: $IntCount in PathInput: $MyJtIoFolder_Input"
    
    foreach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile_Folder = $File

        # Write-JtLog -Where $MyFunctionName -Text "Path of JtIoFile_Folder: $MyJtIoFile_Folder"

        [String]$MyFilename = $MyJtIoFile_Folder.GetName()

        [String]$MyFilePath_Input = $MyJtIoFile_Folder.GetPath()
        [String]$MyFilePath_Output = $MyJtIoFolder_Output.GetFilePath($MyFilename)

        Copy-Item $MyFilePath_Input $MyFilePath_Output
    }
}


Class JtComputername {

    [String]$Computername = $Null

    JtComputername([String]$TheName) {
        [String]$MyName = $TheName
        [String]$MyComputername = $MyName.ToLower()
        $This.Computername = $MyComputername

    }


    [String]GetOrg() {
        [String]$MyComputername = $This.Computername
        [String]$MyResult = ""
        if ($MyComputername) {
            if ($MyComputername.Length -gt 5) {
                $MyResult = $MyComputername.Substring(0, 6)
            }
        }
        return $MyResult
    }

    [String]GetOrg1() {
        [String]$MyComputername = $This.Computername
        [String]$MyResult = ""
        if ($MyComputername) {
            [String[]]$Parts = $MyComputername.Split("-")
            if ($Parts.Count -gt 2) {
                $MyResult = $Parts[0]
            }
        }
        return $MyResult
    }

    [String]GetOrg2() {
        [String]$MyComputername = $This.Computername
        [String]$MyResult = ""
        if ($MyComputername) {
            [String[]]$MyAlParts = $MyComputername.Split("-")
            if ($MyAlParts.Count -gt 2) {
                $MyResult = $MyAlParts[1]
            }
        }
        return $MyResult
    }

    [String]GetType() {
        [String]$MyComputername = $This.Computername

        [String]$MyResult = ""
        if ($MyComputername) {
            [String[]]$MyAlParts = $MyComputername.Split("-")
            if ($MyAlParts.Count -gt 3) {
                $MyResult = $MyAlParts[2]
            }
        }
        return $MyResult
    }
}
Function New-JtComputername {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Name
    )

    [JtComputername]::New($Name)
}

Function Remove-JtIoFiles_Meta {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath
    )

    [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $FolderPath

    [String]$MyFilePrefix = [JtIo]::FilePrefix_Folder
    [String]$MyExtension = [JtIo]::FileExtensionMeta
    $MyJtIoFolder.DoRemoveFiles_Some($MyFilePrefix, $MyExtension)
}




Function Test-JtIoPath {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Path
    )

    return Test-Path -Path $Path
}


Function Test-JtIoFilePath {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FilePath
    )

    [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $FilePath

    [String]$MyFilePath = $MyJtIoFile.GetPath()

    return Test-Path -Path $MyFilePath
}

Function Test-JtIoFolderPath {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][Boolean]$Force
    )

    [JtIoFolder]$MyJtIoFolder = $Null
   
    if (!($Force)) {
        $MyJtIoFolder = New-JtIoFolder -FolderPath $FolderPath
    }
    else {
        $MyJtIoFolder = New-JtIoFolder -FolderPath $FolderPath -Force $Force
    }

    [String]$MyFolderPath = $MyJtIoFolder.GetPath()

    return Test-Path -Path $MyFolderPath
}

Function Test-JtIoSpecial {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FilePath
    )


    [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $FilePath
    [String]$MyFilename = $MyJtIoFile.GetName()

    [Boolean]$MyBlnIsSpecial = $False
    if ($MyFilename.Equals("desktop.ini")) {
        return $True
    }  

    if ($MyFilename.StartsWith("zzz.")) {
        return $True
    }  

    [String]$MyPrefix = [JtIo]::FilePrefix_Betrag
    if ($MyFilename.StartsWith($MyPrefix)) {
        return $True
    }  

    [String]$MyPrefix = [JtIo]::FilePrefix_Buchung
    if ($MyFilename.StartsWith($MyPrefix)) {
        return $True
    }  
        
    [String]$MyExtension = [System.IO.Path]::GetExtension($MyFilename)
    $MyList = New-Object System.Collections.Generic.List[System.Object]
    $MyList.Add([JtIo]::FileExtension_Csv)
    $MyList.Add([JtIo]::FileExtension_Folder)
    $MyList.Add([JtIo]::FileExtension_Md)
    $MyList.Add([JtIo]::FileExtension_Meta)
        
    foreach ($Extension in $MyList) {
        if ($Extension.Equals($MyExtension)) {
            $MyBlnIsSpecial = $True
            return $MyBlnIsSpecial
        }
    }
    return $MyBlnIsSpecial
}


Function Write-JtIoFile {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FilePath_Output,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Content,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][Switch]$Overwrite
    )

    [String]$MyFunctionName = "Write-JtIoFile"
        
    [String]$MyFilePath_Output = $FilePath_Output
    [String]$MyContent = $Content
    if (Test-JtIoFilePath $MyFilePath_Output) {
        if ($Overwrite) {
            Write-JtLog_Error -Where $MyFunctionName -Text "Overwrite $Overwrite - File exists. Replacing old file!! FilePath_Output: $FilePath_Output"
            Write-JtLog_File -Where $MyFunctionName -Text "Writing file." -FilePath $MyFilePath_Output
            $MyContent | Out-File -FilePath $MyFilePath_Output -Encoding utf8
        }
        else {
            Write-JtLog_Error -Where $MyFunctionName -Text "File exists. Not overwriting!!! FilePath_Output: $FilePath_Output"
        }
    }
    else {
        Write-JtLog_File -Where $MyFunctionName -Text "Writing file." -FilePath $MyFilePath_Output
        $MyContent | Out-File -FilePath $MyFilePath_Output -Encoding utf8
    }
}


Function Write-JtIoFile_Md {
        
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Content,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Name,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Extension2,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][Switch]$OnlyOne,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][Switch]$Overwrite
    )

    # [String]$MyFunctionName = "Write-JtIoFile_Md"

    [String]$MyFolderPath_Output = $FolderPath_Output
    [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyFolderPath_Output
    [String]$MyFoldername_Output = $MyJtIoFolder_Output.GetName()

    [String]$MyExtension2 = $Extension2
    [String]$MyContent = $Content
    [String]$MyOverwrite = $Overwrite
    [String]$MyName = $Name
    [String]$MyPrefix = [JtIo]::FilePrefix_Folder
    
    [String]$MyExtension_Md = [JtIo]::FileExtension_Md
    if (! ($MyExtension2.EndsWith($MyExtension_Md))) {
        Throw "Illegal extension"
        return
    }
    
    [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyFolderPath_Output
    if ($OnlyOne) {
        [String]$MyFilter = -join ($MyPrefix, "*", $MyExtension2)
        $MyJtIoFolder_Output.DoRemoveFiles_All($MyFilter)
    }
    
    # $MyFilename_Output = -Join ($MyPrefix, ".", $MyFoldername_Output, ".", $MyName, $MyExtension2)
    $MyFilename_Output = -Join ($MyPrefix, ".", $MyFoldername_Output, $MyExtension2)
    $MyFilename_Output = Convert-JtLabel_To_Filename -Label $MyFilename_Output
    [String]$MyFilePath_Output = $MyJtIoFolder_Output.GetFilePath($MyFilename_Output)
    if ($MyOverwrite -eq $True) {
        Write-JtIoFile -FilePath_Output $MyFilePath_Output -Content $MyContent -Overwrite
    }
    else {
        Write-JtIoFile -FilePath_Output $MyFilePath_Output -Content $MyContent
        
    }
    Convert-JtIoFile_Md_To_Pdf -FolderPath_Input $MyFolderPath_Output -Filename_Input $MyFilename_Output
}

Function Write-JtIoFile_Meta {
    Param (
        [Cmdletbinding()]
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Prefix,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Label,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Value,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Extension2,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][Switch]$OnlyOne,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][Switch]$Overwrite
    )

    # [String]$MyFunctionName = "Write-JtIoFile_Meta"

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
    [String]$MyExtension2 = $Extension2
    [String]$MyOverwrite = $Overwrite
    [String]$MyLabel = $Label
    [String]$MyValue = $Value
    [String]$MyPrefix = $Prefix


    [String]$MyExtension_Meta = [JtIo]::FileExtension_Meta
    if (! ($MyExtension2.EndsWith($MyExtension_Meta))) {
        Throw "Illegal extension"
        return
    }

    [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyFolderPath_Output

    [String]$MyMain = $MyLabel
    if($MyValue) {
        $MyMain = -join($MyLabel, ".", $MyValue)
    }
    $MyMain = Convert-JtLabel_To_Filename -Label $MyMain
    
    $MyFilename_Output = -Join ($MyPrefix, ".", $MyMain, $MyExtension2)
    
    [String]$MyContent = $MyFolderPath_Input
    
    [String]$MyFilePath_Output = $MyJtIoFolder_Output.GetFilePath($MyFilename_Output)
    
    if ($OnlyOne) {
        [String]$MyFilter = -join ($MyPrefix, ".", $MyLabel, "*", $MyExtension2)
        $MyJtIoFolder_Output.DoRemoveFiles_All($MyFilter)
    }
    if ($MyOverwrite) {
        Write-JtIoFile -FilePath_Output $MyFilePath_Output -Content $MyContent -Overwrite
    }
    else {
        Write-JtIoFile -FilePath_Output $MyFilePath_Output -Content $MyContent
    }
}




Function Write-JtIoFile_Meta_Anzahl {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Anzahl
    )
    
    [String]$MyFunctionName = "Write-JtIoFile_Meta_Anzahl"
    Write-JtLog -Where $MyFunctionName -Text "Writing meta file."
    
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
    
    [String]$MyAnzahl = $Anzahl
        
    [String]$MyPrefix = [JtIo]::FilePrefix_Folder
    [String]$MyLabel = $MyAnzahl
    [String]$MyExtension2 = [JtIo]::FileExtension_Meta_Anzahl
    
    $MyParams = @{
        FolderPath_Input  = $MyFolderPath_Input
        FolderPath_Output = $MyFolderPath_Output
        Prefix            = $MyPrefix
        Label             = $MyLabel
        Extension2        = $MyExtension2
        #        Overwrite         = $True
    }
    Write-JtIoFile_Meta @MyParams
}
    
Function Write-JtIoFile_Meta_Betrag {
    
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Name,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Year,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][Decimal]$Betrag
    )
    
    [String]$MyFunctionName = "Write-JtIoFile_Meta_Betrag"
    Write-JtLog -Where $MyFunctionName -Text "Writing meta file."
    
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
    
    [String]$MyName = $Name
    [String]$MyYear = $Year
    [Decimal]$MyDecBetrag = $Betrag
    
    
    if ($Year) {
        $MyYear = $Year
    }
    else {
        $MyYear = "20xx"
    }
    
    [String]$MyLabel = Get-JtLabel_Betrag -FolderPath_Input $MyFolderPath_Input -Name $MyName -Year $MyYear -Betrag $MyDecBetrag 
    
    [String]$MyPrefix = [JtIo]::FilePrefix_Betrag
    [String]$MyExtension2 = [JtIo]::FileExtension_Meta_Betrag

    [String]$MyFilter = -join ($MyPrefix, "*", $MyYear, "*", $MyExtension2) 
    $MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyFolderPath_Input -Filter $MyFilter
    ForEach ($File in $MyAlJtIoFiles) {
        [JtIoFile]$MyJtIoFile_Old = $File
        Remove-Item $MyJtIoFile_Old
        Write-JtLog_Error -Where $MyFunctionName -Text "Going to delete MyJtIoFile_Old: $MyJtIoFile_Old"

    }
    
    $MyParams = @{
        FolderPath_Input  = $MyFolderPath_Input
        FolderPath_Output = $MyFolderPath_Output
        Prefix            = $MyPrefix
        Label             = $MyLabel
        Extension2        = $MyExtension2
    }
    Write-JtIoFile_Meta @MyParams
}
    
    
Function Write-JtIoFile_Meta_Betrag_Year {
            
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Name,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Year,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][Decimal]$Betrag
    )
        
    [Decimal]$MyDecBetrag = $Betrag
    [String]$MyName = $Name
    [String]$MyYear = $Year
        
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
        
    $MyParams = @{
        FolderPath_Input  = $MyFolderPath_Input
        FolderPath_Output = $MyFolderPath_Output
        Name              = $MyName
        Year              = $MyYear
        Betrag            = $MyDecBetrag
        # OnlyOne           = $True
    }
    Write-JtIoFile_Meta_Betrag @MyParams
}
    
    
Function Write-JtIoFile_Meta_Report {
    
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Name,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Value
    )
    
    [String]$MyFunctionName = "Write-JtIoFile_Meta_Report"
    Write-JtLog -Where $MyFunctionName -Text "Writing meta file."
    
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
    
    [String]$MyName = $Name
    [String]$MyValue = $Value
        
    [String]$MyPrefix = [JtIo]::FilePrefix_Report
    [String]$MyExtension2 = [JtIo]::FileExtension_Meta_Report
    
    $MyParams = @{
        FolderPath_Input  = $MyFolderPath_Input
        FolderPath_Output = $MyFolderPath_Output
        Prefix            = $MyPrefix
        Label             = $MyName
        Value             = $MyValue
        Extension2        = $MyExtension2
        Overwrite         = $True
        OnlyOne           = $True
    }
    Write-JtIoFile_Meta @MyParams
}
    
Function Write-JtIoFile_Meta_Time {
            
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Name
    )
    
    [String]$MyFunctionName = "Write-JtIoFile_Meta_Time"
    Write-JtLog -Where $MyFunctionName -Text "Writing meta file."
    
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output
    [String]$MyName = $Name
    [String]$MyPrefix = "_timestamp"
    [String]$MyTimestamp = Get-JtTimestamp
        
    [String]$MyLabel = -join ($MyTimestamp, ".", $MyName)
        
    $MyParams = @{
        FolderPath_Input  = $MyFolderPath_Input
        FolderPath_Output = $MyFolderPath_Output
        Prefix            = $MyPrefix
        Label             = $MyLabel
        Extension2        = [JtIo]::FileExtension_Meta_Time
        Overwrite         = $True
        # OnlyOne           = $True
    }
    Write-JtIoFile_Meta @MyParams
}
    
Function Write-JtIoFile_Meta_Version {
        
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )
            
    [String]$MyFunctionName = "Write-JtIoFile_Meta_Version"
    Write-JtLog -Where $MyFunctionName -Text "Writing meta file."
            
    [String]$MyFolderPath_Input = $FolderPath_Output
    [String]$MyFolderPath_Output = $FolderPath_Output
    [String]$MyTimestamp = Get-JtTimestamp
    [String]$MyPrefix = "_v"

    # Only one
    [String]$MyFilter = -join ($MyPrefix, ".", "*", $MyExtension2)
    [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyFolderPath_Output
    $MyJtIoFolder_Output.DoRemoveFiles_All($MyFilter)
            
    $MyParams = @{
        FolderPath_Input  = $MyFolderPath_Input
        FolderPath_Output = $MyFolderPath_Output
        Prefix            = $MyPrefix
        Label             = $MyTimestamp
        Extension2        = [JtIo]::FileExtension_Meta_Version
        OnlyOne           = $True
        Overwrite         = $True
    }
    Write-JtIoFile_Meta @MyParams
}


Export-ModuleMember -Function Convert-JtFilename_To_IntAnzahl
Export-ModuleMember -Function Convert-JtFilename_To_IntAlter
Export-ModuleMember -Function Convert-JtFilename_To_DecBetrag
Export-ModuleMember -Function Convert-JtFilename_To_DecQm
Export-ModuleMember -Function Convert-JtFilename_To_Jahr
Export-ModuleMember -Function Convert-JtFilename_To_Papier

Export-ModuleMember -Function Convert-JtFilePath_To_Value_Age
Export-ModuleMember -Function Convert-JtFilePath_To_Value_DecQm
Export-ModuleMember -Function Convert-JtFilePath_To_Value_Year

Export-ModuleMember -Function Convert-JtFilePathExpanded
Export-ModuleMember -Function Convert-JtFolderPathExpanded

Export-ModuleMember -Function Convert-JtFilePath_To_Filename
Export-ModuleMember -Function Convert-JtIoFilenamesAtFolderPath
Export-ModuleMember -Function Convert-JtFolderPath_To_Label
Export-ModuleMember -Function Convert-JtFolderPath_To_Foldername

Export-ModuleMember -Function Get-JtChildItem

Export-ModuleMember -Function Get-JtFolderPath_Info_FilesCount
Export-ModuleMember -Function Get-JtFolderPath_Info_Level
Export-ModuleMember -Function Get-JtFolderPath_Info_SizeGb

Export-ModuleMember -Function Get-JtFolderPath_Inv
Export-ModuleMember -Function Get-JtFolderPath_Inv_Out
Export-ModuleMember -Function Get-JtFolderPath_Inv_Report

Export-ModuleMember -Function Get-JtReportLogDate
Export-ModuleMember -Function Get-JtReportLogDaysAgo

Export-ModuleMember -Function New-JtComputername
Export-ModuleMember -Function New-JtConfig 
Export-ModuleMember -Function New-JtIo
Export-ModuleMember -Function New-JtIoCollectFilesWithExtension
Export-ModuleMember -Function New-JtIoFile
Export-ModuleMember -Function New-JtIoFile_Csv

Export-ModuleMember -Function New-JtIoFolder
Export-ModuleMember -Function New-JtIoFolder_Inv
Export-ModuleMember -Function New-JtIoFolder_Report
Export-ModuleMember -Function Get-JtIoFolder_Work

Export-ModuleMember -Function New-JtNetConnection

Export-ModuleMember -Function New-JtRobocopy
Export-ModuleMember -Function New-JtRobocopy_Date
Export-ModuleMember -Function New-JtRobocopy_Element_Extension_Folder

Export-ModuleMember -Function Remove-JtIoFiles_Meta


# Export-ModuleMember -Function Test-JtIoPath
Export-ModuleMember -Function Test-JtIoFilePath
Export-ModuleMember -Function Test-JtIoFolderPath
Export-ModuleMember -Function Test-JtIoSpecial

Export-ModuleMember -Function Write-JtIoFile
Export-ModuleMember -Function Write-JtIoFile_Md
Export-ModuleMember -Function Write-JtIoFile_Meta
Export-ModuleMember -Function Write-JtIoFile_Meta_Anzahl
Export-ModuleMember -Function Write-JtIoFile_Meta_Betrag
Export-ModuleMember -Function Write-JtIoFile_Meta_Betrag_Year
Export-ModuleMember -Function Write-JtIoFile_Meta_Report
Export-ModuleMember -Function Write-JtIoFile_Meta_Time
Export-ModuleMember -Function Write-JtIoFile_Meta_Version

