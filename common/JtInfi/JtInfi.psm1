using module JtClass
using module JtIo
using module JtTime
using module JtUtil
using module JtInf_AFolder
using module JtInf_Bitlocker
using module JtInf_Soft
using module JtInf_Win32Bios
using module JtInf_Win32ComputerSystem
using module JtInf_Win32LogicalDisk
using module JtInf_Win32NetworkAdapter
using module JtInf_Win32OperatingSystem
using module JtInf_Win32Processor
using module JtInf_Win32VideoController

class JtInfi : JtClass {
    
    hidden [JtIoFolder]$JtIoFolder

    hidden [Boolean]$Valid = $False
    hidden [Boolean]$IsValidCsv = $False
    hidden [Boolean]$IsValidXml = $False

    hidden [JtInf_AFolder]$Cache_JtInf_AFolder = $Null
    hidden [JtInf_Bitlocker]$Cache_JtInf_Bitlocker = $Null
    hidden [JtInf_Soft]$Cache_JtInf_Soft = $Null
    hidden [JtInf_Win32Bios]$Cache_JtInf_Win32Bios = $Null
    hidden [JtInf_Win32ComputerSystem]$Cache_JtInf_Win32ComputerSystem = $Null
    hidden [JtInf_Win32LogicalDisk]$Cache_JtInf_Win32LogicalDisk = $Null
    hidden [JtInf_Win32NetworkAdapter]$Cache_JtInf_Win32NetworkAdapter = $Null
    hidden [JtInf_Win32OperatingSystem]$Cache_JtInf_Win32OperatingSystem = $Null
    hidden [JtInf_Win32Processor]$Cache_JtInf_Win32Processor = $Null
    hidden [JtInf_Win32VideoController]$Cache_JtInf_Win32VideoController = $Null

    static [String]GetAliasForComputername([String]$Name) {
        [String]$Out = $Name
        # if ($In -eq "PC-3XTM5Y1") {
        #     $Out = "AL-DEK-PC-DEK05"
        # }
        return $Out
    }

    static [String]GetJtVersion([String]$Path) {
        [String]$MyExtension = -join (".version", [JtIo]::FilenameExtension_Meta)
        [String]$MyFilter = -join ("*", $MyExtension)

        [JtIoFolder]$TheIoFolder = [JtIoFolder]::new($Path)
        [System.Collections.ArrayList]$Files = $TheIoFolder.GetJtIoFilesWithFilter([String]$MyFilter) 
        
        [String]$Out = "not found"
        if ($Files.Count -eq 1) {
            [JtIoFile]$JtIoFile = $Files[0]
            $Out = $JtIoFile.GetName()

            $Out = $Out.Replace($MyExtension, "")
            $Out = $Out.Replace("report.", "")
        }

        return $Out
    }

    static [String]GetDateForKlon([String]$Filename) {
        [String]$Result = ""

        if ($Null -eq $Filename) {

        }
        else {
            [String]$MySuffix = -join (".", "klon", [JtIo]::FilenameExtension_Meta)
            $Result = $Filename.Replace($MySuffix, "")
            $Result = $Result.Replace("_", "")
        }
 
        return $Result
    }

    static [int16]GetDaysAgo([String]$Path) {
        [int16]$Ago = 0

        if ([JtInfi]::GetTheTimestamp($Path) -ne "") {
            $FileDate = [JtIoFolder]::GetReportFolderDateTime($Path)
            $TypeName = $FileDate.getType().Name

            if ($TypeName -eq "DateTime") {
                $TimeAgo = (Get-Date) - ($FileDate)
                $Ago = $TimeAgo.Days
            }
            else {
                $Ago = 0
            }
        }
        return $Ago
    }

    static [String]GetIp([String]$Path) {
        [String]$MyIp = ""
        [String]$pathIpconfig = -join ($Path, "\", [JtIo]::FilenamePrefix_Report, ".", "ip", [JtIo]::FilenameExtension_Meta) 
        if (Test-Path ($pathIpconfig)) {
            [String]$conIpconfig = Get-Content -Path $pathIpconfig
            $line = $conIpconfig
            $MyIp = $line
        }
        return $MyIp
    }
    
    static [String]GetKlonVersion([String]$Path) {
        [String]$Result = "---"
        
        [String]$Match = -join ('_*.klon', [JtIo]::FilenameExtension_Meta)
        
        $MyKlonMetaFiles = Get-ChildItem -Path $Path | Where-Object { $_.Name -match $Match }
        
        if ($Null -ne $MyKlonMetaFiles) {
            if ($MyKlonMetaFiles.Length -gt 0) {
                $File1 = $MyKlonMetaFiles[0]
                $Result = [JtInfi]::GetDateForKlon($File1)
            }
        }
        return $Result
    }

    static [String]GetMasterUser([String]$Path) {
        [String]$Result = "---"
        
        [String]$Match = -join ([JtIo]::FilenamePrefix_Report, '.*.', 'user', [JtIo]::FilenameExtension_Meta)
        
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
    
    static [String]GetOrg1ForComputername([String]$Computername) {
        [String]$Result = ""
        if ($Null -eq $Computername) {
            
        }
        else {
            [String[]]$Parts = $Computername.Split("-")
            if ($Parts.Count -gt 2) {
                $Result = $Parts[0]
            }
        }
        return $Result
    }
    
    static [String]GetOrg2ForComputername([String]$Computername) {
        [String]$Result = ""
        if ($Null -eq $Computername) {
            
        }
        else {
            [String[]]$Parts = $Computername.Split("-")
            if ($Parts.Count -gt 2) {
                $Result = $Parts[1]
            }
        }
        return $Result
    }

    static [String]GetTheTimestamp([String]$Path) {
        [String]$TypeName = ""
        [String]$Stamp = ""
        $FileDate = [JtIoFolder]::GetReportFolderDateTime($Path)
        $TypeName = $FileDate.getType().Name
        if ($TypeName -eq "DateTime") {
            $Stamp = $FileDate.toString([JtIo]::TimestampFormat) 
        }
        return $Stamp
    }
    
    static [String]GetTypeForComputername([String]$Computername) {
        [String]$Result = ""
        if ($Null -eq $Computername) {
            
        }
        else {
            [String[]]$Parts = $Computername.Split("-")
            if ($Parts.Count -gt 3) {
                $Result = $Parts[2]
            }
        }
        return $Result
    }
    
    static [String]GetWinVersion([String]$Path) {
        [String]$WinV = ""
        [String]$pathWinMeta = -join ($Path, "\", [JtIo]::FilenamePrefix_Report, ".", "win", [JtIo]::FilenameExtension_Meta) 
        if (Test-Path ($pathWinMeta)) {
            [String]$conWinMet = Get-Content -Path $pathWinMeta
            $winMetParts = $conWinMet.Split(" ")
            if ($winMetParts.Length -ge 4) {
                $winVer = $winMetParts[4]
                
                $winVer = $winVer.Replace("]", "")
                $WinV = $winVer
            }
        }
        return $WinV
    }

    static [String]GetWinVersionBuild([String]$WinVersion) {
        [String]$Result = 0
        if ($Null -eq $WinVersion) {
 
        }
        else {
            [String[]]$Parts = $WinVersion.Split(".")
            if ($Parts.Count -gt 3) {
                $Result = $Parts[3]
            }
        }
        return $Result
    }

    static [String]GetWinVersionGen([String]$WinVersion) {
        [String]$Result = 0
        if ($Null -eq $WinVersion) {
     
        }
        else {
            [String[]]$Parts = $WinVersion.Split(".")
            if ($Parts.Count -gt 3) {
                $Result = $Parts[2]
            }
        }
        return $Result
    }

    JtInfi([JtIoFolder]$MyJtIoFolder) : base() {
        $This.ClassName = "JtInfi"   
        $This.JtIoFolder = $MyJtIoFolder

        #  New-JtInit_Inf_AFolder -JtIoFolder $This.JtIoFolder 
    }

    [Boolean]GetIsNormalBoot() {
        # Example: For al-dek-nb-dek05.win10p the result should be: $True
        # Example: For al-its-pc-h38.win10p the result should be: $True
        # Example: For al-its-pc-h38.win10p-spezial the result should be: $False

        [Boolean]$Result = $True
        [Boolean]$Spezial = $This.GetJtInf_AFolder().SystemId.GetValue().Contains("spezial")
        if ($True -eq $Spezial) {
            $Result = $False
        }
        return $Result
    }
    
    [JtInf_AFolder]GetJtInf_AFolder() {
        [JtInf_Afolder]$JtInf = $This.Cache_JtInf_AFolder
        if ($Null -eq $JtInf) {
            [JtInf_Afolder]$JtInf = New-JtInit_Inf_AFolder -JtIoFolder $This.GetFolder()
            $This.Cache_JtInf_AFolder = $JtInf
        }
        return $JtInf
    }

    [JtInf_Bitlocker]GetJtInf_Bitlocker() {
        [JtInf_Bitlocker]$JtInf = $This.Cache_JtInf_Bitlocker
        if ($Null -eq $JtInf) {
            [JtInf_Bitlocker]$JtInf = New-JtInit_Inf_Bitlocker -JtIoFolder $This.GetFolder()
            $This.Cache_JtInf_Bitlocker = $JtInf
        }
        return $JtInf
    }
    
    [JtInf_Soft]GetJtInf_Soft() {
        [JtInf_Soft]$JtInf = $This.Cache_JtInf_Soft
        if ($Null -eq $JtInf) {
            [JtInf_Soft]$JtInf = New-JtInit_Inf_Soft -JtIoFolder $This.GetFolder()
            $This.Cache_JtInf_Soft = $JtInf
        }
        return $JtInf
    }

    [JtInf_Win32Bios]GetJtInf_Win32Bios() {
        [JtInf_Win32Bios]$JtInf = $This.Cache_JtInf_Win32Bios
        if ($Null -eq $JtInf) {
            [JtInf_Win32Bios]$JtInf = New-JtInit_Inf_Win32Bios -JtIoFolder $This.GetFolder()
            $This.Cache_JtInf_Win32Bios = $JtInf
        }
        return $JtInf
    }
    
    [JtInf_Win32ComputerSystem]GetJtInf_Win32ComputerSystem() {
        [JtInf_Win32ComputerSystem]$JtInf = $This.Cache_JtInf_Win32ComputerSystem
        if ($Null -eq $JtInf) {
            [JtInf_Win32ComputerSystem]$JtInf = New-JtInit_Inf_Win32ComputerSystem -JtIoFolder $This.GetFolder()
            $This.Cache_JtInf_Win32ComputerSystem = $JtInf
        }
        return $JtInf
    }
    
    [JtInf_Win32LogicalDisk]GetJtInf_Win32LogicalDisk() {
        [JtInf_Win32LogicalDisk]$JtInf = $This.Cache_JtInf_Win32LogicalDisk
        if ($Null -eq $JtInf) {
            [JtInf_Win32LogicalDisk]$JtInf = New-JtInit_Inf_Win32LogicalDisk -JtIoFolder $This.GetFolder()
            $This.Cache_JtInf_Win32LogicalDisk = $JtInf
        }
        return $JtInf
    }
    
    [JtInf_Win32NetworkAdapter]GetJtInf_Win32NetworkAdapter() {
        [JtInf_Win32NetworkAdapter]$JtInf = $This.Cache_JtInf_Win32NetworkAdapter
        if ($Null -eq $JtInf) {
            [JtInf_Win32NetworkAdapter]$JtInf = New-JtInit_Inf_Win32NetworkAdapter -JtIoFolder $This.GetFolder()
            $This.Cache_JtInf_Win32NetworkAdapter = $JtInf
        }
        return $JtInf
    }
    
    [JtInf_Win32OperatingSystem]GetJtInf_Win32OperatingSystem() {
        [JtInf_Win32OperatingSystem]$JtInf = $This.Cache_JtInf_Win32OperatingSystem
        if ($Null -eq $JtInf) {
            [JtInf_Win32OperatingSystem]$JtInf = New-JtInit_Inf_Win32OperatingSystem -JtIoFolder $This.GetFolder()
            $This.Cache_JtInf_Win32OperatingSystem = $JtInf
        }
        return $JtInf
    }
    
    [JtInf_Win32Processor]GetJtInf_Win32Processor() {
        [JtInf_Win32Processor]$JtInf = $This.Cache_JtInf_Win32Processor
        if ($Null -eq $JtInf) {
            [JtInf_Win32Processor]$JtInf = New-JtInit_Inf_Win32Processor -JtIoFolder $This.GetFolder()
            $This.Cache_JtInf_Win32Processor = $JtInf
        }
        return $JtInf
    }

    [JtInf_Win32VideoController]GetJtInf_Win32VideoController() {
        [JtInf_Win32VideoController]$JtInf = $This.Cache_JtInf_Win32VideoController
        if ($Null -eq $JtInf) {
            [JtInf_Win32VideoController]$JtInf = New-JtInit_Inf_Win32VideoController -JtIoFolder $This.GetFolder()
            $This.Cache_JtInf_Win32VideoController = $JtInf
        }
        return $JtInf
    }

    [JtIoFolder]GetFolder() {
        return $This.JtIoFolder
    }

    [String]GetOutput() {
        $This.GetJtInf_AFolder()
        $This.GetJtInf_Bitlocker()
        $This.GetJtInf_Soft()
        $This.GetJtInf_Win32Bios()
        $This.GetJtInf_Win32ComputerSystem()
        $This.GetJtInf_Win32LogicalDisk()
        $This.GetJtInf_Win32NetworkAdapter()
        $This.GetJtInf_Win32OperatingSystem()
        $This.GetJtInf_Win32Processor()
        $This.GetJtInf_Win32VideoController()
        return "output"
    }
    
    [Boolean]IsValid() {
        return $This.GetJtInf_AFolder().IsValid()
    }

    # [System.Object]ObjectCsv([String]$Name) {
    #     # [String]$Name = $This.GetJtInf_AFolder().Name


    #     [String]$FilenameCsv = -Join ($Name, [JtIo]::FilenameExtension_Csv)
    #     [String]$FilePathCsv = $This.JtIoFolder.GetFilePath($FilenameCsv)

    #     [System.Object]$JtObject = $Null
    #     $This.IsValidCsv = $true
    #     if (Test-Path ($FilePathCsv)) {
    #         $JtObject = Import-LocalDataCsv $FilePathCsv -Delimiter ([JtUtil]::Delimiter)
    #         if ($null -eq $JtObject) {
    #             $This.IsValidCsv = $false
    #         }
    #     }
    #     else {
    #         $This.IsValidCsv = $false
    #     }
    #     return $JtObject
    # }
}    

Function New-JtInfi {
    Param (
        [Parameter(Mandatory = $true)]
        [JtIoFolder]$JtIoFolder
    )
        
    [JtInfi]::new($JtIoFolder)
}

Function Get-JtXmlReportObject([JtIoFolder]$JtIoFolder, [String]$Name) {
    [System.Object]$JtObject = $Null

    Write-JtLog ( -Join ("XmlReportObject - ", $JtIoFolder.GetPath()))
    
    [String]$FilenameXml = -Join ($Name, [JtIo]::FilenameExtension_Xml)
    [JtIoFolder]$FolderXml = $JtIoFolder.GetSubfolder("objects")
    [String]$FilePathXml = $FolderXml.GetFilePath($FilenameXml)
    Write-JtLog -Text ( -join ("FilePathXml:", $FilePathXml))
    if (Test-Path ($FilePathXml)) {
        try {
            $JtObject = Import-Clixml $FilePathXml
        }
        catch {
            Write-JtError -Text ( -join ("XmlReportObject; problem while reading Xml:", $FilePathXml))
        }
    }
    return [System.Object]$JtObject
}
