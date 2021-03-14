using module Jt
using module JtIo
using module JtTbl

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

    JtInfi([String]$TheFolderPath_Input) : base() {
        $This.ClassName = "JtInfi"

        [String]$MyFolderPath_Input = $TheFolderPath_Input
        [JtIoFolder]$MyJtIoFolder_Input = New-JtIoFolder -FolderPath $MyFolderPath_Input
        if (!($MyJtIoFolder_Input.IsExisting())) {
            Write-JtLog_Error -Where $This.ClassName -Text "MyJtIoFolder_Input does not exist"
            Throw "MyJtIoFolder_Input does not exist"
        }
        $This.JtIoFolder = $MyJtIoFolder_Input
        #  Get-JtInf_AFolder -JtIoFolder $This.JtIoFolder 
    }

    [Boolean]GetIsNormalBoot() {
        # Example: For al-dek-nb-dek05.win10p the result should be: $True
        # Example: For al-its-pc-h38.win10p the result should be: $True
        # Example: For al-its-pc-h38.win10p-spezial the result should be: $False

        [Boolean]$MyResult = $True
        [Boolean]$Spezial = $This.GetJtInf_AFolder().SystemId.GetValue().Contains("spezial")
        if ($True -eq $Spezial) {
            $MyResult = $False
        }
        return $MyResult
    }
    
    [JtInf_AFolder]GetJtInf_AFolder() {
        [JtInf_Afolder]$MyJtInf = $This.Cache_JtInf_AFolder
        if ($Null -eq $MyJtInf) {
            [JtInf_Afolder]$MyJtInf = Get-JtInf_AFolder -FolderPath $This.GetJtIoFolder()
            $This.Cache_JtInf_AFolder = $MyJtInf
        }
        return $MyJtInf
    }

    [JtInf_Bitlocker]GetJtInf_Bitlocker() {
        [JtInf_Bitlocker]$MyJtInf = $This.Cache_JtInf_Bitlocker
        if ($Null -eq $MyJtInf) {
            [JtInf_Bitlocker]$MyJtInf = Get-JtInf_Bitlocker -FolderPath $This.GetJtIoFolder()
            $This.Cache_JtInf_Bitlocker = $MyJtInf
        }
        return $MyJtInf
    }
    
    [JtInf_Soft]GetJtInf_Soft() {
        [JtInf_Soft]$MyJtInf = $This.Cache_JtInf_Soft
        if ($Null -eq $MyJtInf) {
            # $MyJtInf = Get-JtInf_Soft -FolderPath $This.GetJtIoFolder()
            # [JtInf_Soft]$MyJtInf = $MyJtInf[-1]
            [JtInf_Soft]$MyJtInf = Get-JtInf_Soft -FolderPath $This.GetJtIoFolder()
            $This.Cache_JtInf_Soft = $MyJtInf
        }
        return $MyJtInf
    }

    [JtInf_Win32Bios]GetJtInf_Win32Bios() {
        [JtInf_Win32Bios]$MyJtInf = $This.Cache_JtInf_Win32Bios
        if ($Null -eq $MyJtInf) {
            [JtInf_Win32Bios]$MyJtInf = Get-JtInf_Win32Bios -FolderPath $This.GetJtIoFolder()
            $This.Cache_JtInf_Win32Bios = $MyJtInf
        }
        return $MyJtInf
    }
    
    [JtInf_Win32ComputerSystem]GetJtInf_Win32ComputerSystem() {
        [JtInf_Win32ComputerSystem]$MyJtInf = $This.Cache_JtInf_Win32ComputerSystem
        if ($Null -eq $MyJtInf) {
            [JtInf_Win32ComputerSystem]$MyJtInf = Get-JtInf_Win32ComputerSystem -FolderPath $This.GetJtIoFolder()
            $This.Cache_JtInf_Win32ComputerSystem = $MyJtInf
        }
        return $MyJtInf
    }
    
    [JtInf_Win32LogicalDisk]GetJtInf_Win32LogicalDisk() {
        [JtInf_Win32LogicalDisk]$MyJtInf = $This.Cache_JtInf_Win32LogicalDisk
        if ($Null -eq $MyJtInf) {
            [JtInf_Win32LogicalDisk]$MyJtInf = Get-JtInf_Win32LogicalDisk -FolderPath $This.GetJtIoFolder()
            $This.Cache_JtInf_Win32LogicalDisk = $MyJtInf
        }
        return $MyJtInf
    }
    
    [JtInf_Win32NetworkAdapter]GetJtInf_Win32NetworkAdapter() {
        [JtInf_Win32NetworkAdapter]$MyJtInf = $This.Cache_JtInf_Win32NetworkAdapter
        if ($Null -eq $MyJtInf) {
            [JtInf_Win32NetworkAdapter]$MyJtInf = Get-JtInf_Win32NetworkAdapter -FolderPath $This.GetJtIoFolder()
            $This.Cache_JtInf_Win32NetworkAdapter = $MyJtInf
        }
        return $MyJtInf
    }
    
    [JtInf_Win32OperatingSystem]GetJtInf_Win32OperatingSystem() {
        [JtInf_Win32OperatingSystem]$MyJtInf = $This.Cache_JtInf_Win32OperatingSystem
        if ($Null -eq $MyJtInf) {
            [JtInf_Win32OperatingSystem]$MyJtInf = Get-JtInf_Win32OperatingSystem -FolderPath $This.GetJtIoFolder()
            $This.Cache_JtInf_Win32OperatingSystem = $MyJtInf
        }
        return $MyJtInf
    }
    
    [JtInf_Win32Processor]GetJtInf_Win32Processor() {
        [JtInf_Win32Processor]$MyJtInf = $This.Cache_JtInf_Win32Processor
        if ($Null -eq $MyJtInf) {
            [JtInf_Win32Processor]$MyJtInf = Get-JtInf_Win32Processor -FolderPath $This.GetJtIoFolder()
            $This.Cache_JtInf_Win32Processor = $MyJtInf
        }
        return $MyJtInf
    }

    [JtInf_Win32VideoController]GetJtInf_Win32VideoController() {
        [JtInf_Win32VideoController]$MyJtInf = $This.Cache_JtInf_Win32VideoController
        if ($Null -eq $MyJtInf) {
            [JtInf_Win32VideoController]$MyJtInf = Get-JtInf_Win32VideoController -FolderPath $This.GetJtIoFolder()
            $This.Cache_JtInf_Win32VideoController = $MyJtInf
        }
        return $MyJtInf
    }

    [JtIoFolder]GetJtIoFolder() {
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
}


class JtInf : JtClass {

    [JtFld]$Id
    [String]$JtInf_Name

    JtInf() {
        $This.ClassName = "JtInf"
        $This.Id = New-JtFld -Label "Id"
        $This.JtInf_Name = $This.GetType()
    }

    SetId([String]$MyId) {
        $This.Id.SetValue($MyId)
    }

    [String]GetKey() {
        [String]$Key = -Join ($This.Id.getValue(), ".", $This.Id)
        return $Key
    }

    [String]GetName() {
        return $This.JtInf_Name
    }

    [Object[]]GetProperties() {
        [Object[]]$Prop = Get-Member -InputObject $This -MemberType Property -force
        return $Prop 
    }

    [Boolean]SetObjValue([System.Object]$TheObj, [String]$TheFieldName, [String]$TheProp) {
        [System.Object]$MyObj = $TheObj
        [String]$MyFieldName = $TheFieldName
        [String]$MyProp = $TheProp

        if ($Null -ne $MyObj) {
            $This.($MyFieldName).SetValue($MyObj.($MyProp))
        }
        else {
            Write-JtLog_Error -Where $This.ClassName -Text "Obj is NULL, MyFieldName: $MyFieldName"
        }
        return $True
    }
}




class JtInf_AFolder : JtInf {

    [Boolean]$IsValid = $True

    [JtFld]$Name
    [JtFld]$JtVersion
    [JtFld]$Alias
    [JtFld]$Computername
    [JtFld]$DaysAgo
    [JtFld]$Errors
    [JtFld]$FolderPath
    [JtFld]$Ip
    [JtFld]$Ip3
    [JtFld]$KlonVersion
    [JtFld]$LabelC
    [JtFld]$Org
    [JtFld]$Org1
    [JtFld]$Org2
    [JtFld]$ReportExists
    [JtFld]$SystemId
    [JtFld]$Timestamp
    [JtFld]$Type
    [JtFld]$User
    [JtFld]$Win1
    [JtFld]$Win2
    [JtFld]$Win3
    [JtFld]$Win4
    [JtFld]$WinVer


    static [String]GetIp([String]$TheFolderPath) {
        return Get-JtReport_Value -FolderPath $TheFolderPath -Label "ip"
    }
    
    
    static [String]GetMasterUser([String]$TheFolderPath) {
        return Get-JtReport_Value -FolderPath $TheFolderPath -Label "user"
    }
    
    
    static [String]GetKlonVersion([String]$TheFolderPath) {
        [String]$MyFolderPath = $TheFolderPath
        [String]$MyResult = "---"
        
        [String]$MyMatch = -join ('_*.klon', [JtIo]::FileExtension_Meta)
        
        $MyAlFiles_Meta = Get-ChildItem -Path $MyFolderPath | Where-Object { $_.Name -match $MyMatch }
        
        if ($Null -ne $MyAlFiles_Meta) {
            if ($MyAlFiles_Meta.Length -gt 0) {
                $MyFile1 = $MyAlFiles_Meta[0]
                $MyResult = [JtIo]::GetDateForKlon($MyFile1)
            }
        }
        return $MyResult
    }
    
    
    static [String]GetTheTimestamp([String]$TheFolderPath) {
        [String]$MyFolderPath = $TheFolderPath
        [String]$MyTypeName = ""
        [String]$MyStamp = ""
        $MyDate = [JtIoFolder]::GetReportFolderDateTime($MyFolderPath)
        $MyTypeName = $MyDate.getType().Name
        if ($MyTypeName -eq "DateTime") {
            $MyStamp = $MyDate.toString([JtIo]::TimestampFormat) 
        }
        return $MyStamp
    }
    
    static [String]GetJtVersion([String]$TheFolderPath) {
        return Get-JtReport_Value -FolderPath $TheFolderPath -Label "jt"
    }
    
    
    static [String]GetWinVer([String]$TheFolderPath) {
        [String]$MyValue = Get-JtReport_Value -FolderPath $TheFolderPath -Label "winver"
        [String]$MyWinVer = $MyValue.Replace("-", ".")
        return $MyWinVer
    }

    JtInf_AFolder() {
        $This.ClassName = "JtInf_AFolder"

        $This.Name = New-JtFld -Label "Name"
        $This.JtVersion = New-JtFld -Label "JtVersion"
        $This.Alias = New-JtFld -Label "Alias"
        $This.Computername = New-JtFld -Label "Computername"
        $This.DaysAgo = New-JtFld -Label "DaysAgo"
        $This.Errors = New-JtFld -Label "Errors"
        $This.FolderPath = New-JtFld -Label "FolderPath"
        $This.Ip = New-JtFld -Label "Ip"
        $This.Ip3 = New-JtFld -Label "Ip3"
        $This.KlonVersion = New-JtFld -Label "KlonVersion"
        $This.LabelC = New-JtFld -Label "LabelC"
        $This.Org = New-JtFld -Label "Org"
        $This.Org1 = New-JtFld -Label "Org1"
        $This.Org2 = New-JtFld -Label "Org2"
        $This.ReportExists = New-JtFld -Label "ReportExists"
        $This.SystemId = New-JtFld -Label "SystemId"
        $This.Timestamp = New-JtFld -Label "Timestamp"
        $This.Type = New-JtFld -Label "Type"
        $This.User = New-JtFld -Label "User"
        $This.WinVer = New-JtFld -Label "WinVer"
        $This.Win1 = New-JtFld -Label "Win1"
        $This.Win2 = New-JtFld -Label "Win2"
        $This.Win3 = New-JtFld -Label "Win3"
        $This.Win4 = New-JtFld -Label "Win4"
    }
}


Function Get-JtInf_AFolder {
    
    #[OutputType([JtInf_AFolder])]
    
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath
    ) 

    [String]$MyFunctionName = "Get-JtInf_AFolder"
    [JtInf_AFolder]$MyJtInf = New-JtInf_AFolder

    [JtIoFolder]$MyJtIoFolder = $Null
    if ($FolderPath) {
        [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $FolderPath
    }
    else {
        Write-JtLog_Error -Where $MyFunctionName -Text "PATH is NULL! Using default. PATH: $MyJtIoFolder"
        [JtIoFolder]$MyJtIoFolder = New-JtIoFolder_Report
    }
    [String]$MyFolderPath = $MyJtIoFolder.GetPath()
        

    if (!($MyJtIoFolder.IsExisting())) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Folder does not exist: MyJtIoFolder: $MyJtIoFolder"
        return $MyJtInf
    }

    [JtTimeStop]$MyTimeStop = [JtTimeStop]::new()
    [String]$MyMessage = "Preparing Information for: $MyFolderPath"
    $MyTimeStop.Start($MyMessage)
    
    $MyJtInf.Get_FolderPath().SetValue($MyFolderPath)

    [String]$MyId = $MyFolderPath
    $MyJtInf.SetId($Myid)
    
    [String]$MyFolderName = $MyJtIoFolder.GetName()
    $MyJtInf.Get_Name().SetValue($MyFolderName)
    $MyJtInf.IsValid = $True

    [String]$MyLabelC = "label_c"
    [String]$MyComputername = "computername"
    [String]$MySystemId = "systemid"
    
    if ("report" -eq $MyFolderName) {
        $MyComputername = $env:COMPUTERNAME
        $MyLabelC = [JtIo]::GetLabelC()
    }
    else {
        [String[]]$MyAlParts = $MyFolderName.Split(".")
        if ($MyAlParts.length -lt 2) {
            Write-JtLog_Error -Where $MyFunctionName -Text "Ungueltiger Name: $MyFolderName - $MyFolderPath"
            $MyJtInf.IsValid = $False
        }
        else {
            $MyComputername = $MyAlParts[0]
            $MyLabelC = $MyAlParts[1]
        }
    }

    [JtComputername]$MyJtComputername = New-JtComputername -Name $MyComputername


    $MyJtInf.Get_LabelC().SetValue($MyLabelC)
    $MyJtInf.Get_Computername().SetValue($MyComputername)

    $MySystemId = -join ($MyComputername, ".", $MyLabelC)
    $MySystemId = $MySystemId.ToLower()
    $MyJtInf.Get_SystemId().SetValue($MySystemId)

    [String]$MyAlias = [JtIo]::GetAliasForComputername($MyComputername)
    $MyJtInf.Get_Alias().SetValue($MyAlias)

    $MyJtInf.Get_Org().SetValue($MyJtComputername.GetOrg())
    $MyJtInf.Get_Org1().SetValue($MyJtComputername.GetOrg1())
    $MyJtInf.Get_Org2().SetValue($MyJtComputername.GetOrg2())
    $MyJtInf.Get_Type().SetValue($MyJtComputername.GetType())


    if (Test-JtIoFolderPath -FolderPath $MyFolderPath) {
        [String]$MyJtVersion = [JtInf_AFolder]::GetJtVersion($MyFolderPath)
        $MyJtInf.Get_JtVersion().SetValue($MyJtVersion)

        [String]$MyTimestamp = [JtInf_AFolder]::GetTheTimestamp($MyFolderPath)
        $MyJtInf.Get_Timestamp().SetValue($MyTimestamp)

        [String]$MyDaysAgo = Get-JtReportLogDaysAgo -FolderPath $MyFolderPath
        $MyJtInf.Get_DaysAgo().SetValue($MyDaysAgo)

        [String]$MyWinVer = [JtInf_AFolder]::GetWinVer($MyFolderPath)
        $MyJtInf.Get_WinVer().SetValue($MyWinVev)

        [String]$MyWin1 = Convert-JtDotter -Text $MyWinVer -PatternOut "1"
        $MyJtInf.Get_Win1().SetValue($MyWin1)

        [String]$MyWin2 = Convert-JtDotter -Text $MyWinVer -PatternOut "2"
        $MyJtInf.Get_Win2().SetValue($MyWin2)

        [String]$MyWin3 = Convert-JtDotter -Text $MyWinVer -PatternOut "3"
        $MyJtInf.Get_Win3().SetValue($MyWin3)

        [String]$MyWin4 = Convert-JtDotter -Text $MyWinVer -PatternOut "4"
        $MyJtInf.Get_Win4().SetValue($MyWin4)


        [String]$MyKlonVersion = [JtInf_AFolder]::GetKlonVersion($MyFolderPath)
        $MyJtInf.Get_KlonVersion().SetValue($MyKlonVersion)

        [String]$MyIp = [JtInf_AFolder]::GetIp($MyFolderPath)
        $MyJtInf.Get_Ip().SetValue($MyIp)

        [String]$MyIp3 = Convert-JtIp_To_Ip3 -Ip $MyIp
        $MyJtInf.Get_Ip3().SetValue($MyIp3)

        [String]$MyUser = [JtInf_AFolder]::GetMasterUser($MyFolderPath)
        $MyJtInf.Get_User().SetValue($MyUser)

        
        [String]$MyReportExists = $True
        $MyJtInf.Get_ReportExists().SetValue($MyReportExists)
    }
    else {
        $MyJtInf.IsValid = $False
    }

    return $MyJtInf
}


class JtInf_Bitlocker : JtInf {
    
    [JtFld]$C_CapacityGB
    [JtFld]$C_VolumeType
    [JtFld]$C_EncryptionMethod
    [JtFld]$C_ProtectionStatus
    [JtFld]$D_CapacityGB
    [JtFld]$D_VolumeType
    [JtFld]$D_EncryptionMethod
    [JtFld]$D_ProtectionStatus

    JtInf_Bitlocker () {
        $This.ClassName = "JtInf_Bitlocker"
        $This.C_CapacityGB = New-JtFld -Label "C_CapacityGB"
        $This.C_VolumeType = New-JtFld -Label "C_VolumeType"
        $This.C_EncryptionMethod = New-JtFld -Label "C_EncryptionMethod"
        $This.C_ProtectionStatus = New-JtFld -Label "C_ProtectionStatus"
        $This.D_CapacityGB = New-JtFld -Label "D_CapacityGB"
        $This.D_VolumeType = New-JtFld -Label "D_VolumeType"
        $This.D_EncryptionMethod = New-JtFld -Label "D_EncryptionMethod"
        $This.D_ProtectionStatus = New-JtFld -Label "D_ProtectionStatus"
    }

    [JtFld]Get_C_CapacityGB() {
        return $This.C_CapacityGB
    } 

    [JtFld]Get_C_VolumeType() {
        return $This.C_VolumeType
    } 

    [JtFld]Get_C_EncryptionMethod() {
        return $This.C_EncryptionMethod
    } 

    [JtFld]Get_C_ProtectionStatus() {
        return $This.C_ProtectionStatus
    } 

    [JtFld]Get_D_CapacityGB() {
        return $This.D_CapacityGB
    } 

    [JtFld]Get_D_VolumeType() {
        return $This.D_VolumeType

    } 
    [JtFld]Get_D_EncryptionMethod() {
        return $This.D_EncryptionMethod
    } 

    [JtFld]Get_D_ProtectionStatus() {
        return $This.D_ProtectionStatus
    }
}

Function Get-JtInf_Bitlocker {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath
    ) 

    [JtInf_Bitlocker]$MyJtInf = New-JtInf_Bitlocker
    
    if (!(Test-JtIoFolderPath -FolderPath $FolderPath)) {
        return $MyJtInf
    }
    [String]$MyFolderPath = $FolderPath
    [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $MyFolderPath


    [String]$MyName = "Bitlocker"

    [System.Object]$MyObj = Get-JtXmlReportObject -FolderPath $MyJtIoFolder -Name $MyName
    if ($MyObj) {
        foreach ($Element in $MyObj) {
            $MyElement = $Element
            [String]$MyDriveLetter = $MyElement.MountPoint.Replace(":", "")
            [String]$MyCapacityGB = $MyElement.CapacityGB
            [String]$MyVolumeType = $MyElement.VolumeType
            [String]$MyEncryptionMethod = $MyElement.EncryptionMethod
            [String]$MyProtectionStatus = $MyElement.ProtectionStatus 
            if ($MyDriveLetter -eq "C") {
                $MyJtInf.C_CapacityGB.SetValue($MyCapacityGB)
                $MyJtInf.C_VolumeType.SetValue($MyVolumeType)
                $MyJtInf.C_EncryptionMethod.SetValue($MyEncryptionMethod)
                $MyJtInf.C_ProtectionStatus.SetValue($MyProtectionStatus)
            }
            elseif ($DriveLetter -eq "D") {
                $MyJtInf.D_CapacityGB.SetValue($MyCapacityGB)
                $MyJtInf.D_VolumeType.SetValue($MyVolumeType)
                $MyJtInf.D_EncryptionMethod.SetValue($MyEncryptionMethod)
                $MyJtInf.D_ProtectionStatus.SetValue($MyProtectionStatus)
            }
        }
    }
    return [JtInf_Bitlocker]$MyJtInf 
}



enum JtSoftSrc {
    InstalledSoftware = 0
    Un32 = 32
    Un64 = 64
}


class JtFldSoft : JtFld {

    hidden [JtSoftSrc]$JtSoftSrc
    hidden [String]$Search = ""

    JtFldSoft([String]$TheLabel, [JtSoftSrc]$TheJtSoftSrc, [String]$TheSearch) : base($TheLabel) {
        $This.ClassName = "JtFldSoft"
        $This.Label = $TheLabel
        switch ($TheJtSoftSrc) {
            ([JtSoftSrc]::InstalledSoftware) { 
                $This.JtSoftSrc = [JtSoftSrc]::InstalledSoftware
            } 
            ([JtSoftSrc]::Un32) { 
                $This.JtSoftSrc = [JtSoftSrc]::Un32
            } 
            ([JtSoftSrc]::Un64) { 
                $This.JtSoftSrc = [JtSoftSrc]::Un64
            } 
            default {
                Write-Host "This should not happen! Error with JtFldSoft"
                Exit
            }
        }
        $This.Search = $TheSearch
    }

    SetJtSoftSrc([JtSoftSrc]$TheJtSoftSrc) {
        $This.JtSoftSrc = $TheJtSoftSrc
    } 

    [String]GetSearch() {
        return $This.Search
    } 

    [JtSoftSrc]GetJtSoftSrc() {
        return $This.JtSoftSrc
    } 
 

    SetValue([String]$TheValue) {
        $This.Value = $TheValue
    } 
    
    [String]GetLabel() {
        return $This.Label
    } 
    
    [String]GetValue() {
        return $This.Value
    } 
}


class JtInf_Soft : JtInf {


    [JtFldSoft]$Acrobat_DC
    [JtFldSoft]$AcrobatReader
    [JtFldSoft]$AdobeCreativeCloud
    [JtFldSoft]$AfterEffects_CC
    [JtFldSoft]$AffinityDesigner
    [JtFldSoft]$AffinityPhoto
    [JtFldSoft]$AffinityPublisher
    [JtFldSoft]$Air
    # [JtFldSoft]$Allplan_2012
    [JtFldSoft]$Allplan_2019
    [JtFldSoft]$AntiVirus
    [JtFldSoft]$ArchiCAD
    [JtFldSoft]$Arduino
    # [JtFldSoft]$ASBwin
    [JtFldSoft]$AutoCAD_2021
    [JtFldSoft]$Bacula
    [JtFldSoft]$BkiKosten
    [JtFldSoft]$BkiPos
    [JtFldSoft]$Chrome
    [JtFldSoft]$Chromium
    [JtFldSoft]$Cinema4D
    [JtFldSoft]$CiscoAnyConnect
    [JtFldSoft]$CorelDRAW
    [JtFldSoft]$CreativeSuite_CS6
    [JtFldSoft]$DellCommand
    [JtFldSoft]$DellSuppAs
    [JtFldSoft]$DokanLibrary
    [JtFldSoft]$DriveFs
    [JtFldSoft]$Firefox32
    [JtFldSoft]$Firefox64
    [JtFldSoft]$Flash
    [JtFldSoft]$Foxit
    [JtFldSoft]$Gimp
    [JtFldSoft]$GoogleEarth
    [JtFldSoft]$Grafiktreiber
    [JtFldSoft]$IbpHighend
    [JtFldSoft]$Illustrator_CC
    [JtFldSoft]$Indesign_CC
    [JtFldSoft]$Inkscape
    [JtFldSoft]$IntelME
    [JtFldSoft]$IntelNET
    [JtFldSoft]$IrfanView
    [JtFldSoft]$Java
    [JtFldSoft]$Krita
    [JtFldSoft]$Laubwerk
    [JtFldSoft]$LenovoSysUp
    [JtFldSoft]$LibreOffice
    [JtFldSoft]$Lightroom_CC
    [JtFldSoft]$LUH_Rotis
    [JtFldSoft]$Max_2021
    [JtFldSoft]$NotepadPP
    [JtFldSoft]$OBS
    [JtFldSoft]$Office
    [JtFldSoft]$Office365
    [JtFldSoft]$OfficeStandard
    [JtFldSoft]$OfficeTxt
    [JtFldSoft]$OPSI
    [JtFldSoft]$Orca
    [JtFldSoft]$PDF24
    [JtFldSoft]$Photoshop_CC
    [JtFldSoft]$Powertoys
    [JtFldSoft]$Premiere_CC
    [JtFldSoft]$Project
    [JtFldSoft]$RawTherapee
    [JtFldSoft]$Revit_2020
    [JtFldSoft]$Revit_2021
    [JtFldSoft]$Rhino_6
    [JtFldSoft]$Seadrive
    [JtFldSoft]$Seafile
    [JtFldSoft]$ServerViewAgents
    [JtFldSoft]$Silverlight
    [JtFldSoft]$Sketchup
    [JtFldSoft]$Sumatra
    [JtFldSoft]$Thunderbird32
    [JtFldSoft]$Thunderbird64
    [JtFldSoft]$Unity
    [JtFldSoft]$UnityHub
    [JtFldSoft]$Vectorworks
    [JtFldSoft]$VLC
    [JtFldSoft]$vRay3ds
    [JtFldSoft]$vRayRevit
    [JtFldSoft]$vRayRhino
    [JtFldSoft]$vRaySketchup
    [JtFldSoft]$VSCodium
    [JtFldSoft]$VSCode
    [JtFldSoft]$WebEx
    [JtFldSoft]$WibuKey
    [JtFldSoft]$Zip7

    [JtFldSoft]$prn_4201_000_b006_1 
    [JtFldSoft]$prn_4201_001_a113_1 
    [JtFldSoft]$prn_4201_001_a133_1 
    [JtFldSoft]$prn_4201_u01_bu150_1
    [JtFldSoft]$prn_4201_u01_bu177_1
    
    
    static [String]GetLabelForOffice([String]$Version) {
        [String]$MyResult = ""
        if ($Null -eq $Version) {
            
        }
        else {
            [String[]]$Parts = $Version.Split(".")
            if ($Parts.Count -gt 2) {
                [String]$Part = $Parts[0]
                # [String]$Part2 = $Parts[1]
                [String]$Part3 = $Parts[2]
                switch ($Part) {
                    "v12" { 
                        $MyResult = "Office2007"
                    } 
                    "v13" { 
                        $MyResult = "Office2010"
                    } 
                    "v15" { 
                        $MyResult = "Office2013"
                    } 
                    "v16" { 
                        if ($Part3 -eq "4266") {
                            $MyResult = "Office2016"
                        }
                        elseif ($Part3 -eq "10370") {
                            $MyResult = "Office2019"
                        }
                        elseif ($Part3 -eq "10827") {
                            $MyResult = "Office2019"
                        }
                        elseif ($Part3 -eq "10349") {
                            $MyResult = "Office365"
                        }
                        else {
                            $MyResult = "OfficeXXX"
                            Write-JtLog_Error -Text "GetLabelForOffice. Cannot detect Office Version. VERSION: $Version"
                        }
                    } 
                    default {
                        $MyResult = $Version
                    }
                }
            }
        }
        return $MyResult
    }


    static [System.Collections.ArrayList]GetFilteredArrayList([System.Collections.ArrayList]$MyArray, [String]$FilterProperty) {
        [System.Collections.ArrayList]$Re = [System.Collections.ArrayList]::new()
 
        if ($Null -eq $MyArray) {
            Write-Host "GetFilteredArrayList;  ArrayList is null ------------------------------------"
            return $Re
        }
        # [Int32]$h = $MyArray.Count
        [Int32]$i = 0
        [Int32]$j = 0
 
        foreach ($MySys in $MyArray) {
            $El = $MySys | Get-Member | Where-Object { $_.name -like $FilterProperty }
            if ($Null -ne $El) {
                $Re.add($MySys)
                $j = $j + 1
            }
            $i = $i + 1
        }
        return $re
    }

    JtInf_Soft() {
        $This.ClassName = "JtInf_Soft"
        $This.Acrobat_DC = New-JtFldSoft -Label "Acrobat_DC" -JtSoftSrc Un32 -Search "Adobe Acrobat DC*"
        $This.AcrobatReader = New-JtFldSoft -Label "AcrobatReader" -JtSoftSrc Un32 -Search "Adobe Acrobat Reader *"
        $This.AdobeCreativeCloud = New-JtFldSoft -Label "AdobeCreativeCloud" -JtSoftSrc Un32 -Search "Adobe Creative Cloud*"
        $This.AfterEffects_CC = New-JtFldSoft -Label "AfterEffects_CC" -JtSoftSrc Un32 -Search "Adobe After Effects 2020*"
        $This.AffinityDesigner = New-JtFldSoft -Label "AffinityDesigner" -JtSoftSrc Un64 -Search "Affinity Designer*"
        $This.AffinityPhoto = New-JtFldSoft -Label "AffinityPhoto" -JtSoftSrc Un64 -Search "Affinity Photo*"
        $This.AffinityPublisher = New-JtFldSoft -Label "AffinityPublisher" -JtSoftSrc Un64 -Search "Affinity Publisher*"
        $This.Air = New-JtFldSoft -Label "Air" -JtSoftSrc Un32 -Search "Adobe AIR*"
        # $This.Allplan_2012 = New-JtFldSoft -Label "Allplan_2012" -JtSoftSrc Un32 -Search "Allplan 2012*"
        $This.Allplan_2019 = New-JtFldSoft -Label "Allplan_2019" -JtSoftSrc Un32 -Search "Allplan 2019*"
        $This.AntiVirus = New-JtFldSoft -Label "AntiVirus" -JtSoftSrc Un32 -Search "Sophos Anti-Virus*"
        $This.ArchiCAD = New-JtFldSoft -Label "ArchiCAD" -JtSoftSrc Un64 -Search "ARCHICAD *"
        $This.Arduino = New-JtFldSoft -Label "Arduino" -JtSoftSrc Un32 -Search "Arduino*"
        # $This.ASBwin = New-JtFldSoft -Label "ASBwin" -JtSoftSrc Un32 -Search "ASBwin*"
        $This.AutoCAD_2021 = New-JtFldSoft -Label "AutoCAD_2021" -JtSoftSrc Un64 -Search "Autodesk AutoCAD Jtecture 2021*"
        $This.Bacula = New-JtFldSoft -Label "Bacula" -JtSoftSrc Un32 -Search "Bacula Systems*"
        $This.BkiKosten = New-JtFldSoft -Label "BkiKosten" -JtSoftSrc Un32 -Search "BKI Kostenplaner*"
        $This.BkiPos = New-JtFldSoft -Label "BkiPos" -JtSoftSrc Un32 -Search "BKI Positionen*"
        $This.Chrome = New-JtFldSoft -Label "Chrome" -JtSoftSrc Un64 -Search "Google Chrome*"
        $This.Chromium = New-JtFldSoft -Label "Chromium" -JtSoftSrc Un32 -Search "Chromium*"
        $This.Cinema4D = New-JtFldSoft -Label "Cinema4D" -JtSoftSrc Un64 -Search "Cinema 4D *"
        $This.CiscoAnyConnect = New-JtFldSoft -Label "CiscoAnyConnect" -JtSoftSrc Un32 -Search "Cisco AnyConnect*"
        $This.CorelDRAW = New-JtFldSoft -Label "CorelDRAW" -JtSoftSrc Un64 -Search "CorelDRAW Graphics Suite*"
        $This.CreativeSuite_CS6 = New-JtFldSoft -Label "CreativeSuite_CS6" -JtSoftSrc Un32 -Search "Adobe Creative Suite 6 Design Standard*"
        $This.DellCommand = New-JtFldSoft -Label "DellCommand" -JtSoftSrc Un32 -Search "Dell Command*"
        $This.DellSuppAs = New-JtFldSoft -Label "DellSuppAs" -JtSoftSrc Un64 -Search "Dell SupportAssist*"
        $This.DokanLibrary = New-JtFldSoft -Label "DokanLibrary" -JtSoftSrc Un64 -Search "Dokan Library*"
        $This.DriveFs = New-JtFldSoft -Label "DriveFs" -JtSoftSrc Un64 -Search "Google Drive File Stream*"
        $This.Firefox32 = New-JtFldSoft -Label "Firefox32" -JtSoftSrc Un32 -Search "Mozilla Firefox*"
        $This.Firefox64 = New-JtFldSoft -Label "Firefox64" -JtSoftSrc Un64 -Search "Mozilla Firefox*"
        $This.Flash = New-JtFldSoft -Label "Flash" -JtSoftSrc Un32 -Search "Adobe Flash Player*"
        $This.Foxit = New-JtFldSoft -Label "Foxit" -JtSoftSrc Un32 -Search "Foxit Reader*"
        $This.Gimp = New-JtFldSoft -Label "Gimp" -JtSoftSrc Un64 -Search "GIMP*"
        $This.GoogleEarth = New-JtFldSoft -Label "GoogleEarth" -JtSoftSrc Un32 -Search "Google Earth *"
        $This.Grafiktreiber = New-JtFldSoft -Label "Grafiktreiber" -JtSoftSrc Un64 -Search "NVIDIA Grafiktreiber*"
        $This.IbpHighend = New-JtFldSoft -Label "IbpHighend" -JtSoftSrc Un32 -Search "IBP18599 HighEnd*"
        $This.Illustrator_CC = New-JtFldSoft -Label "Illustrator_CC" -JtSoftSrc Un32 -Search "Adobe Illustrator 2020*"
        $This.Indesign_CC = New-JtFldSoft -Label "Indesign_CC" -JtSoftSrc Un32 -Search "Adobe InDesign 2020*"
        $This.Inkscape = New-JtFldSoft -Label "Inkscape" -JtSoftSrc Un64 -Search "Inkscape*"
        $This.IntelME = New-JtFldSoft -Label "IntelME" -JtSoftSrc Un64 -Search "Intel (R) Management Engine Components*"
        $This.IntelNET = New-JtFldSoft -Label "IntelNET" -JtSoftSrc Un64 -Search "Intel (R) Network *"
        $This.IrfanView = New-JtFldSoft -Label "IrfanView" -JtSoftSrc Un64 -Search "IrfanView *"
        $This.Java = New-JtFldSoft -Label "Java" -JtSoftSrc Un64 -Search "Java 8*"
        $This.Krita = New-JtFldSoft -Label "Krita" -JtSoftSrc Un64 -Search "Krita (x64)*"
        $This.Laubwerk = New-JtFldSoft -Label "Laubwerk" -JtSoftSrc Un64 -Search "Laubwerk Plants*"
        $This.LenovoSysUp = New-JtFldSoft -Label "LenovoSysUp" -JtSoftSrc Un32 -Search "Lenovo System Update*"
        $This.LibreOffice = New-JtFldSoft -Label "LibreOffice" -JtSoftSrc Un64 -Search "LibreOffice*"
        $This.Lightroom_CC = New-JtFldSoft -Label "Lightroom_CC" -JtSoftSrc Un32 -Search "Adobe Lightroom Classic 2020*"
        $This.LUH_Rotis = New-JtFldSoft -Label "LUH_Rotis" -JtSoftSrc Un32 -Search "LUH-Rotis-Font*"
        $This.Max_2021 = New-JtFldSoft -Label "Max_2021" -JtSoftSrc Un64 -Search "Autodesk 3ds Max 2021*"
        $This.NotepadPP = New-JtFldSoft -Label "NotepadPP" -JtSoftSrc Un64 -Search "Notepad++*"
        $This.OBS = New-JtFldSoft -Label "OBS" -JtSoftSrc Un32 -Search "OBS Studio*"
        $This.Office = New-JtFldSoft -Label "Office" -JtSoftSrc Un64 -Search "Microsoft Office Standard*"
        $This.Office365 = New-JtFldSoft -Label "Office365" -JtSoftSrc Un64 -Search "Microsoft 365*"
        $This.OfficeStandard = New-JtFldSoft -Label "OfficeStandard" -JtSoftSrc Un64 -Search "Microsoft Office Standard*"
        $This.OfficeTxt = New-JtFldSoft -Label "OfficeTxt" -JtSoftSrc Un64 -Search "Microsoft Office Standard*"
        $This.OPSI = New-JtFldSoft -Label "OPSI" -JtSoftSrc Un32 -Search "opsi-client-agent*"
        $This.Orca = New-JtFldSoft -Label "Orca" -JtSoftSrc Un32 -Search "ORCA AVA*"
        $This.PDF24 = New-JtFldSoft -Label "PDF24" -JtSoftSrc Un64 -Search "PDF24 Creator*"
        $This.Photoshop_CC = New-JtFldSoft -Label "Photoshop_CC" -JtSoftSrc Un32 -Search "Adobe Photoshop 2020*"
        $This.Premiere_CC = New-JtFldSoft -Label "Premiere_CC" -JtSoftSrc Un32 -Search "Adobe Premiere Pro 2020*"
        $This.Project = New-JtFldSoft -Label "Project" -JtSoftSrc Un64 -Search "Microsoft Project MUI*"
        $This.Powertoys = New-JtFldSoft -Label "Powertoys" -JtSoftSrc Un64 -Search "PowerToys*"
        $This.RawTherapee = New-JtFldSoft -Label "RawTherapee" -JtSoftSrc Un64 -Search "RawTherapee Version*"
        $This.Revit_2020 = New-JtFldSoft -Label "Revit_2020" -JtSoftSrc Un64 -Search "Autodesk Revit 2020*"
        $This.Revit_2021 = New-JtFldSoft -Label "Revit_2021" -JtSoftSrc Un64 -Search "Autodesk Revit 2021*"
        $This.Rhino_6 = New-JtFldSoft -Label "Rhino_6" -JtSoftSrc Un64 -Search "Rhinoceros 6*"
        $This.Seadrive = New-JtFldSoft -Label "Seadrive" -JtSoftSrc Un64 -Search "SeaDrive*"
        $This.Seafile = New-JtFldSoft -Label "Seafile" -JtSoftSrc Un32 -Search "Seafile*"
        $This.ServerViewAgents = New-JtFldSoft -Label "ServerViewAgents" -JtSoftSrc Un64 -Search "FUJITSU Software ServerView Agents x64*"
        $This.Silverlight = New-JtFldSoft -Label "Silverlight" -JtSoftSrc Un64 -Search "Microsoft Silverlight*"
        $This.Sketchup = New-JtFldSoft -Label "Sketchup" -JtSoftSrc Un64 -Search "SketchUp*"
        $This.Sumatra = New-JtFldSoft -Label "Sumatra" -JtSoftSrc Un64 -Search "SumatraPDF*"
        $This.Thunderbird32 = New-JtFldSoft -Label "Thunderbird32" -JtSoftSrc Un32 -Search "Mozilla Thunderbird*"
        $This.Thunderbird64 = New-JtFldSoft -Label "Thunderbird64" -JtSoftSrc Un64 -Search "Mozilla Thunderbird*"
        $This.Unity = New-JtFldSoft -Label "Unity" -JtSoftSrc Un32 -Search "Unity"
        $This.UnityHub = New-JtFldSoft -Label "UnityHub" -JtSoftSrc Un64 -Search "Unity Hub*"
        $This.Vectorworks = New-JtFldSoft -Label "Vectorworks" -JtSoftSrc Un64 -Search "Vectorworks*"
        $This.VLC = New-JtFldSoft -Label "VLC" -JtSoftSrc Un64 -Search "VLC media player*"
        $This.vRay3ds = New-JtFldSoft -Label "vRay3ds" -JtSoftSrc Un64 -Search "V-Ray for 3dsmax 2020*"
        $This.vRayRevit = New-JtFldSoft -Label "vRayRevit" -JtSoftSrc Un64 -Search "V-Ray for Revit*"
        $This.vRayRhino = New-JtFldSoft -Label "vRayRhino" -JtSoftSrc Un64 -Search "V-Ray for Rhinoceros*"
        $This.vRaySketchup = New-JtFldSoft -Label "vRaySketchup" -JtSoftSrc Un64 -Search "V-Ray for SketchUp*"
        $This.VsCodium = New-JtFldSoft -Label "VsCodium" -JtSoftSrc Un64 -Search "VSCodium*"
        $This.VsCode = New-JtFldSoft -Label "VsCode" -JtSoftSrc Un64 -Search "Microsoft Visual Studio Code*"
        $This.WebEx = New-JtFldSoft -Label "WebEx" -JtSoftSrc Un32 -Search "Cisco Webex Meetings*"
        $This.WibuKey = New-JtFldSoft -Label "WibuKey" -JtSoftSrc Un64 -Search "WibuKey Setup*"
        $This.Zip7 = New-JtFldSoft -Label "Zip7" -JtSoftSrc Un64 -Search "7-Zip*"

        $This.prn_4201_000_b006_1 = New-JtFldSoft -Label "prn_4201_000_b006_1" -JtSoftSrc Un64 -Search "prn-4201-000-b006*"
        $This.prn_4201_001_a113_1 = New-JtFldSoft -Label "prn_4201_001_a113_1" -JtSoftSrc Un64 -Search "prn-4201-001-A113*"
        $This.prn_4201_001_a133_1 = New-JtFldSoft -Label "prn_4201_001_a133_1" -JtSoftSrc Un64 -Search "prn-4201-001-a133*"
        $This.prn_4201_u01_bu150_1 = New-JtFldSoft -Label "prn_4201_u01_bu150_1" -JtSoftSrc Un64 -Search "prn-4201-u01-bu150*"
        $This.prn_4201_u01_bu177_1 = New-JtFldSoft -Label "prn_4201_u01_bu177_1" -JtSoftSrc Un64 -Search "prn-4201-u01-bu177*"
    }
    
    [Object[]]GetFields() {
        [JtInf_Soft]$MyJtInf = [JtInf_Soft]::new()

        [Object[]]$MyResult = @()
        [System.Array]$Properties = $This.GetProperties()
        
        foreach ($Property in $Properties) {
            [String]$PropertyName = $Property.Name
            #            Write-Host "PropertyName:" $PropertyName
            
            $Field = $MyJtInf.($PropertyName)
            [String]$FieldType = $Field.GetType()
            # Write-Host "Field-Type:" $FieldType
            if ($FieldType.StartsWith("JtFldSoft")) {
                $MyResult += $Field
            }
        }
        # $MyResult
        return $MyResult
    }

    [System.Array]GetProperties() {
        [JtInf_Soft]$MyJtInf_Soft = [JtInf_Soft]::new()
        $Properties = $MyJtInf_Soft | Get-Member -MemberType Property
        return $Properties
    }

}

Function Get-JtInf_Soft {

    [OutputType([JtInf_Soft])]
    
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath
    ) 

    [String]$MyFunctionName = "Get-JtInf_Soft"
    [JtInf_Soft]$MyJtInf = New-JtInf_Soft

    if (!(Test-JtIoFolderPath -FolderPath $FolderPath)) {
        return $MyJtInf
    }
    [String]$MyFolderPath = $FolderPath
    [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $MyFolderPath

    [String]$MyName = "soft"

    [String]$MyProperty_Filter32 = "DisplayName"
    [String]$MyProperty_Version32 = "DisplayVersion"

    [String]$MyProperty_Filter64 = "DisplayName"
    [String]$MyProperty_Version64 = "DisplayVersion"

    [System.Object]$MyObjXml32 = Get-JtXmlReportSoftware -JtIoFolder $MyJtIoFolder -Name "Uninstall32"
    [System.Object]$MyObjXml64 = Get-JtXmlReportSoftware -JtIoFolder $MyJtIoFolder -Name "Uninstall64"
    

    [System.Collections.ArrayList]$MyArray32 = [JtInf_Soft]::GetFilteredArrayList($MyObjXml32, $MyProperty_Filter32)
    [System.Collections.ArrayList]$MyArray64 = [JtInf_Soft]::GetFilteredArrayList($MyObjXml64, $MyProperty_Filter64)

    [Object[]]$MyAlFields = $MyJtInf.GetFields() 
    foreach ($Field in $MyAlFields) {
        [JtFldSoft]$MyField = $Field
        [String]$MyVersion = ""
        [String]$MyKeyword = $MyField.GetSearch()
        [JtSoftSrc]$MyJtSoftSrc = $MyField.GetJtSoftSrc()

        [System.Collections.ArrayList]$MyArray = $Null
        [String]$MyProperty_Filter = ""
        [String]$MyProperty_Version = ""
        if ($MyJtSoftSrc -eq ([JtSoftSrc]::Un32)) {
            $MyArray = $MyArray32
            $MyProperty_Filter = $MyProperty_Filter32
            $MyProperty_Version = $MyProperty_Version32
        }
        else {
            $MyArray = $MyArray64
            $MyProperty_Filter = $MyProperty_Filter64
            $MyProperty_Version = $MyProperty_Version64
        }

        # try {
        $MyResult = $MyArray | Where-Object { $_.($MyProperty_Filter) -like $MyKeyword }
        if ($Null -ne $MyResult) {
            $MyVersion = "v" + $MyResult[0].($MyProperty_Version)
            [String]$MyLabel = $MyField.GetLabel()
            # Write-JtLog -Where $This.ClassName -Text "Label: $MyLabel Version: $Version"
            $MyJtInf.($MyLabel).SetValue($MyVersion) | Out-Null
        }
        #$MyField.SetValue($Version)
    }

        
    [String]$MyValOff = [JtInf_Soft]::GetLabelForOffice($MyJtInf.Office.GetValue())
    $MyJtInf.OfficeTxt.SetValue($MyValOff) | Out-Null

    
    return , $MyJtInf
}

class JtObj : JtClass {

    hidden [String]$Name

    JtObj() {
        $This.ClassName = "JtObj"
    }
}

class JtInf_Soft_InstalledSoftware : JtInf_Soft {

    static [Object[]]$Cache_Fields_InstalledSoftware = [Object[]]


    JtInf_Soft_InstalledSoftware() {
        $This.ClassName = "JtInf_Soft_InstalledSoftware"
    }


    [Object[]]GetFieldsInstalledSoftware() {
        [Object[]]$MyAlFields = [JtInf_Soft_InstalledSoftware]::Cache_Fields_InstalledSoftware

        if ($Null -eq $MyAlFields) {
            [Object[]]$MyAlObjects = $This.GetFields()
            [Object[]]$MyResult = @()
            foreach ($Object in $MyAlObjects) {
                [JtFldSoft]$MyField = $Object
                [JtSoftSrc]$MyJtSoftSrc = $MyField.GetJtSoftSrc()
                if ($MyJtSoftSrc -eq ([JtSoftSrc]::InstalledSoftware)) {
                    $MyResult += $MyField
                }
            }
            $MyAlFields = $MyResult
            [JtInf_Soft_InstalledSoftware]::Cache_Fields_InstalledSoftware = $MyResult
        }
        return $MyAlFields
    }
}




class JtInf_Win32Bios : JtInf {

    [String]$Label_Hersteller = "Hersteller"

    [JtFld]$Hersteller
    [JtFld]$Sn
    [JtFld]$BIOSVersion

    JtInf_Win32Bios() {
        $This.ClassName = "JtInf_Win32Bios"
        $This.Hersteller = New-JtFld "Hersteller"
        $This.Sn = New-JtFld "Sn"
        $This.BIOSVersion = New-JtFld "BIOSVersion"
    }
}

Function Get-JtInf_Win32Bios {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath
    ) 

    [JtInf_Win32Bios]$MyJtInf = New-JtInf_Win32Bios

    if (!(Test-JtIoFolderPath -FolderPath $FolderPath)) {
        return $MyJtInf
    }
    [String]$MyFolderPath = $FolderPath
    [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $MyFolderPath


    [String]$MyName = "Win32_Bios"
    [System.Object]$MyObj = Get-JtXmlReportObject -FolderPath $MyJtIoFolder -Name $MyName
    if ($MyObj) {
        $MyJtInf.Hersteller.SetValue($MyObj.Manufacturer)
        $MyJtInf.Sn.SetValue($MyObj.SerialNumber)
        $MyJtInf.BIOSVersion.SetValue($MyObj.SMBIOSBIOSVersion)
    }
        
    return $MyJtInf
}




class JtInf_Win32ComputerSystem : JtInf {


    [JtFld]$Modell
    [JtFld]$Herst
    [JtFld]$Ram
    [JtFld]$Computername
    [JtFld]$Owner 
    [JtFld]$Domain


    JtInf_Win32ComputerSystem () {
        $This.ClassName = "JtInf_Win32ComputerSystem"
        $This.Modell = New-JtFld -Label "Modell"
        $This.Herst = New-JtFld -Label "Herst"
        $This.Ram = New-JtFld -Label "Ram"
        $This.Computername = New-JtFld -Label "Computername"
        $This.Owner = New-JtFld -Label "Owner"
        $This.Domain = New-JtFld -Label "Domain"
    }
    
}


Function Get-JtInf_Win32ComputerSystem {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath
    ) 

    [JtInf_Win32ComputerSystem]$MyJtInf = New-JtInf_Win32ComputerSystem

    if (!(Test-JtIoFolderPath -FolderPath $FolderPath)) {
        return $MyJtInf
    }
    [String]$MyFolderPath = $FolderPath
    [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $MyFolderPath

        
    
    [String]$MyName = "Win32_ComputerSystem"
    [System.Object]$MyObj = Get-JtXmlReportObject -FolderPath $MyJtIoFolder -Name $MyName

    if ($MyObj) {
        $MyJtInf.Computername.SetValue($MyObj.Name)
        $MyJtInf.Herst.SetValue($MyObj.Manufacturer)
        $MyJtInf.Modell.SetValue($MyObj.Model)
        
        [String]$MyGB = Convert-JtString_To_DecGb -Text $MyObj.TotalPhysicalMemory
        
        $MyJtInf.Ram.SetValue($MyGB)
        $MyJtInf.Owner.SetValue($MyObj.PrimaryOwnerName)
        $MyJtInf.Domain.SetValue($MyObj.Domain)
    }
    return [JtInf_Win32ComputerSystem]$MyJtInf
}



class JtInf_Win32LogicalDisk : JtInf { 

    [JtFld]$C
    [JtFld]$C_Capacity
    [JtFld]$C_Free
    [JtFld]$C_FreePercent
    [JtFld]$D
    [JtFld]$D_Capacity
    [JtFld]$D_Free
    [JtFld]$D_FreePercent
    [JtFld]$E
    [JtFld]$E_Capacity
    [JtFld]$E_Free
    [JtFld]$E_FreePercent

    JtInf_Win32LogicalDisk() {
        $This.ClassName = "JtInf_Win32LogicalDisk"
        $This.C = New-JtFld -Label "C"
        $This.C_Capacity = New-JtFld -Label "C_Capacity"
        $This.C_Free = New-JtFld -Label "C_Free"
        $This.C_FreePercent = New-JtFld -Label "C_FreePercent"
        $This.D = New-JtFld -Label "D"
        $This.D_Capacity = New-JtFld -Label "D_Capacity"
        $This.D_Free = New-JtFld -Label "D_Free"
        $This.D_FreePercent = New-JtFld -Label "D_FreePercent"
        $This.E = New-JtFld -Label "E"
        $This.E_Capacity = New-JtFld -Label "E_Capacity"
        $This.E_Free = New-JtFld -Label "E_Free"
        $This.E_FreePercent = New-JtFld -Label "E_FreePercent"
    }
    
}

Function Get-JtInf_Win32LogicalDisk {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath
    ) 

    [String]$MyFunctionName = "Get-JtInf_Win32LogicalDisk"
    [JtInf_Win32LogicalDisk]$MyJtInf = New-JtInf_Win32LogicalDisk
    
    [String]$MyFolderPath = $FolderPath
    if (!(Test-JtIoFolderPath -FolderPath $MyFolderPath)) {
        return $MyJtInf
    }

    [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $MyFolderPath

    [String]$MyName = "Win32_LogicalDisk"
    [System.Object]$MyObj = Get-JtXmlReportObject -FolderPath $MyJtIoFolder -Name $MyName
    if ($MyObj) {
        $MyAlLetters = @("C", "D", "E")
        foreach ($MyLetter in $MyAlLetters) {
            $MyField1 = $MyLetter
            $MyValue1 = ""
            $MyField2 = -join ($MyLetter, "_", "Capacity")
            $MyValue2 = ""
            $MyField3 = -join ($MyLetter, "_", "Free")
            $MyValue3 = ""
            $MyField4 = -join ($MyLetter, "_", "FreePercent")
            $MyValue4 = ""

            # mediatype ssd hd ... GetMediaTypeForValue.....

            # try {
            $MyTestValue = -join ($MyLetter, ":")
            $MyObj2 = $MyObj | Where-Object -Property DeviceId -eq -Value $MyTestValue
            $MyObj3 = $MyObj2 | Select-Object -Property DeviceID, VolumeName, @{L = "Capacity"; E = { "{0:#.###}" -f ($_.Size / 1GB) } }, @{L = 'FreeSpaceGB'; E = { "{0:#.###}" -f ($_.FreeSpace / 1GB) } }
     
            foreach ($Line in $MyObj3) {
                $MyDriveLetter = $Line.DeviceID.Replace(":", "")
                $MyValue1 = $MyDriveLetter
                $MyJtInf.$MyField1.SetValue($MyValue1)
    
                $MyCapacity = $Line.Capacity
                $MyValue2 = $MyCapacity
                $MyJtInf.$MyField2.SetValue($MyValue2)
     
                $MyFreeSpaceGB = $Line.FreeSpaceGB
                $MyValue3 = $MyFreeSpaceGB
                $MyJtInf.$MyField3.SetValue($MyValue3)

                [Decimal]$MyDecCapacity = $MyCapacity
                [Decimal]$MyDecFreeSpaceGB = $MyFreeSpaceGB


                $MyValue4 = 0
                if($MyDecCapacity -ne 0) {
                     [Decimal]$MyDecFree = $MyDecFreeSpaceGB / $MyDecCapacity * 100
                    $MyValue4 = $MyDecFree -as [int32]
                }
                $MyJtInf.$MyField4.SetValue($MyValue4)
            } 
        }
    }
    # }
    # catch {
    #     Write-JtLog_Error -Where $MyFunctionName -Text "Obj is NULL for letter MyLetter: $MyLetter in MyName: $MyName"
    # } 
        
        
    else {
        Write-JtLog_Error -Where $MyFunctionName -Text "MyObj is NULL!"
    }
    return [JtInf_Win32LogicalDisk]$MyJtInf
} 


class JtInf_Win32NetworkAdapter : JtInf {

    [JtFld]$Mac
    # [JtFld]$Ip
    # [JtFld]$Ip3

    JtInf_Win32NetworkAdapter () {
        $This.ClassName = "JtInf_Win32NetworkAdapter"
        $This.Mac = New-JtFld -Label "Mac"
        # $This.Ip = New-JtFld -Label "Ip"
        # $This.Ip3 = New-JtFld -Label "Ip3"
    }
}


Function Get-JtInf_Win32NetworkAdapter {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath
    ) 

    [String]$MyFunctionName = "Get-JtInf_Win32NetworkAdapter"
    [JtInf_Win32NetworkAdapter]$MyJtInf = New-JtInf_Win32NetworkAdapter

    [String]$MyFolderPath = $FolderPath
    if (!(Test-JtIoFolderPath -FolderPath $FolderPath)) {
        Return $MyInf
    }
    [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $MyFolderPath
    [String]$MyName = "Win32_NetworkAdapter"

    [System.Object]$MyObj = Get-JtXmlReportObject -FolderPath $MyJtIoFolder -Name $MyName
    if ($MyObj) {
        [String]$MyMac = ""
        try {
            $MyAlCons = $MyObj | Where-Object -Property netconnectionstatus -Like "2" 
            $MyAlResult = $MyAlCons | Select-Object -Property MACAddress
    
            $MyMac = $MyAlResult[0].MACAddress 
        }
        catch {
            Write-JtLog_Error -Where $MyFunctionName -Text "Field: xxxx, Error in $MyName"
        }
        $MyJtInf.Mac.SetValue($MyMac)
    }
    else {
        Write-JtLog_Error -Where $MyFunctionName -Text "MyObj is NULL!"
    }
    return [JtInf_Win32NetworkAdapter]$MyJtInf
}


class JtInf_Win32OperatingSystem : JtInf {

    [JtFld]$OsCaption
    [JtFld]$OsManu
    [JtFld]$OsSerial
    [JtFld]$OsVersion

    JtInf_Win32OperatingSystem() {
        $This.ClassName = "JtInf_Win32OperatingSystem"
        $This.OsCaption = New-JtFld -Label "OsCaption"
        $This.OsManu = New-JtFld -Label "OsManu"
        $This.OsSerial = New-JtFld -Label "OsSerial"
        $This.OsVersion = New-JtFld -Label "OsVersion"
    }

}


Function Get-JtInf_Win32OperatingSystem {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath
    ) 

    [String]$MyFunctionName = "Get-JtInf_Win32OperatingSystem"

    [JtInf_Win32OperatingSystem]$MyJtInf = New-JtInf_Win32OperatingSystem    

    [String]$MyFolderPath = $FolderPath
    if (!(Test-JtIoFolderPath -FolderPath $MyFolderPath)) {
        return $MyJtInf
    }
    [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $MyFolderPath


    [String]$MyName = "Win32_OperatingSystem"

    [System.Object]$MyObj = Get-JtXmlReportObject -FolderPath $MyJtIoFolder -Name $MyName
    if ($MyObj) {
        $MyJtInf.OSCaption.SetValue($MyObj.Caption)
        $MyJtInf.OsManu.SetValue($MyObj.Manufacturer)
        $MyJtInf.OsSerial.SetValue($MyObj.SerialNumber)
        $MyJtInf.OsVersion.SetValue($MyObj.Version)
    }
    else {
        Write-JtLog_Error -Where $MyFunctionName -Text "MyObj is NULL!"
    }
    return [JtInf_Win32OperatingSystem]$MyJtInf
}    


class JtInf_Win32Processor : JtInf {

    [JtFld]$Cpu
    [JtFld]$Ghz
    [JtFld]$Cores
    [JtFld]$CoresH

    JtInf_Win32Processor () {
        $This.ClassName = "JtInf_Win32Processor"
        $This.Cpu = New-JtFld -Label "Cpu"
        $This.Ghz = New-JtFld -Label "Ghz"
        $This.Cores = New-JtFld -Label "Cores"
        $This.CoresH = New-JtFld -Label "CoresH"
    }
}

Function Get-JtInf_Win32Processor {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath
    ) 

    [String]$MyFunctionName = "Get-JtInf_Win32Processor"

    [JtInf_Win32Processor]$MyJtInf = New-JtInf_Win32Processor
    
    [String]$MyFolderPath = $FolderPath
    if (!(Test-JtIoFolderPath -FolderPath $MyFolderPath)) {
        return $MyJtInf
    }
    [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $MyFolderPath

    [String]$MyName = "Win32_Processor"

    [System.Object]$MyObj = Get-JtXmlReportObject -FolderPath $MyJtIoFolder -Name $MyName
    if ($MyObj) {
        $MyJtInf.Cpu.SetValue($MyObj.Name)
        # [String]$MaxClockSpeed = $MyObj.Get_MaxClockSpeed.ToString("0,0")
        # $MyJtInf.SetObjValue($MyObj, $MyJtInf.Get_Ghz(), $MaxClockSpeed )
        $MyJtInf.Ghz.SetValue($MyObj.MaxClockSpeed)   
        $MyJtInf.Cores.SetValue($MyObj.NumberOfCores)
        $MyJtInf.CoresH.SetValue($MyObj.NumberOfLogicalProcessors)
    }
    else {
        Write-JtLog_Error -Where $MyFunctionName -Text "MyObj is NULL!"
    }
    return [JtInf_Win32Processor]$MyJtInf
}

class JtInf_Win32VideoController : JtInf {

    [JtFld]$Grafikkarte
    [JtFld]$TreiberVersion

    JtInf_Win32VideoController () {
        $This.Grafikkarte = New-JtFld -Label "Grafikkarte"
        $This.TreiberVersion = New-JtFld -Label "TreiberVersion"
    }
    
    [JtFld]Get_Grafikkarte() {
        return $This.Grafikkarte
    } 

    [JtFld]Get_TreiberVersion() {
        return $This.TreiberVersion
    } 
}

Function Get-JtInf_Win32VideoController {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath
    ) 

    [String]$MyFunctionName = "Get-JtInf_Win32VideoController"
    
    [JtInf_Win32VideoController]$MyJtInf = New-JtInf_Win32VideoController

    [String]$MyFolderPath = $FolderPath
    if (!(Test-JtIoFolderPath -FolderPath $MyFolderPath)) {
        return $MyJtInf
    }
    [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $MyFolderPath


    [String]$MyName = "Win32_VideoController"
    
    [System.Object]$MyObj = Get-JtXmlReportObject -FolderPath $MyJtIoFolder -Name $MyName
    if ($MyObj) {
        $MyJtInf.Grafikkarte.SetValue($MyObj.Description)
        $MyJtInf.TreiberVersion.SetValue($MyObj.Driverversion)
    }
    else {
        Write-JtLog_Error -Where $MyFunctionName -Text "MyObj is NULL!"
    }
    return [JtInf_Win32VideoController]$MyJtInf
}


Function Get-JtReport_Value {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Label
    ) 


    [String]$MyFolderPath = $FolderPath
    [String]$MyLabel = $Label


    [String]$MyExtension = [JtIo]::FileExtension_Meta_Report
    [String]$MyPrefix = [JtIo]::FilePrefix_Report
    [String]$MyFilter = -join ($MyPrefix, ".", $MyLabel, ".", "*", $MyExtension)
        
    [JtIoFolder]$MyJtIoFolder = [JtIoFolder]::new($MyFolderPath)
    [System.Collections.ArrayList]$MyAlJtIoFiles = Get-JtChildItem -FolderPath $MyJtIoFolder -Filter $MyFilter
        
    [String]$MyOut = "not found"
    if ($MyAlJtIoFiles.Count -eq 1) {
        [JtIoFile]$MyJtIoFile = $MyAlJtIoFiles[0]
        [String]$MyFilename = $MyJtIoFile.GetName()
           
        $MyOut = Convert-JtDotter -Text $MyFilename -PatternOut 3
    }
    return $MyOut
}


Function Get-JtXmlReportSoftware() {

    param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtIoFolder]$JtIoFolder, 
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Name
    )

    [String]$MyFunctionName = "Get-JtXmlReportSoftware"

    [JtIoFolder]$MyJtIoFolder = $JtIoFolder
    Write-JtLog -Where $MyFunctionName -Text "MyJtIoFolder: $MyJtIoFolder"

    [System.Object]$MyObject = $Null
    [System.Object]$MyName = $Name

    Write-JtLog -Where $MyFunctionName -Text "GetXmlReportSoftware. MyName: $MyName"
    

    if ($Null -eq $MyJtIoFolder) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Folder is NULL for MyName: $MyName"
        return $Null
    }
    
    [String]$MyFilename_Xml = -Join ($MyName, [JtIo]::FileExtension_Xml)
    [JtIoFolder]$MyJtIoFolder_Xml = [JtIoFolder]$MyJtIoFolder.GetJtIoFolder_Sub("software")
    if (!($MyJtIoFolder_Xml.IsExisting())) {
        Write-JtLog_Error -Where $MyFunctionName -Text "MyJtIoFolder_Xml does not exist. MyName: $MyName  - MyJtIoFolder_Xml: $MyJtIoFolder_Xml"
        return $Null
    }

    [String]$MyFilePath_Xml = $MyJtIoFolder_Xml.GetFilePath($MyFilename_Xml)
    Write-JtLog -Where $MyFunctionName -Text "Get-JtXmlReportSoftware. MyFilePath_Xml: $MyFilePath_Xml"
    if (Test-JtIoFilePath -FilePath $MyFilePath_Xml) {
        try {
            $MyObject = Import-Clixml $MyFilePath_Xml
        }
        catch {
            Write-JtLog_Error -Where $MyFunctionName -Text "Problem while reading Xml: $MyFilePath_Xml"
            Throw "$MyFunctionName - Problem while reading Xml: $MyFilePath_Xml"
        }
    }
    return [System.Object]$MyObject
}


Function New-JtFldSoft {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Label,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][JtSoftSrc]$JtSoftSrc,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Search
    )

    [String]$MyLabel = $Label
    [JtSoftSrc]$MyJtSoftSrc = $JtSoftSrc
    [String]$MySearch = $Search
    
    [JtFldSoft]::new($MyLabel, $MyJtSoftSrc, $MySearch)
}

Function New-JtInf {
    [JtInf]::new()
}

Function New-JtInfi {
    Param (
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$FolderPath
    )

    [JtIoFolder]$MyJtIoFolder = $Null
    if ($FolderPath) {
        $MyJtIoFolder = New-JtIoFolder -FolderPath $FolderPath
    }
    else {
        $MyJtIoFolder = New-JtIoFolder_Report
    }
    [JtInfi]$MyJtInfi = [JtInfi]::new($MyJtIoFolder)
    $MyJtInfi
}

Function New-JtInf_AFolder {
    
    [JtInf_AFolder]::new()
}


Function New-JtInf_Bitlocker {

    [JtInf_Bitlocker]::new()
}


Function New-JtInf_Soft {
    
    [JtInf_Soft]::new()
}


Function New-JtInf_Soft_InstalledSoftware {

    [JtInf_Soft_InstalledSoftware]::new()
}

Function New-JtInf_Win32Bios {

    [JtInf_Win32Bios]::new()
}


Function New-JtInf_Win32ComputerSystem {

    [JtInf_Win32ComputerSystem]::new()
}


Function New-JtInf_Win32LogicalDisk {
    [JtInf_Win32LogicalDisk]::new()
}


Function New-JtInf_Win32NetworkAdapter {
    [JtInf_Win32NetworkAdapter]::new()
}

Function New-JtInf_Win32OperatingSystem {
    [JtInf_Win32OperatingSystem]::new()
}


Function New-JtInf_Win32Processor {
    [JtInf_Win32Processor]::new()
}

Function New-JtInf_Win32VideoController {

    [JtInf_Win32VideoController]::new()
}



Export-ModuleMember -Function Get-JtInf_AFolder
Export-ModuleMember -Function Get-JtInf_Bitlocker
Export-ModuleMember -Function Get-JtInf_Soft

Export-ModuleMember -Function Get-JtInf_Win32Bios
Export-ModuleMember -Function Get-JtInf_Win32ComputerSystem
Export-ModuleMember -Function Get-JtInf_Win32LogicalDisk
Export-ModuleMember -Function Get-JtInf_Win32NetworkAdapter
Export-ModuleMember -Function Get-JtInf_Win32OperatingSystem
Export-ModuleMember -Function Get-JtInf_Win32Processor
Export-ModuleMember -Function Get-JtInf_Win32VideoController

Export-ModuleMember -Function Get-JtXmlReportSoftware

Export-ModuleMember -Function New-JtFldSoft
Export-ModuleMember -Function New-JtInf
Export-ModuleMember -Function New-JtInfi 
Export-ModuleMember -Function New-JtInf_AFolder
Export-ModuleMember -Function New-JtInf_Bitlocker
Export-ModuleMember -Function New-JtInf_Soft
Export-ModuleMember -Function New-JtInf_Soft_InstalledSoftware
Export-ModuleMember -Function New-JtInf_Win32Bios
Export-ModuleMember -Function New-JtInf_Win32ComputerSystem
Export-ModuleMember -Function New-JtInf_Win32LogicalDisk
Export-ModuleMember -Function New-JtInf_Win32NetworkAdapter
Export-ModuleMember -Function New-JtInf_Win32OperatingSystem
Export-ModuleMember -Function New-JtInf_Win32Processor
Export-ModuleMember -Function New-JtInf_Win32VideoController

