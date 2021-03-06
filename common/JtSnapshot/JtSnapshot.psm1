using module Jt  
using module JtIo

class JtSnap : JtClass {
    
    hidden [String]$FolderPathToolsSource = "\\oslo\Snap$\_archland\tools"
    hidden [String]$FolderPathTools = "C:\_archland\tools"
    hidden [String]$FilePath_Exe_Snapshot = "C:\_archland\tools\Snapshot64.exe"
    hidden [String]$ShutdownExe = "C:\Windows\System32\shutdown.exe"

    JtSnap () {
        $This.ClassName = "JtSnap"
    }

    [Boolean]DoPrepareTools() {
        [String]$MyFolderPath_Input = $This.FolderPathToolsSource
        [String]$MyFolderPath_Output = $This.FolderPathTools

        New-JtRobocopy -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output

        [JtIoFile]$MyJtIoFile_SnaphotExe = [JtIoFile]::new($This.FilePath_Exe_Snapshot)
        if (!($MyJtIoFile_SnaphotExe.IsExisting())) {
            Write-JtLog_Error -Where $This.ClassName -Text "Snapshot64.exe does not exist at MyJtIoFile_SnaphotExe: $MyJtIoFile_SnaphotExe"
            return $False
        }
        return $True
    }
}

class JtSnap_Partition : JtSnap {

    [String]$MyName
    [String]$MyPartition

    JtSnap_Partition([Int32]$Disk, [Int32]$Part, [String]$Comment) {
        $This.ClassName = "JtSnap_Partition"
        $This.MyName = $Comment
        
        # $MyPartition = "HD2:1"
        $This.MyPartition = -join ("HD", $Disk, ":", $Part)
    }
    
    JtSnap_Partition([Int32]$Disk, [Int32]$Part) {
        $This.ClassName = "JtSnap_Partition"
        $This.MyName = -join ("HD", $Disk, "", $Part)

        # $MyPartition = "HD2:1"
        $This.MyPartition = -join ("HD", $Disk, ":", $Part)
    }

    

    [Boolean]DoIt([String]$TheFolderPath_Output) {
        [String]$MyFolderPath_Output = $TheFolderPath_Output
        
        [JtIoFolder]$MyJtIoFolder_Snap = New-JtIoFolder -FolderPath $MyFolderPath_Output
        [String]$MyFilePath_SnapshotExe = $This.FilePath_Exe_Snapshot

        [Boolean]$MyBlnToolsPrepared = $This.DoPrepareTools()
        if (! ($MyBlnToolsPrepared)) {
            return $False
        }

        [String]$MyLabel = -Join ("JtSnap", $This.MyName)
        [JtTimer]$MyJtTimer = [JtTimer]::new($MyLabel)

        if (!($MyJtIoFolder_Snap.IsExisting())) {
            Write-JtLog_Error -Where $This.ClassName -Text "Folder does not exist MyJtIoFolder_Snap: $MyJtIoFolder_Snap"
            return $False
        }
        
        [String]$MyComputername = $env:COMPUTERNAME
        [JtIoFolder]$MyJtIoFolder_SnapComputer = $MyJtIoFolder_Snap.GetJtIoFolder_Sub($MyComputername)
        [JtIoFolder]$MyJtIoFolder_SnapComputerPart = $MyJtIoFolder_SnapComputer.GetJtIoFolder_Sub($This.MyName)
        $MyJtIoFolder_SnapComputerPart.DoRemoveFiles_All()
        
        [String]$MyFilename_Image = -join ($This.MyName, ".sna")
        [String]$MyFilePath_Sna = $MyJtIoFolder_SnapComputerPart.GetFilePath($MyFilename_Image)
    
        $MyCommand = -Join ($This.MyPartition, " ", $MyFilePath_Sna, " -Go -R")
        if (Get-JtDevMode) {
            Write-JtLog -Where $This.ClassName -Text "MyFilePath_SnapshotExe: $MyFilePath_SnapshotExe, MyCommand: $MyCommand"
        }
        else {
            Start-Process -FilePath $MyFilePath_SnapshotExe -ArgumentList $MyCommand -NoNewWindow -Wait
        }
        
        [String]$MyTstamp = Get-JtTimestamp
        $MyParams = @{
            FolderPath_Input  = $MyJtIoFolder_SnapComputerPart
            FolderPath_Output = $MyJtIoFolder_SnapComputerPart
            Name              = "snapshot"
            Value             = $MyTstamp
        }
        Write-JtIoFile_Meta_Report @MyParams

        [Decimal]$MyDecSizeGb = Get-JtFolderPath_Info_SizeGb -FolderPath $MyJtIoFolder_SnapComputerPart
        $MyParams = @{
            FolderPath_Input  = $MyJtIoFolder_SnapComputerPart
            FolderPath_Output = $MyJtIoFolder_SnapComputerPart
            Name              = "size"
            Value             = $MyDecSizeGb
        }
        Write-JtIoFile_Meta_Report @MyParams
    
        $MyJtTimer.Report()
        return $True
    }
}

class JtSnap_Recover : JtSnap {
    
    [JtIofile]$FilePath_Sna = $Null
    [String]$Computer = ""
    [String]$Name = ""
    [Int32]$Disk = 0
    [Int32]$Part = 0
    # [String]$MyPartition
    [Boolean]$BlnSystem = $False

    JtSnap_Recover([String]$TheFilePath_Sna, [Int32]$TheDisk, [Int32]$ThePart, [String]$TheComputer) {
        $This.ClassName = "JtSnap_Recover"
        $This.Disk = $TheDisk
        $This.Part = $ThePart
        $This.Computer = $TheComputer
        $This.Name = -join ("HD", $This.Disk, "", $This.Part)

        $This.FilePath_Sna = $TheFilePath_Sna
        $This.BlnSystem = $False
        
        # $MyPartition = "HD2:1"
        # $This.MyPartition = -join ("HD", $Disk, ":", $Part)
    }
    
    JtSnap_Recover([JtIoFile]$TheFilePath_Sna, [Int32]$TheDisk, [Int32]$ThePart, [String]$TheComputer, [Boolean]$TheBlnIsSystem) {
        $This.ClassName = "JtSnap_Recover"
        $This.Disk = $TheDisk
        $This.Part = $ThePart
        $This.Computer = $TheComputer
        $This.Name = -join ("HD", $This.Disk, "", $This.Part)

        $This.FilePath_Sna = $TheFilePath_Sna
        $This.BlnSystem = $TheBlnIsSystem

        # $MyPartition = "HD2:1"
        # $This.MyPartition = -join ("HD", $Disk, ":", $Part)
    }

    [Boolean]DoIt() {
        [String]$MyFilePath_SnapshotExe = $This.FilePath_Exe_Snapshot
        if ($False -eq $This.DoPrepareTools()) {
            return $False
        }

        [String]$MyFilePath_Sna = $This.FilePath_Sna
        [String]$MyDisk = $This.Disk
        [String]$MyPart = $This.Part
        [Boolean]$MyBlnSystem = $This.BlnSystem

        [String]$MyCommandNormal = -Join (" ", $MyFilePath_Sna, " ", "hd", $MyDisk, ":", $MyPart, " ", "-y")
        [String]$MyCommandSystem = -Join (" ", "C:", " ", $MyFilePath_Sna, " ", "--schedule", " ", "--autoreboot:success")

        [String]$MyCommand = ""
        if ($MyBlnSystem) {
            $MyCommand = $MyCommandSystem
        }
        else {
            $MyCommand = $MyCommandNormal
        }
        Write-JtLog -Where $This.ClassName -Text "MyFilePath_SnapshotExe: $MyFilePath_SnapshotExe, MyCommand: $MyCommand"
        if (Get-JtDevMode) {
            Write-JtLog -Where $This.ClassName -Text "Doing nothing. This is a dev system."
        }
        else {
            Write-JtLog -Where $This.ClassName -Text "Restoring... $MyFilePath_SnapshotExe  $MyCommand"
            Start-Process -FilePath $MyFilePath_SnapshotExe -ArgumentList $MyCommand -NoNewWindow -Wait
            if ($MyBlnSystem) {
                $MyCommand = -join ('/c', ' ', '"', 'Computer wird neu gestartet. System wird recovered.', '"', ' ', '/r')
                #                Start-Process -FilePath $This.ShutdownExe -ArgumentList $MyCommand -NoNewWindow -Wait
            }
        }
        return $True
    }
}

Function New-JtSnap_Partition {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Disk,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Partition
    )

    [String]$MyFolderPath_Output = $FolderPath_Output
    [String]$MyDisk = $Disk
    [String]$MyPartition = $Partition

    [JtSnap_Partition]$MyJtSnap_Partition = [JtSnap_Partition]::new($MyDisk, $MyPartition)
    $MyJtSnap_Partition.DoIt($MyFolderPath_Output)
}


Function New-JtSnap_Recover {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FilePath,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Disk,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Partition,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Computer,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][Boolean]$BlnSystem
    )

    [String]$MyFunctionName = "New-JtSnap_Recover"
    [String]$MyFilePath_Sna = [String]$FilePath
    [String]$MyDisk = [String]$Disk
    [String]$MyPartition = [String]$Partition
    [String]$MyComputer = [String]$Computer
    [Boolean]$MyBlnSystem = [Boolean]$BlnSystem

    if (!(Test-JtIoFilePath -FilePath $MyFilePath_Sna)) {
        Write-JtLog_Error -Where $MyFunctionName -Text "Error!!! File missing; please edit XML for MyFilePath_Sna: $MyFilePath_Sna"
        return $False
    }
        
    [JtSnap_Recover]$MyJtSnap_Recover = [JtSnap_Recover]::new($MyFilePath_Sna, $MyDisk, $MyPartition, $MyComputer, $MyBlnSystem)
    $MyJtSnap_Recover.DoIt()
}

Export-ModuleMember -Function New-JtSnap_Partition
Export-ModuleMember -Function New-JtSnap_Recover
