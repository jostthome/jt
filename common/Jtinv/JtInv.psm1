using module JtClass
using module JtConfig
using module JtIo
using module JtTbl
using module JtUtil
using module JtCsvGenerator
using module JtCsv
using module JtFolderRenderer
using module JtTemplateFile
using module JtMd
using module JtSnapshot
using module JtFacFolderRen
using module JtPreisliste
using module JtTool

class JtInv : JtClass {

    [JtIoFolder]$FolderBase 
    [String]$SystemId = ""


    JtInv([JtConfig]$JtConfig) {
        $This.ClassName = "Report"
        $This.FolderBase = $JtConfig.Get_JtIoFolder_Base()
        $This.DoLogRepoStart()
        $This.DoIt()
    }
    
    DoLogRepoInit() {
        Write-JtLog -Text ( -join ("Init ", $This.ClassName, " REPORT: ", $This.GetReportLabel()))
    }

    DoLogRepoStart() {
        Write-JtLog -Text ( -join ("Starting in ", $This.ClassName, " REPORT: ", $This.GetReportLabel()))
    }

    [JtIoFolder]Get_JtIoFolder_Report() {
        [JtIoFolder]$JtIoFolderReport = New-JtIoFolderReport
        return $JtIoFolderReport
    }

    [String]GetConfigName() {
        Write-JtError -Text ("Function GetConfigName should be overwritten!!!")
        Throw("Function GetConfigName should be overwritten!!!")
        return ""
    }

    [JtIoFolder]GetFolderTarget() {
        [JtIoFolder]$Result = $This.Get_JtIoFolder_Report()
        if ($This.GetReportLabel().Length -gt 0) {
            $Result = $Result.GetSubfolder($This.GetReportLabel(), $True)
        }
        return $Result
    }

    [String]GetReportLabel() {
        Throw "GetReportLabel should be overwritten!!!"
        return "GetReportLabel is not defined!"
    }


    [Xml]GetConfigXml() {
        [String]$MyConfigName = $This.GetConfigName()
        Write-JtLog ( -Join ("IN:", $This.ClassName, "GetConfigXml; FolderBase:", $This.FolderBase.GetPath(), " Config:", $This.GetConfigName()))        
        if ($MyConfigName.Length -lt 1) {
            Write-JtError -Text ("ConfigFolderName not set!")
            Throw "This should not happen."
        }

        [String]$FilePathXml =        
        $FilePathXml = -join ($This.FolderBase.GetPath(), "\", $MyConfigName, ".xml")
        [JtIoFile]$JtIoFile = New-JtIoFile -Path $FilePathXml
        if ($JtIoFile.IsExisting()) {
            [FileElementXml]$FileElementXml = [FileElementXml]::new($JtIoFile)

            [Xml]$XmlContent = $FileElementXml.GetXml()
            return $XmlContent
        }
        else {
            return $Null
        }
    }

    [boolean]DoIt() {
        Throw "Report. The method DoIt should be overwritten."
        return $False
    }
}


function New-JtInvClient {

    Param (
        [Parameter(Mandatory = $false)]
        [JtConfig]$JtConfig
    )
    
    [JtConfig]$JtConfig = New-JtConfig
    [JtInvClientObjects]::new([JtConfig]$JtConfig) 
    [JtInvClientSoftware]::new([JtConfig]$JtConfig) 
    [JtInvClientReport]::new([JtConfig]$JtConfig) 
    [JtInvClientCsvs]::new([JtConfig]$JtConfig) 
    [JtInvClientExport]::new([JtConfig]$JtConfig) 
    New-JtInvTimestamp -JtConfig $JtConfig -Label "report"
}




class JtInvClientChoco : JtInv {

    JtInvClientChoco([JtConfig]$JtConfig) : Base($JtConfig) {
        $This.ClassName = "JtInvClientChoco"
        # Output goes directly to "c:\_inventory\report"
        [JtIoFolder]$This.Source = New-JtIoFolderReport
        [JtIoFolder]$This.Target = $This.Source.GetSubfolder("choco", $True)
    }

    [boolean] DoIt() {
        $This.DoLogRepoStart()

        [String]$MyCommand = ""
        [String]$Label = "choco"
        [String]$Filename = -join ([JtIo]::JtInvPrefix_Report, '.', $Label, [JtIo]::FilenameExtension_Meta)
        [String]$Out = $This.Get_JtIoFolder_Report().GetFilePath($Filename)
        if ($env:ChocolateyInstall -eq "c:\ProgramData\chocolatey" ) {
            $MyCommand = -join ('cmd.exe /C ', '"', 'choco list -li', '"', ' > ', '"', $Out, '"')
            Invoke-Expression -Command:$MyCommand  
        }
        else {
            $MyCommand = -join ('cmd.exe /C ', '"', 'echo choco is not installed', '"', ' > ', '"', $Out, '"')
            Invoke-Expression -Command:$MyCommand  
        }
        return $true
    }
 
    [String]GetConfigName() {
        return ""
    }

    [String]GetReportLabel() {
        return "choco"
    }
}

function New-JtInvClientChoco {

    Param (
        [Parameter(Mandatory = $false)]
        [JtConfig]$JtConfig
    )

    [JtInvClientChoco]::new([JtConfig]$JtConfig) 
}


class JtInvClientClean : JtInv {

    [JtIoFolder]$FolderReport

    JtInvClientClean([JtConfig]$JtConfig) : Base($JtConfig) {
        $This.ClassName = "JtInvClientClean"
        $This.FolderReport = New-JtIoFolderReport
    }

    [Boolean]DoIt() {
        $This.DoLogRepoStart()

        If ($This.FolderReport.IsExisting()) {
            if ($This.FolderReport.GetPath() -eq [JtLog]::C_inventory_Report) {
                $This.FolderReport.DoDeleteEverything()
                Write-JtLog -Text ("# LOG Starting client...")
            }
            else {
                [String]$ErrorMsg = -join ("This should not happen. Illegal path for local report. Should be: ", [JtUtil]::C_inventory_Report)
                Write-JtError -Text ($ErrorMsg)
                Throw $ErrorMsg
            }
            return $True  
        }
        else {
            Throw "This should not happen. c:\_inventory\report is missing."
            return $False
        }
    }
    
    [String]GetConfigName() {
        return ""
    }
    
    [String]GetReportLabel() {
        return "clean"
    }
}


Function New-JtInvClientClean {
    
    Param (
        [Parameter(Mandatory = $false)]
        [JtConfig]$JtConfig
        )

        [JtConfig]$JtConfig = New-JtConfig
        [JtInvClientClean]::new([JtConfig]$JtConfig) 

    New-JtInvTimestamp -JtConfig $JtConfig -Label "clean"
}



class JtInvClientConfig : JtInv {

    [String]$Out = ""
    [String]$XmlFiles = ""

    JtInvClientConfig([JtConfig]$JtConfig) : Base($JtConfig) {
        $This.ClassName = "JtInvClientConfig"
        $JtConfig.DoPrintInfo()
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

function New-JtInvClientConfig {

    Param (
        [Parameter(Mandatory = $false)]
        [JtConfig]$JtConfig
    )

    [JtConfig]$JtConfig = New-JtConfig
    [JtInvClientConfig]::new([JtConfig]$JtConfig) 

    New-JtInvTimestamp -JtConfig $JtConfig -Label "config"
}

class JtInvClientCsvs : JtInv {

    JtInvClientCsvs([JtConfig]$JtConfig) : Base($JtConfig) {
        $This.ClassName = "JtInvClientCsvs"
        # output goes directly to c:\_inventory\report
    }

    [boolean]DoIt() {
        $This.DoLogRepoStart()

        New-JtCsvGenerator -JtIoFolder $This.Get_JtIoFolder_Report() -Label $This.ClassName

        return $True
    }

    [String]GetConfigName() {
        return ""
    }

    [String]GetReportLabel() {
        return "csv"
    }
}

function New-JtInvClientCsvs {

    Param (
        [Parameter(Mandatory = $false)]
        [JtConfig]$JtConfig
    )
    
    [JtConfig]$JtConfig = New-JtConfig
    [JtInvClientCsvs]::new([JtConfig]$JtConfig) 

    New-JtInvTimestamp -JtConfig $JtConfig -Label "csv"
}


class JtInvClientErrors : JtInv {

    JtInvClientErrors([JtConfig]$JtConfig) : Base($JtConfig) {
        $This.ClassName = "JtInvClientErrors"
        # Output goes directly to c:\_inventory\report
    }


    [Boolean]DoCleanErrorFiles() {
        [String]$MyFilter = -join ("*", [JtIo]::JtInvSuffix_Errors, [JtIo]::FilenameExtension_Meta)
        $This.Get_JtIoFolder_Report().DoDeleteAllFiles($MyFilter)

        return $true
    }

    [boolean]DoIt() {
        $This.DoLogRepoStart()

        $This.DoCleanErrorFiles()

        [String]$Content = [JtLog]::CounterError
        [String]$FileLabel = -join ([JtIo]::JtInvPrefix_Report, ".", $Content, ".", [JtIo]::JtInvSuffix_Errors)
        [String]$OutputFilePath = $This.GetFolderTarget().GetPath()

        New-JtIoFileMeta -Path $OutputFilePath -Label $FileLabel -Content $Content

        return $true
    }

    [String]GetConfigName() {
        return ""
    }

    [String]GetReportLabel() {
        return "errors"
    }
}


function New-JtInvClientErrors {

    Param (
        [Parameter(Mandatory = $false)]
        [JtConfig]$JtConfig
    )

    [JtConfig]$JtConfig = New-JtConfig
    [JtInvClientErrors]::new([JtConfig]$JtConfig) 

    New-JtInvTimestamp -JtConfig $JtConfig -Label "errors"
}


class JtInvClientExport  : JtInv {


    JtInvClientExport ([JtConfig]$JtConfig) : Base($JtConfig) {
        $This.ClassName = "JtInvJtSnapshot"
    }

    [Boolean]DoIt() {
        $This.DoLogRepoStart()

        [Xml]$ConfigXml = $This.GetConfigXml()

        if ($Null -eq $ConfigXml) {
            return $False
        }
        foreach ($entity in $ConfigXml.getElementsByTagName("folder")) {
            # [String]$JtInfo = $entity.'#text'

            [JtIoFolder]$FolderExport = $Null
            [String]$Target = $Entity.target
            $Target = ConvertTo-JtExpandedPath $Target
            if ($Target.Length -gt 0) {
                [JtIoFolder]$FolderExport = [JtIoFolder]::new($Target)
            }
            else {
                [JtIoFolder]$FolderExport = $This.GetFolderTarget()
            }
            Write-JtLog -Text ( -join ("... Exporting results to:", $FolderExport.GetPath()))

        
            If ($False -eq $FolderExport.IsExisting()) {
                Write-JtError -Text ( -join ("Path is missing; MyTarget:", $FolderExport.GetPath()))
                return $False
            } 

            [String]$SystemId = [JtIo]::GetSystemId()
            [JtIoFolder]$JtIoFolderTargetSys = $FolderExport.GetSubfolder($SystemId, $True)
        
            [String]$MyInfo = ( -join ("DoExport in ", $This.ClassName))
            New-JtRobocopyIo -IoSource $This.Get_JtIoFolder_Report() -IoTarget $JtIoFolderTargetSys -Info $MyInfo
            return $True
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


function New-JtInvClientExport  {

    Param (
        [Parameter(Mandatory = $false)]
        [JtConfig]$JtConfig
    )

    [JtConfig]$JtConfig = New-JtConfig
    [JtInvClientExport ]::new([JtConfig]$JtConfig) 
    New-JtInvTimestamp -JtConfig $JtConfig -Label "JtExport"
}


class JtInvClientObjects : JtInv {

    JtInvClientObjects([JtConfig]$JtConfig) : Base($JtConfig) {
        $This.ClassName = "JtInvClientObjects"
        # output goes directly to c:\_inventory\report
    }

    hidden [boolean]DoWriteObjectToXml([String]$Label, $JtObject) {
        $MyClass = $Label
        $MyObject = $JtObject
        [String]$XmlFilename = -join ($MyClass.ToLower(), [JtIo]::FilenameExtension_Xml)

        $FilePathXml = $This.GetFolderTarget().GetFilePath($XmlFilename)
        Write-JtIo -Text ( -join ("Writing: ", $Label, " in FilePathXml:", $FilePathXml))
        Export-Clixml -InputObject  $MyObject -Path $FilePathXml
        return $True
    }


    [boolean]DoIt() {
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
        [String]$CsvLabel = $MyClass.ToLower()
        [String]$FilenameXml = -join ($CsvLabel, ".xml")
        $FilePathXml = $This.GetFolderTarget().GetFilePath($FilenameXml)    
        try {
            $MyObject = Get-BitLockerVolume

            $MyObject | Sort-Object -Property MountPoint | Format-Table -Property * 
        
            New-JtCsvWriteArraylist -Label $CsvLabel -JtIoFolder $This.GetFolderTarget() -ArrayList $MyObject

            $This.DoWriteObjectToXml($MyClass, $MyObject)
            Export-Clixml -InputObject $MyObject -Path $FilePathXml
        }
        catch {
            Write-JtError -Text ("Problems with: BitLockerVolume -> Need admin rights...?")
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

function New-JtInvClientObjects {

    Param (
        [Parameter(Mandatory = $false)]
        [JtConfig]$JtConfig
    )

    [JtConfig]$JtConfig = New-JtConfig
    [JtInvClientObjects]::new([JtConfig]$JtConfig) 

    New-JtInvTimestamp -JtConfig $JtConfig -Label "objects"
}

class JtInvClientReport : JtInv {
    
    [JtIoFolder]$FolderReport
    [JtIoFolder]$FolderTarget

    JtInvClientReport([JtConfig]$JtConfig) : Base($JtConfig) {
        $This.ClassName = "JtInvClientReport"
        $This.FolderReport = $JtConfig.Get_JtIoFolder_Report()
    }

    [boolean]DoCreateBcdeditMeta() {
        [String]$MyCommand = ""
        [String]$Label = ""

        [String]$Label = "systemid"
        [String]$Filename = -join ([JtIo]::JtInvPrefix_Report, '.', 'bcdedit', [JtIo]::FilenameExtension_Meta)
        [String]$Out = $This.Get_JtIoFolder_Report().GetFilePath($Filename)
        $MyCommand = -join ('bcdedit.exe /enum ', ' > ', '"', $Out, '"')
        Invoke-Expression -Command:$MyCommand

        return $True
    }

    [boolean]DoCreateDirMetas() {
        [String]$MyTestPath = ""
        [String]$MyCommand = ""
        
        $MyTestPath = "c:\."
        if (Test-Path $MyTestPath) {
            $MyCommand = $This.GetDirCommand($MyTestPath)
            Invoke-Expression -Command:$MyCommand
        }

        $MyTestPath = "c:\users\."
        if (Test-Path $MyTestPath) {
            $MyCommand = $This.GetDirCommand($MyTestPath)
            Invoke-Expression -Command:$MyCommand
        }
        
        $MyTestPath = "d:\."
        if (Test-Path $MyTestPath) {        
            $MyCommand = $This.GetDirCommand($MyTestPath)
            Invoke-Expression -Command:$MyCommand
        }

        $MyTestPath = "e:\."
        if (Test-Path $MyTestPath) {        
            $MyCommand = $This.GetDirCommand($MyTestPath)
            Invoke-Expression -Command:$MyCommand
        }
     
        return $True
    }
    
    [boolean]DoCreateMetas() {
        [String]$MyCommand = ""
        [String]$Label = ""

        [String]$Content = "hello world!"
        [String]$C_Inventory_Report = $This.Get_JtIoFolder_Report().GetPath()

        [String]$Label = "version"
        [String]$MyVersion = $This.GetVersion()
        [String]$Filename = -join ([JtIo]::JtInvPrefix_Report, '.', $MyVersion, '.', $Label, [JtIo]::FilenameExtension_Meta)
        [String]$FilterVersion = -join ("*", '.', $Label, [JtIo]::FilenameExtension_Meta)
        $This.Get_JtIoFolder_Report().DoDeleteAllFiles($FilterVersion)
        [String]$Out = $This.Get_JtIoFolder_Report().GetFilePath($Filename)
        Set-Content -Path $Out -Value $Content

        $MyIpInfo = (Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $null -ne $_.DefaultIPGateway }).IPAddress | select-object -first 1 
        [String]$MyIp = $MyIpInfo
        [String]$Content = $MyIP
        [String]$Label = "ip"
        [String]$Filename = -join ([JtIo]::JtInvPrefix_Report, '.', $Label, [JtIo]::FilenameExtension_Meta)
        [String]$Out = $This.Get_JtIoFolder_Report().GetFilePath($Filename)
        Set-Content -Path $Out -Value $Content

        [String]$Label = "obj"
        [String]$MyIp3 = $MyIp
        [String]$Content = $MyIP
        [String]$Filename = -join ('ip', '.', $MyIp3, '.', $Label, [JtIo]::FilenameExtension_Meta)
        [String]$Out = $This.Get_JtIoFolder_Report().GetFilePath($Filename)
        Set-Content -Path $Out -Value $Content

        [String]$Label = "set"
        [String]$Out = $This.Get_JtIoFolder_Report().GetFilePath($Filename)
        $MyCommand = -join ('cmd.exe /C ', '"', 'set', '"', ' > ', '"', $Out, '"')
        Invoke-Expression -Command:$MyCommand

        [String]$Label = "win"
        [String]$Filename = -join ([JtIo]::JtInvPrefix_Report, '.', $Label, [JtIo]::FilenameExtension_Meta)
        [String]$Out = $This.Get_JtIoFolder_Report().GetFilePath($Filename)
        $MyCommand = -join ('cmd.exe /C ', '"', 'ver', '"', ' > ' , '"', $Out, '"')
        Invoke-Expression -Command:$MyCommand

        [String]$Label = "user"
        [String]$Filename = -join ([JtIo]::JtInvPrefix_Report, '.', $Label, [JtIo]::FilenameExtension_Meta)
        [String]$Out = $This.Get_JtIoFolder_Report().GetFilePath($Filename)
        $MyCommand = -join ('cmd.exe /C ', '"', 'echo %username%', '"', ' > ', '"', $Out, '"')
        Invoke-Expression -Command:$MyCommand

        [String]$Label = "systemid"
        [String]$SystemId = [JtIo]::GetSystemId()
        [String]$Filename = -join ([JtIo]::JtInvPrefix_Report, '.', $systemId, ".", $Label, [JtIo]::FilenameExtension_Meta)
        [String]$Out = $This.Get_JtIoFolder_Report().GetFilePath($Filename)
        $MyCommand = -join ('cmd.exe /C ', '"', 'echo %username%', '"', ' > ', '"', $Out, '"')
        Invoke-Expression -Command:$MyCommand

        [String]$Label = "obj"
        [String]$Computername = [JtIo]::GetComputername()
        [String]$Filename = -join ("computer", '.', $Computername, ".", $Label, [JtIo]::FilenameExtension_Meta)
        [String]$Out = $This.Get_JtIoFolder_Report().GetFilePath($Filename)
        $MyCommand = -join ('cmd.exe /C ', '"', 'echo ', $Computername, '"', ' > ', '"', $Out, '"')
        Invoke-Expression -Command:$MyCommand

        [String]$Label = "ipconfig"
        [String]$Filename = -join ([JtIo]::JtInvPrefix_Report, '.', $Label, [JtIo]::FilenameExtension_Meta)
        [String]$Out = $This.Get_JtIoFolder_Report().GetFilePath($Filename)
        $MyCommand = -join ('cmd.exe /C ', '"', 'ipconfig /all', '"', '   > ', '"', $Out, '"')
        Invoke-Expression -Command:$MyCommand

        [String]$Label = "w32tm"
        [String]$Filename = -join ([JtIo]::JtInvPrefix_Report, '.', $Label, [JtIo]::FilenameExtension_Meta)
        [String]$Out = $This.Get_JtIoFolder_Report().GetFilePath($Filename)
        $MyCommand = -join ('cmd.exe /C ', '"', 'w32tm /stripchart /computer:130.75.1.32 /samples:1', '"', '   > ', '"', $Out, '"')
        Invoke-Expression -Command:$MyCommand

        [String]$Label = "wsus"
        [String]$Filename = -join ([JtIo]::JtInvPrefix_Report, '.', $Label, [JtIo]::FilenameExtension_Meta)
        [String]$Out = $This.Get_JtIoFolder_Report().GetFilePath($Filename)
        try {
            $MyCommand = -join ('reg query ', '"', 'hklm\software\policies\microsoft\windows\windowsupdate', '"', ' /v ', '"', 'wuserver', '"', ' > ', '"', $Out, '"')
            Invoke-Expression -Command:$MyCommand   
        }
        catch {
            $MyCommand = -join ('cmd.exe /C ', '"', 'echo wsus cannot be reported', '"', ' > ', '"', $Out, '"')
            Invoke-Expression -Command:$MyCommand   
        }

        [String]$Label = "choco"
        [String]$Filename = -join ([JtIo]::JtInvPrefix_Report, '.', $Label, [JtIo]::FilenameExtension_Meta)
        [String]$Out = $This.Get_JtIoFolder_Report().GetFilePath($Filename)
        if ($env:ChocolateyInstall -eq "c:\ProgramData\chocolatey" ) {
            $MyCommand = -join ('cmd.exe /C ', '"', 'choco list -li', '"', ' > ', '"', $Out, '"')
            Invoke-Expression -Command:$MyCommand  
        }
        else {
            $MyCommand = -join ('cmd.exe /C ', '"', 'echo choco is not installed', '"', ' > ', '"', $Out, '"')
            Invoke-Expression -Command:$MyCommand  
        }

        [String]$PathPublicDesktop = "c:\users\public\desktop"
        [String]$MyVersionMeta = -join ($PathPublicDesktop, "\*", [JtIo]::FilenameExtension_Meta)
        if (Test-Path $MyVersionMeta) {
            $MyCommand = -join ('cmd.exe /C ', '"', 'copy ', $PathPublicDesktop, '\*', [JtIo]::FilenameExtension_Meta, ' ', $C_Inventory_Report, '\.', '"')   
            Invoke-Expression -Command:$MyCommand    
        }
        return $True
    }

    [boolean]DoIt() {
        $This.DoLogRepoStart()

        $This.DoCreateMetas()
        $This.DoCreateDirMetas()
        $This.DoCreateBcdeditMeta()
        return $true
    }

    [JtIoFolder]Get_JtIoFolder_Report() {
        return New-JtIoFolderReport
    }

    [String]GetConfigName() {
        return "JtInvClientReport"
    }
 

    [String]GetReportLabel() {
        return "report"
    }





    [String]GetDirCommand([String]$Path) {
        [String]$Result = ""
        [String]$Label = [JtIo]::ConvertPathToLabel($Path)
        [String]$Filename = -join ([JtIo]::JtInvPrefix_Report, '.', $Label, '.', 'dir', [JtIo]::FilenameExtension_Meta)
        [String]$Out = $This.Get_JtIoFolder_Report().GetFilePath($Filename)
        [String]$Result = -join ('cmd.exe /C ', '"', 'dir ', $Path, ' > ', $Out, '"')
        return $Result
    }

}

function New-JtInvClientReport {

    Param (
        [Parameter(Mandatory = $false)]
        [JtConfig]$JtConfig
    )
    
    [JtConfig]$JtConfig = New-JtConfig
    [JtInvClientReport]::new([JtConfig]$JtConfig) 
    New-JtInvTimestamp -JtConfig $JtConfig -Label "report"
}




class JtInvClientUpdate : JtInv {

    [String]$DownloadUrlCApps = ""
    [String]$Fp_C_Apps = ""

    [JtIoFolder]$JtIoFolder_C_Apps

    [String]$HelpUrlCApps = "https://seafile.projekt.uni-hannover.de/f/dc1f3a1f8d5d4d528e32/"

    JtInvClientUpdate ([JtConfig]$JtConfig) : Base($JtConfig) {
        $This.ClassName = "JtInvClientUpdate"
        $This.JtIoFolder_C_Apps = [JtIoFolder]::new("c:\apps")
    }

    [Boolean]DoIt () {
        $This.DoLogRepoStart()
        
        [Xml]$ConfigXml = $This.GetConfigXml()

        if ($Null -eq $ConfigXml) {
            return $False
        }
        foreach ($Entity in $ConfigXml.getElementsByTagName("folder")) {
            # [String]$JtInfo = $Entity.'#text'

            [String]$Source = $Entity.source
            $Source = ConvertTo-JtExpandedPath $Source
            [JtIoFolder]$FolderSource = [JtIoFolder]::new($Source)
            if (!($FolderSource.IsExisting())) {
                Write-JtError -Text ( -join ("Error!!! Folder missing; please edit XML for:", $FolderSource.GetPath()))
                return $False
            }
                
            Write-JtLog -Text ( -join ("FolderSource:", $FolderSource.GetPath()))
                
            Write-JtLog -Text ( -join ("Target:", $This.JtIoFolder_C_Apps.GetPath()))

            if ($This.JtIoFolder_C_Apps.IsExisting()) {
                New-JtRobocopyIo -IoSource $FolderSource -IoTarget $This.JtIoFolder_C_Apps
            }
        } 
        return $true
    }

    [String]GetConfigName() {
        return "JtInvClientUpdate"
    }

    [String]GetReportLabel() {
        return "update"
    }
}


function New-JtInvClientUpdate {

    Param (
        [Parameter(Mandatory = $false)]
        [JtConfig]$JtConfig
    )
    [JtConfig]$JtConfig = New-JtConfig

    [JtInvClientUpdate]::new([JtConfig]$JtConfig) 
    
    New-JtInvTimestamp -JtConfig $JtConfig -Label "update"
}


# $mySoftware = Get-JtInstalledSoftware $env:COMPUTERNAME

class JtInvClientSoftware : JtInv {

    [JtIoFolder]$Target = $Null
    [JtIoFolder]$Source = $Null

    JtInvClientSoftware([JtConfig]$JtConfig) : Base($JtConfig) {
        $This.ClassName = "JtInvClientSoftware"
        # output goes directly to c:\_inventory\report

        [JtIoFolder]$This.Source = New-JtIoFolderReport
        [JtIoFolder]$This.Target = $This.Source.GetSubfolder("csv", $True)
    }

    [boolean]DoIt() {
        $This.DoLogRepoStart()

        $MyObject = $NUll
        $MyObject = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Sort-Object DisplayName 
        $MyClass = "Uninstall64"
        [String]$FileNameXml = -join ($MyClass.ToLower(), ".xml")
        [String]$FileNameTxt = -join ($MyClass.ToLower(), ".txt")

        $FilePathXml = $This.GetFolderTarget().GetFilePath($FileNameXml)
        $FilePathTxt = $This.GetFolderTarget().GetFilePath($FileNameTxt)

        Write-JtIo -Text ( -join ("Writing TXT-File: ", $FilePathTxt))
        $MyObject | Sort-Object -Property DisplayName | Format-Table -Property DisplayName, DisplayVersion | Out-File -Filepath $FilePathTxt

        Write-JtIo -Text ( -join ("Writing XML-File: ", $FilePathXml))
        Export-Clixml -InputObject  $MyObject -Path $FilePathXml
        
        $MyObject = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Sort-Object DisplayName 	
        $MyClass = "Uninstall32"
        [String]$FileNameXml = -join ($MyClass.ToLower(), ".xml")
        [String]$FileNameTxt = -join ($MyClass.ToLower(), ".txt")
        
        $FilePathXml = $This.GetFolderTarget().GetFilePath($FileNameXml)
        $FilePathTxt = $This.GetFolderTarget().GetFilePath($FileNameTxt)

        Write-JtIo -Text ( -join ("Writing TXT-File: ", $FilePathTxt))
        $MyObject | Sort-Object -Property DisplayName | Format-Table -Property DisplayName, DisplayVersion | Out-File -Filepath $FilePathTxt

        Write-JtIo -Text ( -join ("Writing XML-File: ", $FilePathXml))
        Export-Clixml -InputObject  $MyObject -Path $FilePathXml

        return $True
    }


    [String]GetConfigName() {
        return ""
    }

    [String]GetReportLabel() {
        return "software"
    }
}

function New-JtInvClientSoftware {

    Param (
        [Parameter(Mandatory = $false)]
        [JtConfig]$JtConfig
    )

    [JtConfig]$JtConfig = New-JtConfig
    [JtInvClientSoftware]::new([JtConfig]$JtConfig) 
    New-JtInvTimestamp -JtConfig $JtConfig -Label "software"
}


class JtInvTimestamp : JtInv {
    
    [String]$Label
    
    JtInvTimestamp([JtConfig]$JtConfig, [String]$MyLabel) : Base($JtConfig) {
        $This.ClassName = "JtInvTimestamp"
        $This.Label = $MyLabel
        # Output goes directly to c:\_inventory\report
    }

    [boolean]DoIt() {
        $This.DoLogRepoStart()

        [String]$Timestamp = ""
        
        $Timestamp = Get-JtTimestamp
        
        [String]$Content = "Hello world!"
        [String]$FileLabel = -join ([JtIo]::JtInvPrefix_Report, ".", $Timestamp, ".", $This.Label, ".", [JtIo]::JtInvSuffix_Time)

        [String]$TargetPath = $This.Get_JtIoFolder_Report().GetPath()
        New-JtIoFileMeta -Path $TargetPath -Label $FileLabel -Content $Content
        return $true
    }
 
    [Boolean]DoCleanTimestamps() {
        [String]$MyFilter = -join ("*", ".", $This.Label, ".", [JtIo]::JtInvSuffix_Time, [JtIo]::FilenameExtension_Meta)
        Write-Host "DoCleanTimestamps"        
        $This.Get_JtIoFolder_Report().DoDeleteAllFiles($MyFilter)
        return $true
    }

    [String]GetConfigName() {
        return ""
    }

    [String]GetReportLabel() {
        return "timestamp"
    }
}


Function New-JtInvTimestamp {

    Param (
        [Parameter(Mandatory = $false)]
        [JtConfig]$JtConfig,
        [Parameter(Mandatory = $false)]
        [String]$Label
    )

    [JtInvTimestamp]::new($JtConfig, $Label)
}



class JtInvData : JtInv {
    
    [String]$Out = ""
    [String]$Computer
    
    JtInvData([JtConfig]$JtConfig) : Base($JtConfig) {
        $This.ClassName = "JtInvData"
        $This.Computer = $env:COMPUTERNAME
    }
    
    hidden [Boolean]DoWriteTheReport([JtIoFolder]$MyTarget, [String]$MyLabel, [JtIoFolder]$MySource) {
        $ReportName = -join ("data", ".", $env:COMPUTERNAME.ToLower(), ".", $MyLabel)
        [JtTblTable]$JtTblTable = New-JtTblTable -Label $ReportName

        $SubFolders = $MySource.GetSubfolders($False)
        foreach ($Folder in $SubFolders) {
            [JtTblRow]$JtTblRow = $This.GetDataLine($Folder.GetPath())
            $JtTblTable.AddRow($JtTblRow)
        }
        New-JtCsvWriteTbl -Label $JtTblTable.GetLabel() -JtIoFolder $MyTarget -JtTblTable $JtTblTable
        return $True
    }

    [Boolean]DoIt() {
        $This.DoLogRepoStart()
        
        [Xml]$ConfigXml = $This.GetConfigXml()

        if ($Null -eq $ConfigXml) {
            return $False
        }
        foreach ($Entity in $ConfigXml.getElementsByTagName("folder")) {
            # [String]$JtInfo = $Entity.'#text'

            [String]$Source = $Entity.source
            $Source = ConvertTo-JtExpandedPath $Source
            [JtIoFolder]$FolderSource = [JtIoFolder]::new($Source)
            Write-JtLog -Text ( -join ("Source:", $Source))
                
            [JtIoFolder]$FolderExport = $Null
            [String]$Target = $Entity.target
            $Target = ConvertTo-JtExpandedPath $Target
            if ($Target.Length -gt 0) {
                [JtIoFolder]$FolderExport = [JtIoFolder]::new($Target, $True)
            }
            else {
                [JtIoFolder]$FolderExport = $This.GetFolderTarget()
            }
            Write-JtLog -Text ( -join ("... Exporting results to:", $FolderExport.GetPath()))

            [String]$Label = $Entity.label
            [String]$MyLabel = ""
            if ($Label.Length -lt 1) {
                $MyLabel = $FolderSource.GetLabelForPath()
            }
            else {
                $MyLabel = $Label
            }
            Write-JtLog -Text ( -join ("Label:", $MyLabel))

            $This.DoWriteTheReport($FolderExport, $MyLabel, $FolderSource)
        }
        return $True
    }

    hidden [JtTblRow]GetDataLine([String]$Path) {
        Write-JtLog -Text ( -join ("-- GetDataLine, Path:", $Path))
        [JtTblRow]$JtTblRow = New-JtTblRow
    
        $Result = $Null
        try {
    
            $Result = Get-ChildItem -Recurse $Path | Where-Object { -not $_.PSIsContainer } | Measure-Object -Property Length -Sum
        }
        catch {
            Write-JtError -Text ( -join ("JtInvData, problem in GetDataLine with path:", $Path))
        }
    
        $JtTblRow.Add("Path", $Path)
        if ($Null -eq $Result) {
            $JtTblRow.Add("Computer", $This.Computer)
    
            $JtTblRow.Add("Size", 0)
            $JtTblRow.Add("SizeGB", 0)
            $JtTblRow.Add("Files", 0)
            $JtTblRow.Add("OK", 0)
        }    
        else {
            $JtTblRow.Add("Computer", $This.Computer)
            
            $JtTblRow.Add("Size", $Result.Sum)
            [String]$SizeGb = ConvertTo-JtStringToGb($Result.Sum)
            $JtTblRow.Add("SizeGB", $SizeGB)
            $JtTblRow.Add("Files", $Result.Count)
            $JtTblRow.Add("OK", 1)
        }    
        return $JtTblRow
    }    

    [String]GetConfigName() {
        return "JtInvDATA"
    }

    [String]GetReportLabel() {
        return "data"
    }
    


}

function New-JtInvData {

    Param (
        [Parameter(Mandatory = $false)]
        [JtConfig]$JtConfig
    )

    [JtConfig]$JtConfig = New-JtConfig
    [JtInvData]::new([JtConfig]$JtConfig) 
    New-JtInvTimestamp -JtConfig $JtConfig -Label "data"
}


class JtInvDownload : JtInv {

    [JtIoFolder]$JtIoFolderDownload = $Null

    JtInvDownload([JtConfig]$JtConfig) : Base($JtConfig) {
        $This.ClassName = "JtInvDownload"
        $This.JtIoFolderDownload = [JtIoFolder]::new("C:\_inventory\download", $True)
    }

    
    [boolean]DoIt() {
        $This.DoLogRepoStart()
        
        Write-JtLog -Text ( -join ("Downloading to:", $This.JtIoFolderDownload.GetPath()))

        # * Download: [apps.exe](https://seafile.projekt.uni-hannover.de/f/b74545092bc24a9c9101/?dl=1)
        # * Download: [apps.zip](https://seafile.projekt.uni-hannover.de/f/d31bffa68e0b445c9194/?dl=1)

        [String]$DownloadUrlAppsZip = "https://seafile.projekt.uni-hannover.de/f/d31bffa68e0b445c9194/?dl=1"
        [String]$FileNameZip = "apps.zip"
        [String]$TargetFilePathZip = $This.JtIoFolderDownload.GetFilePath($FileNameZip)

        (new-object System.Net.WebClient).DownloadFile($DownloadUrlAppsZip, $TargetFilePathZip)
        return $true
    }


    [String]GetConfigName() {
        return "JtInvDOWNLOAD"
    }

    [String]GetReportLabel() {
        return "download"
    }



    [Boolean]DoCleanJtIoFolderDownload() {
        $This.JtIoFolderDownload().DoDeleteAllFiles()
        return $true
    }

}

function New-JtInvDownload {

    Param (
        [Parameter(Mandatory = $false)]
        [JtConfig]$JtConfig
    )

    [JtConfig]$JtConfig = New-JtConfig
    [JtInvDownload]::new([JtConfig]$JtConfig) 
    
    New-JtInvTimestamp -JtConfig $JtConfig -Label "download"
}




class JtInvFiles : JtInv {

    static [String]$JtInvPrefix_Files = "files"

    JtInvFiles ([JtConfig]$JtConfig) : Base($JtConfig) {
        $This.ClassName = "JtInvFiles"
    }

    static [JtTblRow] GetRowForFile([JtIoFile]$MyFile) {
        #  "NAME.EXTENSION.PATH.PARENT_NAME"
        [JtIoFile]$JtIoFile = $MyFile
                
        [JtTblRow]$JtTblRow = New-JtTblRow
        
        [String]$FileName = $JtIoFile.GetName()
        $JtTblRow.Add("NAME", $FileName)
        
        [String]$Extension = $JtIoFile.GetExtension()
        $JtTblRow.Add("EXTENSION", $Extension)

        [String]$Path = $JtIoFile.GetPath()
        $JtTblRow.Add("PATH", $Path)

        [JtIoFolder]$ParentFolder = [JtIoFolder]::new($JtIoFile)
        [String]$ParentName = $ParentFolder.GetName()
        $JtTblRow.Add("PARENT_NAME", $ParentName)

        return $JtTblRow
    }

    static [JtTblRow] GetRowForFileUsingTemplate([JtIoFile]$MyFile, [String]$Template) {
        [JtTblRow]$JtTblRowAll = [JtInvFiles]::GetRowForFile($MyFile)

        [JtTblRow]$JtTblRow = New-JtTblRow
        [String[]]$Parts = $Template.Split(".")

        foreach ($Element in $Parts) {
            [String]$Part = $Element

            [String]$Value = $JtTblRowAll.GetValue($Part)
            $JtTblRow.Add($Part, $Value)
        }
        return $JtTblRow
    }

    [Boolean]DoWriteCsvFileIn([System.Collections.ArrayList]$Files, [String]$MyLabel, [String]$MyTemplate, [JtIoFolder]$MyTarget) {
        [JtTblTable]$JtTblTable = New-JtTblTable -Label "FileTable"      
        foreach ($File in $Files) {
            [JtIoFile]$JtIoFile = $File

            [JtTblRow]$JtTblRow = $Null    
            if ($MyTemplate.Length -lt 1) {
                $JtTblRow = [JtInvFiles]::GetRowForFile($JtIoFile)
            }
            else {
                $JtTblRow = [JtInvFiles]::GetRowForFileUsingTemplate($JtIoFile, $MyTemplate)
            }
            $JtTblTable.AddRow($JtTblRow)
        }

        New-JtCsvWriteTbl -Label $MyLabel -JtIoFolder $MyTarget -JtTblTable $JtTblTable
        return $True
    }

    [Boolean]DoIt() {
        $This.DoLogRepoStart()
        
        [Xml]$ConfigXml = $This.GetConfigXml()

        if ($Null -eq $ConfigXml) {
            return $False
        }
        foreach ($entity in $ConfigXml.getElementsByTagName("folder")) {
            # [String]$JtInfo = $entity.'#text'

            [String]$Source = $entity.source
            $Source = ConvertTo-JtExpandedPath $Source
            [JtIoFolder]$FolderSource = [JtIoFolder]::new($Source)
            Write-JtLog -Text ( -join ("Source:", $Source))

            if ($False -eq $FolderSource.IsExisting()) {
                Write-JtError -Text ( -join ("Error in JtInvFiles GenerteCsvForFolder. Please edit XML in files!!!!"))
                Write-JtError -Text ( -join ("Path not found:", $FolderSource.GetPath()))
                return $False
            }
                
            [JtIoFolder]$FolderExport = $Null
            [String]$Target = $Entity.target
            $Target = ConvertTo-JtExpandedPath $Target
            if ($Target.Length -gt 0) {
                [JtIoFolder]$FolderExport = [JtIoFolder]::new($Target, $True)
            }
            else {
                [JtIoFolder]$FolderExport = $This.GetFolderTarget()
            }
            Write-JtLog -Text ( -join ("... Exporting results to:", $FolderExport.GetPath()))

            [String]$MyFilter = $entity.filter
            Write-JtLog -Text ( -join ("Filter:", $MyFilter))

            [String]$Label = $Entity.label
            [String]$MyLabel = ""
            if ($Label.Length -lt 1) {
                $MyLabel = $FolderSource.GetLabelForName()
                # [String]$CsvLabel = -join ([JtIo]::JtInvPrefix_Files, ".", $MyFolder.GetName())
            }
            else {
                $MyLabel = $Label
            }
            Write-JtLog -Text ( -join ("Label:", $MyLabel))

            [String]$MyTemplate = ""
            [String]$Template = $Entity.template
            if ($Template.Length -lt 1) {
                $MyTemplate = ""
            }
            else {
                $MyTemplate = $Template
            }
            Write-JtLog -Text ( -join ("Template:", $MyTemplate))

            [System.Collections.ArrayList]$Files = $This.GetFiles($FolderSource, $MyFilter)
            $This.DoWriteCsvFileIn($Files, $MyLabel, $MyTemplate, $FolderExport)
        }
        return $true
    }



    [String]GetConfigName() {
        return "JtInvFILES"
    }
    
    [String]GetReportLabel() {
        return "files"
    }



    [System.Collections.ArrayList]GetFiles([JtIoFolder]$JtIoFolder, [String]$Filter) {
        [System.Collections.ArrayList]$Files = $Null
        [String]$MyFilter = $Filter
        if ($Null -eq $Filter) {
            $MyFilter = ""
        }

        if ($MyFilter.Length -gt 0) {
            [System.Collections.ArrayList]$Files = $JtIoFolder.GetJtIoFilesWithFilter($MyFilter, $True)
        }
        else {
            [System.Collections.ArrayList]$Files = $JtIoFolder.GetJtIoFiles($True)
        }
        return $Files
    }
}


function New-JtInvFiles {

    Param (
        [Parameter(Mandatory = $false)]
        [JtConfig]$JtConfig
    )

    [JtConfig]$JtConfig = New-JtConfig
    [JtInvFiles]::new([JtConfig]$JtConfig) 

    New-JtInvTimestamp -JtConfig $JtConfig -Label "files"
}


class JtInvFolders : JtInv {

    JtInvFolders ([JtConfig]$JtConfig) : Base($JtConfig) {
        $This.ClassName = "JtInvFolders"
    }


    [Boolean]DoIt () {
        $This.DoLogRepoStart()
        
        [Xml]$ConfigXml = $This.GetConfigXml()

        if ($Null -eq $ConfigXml) {
            return $False
        }


        foreach ($Entity in $ConfigXml.getElementsByTagName("folder")) {
            # [String]$JtInfo = $Entity.'#text'

            [String]$Source = $Entity.source
            $Source = ConvertTo-JtExpandedPath $Source
            [JtIoFolder]$FolderSource = [JtIoFolder]::new($Source)
            if (!($FolderSource.IsExisting())) {
                Write-JtError -Text ( -join ("Error!!! Folder missing; please edit XML for:", $FolderSource.GetPath()))
                return $False
            }
            Write-JtLog -Text ( -join ("FolderSource:", $FolderSource.GetPath()))
                
            [JtIoFolder]$FolderExport = $Null
            [String]$Target = $Entity.target
            $Target = ConvertTo-JtExpandedPath $Target
            if ($Target.Length -gt 0) {
                [JtIoFolder]$FolderExport = [JtIoFolder]::new($Target, $True)
            }
            else {
                [JtIoFolder]$FolderExport = $This.GetFolderTarget()
            }
            Write-JtLog -Text ( -join ("... Exporting results to:", $FolderExport.GetPath()))

            [System.Collections.ArrayList]$FolderFiles = $FolderSource.GetFolderFiles()
            Write-JtLog -Text ( -join ("Finding FolderFiles. Number of files found: ", $FolderFiles.Count))
                    
            foreach ($MyFile in $FolderFiles) {
                [JtIoFile]$FileFolder = $Myfile
                Write-JtLog -Text ( -join ("Path of FolderFile:", $MyFile.GetPath()))

                [JtFacFolderRen]$JtFacFolderRen = [JtFacFolderRen]::new($FileFolder)
                [JtFolderRenderer]$JtFolderRenderer = $JtFacFolderRen.GetJtFolderRenderer()
                Write-JtLog -Text ( -join ("Kind of folder: ", $JtFacFolderRen.GetKind()))
                Write-JtLog -Text ( -join ("Info for folder: ", $JtFolderRenderer.GetInfo()))
                Write-JtLog -Text ( -join ("Check for folder: ", $JtFolderRenderer.DoCheckFolder()))
                Write-JtLog -Text ( -join ("Clean special files... ", $JtFolderRenderer.DoCleanFilesInFolder()))
                Write-JtLog -Text ( -join ("Create special file... ", $JtFolderRenderer.DoWriteSpecialFileInFolder()))
                Write-JtLog -Text ( -join ("Create special file in... ", $FolderExport.GetPath(), " - ", $JtFolderRenderer.DoWriteSpecialFileIn($FolderExport)))
                Write-JtLog -Text ( -join ("Create table CSV file... ", $JtFolderRenderer.DoWriteCsvFileInFolder()))
                Write-JtLog -Text ( -join ("Create table CSV file in... ", $FolderExport.GetPath(), " - ", $JtFolderRenderer.DoWriteCsvFileIn($FolderExport)))
                
            }
        } 
        return $true
    }


    [String]GetConfigName() {
        return "JtInvFOLDERS"
    }

    [String]GetReportLabel() {
        return "folders"
    }


}

function New-JtInvFolders {

    Param (
        [Parameter(Mandatory = $false)]
        [JtConfig]$JtConfig
    )

    [JtConfig]$JtConfig = New-JtConfig
    [JtInvFolders]::new([JtConfig]$JtConfig) 
    New-JtInvTimestamp -JtConfig $JtConfig -Label "folders"

}

class JtInvLengths : JtInv {

    JtInvLengths([JtConfig]$JtConfig) : Base($JtConfig) {
        $This.ClassName = "JtInvLengths"
    }

    [Boolean]DoIt () {
        $This.DoLogRepoStart()
        
        [Xml]$ConfigXml = $This.GetConfigXml()

        if ($Null -eq $ConfigXml) {
            return $False
        }

        foreach ($Entity in $ConfigXml.getElementsByTagName("folder")) {
            # [String]$JtInfo = $Entity.'#text'

            [String]$Source = $Entity.source
            $Source = ConvertTo-JtExpandedPath $Source
            Write-JtLog -Text ( -join ("Source:", $Source))
            [JtIoFolder]$FolderSource = [JtIoFolder]::new($Source)
            if (!($FolderSource.IsExisting())) {
                Write-JtError -Text ( -join ("Error!!! Please edit XML for:", $FolderSource.GetPath()))
                return $False
            }
                
                
            [JtIoFolder]$FolderExport = $Null
            [String]$Target = $Entity.target
            $Target = ConvertTo-JtExpandedPath $Target
            if ($Target.Length -gt 0) {
                [JtIoFolder]$FolderExport = [JtIoFolder]::new($Target, $True)
            }
            else {
                [JtIoFolder]$FolderExport = $This.GetFolderTarget()
            }
            Write-JtLog -Text ( -join ("... Exporting results to:", $FolderExport.GetPath()))
                    
                
            [JtTblTable]$JtTblTable = $This.GetTable($FolderSource)

            # [System.Data.Datatable]$Datatable = Get-JtDataTableFromTable -JtTableTable $JtTblTable
            [System.Collections.ArrayList]$List = $JtTblTable.GetObjects() | Sort-Object -Property @{e = { $_.Length -as [int] } } -Descending

            [String]$Label = $Entity.label
            [String]$MyLabel = ""
            if ($Label.Length -lt 1) {
                $MyLabel = $FolderSource.GetLabelForPath()
            }
            else {
                $MyLabel = $Label
            }
            Write-JtLog -Text ( -join ("Label:", $Label))


            New-JtCsvWriteTbl -Label $MyLabel -JtIoFolder $FolderExport -JtTblTable $JtTblTable
        }
        return $true
    }


    [String]GetConfigName() {
        return "JtInvLENGTHS"
    }

    [String]GetReportLabel() {
        return "lengths"
    }

    [JtTblTable]GetTable([JtIoFolder]$MyFolder) {
        [JtTblTable]$JtTblTable = New-JtTblTable -Label "Lengths"
    
        $MyFolders = $MyFolder.GetSubfolders($True)
    
        foreach ($Folder in $MyFolders) {
            [JtTblRow]$JtTblRow = New-JtTblRow

            [JtIoFolder]$JtIoFolder = $Folder
    
            $JtTblRow.Add("Foldername", $JtIoFolder.GetName()) | Out-Null

            $JtTblRow.Add("Path", $JtIoFolder.GetPath()) | Out-Null
            $JtTblRow.Add("Length", $JtIoFolder.GetPath().Length) | Out-Null
    
            $JtTblTable.AddRow($JtTblRow) | Out-Null
        }
        return $JtTblTable
    }
}

function New-JtInvLengths {

    Param (
        [Parameter(Mandatory = $false)]
        [JtConfig]$JtConfig
    )

    [JtConfig]$JtConfig = New-JtConfig
    [JtInvLengths]::new([JtConfig]$JtConfig) 
    
    New-JtInvTimestamp -JtConfig $JtConfig -Label "lengths"
}

class JtInvLines : JtInv {

    JtInvLines ([JtConfig]$JtConfig) : Base($JtConfig) {
        $This.ClassName = "JtInvLines"
    }
    

    [Boolean]DoIt () {
        $This.DoLogRepoStart()
        
        [Xml]$ConfigXml = $This.GetConfigXml()

        if ($Null -eq $ConfigXml) {
            return $False
        }
        foreach ($entity in $ConfigXml.getElementsByTagName("folder")) {
            # [String]$JtInfo = $entity.'#text'

            [String]$Source = $entity.source
            $Source = ConvertTo-JtExpandedPath $Source
            [JtIoFolder]$MyFolder = [JtIoFolder]::new($Source)
            Write-JtLog -Text ( -join ("Source:", $Source))
                
                
            [JtIoFolder]$FolderExport = $Null
            [String]$Target = $Entity.target
            $Target = ConvertTo-JtExpandedPath $Target
            if ($Target.Length -gt 0) {
                [JtIoFolder]$FolderExport = [JtIoFolder]::new($Target, $True)
            }
            else {
                [JtIoFolder]$FolderExport = $This.GetFolderTarget()
            }
            Write-JtLog -Text ( -join ("... Exporting results to:", $FolderExport.GetPath()))

            [String]$Filter = $entity.filter
            Write-JtLog -Text ( -join ("Filter:", $Filter))

            [String]$Pattern = $entity.pattern
            Write-JtLog -Text ( -join ("Pattern:", $Pattern))

            [String]$Label = $Entity.label
            [String]$MyLabel = ""
            if ($Label.Length -lt 1) {
                $MyLabel = $MyFolder.GetLabelForPath()
            }
            else {
                $MyLabel = $Label
            }
            Write-JtLog -Text ( -join ("Label:", $Label))

            [JtMd]::DoWriteJtMdCsv($MyFolder, $FolderExport, $MyLabel, $Filter, $Pattern)
        } 
        
        return $true
    }



    [String]GetConfigName() {
        return "JtInvLINES"
    }

    [String]GetReportLabel() {
        return "lines"
    }


}

function New-JtInvLines {

    Param (
        [Parameter(Mandatory = $false)]
        [JtConfig]$JtConfig
    )

    [JtConfig]$JtConfig = New-JtConfig
    [JtInvLines]::new([JtConfig]$JtConfig) 
    New-JtInvTimestamp -JtConfig $JtConfig -Label "lines"

}

class JtInvJtMd : JtInv {


    JtInvJtMd ([JtConfig]$JtConfig) : Base($JtConfig) {
        $This.ClassName = "JtInvJtMd"
    }


    [Boolean]DoIt () {
        $This.DoLogRepoStart()
        
        [Xml]$ConfigXml = $This.GetConfigXml()

        if ($Null -eq $ConfigXml) {
            return $False
        }
        foreach ($Entity in $ConfigXml.getElementsByTagName("folder")) {
            # [String]$JtInfo = $Entity.'#text'
    
            [String]$Source = $Entity.source
            $Source = ConvertTo-JtExpandedPath $Source
            [JtIoFolder]$FolderSource = [JtIoFolder]::new($Source)
            if (!($FolderSource.IsExisting())) {
                Write-JtError -Text ( -join ("Error!!! Folder missing; please edit XML for:", $FolderSource.GetPath()))
                return $False
            }
            Write-JtLog -Text ( -join ("FolderSource:", $FolderSource.GetPath()))
                
            [JtIoFolder]$FolderExport = $Null
            [String]$Target = $Entity.target
            $Target = ConvertTo-JtExpandedPath $Target
            if ($Target.Length -gt 0) {
                [JtIoFolder]$FolderExport = [JtIoFolder]::new($Target, $True)
            }
            else {
                [JtIoFolder]$FolderExport = $This.GetFolderTarget()
            }
            Write-JtLog -Text ( -join ("... Exporting results to:", $FolderExport.GetPath()))
                
            [String]$Filter = "*.md"
            Write-JtLog -Text ( -join ("Filter:", $Filter))
                
            # [String]$Label = $entity.label
                
            # <path filter="*.web.md" label="support_index_az" pattern="[\[]({FILELABEL})[\]][\(](https:\/\/)[A-Za-z0-9.\-\/]*(\))">D:\Seafile\al-public\SUPPORT</path>
            [String]$Label = "JtMd.az"
            Write-JtLog -Text ( -join ("Label:", $Label))
            [String]$Pattern = "[\[]({FILELABEL})[\]][\(](https:\/\/)[A-Za-z0-9.\-\/]*(\))"
            Write-JtLog -Text ( -join ("Pattern:", $Pattern))
            [JtMd]::DoWriteJtMdCsv($FolderSource, $FolderExport, $Label, $Filter, $Pattern)
                
            # <path filter="*.web.md" label="support_links" pattern="[\[][A-Za-z0-9_]*[\]][\(](https:\/\/)[A-Za-z0-9.\-\/]*(\))">D:\Seafile\al-public</path>
            [String]$Label = "JtMd.links"
            Write-JtLog -Text ( -join ("Label:", $Label))
            [String]$Pattern = "[\[][A-Za-z0-9_]*[\]][\(](https:\/\/)[A-Za-z0-9.\-\/]*(\))"
            Write-JtLog -Text ( -join ("Pattern:", $Pattern))
            [JtMd]::DoWriteJtMdCsv($FolderSource, $FolderExport, $Label, $Filter, $Pattern)
        }
        return $true
    }


    [String]GetConfigName() {
        return "JtInvMD"
    }

    [String]GetReportLabel() {
        return "JtMd"
    }



}


function New-JtInvJtMd {

    Param (
        [Parameter(Mandatory = $false)]
        [JtConfig]$JtConfig
    )
    
    [JtConfig]$JtConfig = New-JtConfig
    [JtInvJtMd]::new([JtConfig]$JtConfig) 
    
    New-JtInvTimestamp -JtConfig $JtConfig -Label "JtMd"
}


class JtInvMiete : JtInv {

    [String]$TemplateFileExtension = [JtIo]::FilenameExtension_Whg

    JtInvMiete ([JtConfig]$JtConfig) : Base($JtConfig) {
        $This.ClassName = "JtInvMiete"
    }


    [Boolean]DoIt () {
        $This.DoLogRepoStart()
        
        [Xml]$ConfigXml = $This.GetConfigXml()

        if ($Null -eq $ConfigXml) {
            return $False
        }
        foreach ($Entity in $ConfigXml.getElementsByTagName("folder")) {
            # [String]$JtInfo = $Entity.'#text'

            [String]$Source = $Entity.source
            $Source = ConvertTo-JtExpandedPath $Source
            Write-JtLog -Text ( -join ("Source:", $Source))

            [JtIoFolder]$FolderSource = [JtIoFolder]::new($Source)
            if (!($FolderSource.IsExisting())) {
                Write-JtError -Text ( -join ("Error!!! Please edit XML for:", $FolderSource.GetPath()))
                return $False
            }

            [String]$Target = $entity.target
            $Target = ConvertTo-JtExpandedPath $Target
            Write-JtLog -Text ( -join ("Target:", $Target))
            [JtIoFolder]$FolderTarget = [JtIoFolder]::new($Target)

            foreach ($MyFolder in $FolderSource.GetSubfolders($True)) {
                [JtIoFolder]$JtIoFolderMiete = $MyFolder
                # $JtIoFolderMiete.DoOptimizeFilenames()

                [JtTemplateFile]$JtTemplateFile = Get-JtTemplateFile -JtIoFolder $JtIoFolderMiete -Extension $This.TemplateFileExtension

                Write-JtLog ( -join ($This.ClassName, " Folder:", $MyFolder.GetPath()))

                if ($JtTemplateFile.IsValid()) {
                    [JtFolderRenderer_Miete]$JtFolderRenderer = [JtFolderRenderer_Miete]::new($JtIoFolderMiete)
                    $JtFolderRenderer.DoWriteInFolder()
                    $JtFolderRenderer.DoWriteMdFile()
                    $JtFolderRenderer.DoWriteSpecialFileIn($FolderTarget.GetSubfolder("sum", $True))
                    $JtFolderRenderer.DoWriteMdFileIn($FolderTarget.GetSubfolder("md", $True))
                    $JtFolderRenderer.DoWriteCsvFileIn($FolderTarget.GetSubfolder("csv", $True))
                }
            }
        } 
        return $true
    }


    [String]GetConfigName() {
        return "JtInvMIETE"
    }

    [String]GetReportLabel() {
        return "miete"
    }

    [String]GetName() {
        [String]$Result = -join ("_MONAT.ART.OBJEKT.MIETER.MIETE.NEBENKOSTEN.BETRAG", [JtIo]::FilenameExtension_Whg)
        return $Result
    }


}


function New-JtInvMiete {

    Param (
        [Parameter(Mandatory = $false)]
        [JtConfig]$JtConfig
    )

    [JtConfig]$JtConfig = New-JtConfig
    [JtInvMiete]::new([JtConfig]$JtConfig) 

    New-JtInvTimestamp -JtConfig $JtConfig -Label "miete"
}


class JtInvMirror : JtInv {

    JtInvMirror ([JtConfig]$JtConfig) : Base($JtConfig) {
        $This.ClassName = "JtInvMirror"
    }

    [Boolean]DoIt () {
        $This.DoLogRepoStart()
        
        [Xml]$ConfigXml = $This.GetConfigXml()

        if ($Null -eq $ConfigXml) {
            return $False
        }
        foreach ($entity in $ConfigXml.getElementsByTagName("folder")) {
            # [String]$JtInfo = $entity.'#text'
                
            [String]$Source = $entity.source
            $Source = ConvertTo-JtExpandedPath $Source
            Write-JtLog -Text ( -join ("Source:", $Source))
            [JtIoFolder]$FolderSource = [JtIoFolder]::new($Source)
                
            [String]$Target = $entity.target
            $Target = ConvertTo-JtExpandedPath $Target
            Write-JtLog -Text ( -join ("Target:", $Target))
            [JtIoFolder]$FolderTarget = [JtIoFolder]::new($Target)

            New-JtRobocopyIo -IoSource $FolderSource -IoTarget $FolderTarget
        }
        return $true
    }


    [String]GetConfigName() {
        return "JtInvMIRROR"
    }

        
    [String]GetReportLabel() {
        return "mirror"
    }


}

function New-JtInvMirror {

    Param (
        [Parameter(Mandatory = $false)]
        [JtConfig]$JtConfig
    )

    [JtConfig]$JtConfig = New-JtConfig
    [JtInvMirror]::new([JtConfig]$JtConfig) 
    New-JtInvTimestamp -JtConfig $JtConfig -Label "mirror"

}


class JtInvPoster : JtInv {

    [String]$ExtensionFolder = ".job"

    [JtPreisliste]$JtPreisliste = $Null

    JtInvPoster ([JtConfig]$JtConfig) : Base($JtConfig) {
        $This.ClassName = "JtInvPoster"
        $This.JtPreisliste = New-JtPreisliste_Plotten_2020_07_01
    }


    [Boolean]DoPrepareJtTemplateFiles([JtIoFolder]$JtIoFolder) {
        foreach ($MyFolder in $JtIoFolder.GetSubfolders($False)) {
            [JtIoFolder]$JtIoFolderJob = $MyFolder

            [String]$MyFilter = -join ("*", [JtIo]::FilenameExtension_Poster)
            [System.Collections.ArrayList]$FolderFiles = $JtIoFolderJob.GetJtIoFilesWithFilter($MyFilter) 

            if ($FolderFiles.Count -eq 0) {
                [String]$JtTemplateFileName = $This.JtPreisliste.TemplateFileName
                [String]$JtTemplateFilePath = $JtIoFolderJob.GetFilePath($JtTemplateFileName)

                "Hello world!" | Out-File -FilePath $JtTemplateFilePath -Encoding utf8
            }
        }
        return $True
    }

    [Boolean]DoIt () {
        $This.DoLogRepoStart()
        
        [Xml]$ConfigXml = $This.GetConfigXml()

        if ($Null -eq $ConfigXml) {
            return $False
        }

        foreach ($Entity in $ConfigXml.getElementsByTagName("folder")) {
            # [String]$JtInfo = $Entity.'#text'

            [String]$Source = $Entity.source
            $Source = ConvertTo-JtExpandedPath $Source
            Write-JtLog -Text ( -join ("Source:", $Source))

            [JtIoFolder]$FolderSource = [JtIoFolder]::new($Source)
            if (!($FolderSource.IsExisting())) {
                Write-JtError -Text ( -join ("Error!!! Please edit XML for:", $FolderSource.GetPath()))
                return $False
            }

            $This.DoPrepareJtTemplateFiles($FolderSource)
            foreach ($MyFolder in $FolderSource.GetSubfolders($False)) {
                [JtIoFolder]$JtIoFolderJob = $MyFolder
                $JtIoFolderJob.DoOptimizeFilenames()

                [JtFolderRenderer_Poster]$JtFolderRenderer = [JtFolderRenderer_Poster]::new($JtIoFolderJob, $This.JtPreisliste)
                $JtFolderRenderer.DoWriteInFolder()
                $JtFolderRenderer.DoWriteMdFile()
            }
        } 
        return $true
    }


    [String]GetConfigName() {
        return "JtInvPOSTER"
    }

    [String]GetReportLabel() {
        return "poster"
    }


}


function New-JtInvPoster {

    Param (
        [Parameter(Mandatory = $false)]
        [JtConfig]$JtConfig
    )

    [JtConfig]$JtConfig = New-JtConfig
    [JtInvPoster]::new([JtConfig]$JtConfig) 

    New-JtInvTimestamp -JtConfig $JtConfig -Label "poster"
}

class JtInvRecover : JtInv {

    [JtIoFolder]$Folder_Common
    [JtIoFolder]$Folder_C_Inv

    JtInvRecover([JtConfig]$JtConfig) : Base($JtConfig) {
        $This.ClassName = "JtInvRecover"
    }

    
    [Boolean]DoIt() {
        $This.DoLogRepoStart()
        
        [Xml]$ConfigXml = $This.GetConfigXml()

        if ($Null -eq $ConfigXml) {
            return $False
        }

        foreach ($Entity in $ConfigXml.getElementsByTagName("folder")) {
            # [String]$JtInfo = $Entity.'#text'
    
            [String]$Source = $Entity.source
            $Source = ConvertTo-JtExpandedPath $Source
            [JtIoFile]$Snafile = [JtIoFile]::new($Source)
            if (!($Snafile.IsExisting())) {
                Write-JtError -Text ( -join ("Error!!! File missing; please edit XML for:", $Snafile.GetPath()))
                return $False
            }
            Write-JtLog -Text ( -join ("Source:", $Snafile.GetPath()))
                        
            [Int32]$Disk = $entity.disk
            [Int32]$Partition = $entity.partition
            [String]$Computer = $entity.computer
            [String]$System = $entity.system
            [Boolean]$BlnSystem = $False
            if (("true").Equals($System)) {
                $BlnSystem = $True
            }
                    
            Write-JtLog -Text ( -join ("Recover JtSnapshot. Disk:", $Disk, ", Partition:", $Partition, " Computer:", $Computer, ", Local folder:", $Source))

            [JtSnap_Recover]$JtSnap_Recover = [JtSnap_Recover]::new($Snafile, $Disk, $Partition, $Computer, $BlnSystem)
            $JtSnap_Recover.DoIt()
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

function New-JtInvRecover {

    Param (
        [Parameter(Mandatory = $false)]
        [JtConfig]$JtConfig
    )

    [JtConfig]$JtConfig = New-JtConfig
    [JtInvRecover]::new([JtConfig]$JtConfig) 

    New-JtInvTimestamp -JtConfig $JtConfig -Label "recover"
}

class JtInvRename : JtInv {

    [JtIoFolder]$Folder_Common
    [JtIoFolder]$Folder_C_Inv

    JtInvRename([JtConfig]$JtConfig) : Base($JtConfig) {
        $This.ClassName = "JtInvRename"
    }

    [Boolean]DoIt() {
        $This.DoLogRepoStart()
        
        [Xml]$ConfigXml = $This.GetConfigXml()

        if ($Null -eq $ConfigXml) {
            return $False
        }

        # Muss noch angepasst werden... 
        # BEGIN
 
        $SN = Get-WmiObject win32_bios | Select-Object -ExpandProperty SerialNumber
        Write-Host "SN:"$SN
 
        [String]$ComputerNameOld = $env:computername
        [String]$ComputerNameNew = $env:computername
 
        Switch ($SN ) {
            8YH8032 { $ComputerNameNew = "al-its-pc-f01"; break }
            1XH8032 { $ComputerNameNew = "al-its-pc-f02"; break }
            CZH8032 { $ComputerNameNew = "al-its-pc-f03"; break }
            FVH8032 { $ComputerNameNew = "al-its-pc-f04"; break }
            GWH8032 { $ComputerNameNew = "al-its-pc-f05"; break }
            DRH8032 { $ComputerNameNew = "al-its-pc-f06"; break }
            7SH8032 { $ComputerNameNew = "al-its-pc-f07"; break }
            FTH8032 { $ComputerNameNew = "al-its-pc-f08"; break }
            HTH8032 { $ComputerNameNew = "al-its-pc-f09"; break }
            CVH8032 { $ComputerNameNew = "al-its-pc-f10"; break }
            7VH8032 { $ComputerNameNew = "al-its-pc-f11"; break }
            1WH8032 { $ComputerNameNew = "al-its-pc-f12"; break }
            9ZH8032 { $ComputerNameNew = "al-its-pc-f13"; break }
            7TH8032 { $ComputerNameNew = "al-its-pc-f14"; break }
            6WH8032 { $ComputerNameNew = "al-its-pc-f15"; break }
            3ZH8032 { $ComputerNameNew = "al-its-pc-f16"; break }
            6XH8032 { $ComputerNameNew = "al-its-pc-f17"; break }
            5TH8032 { $ComputerNameNew = "al-its-pc-f18"; break }
            6SH8032 { $ComputerNameNew = "al-its-pc-f19"; break }
            9TH8032 { $ComputerNameNew = "al-its-pc-f20"; break }
            JXH8032 { $ComputerNameNew = "al-its-pc-f21"; break }
            3VH8032 { $ComputerNameNew = "al-its-pc-f22"; break }
            FXH8032 { $ComputerNameNew = "al-its-pc-f23"; break }
            CTH8032 { $ComputerNameNew = "al-its-pc-f24"; break }
            5VH8032 { $ComputerNameNew = "al-its-pc-f25"; break }
            DYH8032 { $ComputerNameNew = "al-its-pc-f26"; break }
            3SH8032 { $ComputerNameNew = "al-its-pc-f27"; break }
            1TH8032 { $ComputerNameNew = "al-its-pc-f28"; break }
            GSH8032 { $ComputerNameNew = "al-its-pc-f29"; break }
            2SH8032 { $ComputerNameNew = "al-its-pc-f30"; break }
            BSH8032 { $ComputerNameNew = "al-its-pc-f31"; break }
            HYH8032 { $ComputerNameNew = "al-its-pc-f32"; break }
            4TH8032 { $ComputerNameNew = "al-its-pc-f33"; break }
            1VH8032 { $ComputerNameNew = "al-its-pc-f34"; break }
            6ZH8032 { $ComputerNameNew = "al-its-pc-f35"; break }
     
            H3LX3G2 { $ComputerNameNew = "al-its-pc-g01"; break }
            H3M04G2 { $ComputerNameNew = "al-its-pc-g02"; break }
            H3M24G2 { $ComputerNameNew = "al-its-pc-g03"; break }
            H3M44G2 { $ComputerNameNew = "al-its-pc-g04"; break }
            H3MX3G2 { $ComputerNameNew = "al-its-pc-g05"; break }
            H3MY3G2 { $ComputerNameNew = "al-its-pc-g06"; break }
            H3N14G2 { $ComputerNameNew = "al-its-pc-g07"; break }
            H3NX3G2 { $ComputerNameNew = "al-its-pc-g08"; break }
            H3P04G2 { $ComputerNameNew = "al-its-pc-g09"; break }
            H3P44G2 { $ComputerNameNew = "al-its-pc-g10"; break }
            H3PY3G2 { $ComputerNameNew = "al-its-pc-g11"; break }
            # Nach Mainboard-Tausch in 10.2018 Namen getauscht: g12 und g19
            H3SW3G2 { $ComputerNameNew = "al-its-pc-g12"; break }
            H3QY3G2 { $ComputerNameNew = "al-its-pc-g13"; break }
            H3R14G2 { $ComputerNameNew = "al-its-pc-g14"; break }
            H3R34G2 { $ComputerNameNew = "al-its-pc-g15"; break }
            H3RX3G2 { $ComputerNameNew = "al-its-pc-g16"; break }
            H3RZ3G2 { $ComputerNameNew = "al-its-pc-g17"; break }
            H3S14G2 { $ComputerNameNew = "al-its-pc-g18"; break }
            # Nach Mainboard-Tausch in 10.2018 Namen getauscht: g12 und g19
            H3Q34G2 { $ComputerNameNew = "al-its-pc-g19"; break }
            H3SZ3G2 { $ComputerNameNew = "al-its-pc-g20"; break }
    
            1WM7MZ2 { $ComputerNameNew = "al-its-pc-h01"; break }
            JWM7MZ2 { $ComputerNameNew = "al-its-pc-h02"; break } 
            JVM7MZ2 { $ComputerNameNew = "al-its-pc-h03"; break } 
            HWM7MZ2 { $ComputerNameNew = "al-its-pc-h04"; break } 
            HVM7MZ2 { $ComputerNameNew = "al-its-pc-h05"; break } 
            GWM7MZ2 { $ComputerNameNew = "al-its-pc-h06"; break } 
            GVM7MZ2 { $ComputerNameNew = "al-its-pc-h07"; break } 
            FWM7MZ2 { $ComputerNameNew = "al-its-pc-h08"; break } 
            FVM7MZ2 { $ComputerNameNew = "al-its-pc-h09"; break } 

            DWM7MZ2 { $ComputerNameNew = "al-its-pc-h10"; break } 
            DVM7MZ2 { $ComputerNameNew = "al-its-pc-h11"; break } 
            CWM7MZ2 { $ComputerNameNew = "al-its-pc-h12"; break } 
            CVM7MZ2 { $ComputerNameNew = "al-its-pc-h13"; break } 
            BWM7MZ2 { $ComputerNameNew = "al-its-pc-h14"; break } 
            BVM7MZ2 { $ComputerNameNew = "al-its-pc-h15"; break } 
            9XM7MZ2 { $ComputerNameNew = "al-its-pc-h16"; break } 
            9WM7MZ2 { $ComputerNameNew = "al-its-pc-h17"; break } 
            9VM7MZ2 { $ComputerNameNew = "al-its-pc-h18"; break } 
            8XM7MZ2 { $ComputerNameNew = "al-its-pc-h19"; break } 
            8WM7MZ2 { $ComputerNameNew = "al-its-pc-h20"; break } 
    
            8VM7MZ2 { $ComputerNameNew = "al-its-pc-h21"; break } 
            7XM7MZ2 { $ComputerNameNew = "al-its-pc-h22"; break }
            7WM7MZ2 { $ComputerNameNew = "al-its-pc-h23"; break }
            7VM7MZ2 { $ComputerNameNew = "al-its-pc-h24"; break }
            6XM7MZ2 { $ComputerNameNew = "al-its-pc-h25"; break }
            6WM7MZ2 { $ComputerNameNew = "al-its-pc-h26"; break }
            6VM7MZ2 { $ComputerNameNew = "al-its-pc-h27"; break }
            5XM7MZ2 { $ComputerNameNew = "al-its-pc-h28"; break }
            5WM7MZ2 { $ComputerNameNew = "al-its-pc-h29"; break }
            5VM7MZ2 { $ComputerNameNew = "al-its-pc-h30"; break }
    
            4XM7MZ2 { $ComputerNameNew = "al-its-pc-h31"; break }
            4WM7MZ2 { $ComputerNameNew = "al-its-pc-h32"; break }
            4VM7MZ2 { $ComputerNameNew = "al-its-pc-h33"; break }
            3XM7MZ2 { $ComputerNameNew = "al-its-pc-h34"; break }
            3WM7MZ2 { $ComputerNameNew = "al-its-pc-h35"; break }
            2XM7MZ2 { $ComputerNameNew = "al-its-pc-h36"; break }
            2WM7MZ2 { $ComputerNameNew = "al-its-pc-h37"; break }
            1XM7MZ2 { $ComputerNameNew = "al-its-pc-h38"; break }
    
    
            82WLBS2 { $ComputerNameNew = "al-its-pc-h39"; break }
            76WLBS2 { $ComputerNameNew = "al-its-pc-h40"; break }
    
            Default { "Serial not defined."; $ComputerNameNew = $ComputerNameOld }
        }


        Write-Host "Aktueller Name:" $env:computername
        Write-Host "Neuer     Name:" $ComputerNameNew 

        Switch ($ComputerNameNew ) {
            $ComputerNameOld { Write-Host "Keine Aenderung." ; break }
            Default { Write-Host "Umbenennen in:" $ComputerNameNew; RENAME-COMPUTER -computer $ComputerNameOld -newname $ComputerNameNew; RESTART-COMPUTER -force }
        }


        return $True
    }

    [String]GetConfigName() {
        return "JtInvRENAME"
    }
    
    [String]GetReportLabel() {
        return "rename"
    }


}

function New-JtInvRename {

    Param (
        [Parameter(Mandatory = $false)]
        [JtConfig]$JtConfig
    )

    [JtConfig]$JtConfig = New-JtConfig
    [JtInvRename]::new([JtConfig]$JtConfig) 

    New-JtInvTimestamp -JtConfig $JtConfig -Label "rename"
}




class JtInvJtSnapshot : JtInv {

    [JtIoFolder]$Folder_Common
    [JtIoFolder]$Folder_C_Inv

    JtInvJtSnapshot([JtConfig]$JtConfig) : Base($JtConfig) {
        $This.ClassName = "JtInvJtSnapshot"
        $This.Folder_Common = $JtConfig.Get_JtIoFolder_Common()
        $This.Folder_C_Inv = $JtConfig.Get_JtIoFolder_Inv()
    }

    [Boolean]DoIt() {
        $This.DoLogRepoStart()
        
        [Xml]$ConfigXml = $This.GetConfigXml()

        if ($Null -eq $ConfigXml) {
            return $False
        }
        foreach ($Entity in $ConfigXml.getElementsByTagName("folder")) {
            # [String]$JtInfo = $Entity.'#text'

            [String]$Target = $Entity.target
            $Target = ConvertTo-JtExpandedPath $Target
            [JtIoFolder]$FolderExport = [JtIoFolder]::new($Target)
            if (!($FolderExport.IsExisting())) {
                Write-JtError -Text ( -join ("Error!!! Folder missing; please edit XML for:", $FolderExport.GetPath()))
                return $False
            }
                        
            [Int32]$Disk = $entity.disk
            [Int32]$Partition = $entity.partition

            Write-JtLog -Text ( -join ("Creating JtSnapshot. Drive:", $Disk, ", Partition:", $Partition, ", Local folder:", $Target))

            [JtSnapshot]$JtSnapshot = [JtSnapshot]::new($FolderExport)
            $JtSnapshot.DoJtSnapPart($Disk, $Partition)
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


function New-JtInvJtSnapshot {

    Param (
        [Parameter(Mandatory = $false)]
        [JtConfig]$JtConfig
    )

    [JtConfig]$JtConfig = New-JtConfig
    [JtInvJtSnapshot]::new([JtConfig]$JtConfig) 
    New-JtInvTimestamp -JtConfig $JtConfig -Label "JtSnapshot"
}






class JtInvWol : JtInv {

    [String]$WolExe = "C:\apps\al\archland\tasks\_wol\wol.exe"

    JtInvWol([JtConfig]$JtConfig) : Base($JtConfig) {
        $This.ClassName = "JtInvWol"
        # Output goes directly to "c:\_inventory\report"
    }
    
    [Boolean]DoWol($Name, $Mac) {
        [String]$MyCommand = ""
        [String]$Label = ""

        [String]$Label = "wol"
        $MyCommand = -join ($This.WolExe, ' ', $Mac)
        Write-JtLog -Text ("Trying to wake device ", $Name, " with MAC:", $Mac, " ...")
        Invoke-Expression -Command:$MyCommand

        return $True
    }

    [Boolean]DoIt() {
        $This.DoLogRepoStart()
        
        [Xml]$ConfigXml = $This.GetConfigXml()

        if ($Null -eq $ConfigXml) {
            return $False
        }
        foreach ($entity in $ConfigXml.getElementsByTagName("device")) {

            [String]$Device = $entity.'#text'

            [String]$Name = $entity.name
            [String]$Mac = $entity.mac
            [String]$Ip = $entity.ip

            Write-JtLog -Text ( -join (" Name:", $Name, " Mac:", $Mac, " IP:", $Ip, "  ... DEVICE:", $Device))
            $This.DoWol($Name, $Mac)
        }
        return $true
    }
 

    [String]GetConfigName() {
        return "JtInvWOL"
    }

    [String]GetReportLabel() {
        return "wol"
    }



}

function New-JtInvWol {

    Param (
        [Parameter(Mandatory = $false)]
        [JtConfig]$JtConfig
    )

    [JtInvWol]::new([JtConfig]$JtConfig) 

New-JtInvTimestamp -JtConfig $JtConfig -Label "wol"

}


class JtInvMasterCombine : JtInv {

    
    JtInvMasterCombine([JtConfig]$JtConfig) : Base($JtConfig) {
        $This.ClassName = "JtInvMasterCombine"
    }

    [Boolean]DoIt() {
        $This.DoLogRepoStart()
        
        [Xml]$ConfigXml = $This.GetConfigXml()

        if ($Null -eq $ConfigXml) {
            return $False
        }

        [System.Collections.ArrayList]$CsvFiles = $This.FolderBase.GetJtIoFilesCsv()

        # [JtIoFolder]$FolderReports = $null
        # [JtIoFolder]$FolderCombine = $null


        [JtIoFolder]$FolderSource = $null
        [JtIoFolder]$FolderExport = $null

        foreach ($Entity in $ConfigXml.getElementsByTagName("folder")) {
            # [String]$JtInfo = $Entity.'#text'

            [String]$Source = $Entity.source
            $Source = ConvertTo-JtExpandedPath $Source
            [JtIoFolder]$FolderSource = [JtIoFolder]::new($Source)
            Write-JtLog -Text ( -join ("FolderSource (reports):", $FolderSource.GetPath()))
                
            [String]$Target = $Entity.target
            $Target = ConvertTo-JtExpandedPath $Target

   

            [JtIoFolder]$FolderExport = [JtIoFolder]::new($Target, $True)
            Write-JtLog -Text ( -join ("FolderExport (combine):", $FolderExport.GetPath()))
        }

        if ($Null -eq $FolderSource) {
            Write-JtError -Text ("Error!!! FolderSource is null")
            return $False
        }
        elseif ($False -eq $FolderSource.IsExisting()) {
            Write-JtError -Text ( -join ("Error!!! FolderSource missing; please edit XML for:", $FolderSource.GetPath()))
            return $False
        }

        if ($Null -eq $FolderExport) {
            Write-JtError -Text ( -join ("Error!!! FolderExport missing; please edit XML for:", $FolderExport.GetPath()))
            return $False
        }
        elseif ($False -eq $FolderExport.IsExisting()) {
            Write-JtError -Text ( -join ("Error!!! FolderExport missing; please edit XML for:", $FolderExport.GetPath()))
            return $False
        }

        [System.Collections.ArrayList]$SelectionFiles = $CsvFiles
        if ($SelectionFiles.Count -gt 0) {
            ForEach ($MyFile in $SelectionFiles) {
                [JtIoFile]$SelectionFile = $MyFile

                [String]$ColumnName = "SystemId"

                [JtIoFileCsv]$JtIoFileCsv = New-JtIoFileCsv -Path $SelectionFile.GetPath()
                [System.Collections.ArrayList]$Elements = $JtIoFileCsv.GetSelection($ColumnName)
                $Elements
    
                # [String]$SelectionFilename = [System.IO.Path]::GetFileName($SelectionFilePath)
                [String]$SelectionFilename = $SelectionFile.GetName()
                $SelectionNameParts = $SelectionFilename.Split(".")
    
                [String]$SelectionLabel = $SelectionNameParts[1]
    
                [JtCsvTool]$JtCsvTool = [JtCsvTool]::new($FolderSource, $FolderExport, $SelectionLabel, $Elements)
                $JtCsvTool.DoIt()
            }
        }

        [JtCsvTool]$JtCsvTool = [JtCsvTool]::new($FolderSource, $FolderExport)
        $JtCsvTool.DoIt()
        return $False
    }

    [String]GetConfigName() {
        return "JtInvCOMBINE"
    }

    [String]GetReportLabel() {
        return "combine"
    }

}


Function New-JtInvCombine {
    Param (
        [Parameter(Mandatory = $false)]
        [JtConfig]$JtConfig
        )
        
        
        [JtConfig]$JtConfig = New-JtConfig
        [JtInvMasterCombine]::new([JtConfig]$JtConfig) 
}





class JtInvMasterReports : JtInv {

    JtInvMasterReports([JtConfig]$JtConfig) : Base($JtConfig) {
        $This.ClassName = "JtInvMasterReports"
    }

    [Boolean]DoIt() {
        $This.DoLogRepoStart()
        
        [Xml]$ConfigXml = $This.GetConfigXml()

        if ($Null -eq $ConfigXml) {
            return $False
        }
        foreach ($Entity in $ConfigXml.getElementsByTagName("folder")) {
            # [String]$JtInfo = $Entity.'#text'

            [String]$Source = $Entity.source
            $Source = ConvertTo-JtExpandedPath $Source
            [JtIoFolder]$FolderSource = [JtIoFolder]::new($Source)
            if (!($FolderSource.IsExisting())) {
                Write-JtError -Text ( -join ("Error!!! Source is missing; please edit XML for:", $FolderSource.GetPath()))
                return $False
            }

            # [String]$Target = $Entity.target
            # $Target = $Target.Replace("%OneDrive%", $env:OneDrive)
            # [JtIoFolder]$FolderExport = [JtIoFolder]::new($Target)
            # if (!($FolderExport.IsExisting())) {
            #     Write-JtError -Text ( -join ("Error!!! Target missing; please edit XML for:", $FolderExport.GetPath()))
            #     return $False
            # }
                
            Write-JtLog -Text ( -join ("Using FolderSource (for reports):", $FolderSource.GetPath()))
            $Subfolders = $FolderSource.GetSubfolders($False)
            foreach ($Folder in $Subfolders) {
                Write-JtLog -Text ( -join ("DoIt for report:", $Folder.GetPath()))
                        
                New-JtCsvGenerator -JtIoFolder $Folder
            }
        }
        return $True
    }


    [String]GetConfigName() {
        return "JtInvClientReportS"
    }
  
    [String]GetReportLabel() {
        return "reports"
    }
}

Function New-JtInvClientReports {
    Param (
        [Parameter(Mandatory = $false)]
        [JtConfig]$JtConfig
        )
        
        [JtConfig]$JtConfig = New-JtConfig
        [JtInvMasterReports]::new([JtConfig]$JtConfig) 

    return $Gen.DoIt()
}


class FileElementXml : JtClass {

    hidden [xml]$Xml = $Null
    
    FileElementXml([JtIoFile]$JtIoFile) {
        [String]$FilePathXml = $JtIoFile.GetPath()
        [xml]$This.Xml = Get-Content $FilePathXml -Encoding UTF8
    } 

    [String]GetValuePath() {
        [String]$TagName = "path"
        [String]$ThePath = ""
        [xml]$XmlContent = $This.GetXml()
        ForEach ($entity in $XmlContent.getElementsByTagName($TagName)) {
            [String]$ThePath = $entity.'#text'
                
            $ThePath = $ThePath.Replace("%OneDrive%", $env:OneDrive)
            return $ThePath
        }
        return $ThePath
    }

    [System.Collections.ArrayList]GetValueListPaths() {
        [System.Collections.ArrayList]$ArrayList = [System.Collections.ArrayList]::new()
        [String]$TagName = "path"
        [String]$ThePath = ""
        [Xml]$XmlContent = $This.GetXml()
        ForEach ($entity in $XmlContent.getElementsByTagName($TagName)) {
            [String]$ThePath = $entity.'#text'
                
            $ThePath = $ThePath.Replace("%OneDrive%", $env:OneDrive)
            $ArrayList.Add($ThePath)
        }
        return $ArrayList
    }

    [String]GetValueForTag([String]$TagName) {
        [String]$Result = ""
        [xml]$XmlContent = $This.GetXml()
        ForEach ($entity in $XmlContent.getElementsByTagName($TagName)) {
            [String]$Result = $entity.'#text'
            $Result = $Result.Replace("%OneDrive%", $env:OneDrive)
            return $Result
        }
        return $Result
    }

    [Xml]GetXml() {
        return $This.Xml
    } 
} 



class Gen_Csvs_To_CsvsAll : JtClass {

    [JtIoFolder]$Source

    
    static hidden [Boolean]DoJoinCsvs([System.Collections.ArrayList]$CsvFiles, [JtIoFolder]$FolderOut, [String]$MyLabel) {
        [JtTblTable]$JtTblTable = New-JtTblTable -Label $MyLabel
        foreach ($CsvFile in $CsvFiles) {
            [JtIoFile]$JtIoFile = $CsvFile
            [String]$Filename = $JtIoFile.GetName() 
            if (! ($Filename.StartsWith("all"))) {
                $CsvFilePath = $JtIoFile.GetPath()
                $Content = Import-Csv -Path $CsvFilePath -Delimiter ([JtUtil]::Delimiter)  
                $Content
                
                [JtTblRow]$JtTblRow = New-JtTblRow
                foreach ($Field in $Content) {
                    foreach ($Element in $Field | Get-Member) {
                        if ($element.MemberType -eq "NoteProperty") {
                            $Name = $element.Name
    
                            $FieldLabel = $Element.Name
                            $FieldValue = $Field.$Name
    
                            [JtField]$JtField = New-JtField -Label $FieldLabel
                            $JtField.SetValue($FieldValue)
    
                            $JtTblRow.Add($JtField)
                        }
                    }
                }
                $JtTblTable.AddRow($JtTblRow) | Out-Null
            }
        }

        New-JtCsvWriteTbl -Label $MyLabel -JtIoFolder $FolderOut -JtTblTable $JtTblTable
        return $True
    }  


    Gen_Csvs_To_CsvsAll([JtIoFolder]$MySource) {
        $This.ClassName = "Gen_Csvs_To_CsvsAll"
        $This.Source = $MySource
    }

    [Boolean]DoIt() {
        $This.DoLogRepoStart()

        [JtIoFolder]$FolderCsv = $This.Source.GetSubfolder("csv")
        [System.Collections.ArrayList]$CsvFiles = $FolderCsv.GetJtIoFiles()

        [String]$MyLabel = "all"

        [JtIoFolder]$FolderTarget = $This.Source
        [Gen_Csvs_To_CsvsAll]::DoJoinCsvs($CsvFiles, $FolderTarget, $MyLabel)

        return $True
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
        [Parameter(ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $true, Mandatory = $true, Position = 1)]
        [String[]]$Name
    )
    Begin {

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
            Write-JtError -Message "Unable to contact $Name. Please verify its network connectivity and try again." -Category ObjectNotFound -TargetObject $Computer
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
            if ($regKey -ne $null) {
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


Function New-JtInvMaster {
    New-JtInvCombine
    New-JtInvClientReports
}



Function New-JtInvVersion {
    New-JtRobocopy -Source "%OneDrive%\0.INVENTORY\common" -Target "D:\Seafile\al-apps\apps\inventory\common"
    [String]$Timestamp = Get-JtTimestamp
    New-JtIoFileMeta -Path "%OneDrive%\0.INVENTORY\common" -Label $Timestamp
pause
}


