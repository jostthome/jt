using module Jt 
using module JtColRen
using module JtIndex
using module JtIo
using module JtMd
using module JtRep
using module JtSnapshot
using module JtTbl


class JtCsvTool : JtClass {

    [JtIoFolder]$JtIoFolder_Output_Combine
    [System.Collections.ArrayList]$AlJtIoFolders_Reports
    [String]$LabelSelection
    
    JtCsvTool([JtIoFolder]$TheJtIoFolder_Reports, [JtIoFolder]$TheJtIoFolder_Output, [String]$TheLabelSelection, [System.Collections.ArrayList]$TheSelection) {
        $This.ClassName = "JtCsvTool"

        [JtIoFolder]$MyJtIoFolder_Reports = $TheJtIoFolder_Reports
        [JtIoFolder]$MyJtIoFolder_Output = $TheJtIoFolder_Output
        [System.Collections.ArrayList]$MySelection = $TheSelection
        
        $This.LabelSelection = $TheLabelSelection
        $This.JtIoFolder_Output_Combine = $MyJtIoFolder_Output.GetJtIoFolder_Sub($This.LabelSelection, $True)
        
        [System.Collections.ArrayList]$MyAlJtIoFolders_Reports = $MyJtIoFolder_Reports.GetAlJtIoFolders_Sub($False)
        [System.Collections.ArrayList]$MyAlJtIoFolders_Reports_Selected = [JtCsvTool]::GetAlIoFolders_Selected($MyAlJtIoFolders_Reports, $MySelection) 
        
        $This.AlJtIoFolders_Reports = $MyAlJtIoFolders_Reports_Selected
    }
    
    JtCsvTool([JtIoFolder]$TheJtIoFolder_Reports, [JtIoFolder]$TheJtIoFolder_Output) {
        $This.ClassName = "JtCsvTool"
        
        [JtIoFolder]$MyJtIoFolder_Reports = $TheJtIoFolder_Reports
        [JtIoFolder]$MyJtIoFolder_Output = $TheJtIoFolder_Output
        
        $This.LabelSelection = "all"
        $This.JtIoFolder_Output_Combine = $MyJtIoFolder_Output.GetJtIoFolder_Sub($This.LabelSelection, $True)
  
        [System.Collections.ArrayList]$MyAlJtIoFolders_Reports = $MyJtIoFolder_Reports.GetAlJtIoFolders_Sub($False)

        $This.AlJtIoFolders_Reports = $MyAlJtIoFolders_Reports
    }

    static [System.Collections.ArrayList]GetAlIoFolders_Selected([System.Collections.ArrayList]$TheAlJtIoFolders, [System.Collections.ArrayList]$TheAlSelection) {
        [System.Collections.ArrayList]$MyAlSelection = $TheAlSelection
        [System.Collections.ArrayList]$MyAlJtIoFolders = $TheAlJtIoFolders

        [System.Collections.ArrayList]$MyAlJtIoFolders_Selected = New-Object System.Collections.ArrayList
        foreach ($Folder in $MyAlJtIoFolders) {
            [JtIoFolder]$MyJtIoFolder = $Folder
            if ($Null -eq $MyAlSelection) {
                $MyAlJtIoFolders_Selected.Add($MyJtIoFolder)
            }
            else {
                [Boolean]$MyBlnSelected = [JtCsvTool]::IsJtIoFolderInSelection($MyJtIoFolder, $MyAlSelection)
                if ($MyBlnSelected) {
                    $MyAlJtIoFolders_Selected.Add($MyJtIoFolder)
                }
            } 
        }
        return $MyAlJtIoFolders_Selected
    }

    static [Boolean]IsJtIoFolderInSelection([JtIoFolder]$TheJtIoFolder, [System.Collections.ArrayList]$TheAlFoldernames) {
        if ($Null -eq $TheAlFoldernames) {
            return $False
        }
        [Boolean]$MyBlnSelected = $False
        foreach ($Element in $TheAlFoldernames) {
            [String]$MyFoldername = $Element.ToString()
            
            [String]$MySearch = -join ("*", $MyFoldername, "*")
            [String]$MyFolderPathFull = $TheJtIoFolder.GetPath()
            if ($MyFolderPathFull -like $MySearch) {
                return $True
            }
        }
        return $MyBlnSelected
    }

    [System.Collections.ArrayList]GetAlJtIoFolders_Sub_Selected([System.Collections.ArrayList]$TheSelection) {
        [System.Collections.ArrayList]$MyAlJtIoFolders = $This.GetAlJtIoFolders_Sub($False)
        [System.Collections.ArrayList]$MyAlJtIoFolders_Selected = [JtCsvTool]::GetAlIoFolders_Selected($MyAlJtIoFolders, $TheSelection)
        return $MyAlJtIoFolders_Selected
    }

    [Boolean]DoIt() {
        [JtIoFolder]$MyJtIoFolder_Output_Combine = $This.JtIoFolder_Output_Combine
        Write-JtLog -Where $This.ClassName -Text "DoIt - MyJtIoFolder_Output_Combine: $MyJtIoFolder_Output_Combine"

        [System.Collections.ArrayList]$MyAlFilenames_Csv = [System.Collections.ArrayList]::new()

        [JtIoFolder]$MyJtIoFolder_Report = New-JtIoFolder_Report
        [JtIoFolder]$MyJtIoFolder_Report_Csv = $MyJtIoFolder_Report.GetJtIoFolder_Sub("csv")
        [String]$MyFilter = -join ("*", [JtIo]::FileExtension_Csv)
        [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder_Report_Csv -Filter $MyFilter
        foreach ($File in $MyAlJtIoFiles) {
            [JtIoFile]$MyJtIoFile = $File
            $MyAlFilenames_Csv.Add($MyJtIoFile.GetName())
        }
    
        foreach ($Filename in $MyAlFilenames_Csv) {
            [String]$MyFilename = $Filename

            [System.Collections.ArrayList]$MyAlJtIoFiles_Csv = [System.Collections.ArrayList]::new()
            [System.Collections.ArrayList]$MyAlFilePaths_Csv = [System.Collections.ArrayList]::new()
            
            [System.Collections.ArrayList]$MyAlJtIoFolders_Reports = $This.AlJtIoFolders_Reports
            foreach ($Folder in $MyAlJtIoFolders_Reports) {
                [JtIoFolder]$MyJtIoFolder = $Folder
                [JtIoFolder]$MyJtIoFolder_Csv = $MyJtIoFolder.GetJtIoFolder_Sub("csv")
                if ($MyJtIoFolder_Csv.IsExisting()) {
                    [JtIoFile]$MyJtIoFile = $MyJtIoFolder_Csv.GetJtIoFile($MyFilename)
                    if ($MyJtIoFile.IsExisting()) {
                        $MyAlJtIoFiles_Csv.Add($MyJtIoFile)
                        $MyAlFilePaths_Csv.Add($MyJtIoFile.GetPath())
                    }
                }
            }

            $MyDataCsv = $MyAlFilePaths_Csv | Import-Csv  -Delimiter ([JtClass]::Delimiter)

            [JtIoFile]$MyJtIoFileOutput = $MyJtIoFolder_Output_Combine.GetJtIoFile($MyFilename)
            [String]$MyFilePath_Output = $MyJtIoFileOutput.GetPath()
            Write-JtLog_File -Where $This.ClassName -Text "Combining for MyFilename: $MyFilename" -FilePath $MyFilePath_Output            
            $MyDataCsv | Export-Csv $MyFilePath_Output -NoTypeInformation -Delimiter ([JtClass]::Delimiter) -Force
        }
        return $True
    }
}

class JtInv : JtClass {

    [JtIoFolder]$JtIoFolder_Base
    [JtIoFolder]$JtIoFolder_Report
    [String]$SystemId = ""

    JtInv() {
        [JtConfig]$MyJtConfig = New-JtConfig
        $This.ClassName = "JtInv"
        $This.JtIoFolder_Report = $MyJtConfig.Get_JtIoFolder_Report()
        $This.JtIoFolder_Base = $MyJtConfig.Get_JtIoFolder_Base()
        $This.DoIt()
    }
    
    DoLogRepoInit() {
        [String]$MyReportLabel = $This.GetReportLabel()
        Write-JtLog -Where $This.ClassName -Text "INIT. REPORT: $MyReportLabel"
    }
    
    DoLogRepoStart() {
        [String]$MyReportLabel = $This.GetReportLabel()
        Write-JtLog -Where $This.ClassName -Text "Starting in REPORT: $MyReportLabel"
    }
    
    [String]GetConfigName() {
        Write-JtLog_Error -Where $This.ClassName -Text "GetConfigName. Should be overwritten!!!"
        Throw "GetConfigName. Should be overwritten!!!"
        return ""
    }
    
    [JtIoFolder]GetFolderPath_Output() {
        [JtIoFolder]$MyJtIoFolder_Report = $This.JtIoFolder_Report
        [JtIoFolder]$MyJtIoFolder_Output = $Null
        
        [String]$MyLabel_Report = $This.GetReportLabel()
        if ($MyLabel_Report.Length -gt 0) {
            $MyJtIoFolder_Output = $MyJtIoFolder_Report.GetJtIoFolder_Sub($MyLabel_Report, $True)
        }
        return $MyJtIoFolder_Output
    }


    [JtIoFolder]GetFolderPath_Input() {
        [JtConfig]$MyJtConfig = New-JtConfig
        [JtIoFolder]$MyJtIoFolder_Report = $MyJtConfig.Get_JtIoFolder_Report()
        [JtIoFolder]$MyJtIoFolder_Input = $MyJtIoFolder_Report
        return $MyJtIoFolder_Input
    }

    [String]GetReportLabel() {
        Throw "GetReportLabel should be overwritten!!!"
        return "GetReportLabel is not defined!"
    }

    [Xml]GetConfigXml() {
        [String]$MyConfigName = $This.GetConfigName()
        if ($MyConfigName.Length -lt 1) {
            Write-JtLog_Error -Where $This.ClassName -Text "ConfigFolderName not set!"
            Throw "This should not happen."
            return $Null
        }
        
        [String]$MyFileName_Xml = -join ($MyConfigName, ".xml")
        [String]$MyFilePath_Xml = $This.JtIoFolder_Base.GetFilePath($MyFileName_Xml)
        Write-JtLog -Where $This.ClassName -Text "GetConfigXml; FilePathXml: $MyFilePath_Xml"    
        [JtIoFile]$MyJtIoFile = New-JtIoFile -FilePath $MyFilePath_Xml
        if (!($MyJtIoFile.IsExisting())) {
            return $Null
        }
        [FileElementXml]$MyFileElementXml = [FileElementXml]::new($MyJtIoFile)
        [Xml]$MyXmlContent = $MyFileElementXml.GetXml()
        return $MyXmlContent
    }

    [Boolean]DoIt() {
        Throw "Report. The method DoIt should be overwritten."
        return $False
    }
}

class JtInvClientChoco : JtInv {

    JtInvClientChoco() : Base() {
        $This.ClassName = "JtInvClientChoco"
        # Output goes directly to "c:\_inventory\report"
    }
    
    [Boolean]DoIt() {
        $This.DoLogRepoStart()
        
        [String]$MyCommand = ""

        [String]$MyFilename = -join ([JtIo]::FilePrefix_Report, [JtIo]::FileExtension_Meta_Choco)
        [JtIoFolder]$MyJtIoFolder_Output = $This.JtIoFolder_Report.GetJtIoFolder_Sub("choco", $True)
        [String]$MyFilePath_Output = $MyJtIoFolder_Output.GetFilePath($MyFilename)
        if ($env:ChocolateyInstall -eq "c:\ProgramData\chocolatey" ) {
            $MyCommand = -join ('cmd.exe /C ', '"', 'choco list -li', '"', ' > ', '"', $MyFilePath_Output, '"')
            Invoke-Expression -Command:$MyCommand  
        }
        else {
            $MyCommand = -join ('cmd.exe /C ', '"', 'echo choco is not installed', '"', ' > ', '"', $MyFilePath_Output, '"')
            Invoke-Expression -Command:$MyCommand  
        }
        return $True
    }
 
    [String]GetConfigName() {
        return ""
    }

    [String]GetReportLabel() {
        return "choco"
    }
}



class JtInvClientClean : JtInv {

    JtInvClientClean() : Base() {
        $This.ClassName = "JtInvClientClean"
    }

    [Boolean]DoIt() {
        $This.DoLogRepoStart()

        [String]$MyFolderPath_C_Inventory_Report = [JtLog]::FolderPath_C_inventory_Report

        [JtIoFolder]$MyJtIoFolder_Report = $This.JtIoFolder_Report
        If (!($MyJtIoFolder_Report.IsExisting())) {
            Throw "This should not happen. c:\_inventory\report is missing."
            return $False
        }

        if ($MyJtIoFolder_Report.GetPath() -eq $MyFolderPath_C_Inventory_Report) {
            $MyJtIoFolder_Report.DoRemoveEverything()
            Write-JtLog -Where $This.ClassName -Text "# LOG Starting client..."
        }
        else {
            [String]$MyMsg = -join ("This should not happen. Illegal path for local report. Should be: ", $MyFolderPath_C_Inventory_Report)
            Write-JtLog_Error -Where $This.ClassName -Text $MyMsg
            Throw $MyMsg
        }
        return $True  
    }
    
    [String]GetConfigName() {
        return ""
    }
    
    [String]GetReportLabel() {
        return "clean"
    }
}



class JtInvClientConfig : JtInv {

    [String]$Out = ""
    [String]$XmlFiles = ""

    JtInvClientConfig() : Base() {
        $This.ClassName = "JtInvClientConfig"
    }
    
    [Boolean]DoIt() {
        $This.DoLogRepoStart()
        return $True
    }
    
    [String]GetConfigName() {
        return ""
    }

    [String]GetReportLabel() {
        return "config"
    }
}


class JtInvClientCsvs : JtInv {

    JtInvClientCsvs() : Base() {
        $This.ClassName = "JtInvClientCsvs"
        # output goes directly to c:\_inventory\report
    }

    [Boolean]DoIt() {
        $This.DoLogRepoStart()

        [JtIoFolder]$MyJtIoFolder = New-JtIoFolder_Report
        New-JtCsvGenerator -FolderPath_Input $MyJtIoFolder -FolderPath_Output $MyJtIoFolder -Label $This.ClassName

        return $True
    }

    [String]GetConfigName() {
        return ""
    }

    [String]GetReportLabel() {
        return "csv"
    }
}

class JtInvClientErrors : JtInv {

    JtInvClientErrors() : Base() {
        $This.ClassName = "JtInvClientErrors"
        # Output goes directly to c:\_inventory\report
    }

    [Boolean]DoCleanErrorFiles() {
        [String]$MyFilter = -join ("*", [JtIo]::FileExtension_Meta_Errors)
        $This.JtIoFolder_Report.DoRemoveFiles_All($MyFilter)
        return $True
    }

    [Boolean]DoIt() {
        $This.DoLogRepoStart()
        $This.DoCleanErrorFiles()

        [String]$MyFolderPath_Input = $This.GetFolderPath_Input()
        [String]$MyFolderPath_Output = $This.GetFolderPath_Output()
        
        [String]$MyCounter = [JtLog]::CounterError
        [String]$MyLabel = $MyCounter
        [String]$MyPrefix = [JtIo]::FilePrefix_Report
        [String]$MyExtension2 = [JtIo]::FileExtension_Meta_Errors

        $MyParams = @{
            FolderPath_Input  = $MyFolderPath_Input
            FolderPath_Output = $MyFolderPath_Output
            Prefix            = $MyPrefix
            Label             = $MyLabel
            Extension2        = $MyExtension2
            Overwrite         = $True
        }
        Write-JtIoFile_Meta @MyParams

        return $True
    }


    [String]GetConfigName() {
        return ""
    }

    [String]GetReportLabel() {
        return "errors"
    }
}

class JtInvClientExport  : JtInv {

    JtInvClientExport () : Base() {
        $This.ClassName = "JtInvClientExport"
    }


        
    [System.Collections.ArrayList]GetAlItems() {
        [System.Collections.ArrayList]$MyArrayList = New-Object System.Collections.ArrayList
        
        [Xml]$MyConfigXml = $This.GetConfigXml()
        if ($Null -eq $MyConfigXml) {
            return $MyArrayList
        }
        
        [String]$MyTagName = "export"
        foreach ($Entity in $MyConfigXml.getElementsByTagName($MyTagName)) {
            $MyParams = @{
                target = $Entity.target
            }
            [HashTable]$MyItem = New-JtConfigItem @MyParams
    
            if ($MyItem.BlnValid) {
                $MyArrayList.Add($MyItem)
            }
            else {
                Write-JtLog_Error -Where $This.ClassName -Text "Config not valid. Problem with item."
                $MyItem
                Write-JtLog_Error -Where $This.ClassName -Text "Config not valid"
                Throw "Problem with config."
            }
        }
        return $MyArrayList
    }

    [Boolean]DoIt() {
        $This.DoLogRepoStart()
        [System.Collections.ArrayList]$MyArrayList = New-Object System.Collections.ArrayList
        
        [Xml]$MyConfigXml = $This.GetConfigXml()
        if ($Null -eq $MyConfigXml) {
            return $False
        }
        
        $MyArrayList = $This.GetAlItems()
        [Int]$MyIntCount = $MyArrayList.count
        Write-JtLog -Where $This.ClassName -Text "DoIt. Number of items. MyIntCount: $MyIntCount"

        foreach ($MyItem in $MyArrayList) {
            [JtIoFolder]$MyJtIoFolder_Export = $Null
            [String]$MyFolderPath_Target = $MyItem.target

            if ($MyFolderPath_Target.Length -gt 0) {
                [JtIoFolder]$MyJtIoFolder_Export = New-JtIoFolder -FolderPath $MyFolderPath_Target -Force
                Write-JtLog -Where $This.ClassName -Text "... Exporting results to: $MyJtIoFolder_Export"
            }

            [String]$MySystemId = [JtIo]::GetSystemId()
            [JtIoFolder]$MyJtIoFolder_OutputSys = $MyJtIoFolder_Export.GetJtIoFolder_Sub($MySystemId, $True)

            [String]$MyFolderPath_Output = $MyJtIoFolder_OutputSys.GetPath()
            
            [String]$MyInfo = "DoI (export) in $This.ClassName"
            
            [String]$MyFolderPath_Input = $This.JtIoFolder_Report.GetPath()
            New-JtRobocopy -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output -Info $MyInfo
        }
        return $True
    }

    [String]GetConfigName() {
        return "JtInvCLIENT"
    }

    [String]GetReportLabel() {
        return "Export"
    }
}

class JtInvClientObjects : JtInv {

    JtInvClientObjects() : Base() {
        $This.ClassName = "JtInvClientObjects"
        # output goes directly to c:\_inventory\report
    }

    hidden [Boolean]DoWriteObjectToXml([String]$TheLabel, $TheJtObject) {
        [String]$MyLabel = $TheLabel
        $MyObject = $TheJtObject
        [String]$MyFilename_Xml = -join ($MyLabel.ToLower(), [JtIo]::FileExtension_Xml)

        [String]$MyFilePath_Xml = $This.GetFolderPath_Output().GetFilePath($MyFilename_Xml)
        Write-JtLog_File -Where $This.ClassName -Text "Writing: $MyLabel in FilePathXml" -FilePath $MyFilePath_Xml
        Export-Clixml -InputObject  $MyObject -Path $MyFilePath_Xml
        return $True
    }

    [Boolean]DoIt() {
        $This.DoLogRepoStart()

        $MyClass = "Win32_BIOS"
        $MyObject = Get-CimInstance -ClassName Win32_BIOS
        $This.DoWriteObjectToXml($MyClass, $MyObject)

        $MyClass = "Win32_ComputerSystem"
        $MyObject = Get-CimInstance -ClassName Win32_ComputerSystem
        $This.DoWriteObjectToXml($MyClass, $MyObject)

        $MyClass = "Win32_Desktop"
        $MyObject = Get-CimInstance -ClassName Win32_Desktop
        $This.DoWriteObjectToXml($MyClass, $MyObject)

        $MyClass = "Win32_LocalTime"
        $MyObject = Get-CimInstance -ClassName Win32_LocalTime
        $This.DoWriteObjectToXml($MyClass, $MyObject)

        $MyClass = "Win32_LogicalDisk"
        $MyObject = Get-CimInstance -ClassName Win32_LogicalDisk
        $This.DoWriteObjectToXml($MyClass, $MyObject)

        $MyClass = "Win32_LogonSession"
        $MyObject = Get-CimInstance -ClassName Win32_LogonSession
        $This.DoWriteObjectToXml($MyClass, $MyObject)

        $MyClass = "Win32_NetworkAdapter"
        $MyObject = Get-CimInstance -ClassName Win32_NetworkAdapter
        $This.DoWriteObjectToXml($MyClass, $MyObject)

        $MyClass = "Win32_OperatingSystem"
        $MyObject = Get-CimInstance -ClassName Win32_OperatingSystem
        $This.DoWriteObjectToXml($MyClass, $MyObject)

        $MyClass = "Win32_Processor"
        $MyObject = Get-CimInstance -ClassName Win32_Processor
        $This.DoWriteObjectToXml($MyClass, $MyObject)

        $MyClass = "Win32_QuickFixEngineering"
        $MyObject = Get-CimInstance -ClassName Win32_QuickFixEngineering
        $This.DoWriteObjectToXml($MyClass, $MyObject)

        $MyClass = "Win32_Service"
        $MyObject = Get-CimInstance -ClassName Win32_Service
        $This.DoWriteObjectToXml($MyClass, $MyObject)

        $MyClass = "Win32_VideoController"
        $MyObject = Get-CimInstance -ClassName Win32_VideoController
        $This.DoWriteObjectToXml($MyClass, $MyObject)

        $MyClass = "BitLocker"
        [String]$MyLabelCsv = $MyClass.ToLower()
        [String]$MyExtension = [JtIo]::FileExtension_Xml
        [String]$MyFilename_Xml = -join ($MyLabelCsv, $MyExtension)
        [String]$MyFilePath_Xml = $This.GetFolderPath_Output().GetFilePath($MyFilename_Xml)    
        try {
            $MyAlObject = Get-BitLockerVolume

            $MyAlObject | Sort-Object -Property MountPoint | Format-Table -Property * 
        
            [String]$MyFolderPath_Output = $This.GetFolderPath_Output()
            Convert-JtAl_to_FileCsv -ArrayList $MyAlObject -FolderPath_Output $MyFolderPath_Output -Label $MyLabelCsv

            $This.DoWriteObjectToXml($MyClass, $MyAlObject)
            Export-Clixml -InputObject $MyAlObject -Path $MyFilePath_Xml
        }
        catch {
            Write-JtLog_Error -Where $This.ClassName -Text "Problems with: BitLockerVolume -> Need admin rights...?"
        }

        return $True
    }

    [String]GetConfigName() {
        return ""
    }

    [String]GetReportLabel() {
        return "objects"
    }
}



class JtInvClientReport : JtInv {
    
    [JtIoFolder]$JtIoFolder_Output

    JtInvClientReport() : Base() {
        $This.ClassName = "JtInvClientReport"
    }

    [Boolean]DoCreateBcdeditMeta() {
        [String]$MyCommand = ""
        # [String]$MyLabel = "systemid"
        [String]$MyFilename = -join ([JtIo]::FilePrefix_Report, '.', 'bcdedit', [JtIo]::FileExtension_Meta_Report)
        [String]$MyFilePath_Output = $This.JtIoFolder_Report.GetFilePath($MyFilename)
        $MyCommand = -join ('bcdedit.exe /enum ', ' > ', '"', $MyFilePath_Output, '"')
        Invoke-Expression -Command:$MyCommand

        return $True
    }



    [Boolean]DoCreateDirMetas() {
        [String]$MyFolderPath_Test = ""
        [String]$MyCommand = ""
        
        $MyFolderPath_Test = "c:\."
        if (Test-JtIoFolderPath -FolderPath $MyFolderPath_Test ) {
            $MyCommand = $This.GetDirCommand($MyFolderPath_Test )
            Invoke-Expression -Command:$MyCommand
        }

        $MyFolderPath_Test = "c:\users\."
        if (Test-JtIoFolderPath -FolderPath $MyFolderPath_Test ) {
            $MyCommand = $This.GetDirCommand($MyFolderPath_Test )
            Invoke-Expression -Command:$MyCommand
        }
        
        $MyFolderPath_Test = "d:\."
        if (Test-JtIoFolderPath -FolderPath $MyFolderPath_Test ) {        
            $MyCommand = $This.GetDirCommand($MyFolderPath_Test )
            Invoke-Expression -Command:$MyCommand
        }

        $MyFolderPath_Test = "e:\."
        if (Test-JtIoFolderPath -FolderPath $MyFolderPath_Test ) {        
            $MyCommand = $This.GetDirCommand($MyFolderPath_Test )
            Invoke-Expression -Command:$MyCommand
        }
        return $True
    }
    
    [Boolean]DoCreateMetas() {
        [String]$MyCommand = ""
        [String]$MyLabel = ""

        [String]$MyContent = "hello world!"
        [String]$MyFolderPath_C_inventory_Report = $This.JtIoFolder_Report.GetPath()

        [String]$MyFolderPath_Input = $MyFolderPath_C_inventory_Report
        [String]$MyFolderPath_Output = $MyFolderPath_C_inventory_Report

        $MyParams = @{
            FolderPath_Input  = $MyFolderPath_Input
            FolderPath_Output = $MyFolderPath_Output
            Name              = "jt"
            Value             = Get-JtVersion
        }
        Write-JtIoFile_Meta_Report @MyParams

        $MyIpInfo = (Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $null -ne $_.DefaultIPGateway }).IPAddress | select-object -first 1 
        [String]$MyIp = $MyIpInfo
        [String]$MyIpOutput = $MyIp.Replace(".", "-")
        $MyParams = @{
            FolderPath_Input  = $MyFolderPath_Input
            FolderPath_Output = $MyFolderPath_Output
            Name              = "ip"
            Value             = $MyIpOutput
        }
        Write-JtIoFile_Meta_Report @MyParams
        
        [String]$MyLabel = -join ("user", ".", $env:Username)
        $MyParams = @{
            FolderPath_Input  = $MyFolderPath_Input
            FolderPath_Output = $MyFolderPath_Output
            Name              = "user"
            Value             = $env:Username
        }
        Write-JtIoFile_Meta_Report @MyParams

        # [String]$MyLabel = -join ("klonversion", ".", $env:Username)
        [String]$MyKlonVersion = Get-JtKlonversion
        $MyParams = @{
            FolderPath_Input  = $MyFolderPath_Input
            FolderPath_Output = $MyFolderPath_Output
            Name              = "klonversion"
            Value             = $MyKlonVersion
        }
        Write-JtIoFile_Meta_Report @MyParams
        
        $MyParams = @{
            FolderPath_Input  = $MyFolderPath_Input
            FolderPath_Output = $MyFolderPath_Output
            Name              = "id"
            Value             = [JtIo]::GetSystemId()
        }
        Write-JtIoFile_Meta_Report @MyParams

        $MyParams = @{
            FolderPath_Input  = $MyFolderPath_Input
            FolderPath_Output = $MyFolderPath_Output
            Name              = "computer"
            Value             = [JtIo]::GetComputername()
        }
        Write-JtIoFile_Meta_Report @MyParams

        [String]$MyName = "set"
        [String]$MyFilePath_Output = $This.GetFilePath_Txt($MyName)
        $MyCommand = -join ('cmd.exe /C ', '"', 'set', '"', ' > ', '"', $MyFilePath_Output, '"')
        Invoke-Expression -Command:$MyCommand
        
        [String]$MyName = "winver"
        [String]$MyFilePath_Output = $This.GetFilePath_Txt($MyName)
        $MyCommand = -join ('cmd.exe /C ', '"', 'ver', '"', ' > ' , '"', $MyFilePath_Output, '"')
        Invoke-Expression -Command:$MyCommand

        $MyVer2 = Get-Content $MyFilePath_Output | Where-Object { $_.Trim() -ne '' }
        # [String]$MyLabel = Convert-JtDotter $MyVer2 -PatternOut "3"

        [String]$MyVersion = "verX"
        if ($MyVer2 -match '\d+\.\d+\.\d+\.\d+') {
            $MyVersion = $Matches[0]
        }
               
        [String]$MyValue = Convert-JtDotter -Text $MyVersion -PatternOut "1.2.3.4" -SeparatorOut "-"
        $MyParams = @{
            FolderPath_Input  = $MyFolderPath_Input
            FolderPath_Output = $MyFolderPath_Output
            Name              = "winver"
            Value             = $MyValue
        }
        Write-JtIoFile_Meta_Report @MyParams

        [String]$MyName = "ipconfig"
        [String]$MyFilePath_Output = $This.GetFilePath_Txt($MyName)
        $MyCommand = -join ('cmd.exe /C ', '"', 'ipconfig /all', '"', '   > ', '"', $MyFilePath_Output, '"')
        Invoke-Expression -Command:$MyCommand
        
        [String]$MyName = "w32tm"
        [String]$MyFilePath_Output = $This.GetFilePath_Txt($MyName)
        $MyCommand = -join ('cmd.exe /C ', '"', 'w32tm /stripchart /computer:130.75.1.32 /samples:1', '"', '   > ', '"', $MyFilePath_Output, '"')
        Invoke-Expression -Command:$MyCommand
        
        [String]$MyName = "wsus"
        [String]$MyFilePath_Output = $This.GetFilePath_Txt($MyName)
        try {
            $MyCommand = -join ('reg query ', '"', 'hklm\software\policies\microsoft\windows\windowsupdate', '"', ' /v ', '"', 'wuserver', '"', ' > ', '"', $MyFilePath_Output, '"')
            Invoke-Expression -Command:$MyCommand   
        }
        catch {
            $MyCommand = -join ('cmd.exe /C ', '"', 'echo wsus cannot be reported', '"', ' > ', '"', $MyFilePath_Output, '"')
            Invoke-Expression -Command:$MyCommand   
        }

        [String]$MyName = "choco"
        [String]$MyFilePath_Output = $This.GetFilePath_Txt($MyName)
        if ($env:ChocolateyInstall -eq "c:\ProgramData\chocolatey" ) {
            $MyCommand = -join ('cmd.exe /C ', '"', 'choco list -li', '"', ' > ', '"', $MyFilePath_Output, '"')
            Invoke-Expression -Command:$MyCommand  
        }
        else {
            [String]$MyContent = "CHOCO IS NOT INSTALLED"
            Add-Content -Path $MyFilePath_Output
        }

        return $True
    }

    [Boolean]DoIt() {
        $This.DoLogRepoStart()

        $This.DoCreateMetas()
        $This.DoCreateDirMetas()
        $This.DoCreateBcdeditMeta()
        return $True
    }


    [String]GetConfigName() {
        return "JtInvClientReport"
    }

    [String]GetDirCommand([String]$TheFolderPath) {
        [String]$MyFolderPath = $TheFolderPath
        [String]$MyLabel = Convert-JtFolderPath_To_Label -FolderPath $MyFolderPath
        [String]$MyName = -join ("dir", "_", $MyLabel)
        [String]$MyFilePath_Output = $This.GetFilePath_Txt($MyName)
        [String]$MyResult = -join ('cmd.exe /C ', '"', 'dir ', $MyFolderPath, ' > ', $MyFilePath_Output, '"')
        return $MyResult
    }


    [String]GetFilePath_Txt([String]$TheName) {
        [JtIoFolder]$MyJtIoFolder_Report = New-JtIoFolder_Report
        [JtIoFolder]$MyJtIoFolder_Output = $MyJtIoFolder_Report

        [String]$MyName = $TheName
        [String]$MyPrefix = [JtIo]::FilePrefix_Report
        [String]$MyExtension = [JtIo]::FileExtension_Txt
        [String]$MyFilename = -join ($MyPrefix, '.', $MyName, $MyExtension)
        [String]$MyFilePath_Output = $MyJtIoFolder_Output.GetFilePath($MyFilename)
        return $MyFilePath_Output
    }

    [String]GetReportLabel() {
        return "report"
    }
}


class JtInvClientSoftware : JtInv {

    JtInvClientSoftware() : Base() {
        $This.ClassName = "JtInvClientSoftware"
        # output goes directly to c:\_inventory\report
    }

    [Boolean]DoIt() {
        $This.DoLogRepoStart()

        $MyObject = $NUll
        $MyObject = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Sort-Object DisplayName 
        $MyClass = "Uninstall64"
        [String]$MyFileName_Xml = -join ($MyClass.ToLower(), [JtIo]::FileExtension_Xml)
        [String]$MyFileName_Txt = -join ($MyClass.ToLower(), [JtIo]::FileExtension_Txt)

        $MyFilePath_Xml = $This.GetFolderPath_Output().GetFilePath($MyFileName_Xml)
        $MyFilePathTxt = $This.GetFolderPath_Output().GetFilePath($MyFileName_Txt)

        Write-JtLog_File -Where $This.ClassName -Text "Writing TXT-File." -FilePath $MyFilePathTxt
        $MyObject | Sort-Object -Property DisplayName | Format-Table -Property DisplayName, DisplayVersion | Out-File -FilePath $MyFilePathTxt

        Write-JtLog_File -Where $This.ClassName -Text "Writing XML-File." -FilePath $MyFilePath_Xml
        Export-Clixml -InputObject  $MyObject -Path $MyFilePath_Xml
        
        $MyObject = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Sort-Object DisplayName 	
        $MyClass = "Uninstall32"
        [String]$MyFileName_Xml = -join ($MyClass.ToLower(), [JtIo]::FileExtension_Xml)
        [String]$MyFileName_Txt = -join ($MyClass.ToLower(), [JtIo]::FileExtension_Txt)
        
        $MyFilePath_Xml = $This.GetFolderPath_Output().GetFilePath($MyFileName_Xml)
        $MyFilePathTxt = $This.GetFolderPath_Output().GetFilePath($MyFileName_Txt)

        Write-JtLog_File -Where $This.ClassName -Text "Writing TXT-File." -FilePath $MyFilePathTxt
        $MyObject | Sort-Object -Property DisplayName | Format-Table -Property DisplayName, DisplayVersion | Out-File -FilePath $MyFilePathTxt

        Write-JtLog_File -Where $This.ClassName -Text "Writing XML-File." -FilePath $MyFilePath_Xml
        Export-Clixml -InputObject  $MyObject -Path $MyFilePath_Xml

        return $True
    }


    [String]GetConfigName() {
        return ""
    }

    [String]GetReportLabel() {
        return "software"
    }
}


class JtInvClientTimestamp : JtInv {
    
    [String]$MetaLabel
    
    JtInvClientTimestamp([String]$TheLabel) : Base() {
        $This.ClassName = "JtInvClientTimestamp"
        $This.MetaLabel = $TheLabel
        # Output goes directly to c:\_inventory\report
        
        [String]$MyLabel = $TheLabel
        $This.DoCreateMetaTime($MyLabel)
    }
    
    [Boolean]DoIt() {
        $This.DoLogRepoStart()

        return $True
    }
    
    [Boolean]DoCreateMetaTime([String]$TheName) {
        [String]$MyName = $TheName
        
        [String]$MySub = $this.GetReportLabel()
        [JtIoFolder]$MyJtIoFolder_Input = $This.JtIoFolder_Report
        [JtIoFolder]$MyJtIoFolder_Output = $This.JtIoFolder_Report.GetJtIoFolder_Sub($MySub, $True)
        $MyParams = @{
            FolderPath_Input  = $MyJtIoFolder_Input
            FolderPath_Output = $MyJtIoFolder_Output
            Name              = $MyName
        }
        Write-JtIoFile_Meta_Time @MyParams
        return $True
    }
 
    [Boolean]DoCleanTimestamps() {
        [String]$MyFilter = -join ("*", ".", $This.MetaLabel, [JtIo]::FileExtension_Meta_Time)
        Write-Host "DoCleanTimestamps"        
        $This.JtIoFolder_Report.DoRemoveFiles_All($MyFilter)
        return $True
    }

    [String]GetConfigName() {
        return ""
    }

    [String]GetReportLabel() {
        return "timestamp"
    }
}


# $mySoftware = Get-JtInstalledSoftware $env:COMPUTERNAME

class JtInvData : JtInv {
    
    [String]$Out = ""
    [String]$Computer
    
    JtInvData() : Base() {
        $This.ClassName = "JtInvData"
        $This.Computer = $env:COMPUTERNAME
    }

    
    [System.Collections.ArrayList]GetAlItems() {
        [System.Collections.ArrayList]$MyArrayList = New-Object System.Collections.ArrayList
        
        [Xml]$MyConfigXml = $This.GetConfigXml()
        if ($Null -eq $MyConfigXml) {
            return $MyArrayList
        }
        
        [String]$MyTagName = "data"
        foreach ($Entity in $MyConfigXml.getElementsByTagName($MyTagName)) {
            $MyParams = @{
                source = $Entity.source
                target = $Entity.target
                label  = $Entity.label
            }
            [HashTable]$MyItem = New-JtConfigItem @MyParams
    
            if ($MyItem.BlnValid) {
                $MyArrayList.Add($MyItem)
            }
            else {
                Write-JtLog_Error -Where $This.ClassName -Text "Config not valid. Problem with item."
                $MyItem
                Write-JtLog_Error -Where $This.ClassName -Text "Config not valid"
                Throw "Problem with config."
            }
        }
        return $MyArrayList
    }

    [Boolean]DoIt() {
        $This.DoLogRepoStart()
        [System.Collections.ArrayList]$MyArrayList = New-Object System.Collections.ArrayList
        
        [Xml]$MyConfigXml = $This.GetConfigXml()
        if ($Null -eq $MyConfigXml) {
            return $False
        }
        
        $MyArrayList = $This.GetAlItems()
        [Int]$MyIntCount = $MyArrayList.count
        Write-JtLog -Where $This.ClassName -Text "DoIt. Number of items. MyIntCount: $MyIntCount"

        foreach ($MyItem in $MyArrayList) {
            $This.DoWriteTheReport($MyItem.source, $MyItem.target, $MyItem.label)
        }
        return $True
    }

    hidden [Boolean]DoWriteTheReport([String]$TheFolderPath_Input, [String]$TheFolderPath_Output, [String]$TheLabel) {
        [String]$MyLabel = $TheLabel
        [String]$MyFolderPath_Input = $TheFolderPath_Input
        [String]$MyFolderPath_Output = $TheFolderPath_Output

        [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input
        [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyFolderPath_Output
        Write-JtLog -Where $This.ClassName -Text "DoWriteTheReport. MyFolderPath_Input: $MyFolderPath_Input, MyFolderPath_Output: $MyFolderPath_Output, LABEL: $MyLabel"
        [String]$MyReportName = -join ("data", ".", $env:COMPUTERNAME.ToLower(), ".", $MyLabel)
        [JtTblTable]$MyJtTblTable = New-JtTblTable -Label $MyReportName

        $MyAlJtIoFoldersFoldersSub = $MyJtIoFolder_Input.GetAlJtIoFolders_Sub($False)
        foreach ($Folder in $MyAlJtIoFoldersFoldersSub) {
            [JtIoFolder]$MyJtIoFolder = $Folder
            [JtTblRow]$MyJtTblRow = $This.GetDataLine($MyJtIoFolder.GetPath())
            $MyJtTblTable.AddRow($MyJtTblRow)
        }
        [String]$MyFolderPath_Output = $MyJtIoFolder_Output.GetPath()
        Convert-JtTblTable_To_Csv -JtTblTable $MyJtTblTable -FolderPath_Output $MyFolderPath_Output
        return $True
    }

    hidden [JtTblRow]GetDataLine([String]$TheFolderPath) {
        [String]$MyFolderPath = $TheFolderPath
        [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $MyFolderPath
        [String]$MyFoldername = $MyJtIoFolder.GetName()
        Write-JtLog -Where $This.ClassName -Text "-- GetDataLine, MyFolderPath: $MyFolderPath"
        [JtTblRow]$MyJtTblRow = New-JtTblRow
    
        [String]$MyComputername = Get-JtComputername
        $MyJtTblRow.Add("Computer", $MyComputername)
        $MyJtTblRow.Add("Foldername", $MyFoldername)
        $MyJtTblRow.Add("Path", $MyFolderPath)

        [Decimal]$MyDecFolderSize = Get-JtFolderPath_Info_SizeGb -FolderPath $MyFolderPath
        [Decimal]$MyIntFilesCount = Get-JtFolderPath_Info_FilesCount -FolderPath $MyFolderPath

        if ($Null -eq $MyDecFolderSize) {
            # $MyJtTblRow.Add("Size", 0)
            $MyJtTblRow.Add("SizeGB", 0)
            $MyJtTblRow.Add("Files", 0)
            $MyJtTblRow.Add("OK", 0)
        }    
        else {
            # $MyJtTblRow.Add("Size", $MyResult.Sum)
            $MyJtTblRow.Add("SizeGB", $MyDecFolderSize)
            $MyJtTblRow.Add("Files", $MyIntFilesCount)
            $MyJtTblRow.Add("OK", 1)
        }    
        return $MyJtTblRow
    }    

    [String]GetConfigName() {
        return "JtInvDATA"
    }

    [String]GetReportLabel() {
        return "data"
    }
}



class JtTblFilelist : JtClass {

    #  "NAME.EXTENSION.PATH.PARENT_NAME"


    static [JtTblRow] GetRowForFile2([JtIoFile]$TheJtIoFile) {
        #  "NAME.EXTENSION.PATH.PARENT_NAME"
        [JtIoFile]$MyJtIoFile = $TheJtIoFile
                
        [JtTblRow]$MyJtTblRow = New-JtTblRow
        
        [String]$MyFilename = $MyJtIoFile.GetName()
        $MyJtTblRow.Add("NAME", $MyFileName)
        
        [String]$MyExtension = $MyJtIoFile.GetExtension()
        $MyJtTblRow.Add("EXTENSION", $MyExtension)

        [String]$MyFilePath = $MyJtIoFile.GetPath()
        $MyJtTblRow.Add("PATH", $MyFilePath)

        [JtIoFolder]$MyJtIoFolder_Parent = $MyJtIoFile.GetJtIoFolder_Parent()
        [String]$MyFoldername_Parent = $MyJtIoFolder_Parent.GetName()
        $MyJtTblRow.Add("PARENT_NAME", $MyFoldername_Parent)

        return $MyJtTblRow
    }

    static [JtTblRow] GetRowForFileUsingTemplate([JtIoFile]$TheJtIoFile, [String]$TheFilename_Template) {
        [JtTblRow]$MyJtTblRowAll = Convert-JtFilePath_To_JtTblRow_Betrag -FilePath $TheJtIoFile

        [JtTblRow]$MyJtTblRow = New-JtTblRow
        [String[]]$AlParts = $TheFilename_Template.Split(".")

        foreach ($Element in $AlParts) {
            [String]$MyPart = $Element

            [String]$MyValue = $MyJtTblRowAll.GetValue($MyPart)
            $MyJtTblRow.Add($MyPart, $MyValue)
        }
        return $MyJtTblRow
    }


}

class JtInvFiles : JtInv {

    JtInvFiles () : Base() {
        $This.ClassName = "JtInvFiles"
    }

    [System.Collections.ArrayList]GetAlItems() {
        [System.Collections.ArrayList]$MyArrayList = New-Object System.Collections.ArrayList
        
        [Xml]$MyConfigXml = $This.GetConfigXml()
        if ($Null -eq $MyConfigXml) {
            return $MyArrayList
        }
        
        [String]$MyTagName = "files"
        foreach ($Entity in $MyConfigXml.getElementsByTagName($MyTagName)) {
            $MyParams = @{
                source = $Entity.source
                target = $Entity.target
                label  = $Entity.label
                filter = $Entity.filter
            }
            [HashTable]$MyItem = New-JtConfigItem @MyParams

            if ($MyItem.BlnValid) {
                $MyArrayList.Add($MyItem)
            }
            else {
                Write-JtLog_Error -Where $This.ClassName -Text "Config not valid. Problem with item."
                $MyItem
                Write-JtLog_Error -Where $This.ClassName -Text "Config not valid"
                Throw "Problem with config."
            }
        }
        return $MyArrayList
    }

    [Boolean]DoIt() {
        $This.DoLogRepoStart()

        [Xml]$MyConfigXml = $This.GetConfigXml()
        if ($Null -eq $MyConfigXml) {
            return $False
        }
        
        $MyArrayList = $This.GetAlItems()
        [Int]$MyIntCount = $MyArrayList.count
        Write-JtLog -Where $This.ClassName -Text "DoIt. Number of items. MyIntCount: $MyIntCount"
        foreach ($MyItem in $MyArrayList) {
            [String]$MySource = $MyItem.source
            [String]$MyLabel = $MyItem.label
            [String]$MyTarget = $MyItem.target
            [String]$MyFilter = $MyItem.filter
            
            [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $MySource
            [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyTarget -Force
            [String]$MyFolderPath_Output = $MyJtIoFolder_Output.GetPath()

            [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder -Filter $MyFilter -Recurse

            [Int16]$MyIntCount = $MyAlJtIoFiles.Count
            if ($MyIntCount -gt 0) {
                Write-JtLog -Where $This.ClassName -Text "DoIt... Number of files: $MyIntCount in MyJtIoFolder: $MyJtIoFolder"
                
                [JtTblTable]$MyJtTblTable = Convert-JtAlJtIoFiles_to_JtTblTable -ArrayList $MyAlJtIoFiles -Label $MyLabel
                
                Convert-JtTblTable_To_Csv -JtTblTable $MyJtTblTable -FolderPath_Output $MyFolderPath_Output
            }
            else {
                Write-JtLog_Error -Where $This.ClassName -Text "DoIt... Nothing to do. Number of files: $MyIntCount in MyJtIoFolder: $MyJtIoFolder"
            }
        }
        return $True
    }


    [String]GetConfigName() {
        return "JtInvFILES"
    }


    [String]GetReportLabel() {
        return "files"
    }
}


class JtInvFolder : JtInv {

    JtInvFolder () : Base() {
        $This.ClassName = "JtInvFolder"
    }

    [System.Collections.ArrayList]GetAlItems() {
        [System.Collections.ArrayList]$MyArrayList = New-Object System.Collections.ArrayList

        [Xml]$MyConfigXml = $This.GetConfigXml()
        if ($Null -eq $MyConfigXml) {
            return $MyArrayList 
        }

        [String]$MyTagName = "folder"
        foreach ($Entity in $MyConfigXml.getElementsByTagName($MyTagName)) {
            $MyParams = @{
                source = $Entity.source
                target = $Entity.target
            }
            [HashTable]$MyItem = New-JtConfigItem @MyParams

            if ($MyItem.BlnValid) {
                $MyArrayList.Add($MyItem)
            }
            else {
                Write-JtLog_Error -Where $This.ClassName -Text "Config not valid"
                Throw "Problem with config."
            }
        }
        return $MyArrayList     
    }

    [Boolean]DoIt() {
        $This.DoLogRepoStart()
        [System.Collections.ArrayList]$MyArrayList = New-Object System.Collections.ArrayList
        
        [Xml]$MyConfigXml = $This.GetConfigXml()

        if ($Null -eq $MyConfigXml) {
            Write-JtLog_Error -Where $This.ClassName -Text "MyConfigXml is NULL"
            return $False
        }

        [System.Collections.ArrayList]$MyArrayList = $This.GetAlItems()
        [Int]$MyIntCount = $MyArrayList.count
        Write-JtLog -Where $This.ClassName -Text "DoIt. Number of items. MyIntCount: $MyIntCount"
        foreach ($MyItem in $MyArrayList) {
            # [String]$MyJtInfo = $Entity.'#text'

            [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyItem.source
            [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyItem.target

            # [System.Collections.ArrayList]$MyAlFolderTypes = Convert-JtFolderPath_To_AlFoldertypes  -FolderPath $MyJtIoFolder_Input
            # Write-JtLog -Where $This.ClassName -Text "Finding Foldertypes"

            Update-JtFolderPath_Md_And_Meta -FolderPath_Input $MyJtIoFolder_Input -FolderPath_Output $MyJtIoFolder_Output

        } 
        return $True
    }


    [String]GetConfigName() {
        return "JtInvFolder"
    }

    [String]GetReportLabel() {
        return "folders"
    }
}


class JtInvLengths : JtInv {

    JtInvLengths() : Base() {
        $This.ClassName = "JtInvLengths"
    }

    [System.Collections.ArrayList]GetAlItems() {
        [System.Collections.ArrayList]$MyArrayList = New-Object System.Collections.ArrayList

        [Xml]$MyConfigXml = $This.GetConfigXml()
        if ($Null -eq $MyConfigXml) {
            return $MyArrayList 
        }

        [String]$MyTagName = "lengths"
        foreach ($Entity in $MyConfigXml.getElementsByTagName($MyTagName)) {
            $MyParams = @{
                source = $Entity.source
                label  = $Entity.label
                target = $Entity.target
            }
            [HashTable]$MyItem = New-JtConfigItem @MyParams

            if ($MyItem.BlnValid) {
                $MyArrayList.Add($MyItem)
            }
            else {
                Write-JtLog_Error -Where $This.ClassName -Text "Config not valid"
                Throw "Problem with config."
            }
        }
        return $MyArrayList     
    }


    [Boolean]DoIt() {
        $This.DoLogRepoStart()
        
        [Xml]$MyConfigXml = $This.GetConfigXml()
        if ($Null -eq $MyConfigXml) {
            return $False
        }
        
        [System.Collections.ArrayList]$MyArrayList = $This.GetAlItems()
        [Int]$MyIntCount = $MyArrayList.count
        Write-JtLog -Where $This.ClassName -Text "DoIt. Number of items. MyIntCount: $MyIntCount"

        foreach ($Item in $MyArrayList) {
            $MyItem = $Item

            [String]$MySource = $MyItem.source
            [String]$MyTarget = $MyItem.target
            [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MySource
            [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyTarget
            [String]$MyLabel = $MyItem.label
            [JtTblTable]$MyJtTblTable = $This.GetTable($MyJtIoFolder_Input, $MyLabel)
            
            Write-JtLog -Where $This.ClassName -Text "MyLabel: $MyLabel, $MySource"
            [String]$MyFolderPath_Output = $MyJtIoFolder_Output.GetPath()
            Convert-JtTblTable_To_Csv -JtTblTable $MyJtTblTable -FolderPath_Output $MyFolderPath_Output
        }
        return $True
    }

    [String]GetConfigName() {
        return "JtInvLENGTHS"
    }

    [String]GetReportLabel() {
        return "lengths"
    }

    [JtTblTable]GetTable([JtIoFolder]$TheJtIoFolder, $TheLabel) {
        [String]$MyLabel = $TheLabel
        [JtTblTable]$MyJtTblTable = New-JtTblTable -Label $MyLabel
    
        [JtIoFolder]$MyJtIoFolder = $TheJtIoFolder
        $MyAlJtIoFolders = $MyJtIoFolder.GetAlJtIoFolders_Sub($True)
        foreach ($Folder in $MyAlJtIoFolders) {
            [JtIoFolder]$MyJtIoFolder = $Folder
            [JtTblRow]$MyJtTblRow = New-JtTblRow
            $MyJtTblRow.Add("Foldername", $MyJtIoFolder.GetName()) | Out-Null
            $MyJtTblRow.Add("Path", $MyJtIoFolder.GetPath()) | Out-Null
            $MyJtTblRow.Add("Length", $MyJtIoFolder.GetPath().Length) | Out-Null
            $MyJtTblTable.AddRow($MyJtTblRow) | Out-Null
        }
        return $MyJtTblTable
    }
}


class JtInvLines : JtInv {

    JtInvLines () : Base() {
        $This.ClassName = "JtInvLines"
    }

    [System.Collections.ArrayList]GetAlItems() {
        [System.Collections.ArrayList]$MyArrayList = New-Object System.Collections.ArrayList

        [Xml]$MyConfigXml = $This.GetConfigXml()
        if ($Null -eq $MyConfigXml) {
            return $MyArrayList 
        }

        [String]$MyTagName = "files"
        foreach ($Entity in $MyConfigXml.getElementsByTagName($MyTagName)) {
            $MyParams = @{
                source = $Entity.source
                target = $Entity.target
                filter = $Entity.filter
                label  = $Entity.label
            }
            [HashTable]$MyItem = New-JtConfigItem @MyParams

            if ($MyItem.BlnValid) {
                $MyArrayList.Add($MyItem)
                return $MyArrayList
            }
            else {
                Write-JtLog_Error -Where $This.ClassName -Text "Config not valid"
                Throw "Problem with config."
            }
        }
        return $MyArrayList     
    }

    [Boolean]DoIt() {
        $This.DoLogRepoStart()
        
        [Xml]$MyConfigXml = $This.GetConfigXml()
        if ($Null -eq $MyConfigXml) {
            return $False
        }

        [System.Collections.ArrayList]$MyArrayList = $This.GetAlItems()
        [Int]$MyIntCount = $MyArrayList.count
        Write-JtLog -Where $This.ClassName -Text "DoIt. Number of items. MyIntCount: $MyIntCount"
        foreach ($MyItem in $MyArrayList) {
            [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $MyItem.source
            [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyItem.target

            [JtMd]::DoWriteJtMdCsv($MyJtIoFolder, $MyJtIoFolder_Output, $MyItem.label, $MyItem.filter, $MyItem.pattern)
        } 
        return $True
    }

    [String]GetConfigName() {
        return "JtInvLINES"
    }

    [String]GetReportLabel() {
        return "lines"
    }
}


class JtInvMd : JtInv {

    JtInvMd () : Base() {
        $This.ClassName = "JtInvMd"
    }

    [System.Collections.ArrayList]GetAlItems() {
        [System.Collections.ArrayList]$MyArrayList = New-Object System.Collections.ArrayList

        [Xml]$MyConfigXml = $This.GetConfigXml()
        if ($Null -eq $MyConfigXml) {
            return $MyArrayList 
        }

        [String]$MyTagName = "md"
        foreach ($Entity in $MyConfigXml.getElementsByTagName($MyTagName)) {
            $MyParams = @{
                source  = $Entity.source
                pattern = $Entity.pattern
                label   = $Entity.label
            }
            [HashTable]$MyItem = New-JtConfigItem @MyParams

            if ($MyItem.BlnValid) {
                $MyArrayList.Add($MyItem)
                return $MyArrayList
            }
            else {
                Write-JtLog_Error -Where $This.ClassName -Text "Config not valid"
                Throw "Problem with config."
            }
        }
        return $MyArrayList     
    }

    [Boolean]DoIt() {
        $This.DoLogRepoStart()
        
        [Xml]$MyConfigXml = $This.GetConfigXml()
        if ($Null -eq $MyConfigXml) {
            return $False
        }

        [System.Collections.ArrayList]$MyArrayList = $This.GetAlItems()
        [Int]$MyIntCount = $MyArrayList.count
        Write-JtLog -Where $This.ClassName -Text "DoIt. Number of items. MyIntCount: $MyIntCount"
        foreach ($MyItem in $MyArrayList) {
            [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyItem.source
            [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyItem.target

            # <path filter="*.web.md" label="support_index_az" pattern="[\[]({FILELABEL})[\]][\(](https:\/\/)[A-Za-z0-9.\-\/]*(\))">D:\Seafile\al-public\SUPPORT</path>
            [String]$Filter = "*.md"
            Write-JtLog -Where $This.ClassName -Text "Filter: $Filter"
            [String]$MyLabel = "JtMd.az"
            Write-JtLog -Where $This.ClassName -Text "Label: $MyItem.label"
            [String]$Pattern = "[\[]({FILELABEL})[\]][\(](https:\/\/)[A-Za-z0-9.\-\/]*(\))"
            Write-JtLog -Where $This.ClassName -Text "Pattern: $MyItem.Pattern"
            [JtMd]::DoWriteJtMdCsv($MyJtIoFolder_Input, $MyJtIoFolder_Output, $MyItem.label, $MyItem.filter, $MyItem.pattern)
                
            # <path filter="*.web.md" label="support_links" pattern="[\[][A-Za-z0-9_]*[\]][\(](https:\/\/)[A-Za-z0-9.\-\/]*(\))">D:\Seafile\al-public</path>
            [String]$MyLabel = "JtMd.links"
            Write-JtLog -Where $This.ClassName -Text "Label: $MyLabel"
            [String]$Pattern = "[\[][A-Za-z0-9_]*[\]][\(](https:\/\/)[A-Za-z0-9.\-\/]*(\))"
            Write-JtLog -Where $This.ClassName -Text "Pattern: $Pattern"
            [JtMd]::DoWriteJtMdCsv($MyJtIoFolder_Input, $MyJtIoFolder_Output, $MyItem.label, $MyItem.filter, $MyItem.pattern)
        }
        return $True
    }


    [String]GetConfigName() {
        return "JtInvMD"
    }

    [String]GetReportLabel() {
        return "JtMd"
    }
}


class JtInvDeploy : JtInv {

    JtInvDeploy () : Base() {
        $This.ClassName = "JtInvDeploy"
    }

    [System.Collections.ArrayList]GetAlItems() {
        [System.Collections.ArrayList]$MyArrayList = New-Object System.Collections.ArrayList
        
        [Xml]$MyConfigXml = $This.GetConfigXml()
        if ($Null -eq $MyConfigXml) {
            return $MyArrayList
        }
        
        [String]$MyTagName = "deploy"
        foreach ($Entity in $MyConfigXml.getElementsByTagName($MyTagName)) {
            $MyParams = @{
                source   = $Entity.source
                computer = $Entity.computer
                username = $Entity.username
                share    = $Entity.share
                passwd   = $Entity.passwd
                path     = $Entity.path
            }
            [HashTable]$MyItem = New-JtConfigItem @MyParams

            if ($MyItem.BlnValid) {
                $MyArrayList.Add($MyItem)
            }
            else {
                Write-JtLog_Error -Where $This.ClassName -Text "Config not valid"
                Throw "Problem with config."
            }
        }
        return $MyArrayList
    }

    [Boolean]DoIt() {
        $This.DoLogRepoStart()

        [Xml]$MyConfigXml = $This.GetConfigXml()
        if ($Null -eq $MyConfigXml) {
            return $False
        }

        [System.Collections.ArrayList]$MyArrayList = $This.GetAlItems()
        [Int]$MyIntCount = $MyArrayList.count
        Write-JtLog -Where $This.ClassName -Text "DoIt. Number of items. MyIntCount: $MyIntCount"
        foreach ($Item in $MyArrayList) {
            [String]$MySource = $Item.source
            [String]$MyComputer = $Item.computer
            [String]$MyUsername = $Item.username
            [String]$MyPasswd = $Item.passwd
            [String]$MyShare = $Item.share
            [String]$MyPath = $Item.path

            if (New-JtNetConnection -Computer $MyComputer -Username $MyUsername -Passwd $MyPasswd -Share $MyShare) {
                [String]$MyFolderPath_Output = -join ("\\", $MyComputer, "\", $MyShare, "\", $MyPath)
                New-JtRobocopy -FolderPath_Input $MySource -FolderPath_Output $MyFolderPath_Output
            }
            else {
                Write-JtLog_Error -Where $This.ClassName -Text "Cannot access computer. MyComputer: $MyComputer"
            }
        }
        return $True
    }

    [String]GetConfigName() {
        return "JtInvDeploy"
    }

    [String]GetReportLabel() {
        return "deploy"
    }
}


class JtInvMirror : JtInv {

    JtInvMirror () : Base() {
        $This.ClassName = "JtInvMirror"
    }

    [System.Collections.ArrayList]GetAlItems() {
        [System.Collections.ArrayList]$MyArrayList = New-Object System.Collections.ArrayList
        
        [Xml]$MyConfigXml = $This.GetConfigXml()
        if ($Null -eq $MyConfigXml) {
            return $MyArrayList
        }
        
        [String]$MyTagName = "mirror"
        foreach ($Entity in $MyConfigXml.getElementsByTagName($MyTagName)) {
            $MyParams = @{
                source = $Entity.source
                target = $Entity.target
            }
            [HashTable]$MyItem = New-JtConfigItem @MyParams

            if ($MyItem.BlnValid) {
                $MyArrayList.Add($MyItem)
            }
            else {
                Write-JtLog_Error -Where $This.ClassName -Text "Config not valid"
                Throw "Problem with config."
            }
        }
        return $MyArrayList
    }

    [Boolean]DoIt() {
        $This.DoLogRepoStart()

        [Xml]$MyConfigXml = $This.GetConfigXml()
        if ($Null -eq $MyConfigXml) {
            return $False
        }

        [System.Collections.ArrayList]$MyArrayList = $This.GetAlItems()
        [Int]$MyIntCount = $MyArrayList.count
        Write-JtLog -Where $This.ClassName -Text "DoIt. Number of items. MyIntCount: $MyIntCount"
        foreach ($MyItem in $MyArrayList) {
            New-JtRobocopy -FolderPath_Input $MyItem.source -FolderPath_Output $MyItem.target
        }
        return $True
    }

    [String]GetConfigName() {
        return "JtInvMIRROR"
    }

    [String]GetReportLabel() {
        return "mirror"
    }
}


class JtInvPoster : JtInv {

    [String]$ExtensionFolder = [JtIo]::FileExtension_Folder

    JtInvPoster () : Base() {
        $This.ClassName = "JtInvPoster"
    }

    [System.Collections.ArrayList]GetAlItems() {
        [System.Collections.ArrayList]$MyArrayList = New-Object System.Collections.ArrayList
        
        [Xml]$MyConfigXml = $This.GetConfigXml()
        if ($Null -eq $MyConfigXml) {
            return $MyArrayList
        }
        
        [String]$MyTagName = "poster"
        foreach ($Entity in $MyConfigXml.getElementsByTagName($MyTagName)) {
            $MyParams = @{
                source   = $Entity.source
                target   = $Entity.target
                template = $Entity.template
            }
            [HashTable]$MyItem = New-JtConfigItem @MyParams
    
            if ($MyItem.BlnValid) {
                $MyArrayList.Add($MyItem)
            }
            else {
                Write-JtLog_Error -Where $This.ClassName -Text "Config not valid. Problem with item."
                $MyItem
                Throw "Problem with config."
            }
        }
        return $MyArrayList
    }

    [Boolean]DoIt() {
        $This.DoLogRepoStart()

        [Xml]$MyConfigXml = $This.GetConfigXml()
        if ($Null -eq $MyConfigXml) {
            return $False
        }
        
        $MyArrayList = $This.GetAlItems()
        [Int]$MyIntCount = $MyArrayList.count

        Write-JtLog -Where $This.ClassName -Text "DoIt. Number of items. MyIntCount: $MyIntCount"

        foreach ($MyItem in $MyArrayList) {
            [String]$MyFolderPath_Input = $MyItem.source
            [String]$MyFolderPath_Output = $MyItem.target
            [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input
            [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyFolderPath_Output
            
            [String]$MyFilename_Template = $MyItem.template

            foreach ($Folder in $MyJtIoFolder_Input.GetAlJtIoFolders_Sub()) {
                [JtIoFolder]$MyJtIoFolder_Sub = $Folder
                [String]$MyFolderPath_Input = $MyJtIoFolder_Sub.GetPath()
                Update-JtIndex_BxH -FolderPath_Input $MyFolderPath_Input -Filename_Template $MyFilename_Template
                # New-JtIndex_BxH -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyJtIoFolder_Output -Filename_Template $MyFilename_Template
                New-JtIndex_BxH -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyJtIoFolder_Output
            }
        } 
        return $True
    }

    [String]GetConfigName() {
        return "JtInvPOSTER"
    }

    [String]GetReportLabel() {
        return "poster"
    }
}


class JtInvRecover : JtInv {

    [JtIoFolder]$Folder_C_Inv

    JtInvRecover() : Base() {
        $This.ClassName = "JtInvRecover"
    }

    [System.Collections.ArrayList]GetAlItems() {
        [System.Collections.ArrayList]$MyArrayList = New-Object System.Collections.ArrayList
        
        [Xml]$MyConfigXml = $This.GetConfigXml()
        if ($Null -eq $MyConfigXml) {
            return $MyArrayList
        }
        
        [String]$MyTagName = "recover"
        foreach ($Entity in $MyConfigXml.getElementsByTagName($MyTagName)) {
            $MyParams = @{
                source    = $Entity.source
                disk      = $Entity.disk
                partition = $Entity.partition
                computer  = $Entity.computer
                system    = $Entity.system
            }
            [HashTable]$MyItem = New-JtConfigItem @MyParams
    
            if ($MyItem.BlnValid) {
                $MyArrayList.Add($MyItem)
            }
            else {
                Write-JtLog_Error -Where $This.ClassName -Text "Config not valid. Problem with item."
                $MyItem
                Write-JtLog_Error -Where $This.ClassName -Text "Config not valid"
                Throw "Problem with config."
            }
        }
        return $MyArrayList
    }

    [Boolean]DoIt() {
        $This.DoLogRepoStart()
        [System.Collections.ArrayList]$MyArrayList = New-Object System.Collections.ArrayList
        
        [Xml]$MyConfigXml = $This.GetConfigXml()
        if ($Null -eq $MyConfigXml) {
            return $False
        }
        
        $MyArrayList = $This.GetAlItems()
        [Int]$MyIntCount = $MyArrayList.count
        Write-JtLog -Where $This.ClassName -Text "DoIt. Number of items. MyIntCount: $MyIntCount"
        foreach ($Item in $MyArrayList) {
            [String]$MyFilePath_Source = $Item.source
          
            [Int32]$MyDisk = $Item.disk
            [Int32]$MyPartition = $Item.partition
            [String]$MyComputer = $Item.computer
            [String]$MySystem = $Item.system
            [Boolean]$MyBlnSystem = $False
            if (("true").Equals($MySystem)) {
                $MyBlnSystem = $True
            }
                    
            Write-JtLog -Where $This.ClassName -Text "Recover. MyDisk: $MyDisk, MyPartition: $MyPartition, MyComputer: $MyComputer, MyFilePath_Source: $MyFilePath_Source"

            $MyParams = @{
                FilePath  = $MyFilePath_Source
                Disk      = $MyDisk
                Partition = $MyPartition
                Computer  = $MyComputer
                BlnSystem = $MyBlnSystem
            }
            New-JtSnap_Recover @MyParams
        }
        return $True
    }

    
    [String]GetConfigName() {
        return "JtInvRECOVER"
    }

    [String]GetReportLabel() {
        return "recover"
    }
}


class JtInvReportsCombine : JtInv {
    
    JtInvReportsCombine() : Base() {
        $This.ClassName = "JtInvReportsCombine"
    }

    
    [System.Collections.ArrayList]GetAlItems() {
        [System.Collections.ArrayList]$MyArrayList = New-Object System.Collections.ArrayList
        
        [Xml]$MyConfigXml = $This.GetConfigXml()
        if ($Null -eq $MyConfigXml) {
            return $MyArrayList
        }
        
        [String]$MyTagName = "combine"
        foreach ($Entity in $MyConfigXml.getElementsByTagName($MyTagName)) {
            $MyParams = @{
                source = $Entity.source
                target = $Entity.target
            }
            [HashTable]$MyItem = New-JtConfigItem @MyParams
    
            if ($MyItem.BlnValid) {
                $MyArrayList.Add($MyItem)
            }
            else {
                Write-JtLog_Error -Where $This.ClassName -Text "Config not valid. Problem with item."
                $MyItem
                Write-JtLog_Error -Where $This.ClassName -Text "Config not valid"
                Throw "Problem with config."
            }
        }
        return $MyArrayList
    }

    [Boolean]DoIt() {
        $This.DoLogRepoStart()
        [System.Collections.ArrayList]$MyArrayList = New-Object System.Collections.ArrayList
        
        [Xml]$MyConfigXml = $This.GetConfigXml()
        if ($Null -eq $MyConfigXml) {
            return $False
        }
        
        $MyArrayList = $This.GetAlItems()
        [Int]$MyIntCount = $MyArrayList.count
        Write-JtLog -Where $This.ClassName -Text "DoIt. Number of items. MyIntCount: $MyIntCount"
        foreach ($MyItem in $MyArrayList) {
            [JtIoFolder]$MyFolderPath_Input = New-JtIoFolder -FolderPath $MyItem.source
            Write-JtLog -Where $This.ClassName -Text "Source: $MyFolderPath_Input"
            [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyItem.target
            
            [JtIoFolder]$MyJtIoFolder_Base = $This.JtIoFolder_Base
            [String]$MyFilter = -Join ([JtIo]::FilePrefix_Selection, ".", "*", [JtIo]::FileExtension_Csv)
            [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder_Base -Filter $MyFilter
            if ($MyAlJtIoFiles.Count -gt 0) {
                ForEach ($File in $MyAlJtIoFiles) {
                    [JtIoFile]$MyJtIoFile = $File
                        
                    Write-JtLog -Where $This.ClassName -Text "MyJtIoFile: $MyJtIoFile"
                        
                    [String]$MyColumnName = "SystemId"
                        
                    [JtIoFileCsv]$MyJtIoFileCsv = New-JtIoFile_Csv -FilePath $MyJtIoFile.GetPath()

                    [System.Collections.ArrayList]$MyAlElements = $MyJtIoFileCsv.GetSelection($MyColumnName)
                    [String]$MyFilename_Selection = $MyJtIoFileCsv.GetName()
                    [String]$MyLabel_Selection = Convert-JtDotter -Text $MyFilename_Selection -PatternOut "2"
                    [JtCsvTool]$MyJtCsvTool = [JtCsvTool]::new($MyFolderPath_Input, $MyJtIoFolder_Output, $MyLabel_Selection, $MyAlElements)
                    $MyJtCsvTool.DoIt()
                }
            }
            else {
                Write-JtLog -Where $This.ClassName -Text "No selection files."
            }
        
            [JtCsvTool]$MyJtCsvTool = [JtCsvTool]::new($MyFolderPath_Input, $MyJtIoFolder_Output)
            $MyJtCsvTool.DoIt()
        }
        return $False
    }

    [String]GetConfigName() {
        return "JtInvReportsCombine"
    }

    [String]GetReportLabel() {
        return "combine"
    }
}

class JtInvReportsUpdate : JtInv {

    JtInvReportsUpdate() : Base() {
        $This.ClassName = "JtInvReportsUpdate"
        $This.DoIt()
    }

    [System.Collections.ArrayList]GetAlItems() {
        [System.Collections.ArrayList]$MyArrayList = New-Object System.Collections.ArrayList
        
        [Xml]$MyConfigXml = $This.GetConfigXml()
        if ($Null -eq $MyConfigXml) {
            return $MyArrayList
        }
        
        [String]$MyTagName = "reports"
        foreach ($Entity in $MyConfigXml.getElementsByTagName($MyTagName)) {
            $MyParams = @{
                source = $Entity.source
            }
            [HashTable]$MyItem = New-JtConfigItem @MyParams
    
            if ($MyItem.BlnValid) {
                $MyArrayList.Add($MyItem)
            }
            else {
                Write-JtLog_Error -Where $This.ClassName -Text "Config not valid. Problem with item."
                $MyItem
                Write-JtLog_Error -Where $This.ClassName -Text "Config not valid"
                Throw "Problem with config."
            }
        }
        return $MyArrayList
    }

    [Boolean]DoIt() {
        $This.DoLogRepoStart()
        [System.Collections.ArrayList]$MyArrayList = New-Object System.Collections.ArrayList
        
        [Xml]$MyConfigXml = $This.GetConfigXml()
        if ($Null -eq $MyConfigXml) {
            return $False
        }
        
        $MyArrayList = $This.GetAlItems()
        [Int]$MyIntCount = $MyArrayList.count
        Write-JtLog -Where $This.ClassName -Text "DoIt. Number of items. MyIntCount: $MyIntCount"
        foreach ($Item in $MyArrayList) {
            [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $Item.source

            $MyAlJtIoSubfolders = $MyJtIoFolder_Input.GetAlJtIoFolders_Sub()
            foreach ($Folder in $MyAlJtIoSubfolders) {
                [JtIoFolder]$MyJtIoFolder_Report = $Folder
                Write-JtLog -Where $This.ClassName -Text "DoIt for report. MyJtIoFolder_Report: $MyJtIoFolder_Report"
                New-JtCsvGenerator -FolderPath_Input $MyJtIoFolder_Report -FolderPath_Output $MyJtIoFolder_Report -Label $This.ClassName
            }
        }
        return $True
    }

    [String]GetConfigName() {
        return "JtInvReportsUpdate"
    }
  
    [String]GetReportLabel() {
        return "reports"
    }
}



class JtInvSnapshot : JtInv {

    JtInvSnapshot() : Base() {
        $This.ClassName = "JtInvSnapshot"
    }

    [System.Collections.ArrayList]GetAlItems() {
        [System.Collections.ArrayList]$MyArrayList = New-Object System.Collections.ArrayList
        
        [Xml]$MyConfigXml = $This.GetConfigXml()
        if ($Null -eq $MyConfigXml) {
            return $MyArrayList
        }
        
        [String]$MyTagName = "snapshot"
        foreach ($Entity in $MyConfigXml.getElementsByTagName($MyTagName)) {
            $MyParams = @{
                disk      = $Entity.disk
                partition = $Entity.partition
                target    = $Entity.target
            }
            [HashTable]$MyItem = New-JtConfigItem @MyParams
    
            if ($MyItem.BlnValid) {
                $MyArrayList.Add($MyItem)
            }
            else {
                Write-JtLog_Error -Where $This.ClassName -Text "Config not valid. Problem with item."
                $MyItem
                Write-JtLog_Error -Where $This.ClassName -Text "Config not valid"
                Throw "Problem with config."
            }
        }
        return $MyArrayList
    }

    [Boolean]DoIt() {
        $This.DoLogRepoStart()
        [System.Collections.ArrayList]$MyArrayList = New-Object System.Collections.ArrayList
        
        [Xml]$MyConfigXml = $This.GetConfigXml()
        if ($Null -eq $MyConfigXml) {
            return $False
        }
        
        $MyArrayList = $This.GetAlItems()
        [Int]$MyIntCount = $MyArrayList.count
        Write-JtLog -Where $This.ClassName -Text "DoIt. Number of items. MyIntCount: $MyIntCount"
        foreach ($Item in $MyArrayList) {

            [Int32]$MyDisk = $Item.disk
            [Int32]$MyPartition = $Item.partition
            [String]$MyFolderPath_Output = $Item.target

            Write-JtLog -Where $This.ClassName -Text "Creating snapshot. MyDisk: $MyDisk, MyPartition: $MyPartition, MyFolderPath_Output: $MyFolderPath_Output"
            $MyParams = @{
                FolderPath_Output = $MyFolderPath_Output
                Disk              = $MyDisk
                Partition         = $MyPartition
            }
            New-JtSnap_Partition @MyParams
        }
        return $True
    }



    [String]GetConfigName() {
        return "JtInvSNAPSHOT"
    }

    [String]GetReportLabel() {
        return "Snapshot"
    }
}


class JtInvWol : JtInv {

    [String]$FilePath_Wol_Exe = "C:\apps\al\archland\tasks\_wol\wol.exe"

    JtInvWol() : Base() {
        $This.ClassName = "JtInvWol"
        # Output goes directly to "c:\_inventory\report"
    }
    
    [Boolean]DoWol($TheName, $TheMac) {
        [String]$MyCommand = ""
        $MyCommand = -join ($This.FilePath_Wol_Exe, ' ', $TheMac)
        Write-JtLog -Where $This.ClassName -Text "Trying to wake device $TheName with MAC:  $TheMac ..."
        Invoke-Expression -Command:$MyCommand

        return $True
    }

    [Boolean]DoIt() {
        $This.DoLogRepoStart()
        [System.Collections.ArrayList]$MyArrayList = New-Object System.Collections.ArrayList
        
        [Xml]$MyConfigXml = $This.GetConfigXml()
        if ($Null -eq $MyConfigXml) {
            return $False
        }

        [String]$MyTagName = "wol"
        foreach ($Entity in $MyConfigXml.getElementsByTagName($MyTagName)) {
            [HashTable]$MyItem = New-Object HashTable

            $MyItem.device = $entity.'#text'
            if ($Null -eq $MyItem.device) {
                Write-JtLog_Error -Where $This.ClassName -Text "Error!!! device is NULL. device: $MyItem.device"
                return $False
            }
            if ($MyItem.device.length -lt 1) {
                Write-JtLog_Error -Where $This.ClassName -Text "Error!!! device is "". device: $MyItem.device"
                return $False
            }
        }
        foreach ($MyItem in $MyArrayList) {

            $MyItem.name = $entity.name
            $MyItem.mac = $entity.mac
            $MyItem.ip = $entity.ip

            Write-JtLog -Where $This.ClassName -Text "Name: $MyItem.name, Mac: $MyItem.mac, IP: $MyItem.ip, ... DEVICE: $MyItem.device"
            $This.DoWol($MyItem.Name, $MyItem.Mac)
        }
        return $True
    }
 

    [String]GetConfigName() {
        return "JtInvWOL"
    }

    [String]GetReportLabel() {
        return "wol"
    }
}



class FileElementXml : JtClass {

    hidden [xml]$Xml = $Null
    
    FileElementXml([JtIoFile]$TheJtIoFile) {
        [String]$MyFilePath_Xml = $TheJtIoFile.GetPath()
        [xml]$This.Xml = Get-Content $MyFilePath_Xml -Encoding UTF8
    } 

    [String]GetValuePath() {
        [String]$MyTagName = "path"
        [String]$MyPath = ""
        [xml]$MyXmlContent = $This.GetXml()
        ForEach ($Entity in $MyXmlContent.getElementsByTagName($MyTagName)) {
            [String]$MyPath = $Entity.'#text'
            $MyPath = Convert-JtEnvironmentVariables -Text $MyPath
            return $MyPath
        }
        return $MyPath
    }

    [System.Collections.ArrayList]GetValueListPaths() {
        [System.Collections.ArrayList]$MyAl = [System.Collections.ArrayList]::new()
        [String]$MyTagName = "path"
        [String]$MyPath = ""
        [Xml]$MyXmlContent = $This.GetXml()
        ForEach ($entity in $MyXmlContent.getElementsByTagName($MyTagName)) {
            [String]$MyPath = $entity.'#text'
                
            $MyPath = Convert-JtEnvironmentVariables -Text $MyPath
            $MyAl.Add($MyPath)
        }
        return $MyAl
    }


    [Xml]GetXml() {
        return $This.Xml
    } 
} 



# https://github.com/ThePoShWolf/Utilities/blob/master/Misc/Get-JtInstalledSoftware.ps1
<#
.SYNOPSIS
	Get-JtInstalledSoftware retrieves a list of installed software
.DESCRIPTION
	Get-JtInstalledSoftware opens up the specified (remote) registry and scours it for installed software. When found it returns a list of the software and it's version.
.PARAMETER ComputerName
	The computer from which you want to get a list of installed software. Defaults to the local host.
.EXAMPLE
	Get-JtInstalledSoftware DC1
	
	This will return a list of software from DC1. Like:
	Name			Version		Computer  UninstallCommand
	----			-------     --------  ----------------
	7-Zip 			9.20.00.0	DC1       MsiExec.exe /I{23170F69-40C1-2702-0920-000001000000}
	Google Chrome	65.119.95	DC1       MsiExec.exe /X{6B50D4E7-A873-3102-A1F9-CD5B17976208}
	Opera			12.16		DC1		  "C:\Program Files (x86)\Opera\Opera.exe" /uninstall
.EXAMPLE
	Import-Module ActiveDirectory
	Get-ADComputer -filter 'name -like "DC*"' | Get-JtInstalledSoftware
	
	This will get a list of installed software on every AD computer that matches the AD filter (So all computers with names starting with DC)
.INPUTS
	[string[]]Computername
.OUTPUTS
	PSObject with properties: Name,Version,Computer,UninstallCommand
.NOTES
	Author: ThePoShWolf
	
	To add registry directories, add to the lmKeys (LocalMachine)
.LINK
	[Microsoft.Win32.RegistryHive]
    [Microsoft.Win32.RegistryKey]
    https://github.com/theposhwolf/utilities
#>


Function Get-JtInstalledSoftware {
    Param(
        [Alias('Computer', 'ComputerName', 'HostName')]
        [Parameter(ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True, Mandatory = $True, Position = 1)]
        [String[]]$Name
    )
    Begin {
        [String]$MyFunctionName = "Get-JtInstalledSoftware"

        if (!($Name)) {
            $Name = $env:COMPUTERNAME
        }
        $lmKeys = "Software\Microsoft\Windows\CurrentVersion\Uninstall", "SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
        $lmReg = [Microsoft.Win32.RegistryHive]::LocalMachine
        $cuKeys = "Software\Microsoft\Windows\CurrentVersion\Uninstall"
        $cuReg = [Microsoft.Win32.RegistryHive]::CurrentUser
    }
    Process {
        if (!(Test-Connection -ComputerName $Name -count 1 -quiet)) {
            Write-JtLog_Error -Where $MyFunctionName -Text "Unable to contact $Name. Please verify its network connectivity and try again." -Category ObjectNotFound -TargetObject $Computer
            Break
        }
        $masterKeys = @()
        $remoteCURegKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($cuReg, $Name)
        $remoteLMRegKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($lmReg, $Name)
        foreach ($key in $lmKeys) {
            $regKey = $remoteLMRegKey.OpenSubkey($key)
            foreach ($subName in $regKey.GetSubkeyNames()) {
                foreach ($sub in $regKey.OpenSubkey($subName)) {
                    $masterKeys += (New-Object PSObject -Property @{
                            "ComputerName"     = $Name
                            "Name"             = $sub.GetValue("displayname")
                            "SystemComponent"  = $sub.GetValue("systemcomponent")
                            "ParentKeyName"    = $sub.GetValue("parentkeyname")
                            "Version"          = $sub.GetValue("DisplayVersion")
                            "UninstallCommand" = $sub.GetValue("UninstallString")
                            "InstallDate"      = $sub.GetValue("InstallDate")
                            "RegPath"          = $sub.ToString()
                        })
                }
            }
        }
        foreach ($key in $cuKeys) {
            $regKey = $remoteCURegKey.OpenSubkey($key)
            if ($Null -ne $regKey) {
                foreach ($subName in $regKey.getsubkeynames()) {
                    foreach ($sub in $regKey.opensubkey($subName)) {
                        $masterKeys += (New-Object PSObject -Property @{
                                "ComputerName"     = $Computer
                                "Name"             = $sub.GetValue("displayname")
                                "SystemComponent"  = $sub.GetValue("systemcomponent")
                                "ParentKeyName"    = $sub.GetValue("parentkeyname")
                                "Version"          = $sub.GetValue("DisplayVersion")
                                "UninstallCommand" = $sub.GetValue("UninstallString")
                                "InstallDate"      = $sub.GetValue("InstallDate")
                                "RegPath"          = $sub.ToString()
                            })
                    }
                }
            }
        }
        $woFilter = { $null -ne $_.name -AND $_.SystemComponent -ne "1" -AND $null -eq $_.ParentKeyName }
        $props = 'Name', 'Version', 'ComputerName', 'Installdate', 'UninstallCommand', 'RegPath'
        $masterKeys = ($masterKeys | Where-Object $woFilter | Select-Object $props | Sort-Object Name)
        $masterKeys
    }
    End { }
}


Function Get-JtXmlReportObject {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Name
    )

    [String]$MyFunctionName = "Get-JtXmlReportObject"

    [String]$MyFolderPath = $FolderPath
    [String]$MyName = $Name
    if (!(Test-JtIoFolderPath -FolderPath $MyFolderPath)) {
        Write-JtLog_Error -Where $MyFunctionName -Text "MyName: $MyName - Folder is missing."
        return $Null
    }
    [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $MyFolderPath

    Write-JtLog -Where $MyFunctionName -Text "MyJtIoFolder: $MyJtIoFolder - MyName: $MyName"
    
    [JtIoFolder]$MyJtIoFolder_Xml = $MyJtIoFolder.GetJtIoFolder_Sub("objects")
    if (!($MyJtIoFolder_Xml.IsExisting())) {
        Write-JtLog_Error -Where $MyFunctionName -Text "MyName: $MyName - Folder is missing. MyJtIoFolder_Xml: $MyJtIoFolder_Xml"
        return $Null
    }
    
    [String]$MyExtension = [JtIo]::FileExtension_Xml
    [String]$MyFilename_Xml = -Join ($MyName, $MyExtension)
    [String]$MyFilePath_Xml = $MyJtIoFolder_Xml.GetFilePath($MyFilename_Xml)
    
    Write-JtLog -Where $MyFunctionName -Text "MyName: $MyName - MyFilePath_Xml: $MyFilePath_Xml"
    if (!(Test-JtIoFilePath -FilePath $MyFilePath_Xml)) {
        Write-JtLog_Error -Where $MyFunctionName -Text "MyName: $MyName - Xml file is missing. MyFilePath_Xml: $MyFilePath_Xml"
        return $Null
    }
    [System.Object]$MyObject = $Null
    try {
        $MyObject = Import-Clixml $MyFilePath_Xml
    }
    catch {
        Write-JtLog_Error -Where $MyFunctionName -Text "MyName: $MyName - Problem while reading MyFilePath_Xml: $MyFilePath_Xml"
        return $Null
    }
    return [System.Object]$MyObject
}




Function New-JtConfigItem {

    Param (
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Computer,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Disk,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Filter,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Label,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Partition,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Passwd,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Path,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Pattern,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Source,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Share,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$System,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Target,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Template,
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Username
    )

    [String]$MyFunctionName = "New-JtConfigItem"

    [HashTable]$MyItem = New-Object HashTable
    $MyItem.BlnValid = $True

    if ($Source) {
        [String]$MySource = $Source
        $MyItem.source = $MySource
        if (!(Test-JtIoFolderPath -FolderPath $MyItem.source)) {
            Write-JtLog_Error -Where $MyFunctionName -Text "Error!!! Folder missing. MySource: $MySource"
            $MyItem.BlnValid = $False
            return $MyItem
        }
    }

    
    if ($Target) {
        [String]$MyTarget = $target
        $MyItem.target = $MyTarget
        [String]$MyFolderPath_Target = $MyTarget
        [JtIoFolder]$MyJtIoFolder_Output = New-JtIoFolder -FolderPath $MyFolderPath_Target -Force
        if (!($MyJtIoFolder_Output.IsExisting())) {
            Write-JtLog_Error -Where $MyFunctionName -Text "Error!!! Folder missing. MyTarget: $MyTarget"
            $MyItem.BlnValid = $False
            return $MyItem
        }
    }

    if ($computer) {
        $MyItem.computer = $computer
        if ($computer.length -lt 1) {
            Write-JtLog_Error -Where $MyFunctionName -Text "Error!!! COMPUTER is empty."
            $MyItem.BlnValid = $False
            return $MyItem
        }
    }

    if ($disk) {
        $MyItem.disk = $disk
        if ($disk.length -lt 1) {
            Write-JtLog_Error -Where $MyFunctionName -Text "Error!!! DISK is empty."
            $MyItem.BlnValid = $False
            return $MyItem
        }
    }

    if ($filter) {
        $MyItem.filter = $filter
        if ($filter.length -lt 1) {
            Write-JtLog_Error -Where $MyFunctionName -Text "Error!!! FILTER is EMPTY."
            $MyItem.BlnValid = $False
            return $MyItem
        }
    }

    if ($label) {
        $MyItem.label = $label
        if ($label.length -lt 1) {
            Write-JtLog_Error -Where $MyFunctionName -Text "Error!!! LABEL is EMPTY."
            $MyItem.BlnValid = $False
            return $MyItem
        }
    }

    if ($partition) {
        $MyItem.partition = $partition
        if ($partition.length -lt 1) {
            Write-JtLog_Error -Where $MyFunctionName -Text "Error!!! PARTITION is empty."
            $MyItem.BlnValid = $False
            return $MyItem
        }
    }

    if ($passwd) {
        $MyItem.passwd = $passwd
        if ($passwd.length -lt 1) {
            Write-JtLog_Error -Where $MyFunctionName -Text "Error!!! PASSWD is empty."
            $MyItem.BlnValid = $False
            return $MyItem
        }
    }

    if ($path) {
        $MyItem.path = $path
        if ($path.length -lt 1) {
            Write-JtLog_Error -Where $MyFunctionName -Text "Error!!! PATH is empty."
            $MyItem.BlnValid = $False
            return $MyItem
        }
    }

    if ($pattern) {
        $MyItem.pattern = $pattern
        if ($pattern.length -lt 1) {
            Write-JtLog_Error -Where $MyFunctionName -Text "Error!!! PATTERN is empty."
            $MyItem.BlnValid = $False
            return $MyItem
        }
    }

    if ($share) {
        $MyItem.share = $share
        if ($share.length -lt 1) {
            Write-JtLog_Error -Where $MyFunctionName -Text "Error!!! SHARE is empty."
            $MyItem.BlnValid = $False
            return $MyItem
        }
    }

    if ($system) {
        $MyItem.system = $system
        if ($system.length -lt 1) {
            Write-JtLog_Error -Where $MyFunctionName -Text "Error!!! SYSTEM is empty."
            $MyItem.BlnValid = $False
            return $MyItem
        }
    }

    if ($template) {
        $MyItem.template = $template
        if ($template.length -lt 1) {
            Write-JtLog_Error -Where $MyFunctionName -Text "Error!!! TEMPLATE is empty."
            $MyItem.BlnValid = $False
            return $MyItem
        }
    }

    if ($username) {
        $MyItem.username = $username
        if ($username.length -lt 1) {
            Write-JtLog_Error -Where $MyFunctionName -Text "Error!!! USERNAME is empty."
            $MyItem.BlnValid = $False
            return $MyItem
        }
    }

    return $MyItem
}




Function New-JtInvClient {

    New-JtInvClientClean
    New-JtInvClientReport
    New-JtInvClientObjects
    New-JtInvClientSoftware
    New-JtInvClientCsvs
    New-JtInvClientExport
    
    New-JtInvClientTimestamp  -Label "client"
}


Function New-JtInvClientChoco {

    [JtInvClientChoco]::new()
}


Function New-JtInvClientClean {

    [JtInvClientClean]::new()

    New-JtInvClientTimestamp  -Label "clean"
}


Function New-JtInvClientConfig {

    [JtInvClientConfig]::new()

    New-JtInvClientTimestamp  -Label "config"
}


Function New-JtInvClientCsvs {

    [JtInvClientCsvs]::new()

    New-JtInvClientTimestamp  -Label "csv"
}


Function New-JtInvClientErrors {


    [JtInvClientErrors]::new()

    New-JtInvClientTimestamp  -Label "errors"
}


Function New-JtInvClientExport {


    [JtInvClientExport]::new()
    
    New-JtInvClientTimestamp  -Label "export"
}


Function New-JtInvClientObjects {


    [JtInvClientObjects]::new()

    New-JtInvClientTimestamp  -Label "objects"
}



Function New-JtInvClientReport {

    [JtInvClientReport]::new()

    New-JtInvClientTimestamp  -Label "report"
}


Function New-JtInvClientSoftware {


    [JtInvClientSoftware]::new()
    
    New-JtInvClientTimestamp  -Label "software"
}


Function New-JtInvClientTimestamp {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Label
    )

    [String]$MyLabel = $Label


    [JtInvClientTimestamp]::new($MyLabel)
}



Function New-JtInvData {


    [JtInvData]::new()
    
    # New-JtInvClientTimestamp -Label "data"
}

Function New-JtInvDeploy {


    [JtInvDeploy]::new()
    
    # New-JtInvClientTimestamp  -Label "mirror"
}



Function New-JtInvFiles {


    [JtInvFiles]::new()

    # New-JtInvClientTimestamp  -Label "files"
}




Function New-JtInvFolder {

    [JtInvFolder]::new()

    # New-JtInvClientTimestamp  -Label "folder"

}


Function New-JtInvLengths {


    [JtInvLengths]::new()
    
    # New-JtInvClientTimestamp -Label "lengths"
}


Function New-JtInvLines {


    [JtInvLines]::new()
    
    # New-JtInvClientTimestamp  -Label "lines"

}


Function New-JtInvMd {


    [JtInvMd]::new()
    
    # New-JtInvClientTimestamp  -Label "JtMd"
}


Function New-JtInvMirror {


    [JtInvMirror]::new()
    
    # New-JtInvClientTimestamp  -Label "mirror"
}


Function New-JtInvPoster {


    [JtInvPoster]::new()

    # New-JtInvClientTimestamp  -Label "poster"
}


Function New-JtInvRecover {


    [JtInvRecover]::new()

    # New-JtInvClientTimestamp  -Label "recover"
}



Function New-JtInvReportsCombine {

    [JtInvReportsCombine]::new()
}


Function New-JtInvReportsUpdate {

    [JtInvReportsUpdate]::new()

}



Function New-JtInvSnapshot {
    [JtInvSnapshot]::new()
    
    # New-JtInvClientTimestamp  -Label "Snapshot"
}



Function New-JtInvWol {

    [JtInvWol]::new()

    # New-JtInvClientTimestamp  -Label "wol"
}



Function New-JtCommonVersion {
    New-JtRobocopy -FolderPath_Input "%OneDrive%\0.INVENTORY\common" -FolderPath_Output "D:\Seafile\al-apps\apps\inventory\common"

    Write-JtIoFile_Meta_Version -FolderPath_Output "%OneDrive%\0.INVENTORY\common"
}









Export-ModuleMember -Function Get-JtInstalledSoftware
Export-ModuleMember -Function Get-JtXmlReportObject

Export-ModuleMember -Function New-JtConfigItem

Export-ModuleMember -Function New-JtInvClient
Export-ModuleMember -Function New-JtInvClientChoco 
Export-ModuleMember -Function New-JtInvClientClean
Export-ModuleMember -Function New-JtInvClientConfig
Export-ModuleMember -Function New-JtInvClientCsvs
Export-ModuleMember -Function New-JtInvClientErrors
Export-ModuleMember -Function New-JtInvClientExport
Export-ModuleMember -Function New-JtInvClientObjects
Export-ModuleMember -Function New-JtInvClientReport
Export-ModuleMember -Function New-JtInvClientSoftware
Export-ModuleMember -Function New-JtInvClientTimestamp
Export-ModuleMember -Function New-JtInvReportsCombine
Export-ModuleMember -Function New-JtInvReportsUpdate
Export-ModuleMember -Function New-JtInvData
Export-ModuleMember -Function New-JtInvDeploy
Export-ModuleMember -Function New-JtInvFiles
Export-ModuleMember -Function New-JtInvFolder
Export-ModuleMember -Function New-JtInvLengths
Export-ModuleMember -Function New-JtInvLines
Export-ModuleMember -Function New-JtInvMd
Export-ModuleMember -Function New-JtInvMirror
Export-ModuleMember -Function New-JtInvPoster
Export-ModuleMember -Function New-JtInvRecover
Export-ModuleMember -Function New-JtInvSnapshot
Export-ModuleMember -Function New-JtInvWol
Export-ModuleMember -Function New-JtCommonVersion