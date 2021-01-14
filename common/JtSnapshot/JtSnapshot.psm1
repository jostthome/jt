using module JtClass
using module JtIo
using module JtTime
using module JtTool

class JtSnap : JtClass {
    
    hidden [String]$PathFolderToolsSource = "\\oslo\Snap$\_archland\tools"
    hidden [String]$PathFolderTools = "C:\_archland\tools"
    hidden [String]$JtSnapshotExe = "C:\_archland\tools\Snapshot64.exe"
    hidden [String]$ShutdownExe = "C:\Windows\System32\shutdown.exe"

    JtSnap () {
        $This.ClassName = "JtSnap"
    }

    [Boolean]DoPrepareTools() {
        [JtIoFolder]$FolderToolsSource = [JtIoFolder]::new($This.PathFolderToolsSource)
        [JtIoFolder]$FolderTools = [JtIoFolder]::new($This.PathFolderTools)
    
        New-JtRobocopyIo -IoSource $FolderToolsSource -IoTarget $FolderTools

        [JtIoFile]$FileJtSnaphotExe = [JtIoFile]::new($This.JtSnapshotExe)
        if ($False -eq $FileJtSnaphotExe.IsExisting()) {
            Write-JtError -Text ( -join ("Snapshot64.exe does not exist at:", $This.JtSnapshotExe))
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

    

    [Boolean]DoIt([JtIoFolder]$FolderJtSnap) {
        if($False -eq $This.DoPrepareTools()) {
            return $False
        }


        [JtTimer]$JtTimer = [JtTimer]::new( -Join ("JtSnap", $This.MyName))

        if ($False -eq $FolderJtSnap.IsExisting()) {
            Write-JtError -Text ( -join ("FolderJtSnap does not exist:", $FolderJtSnap.GetPath()))
            return $False
        }
        
        [JtIoFolder]$FolderJtSnapComputer = $FolderJtSnap.GetSubFolder($env:COMPUTERNAME)
        [JtIoFolder]$FolderJtSnapComputerPart = $FolderJtSnapComputer.GetSubFolder($This.MyName)
        $FolderJtSnapComputerPart.DoDeleteAllFiles()
        
        [String]$ImageFilename = -join ($This.MyName, ".sna")
        [String]$ImageFilePath = $FolderJtSnapComputerPart.GetFilePath($ImageFilename)
    
        $TheCommand = -Join ($This.MyPartition, " ", $ImageFilePath, " -Go -R")
        if($True -eq $This.GetDev()) {
            Write-JtLog -Text (-join("Snapshot.exe:", $This.JtSnapshotExe, ", Command:", $TheCommand))
        } else {
            Start-Process -FilePath $This.JtSnapshotExe -ArgumentList $TheCommand -NoNewWindow -Wait
        }
        
        $tstamp = Get-Date -Format yyyy-MM-dd
        [String]$FilenameTstamp = -join ( "JtSnapshot.", $tstamp, ".tstamp.meta")
        [String]$FilePathTstamp = $FolderJtSnapComputerPart.GetFilePath($FilenameTstamp)
        Out-File -FilePath $FilePathTstamp
        
        [String]$MySize = $FolderJtSnapComputerPart.GetFolderSize()
        $MySize = $MySize.replace('.', '_')
        $MySize = $MySize.replace(',', '_')
        $MySize = $MySize.replace(' ', '')
        [String]$FilenameSize = -join ( "JtSnapshot.", $MySize, ".size.meta")
        [String]$FilePathSize = $FolderJtSnapComputerPart.GetFilePath($FilenameSize)
        Out-File -FilePath $FilePathSize
    
        $JtTimer.Report()
        return $True
    }
}

class JtSnap_Recover : JtSnap {
    
    [JtIofile]$SnaFile = $Null
    [String]$Computer = ""
    [String]$MyName = ""
    [Int32]$Disk = 0
    [Int32]$Part = 0
    # [String]$MyPartition
    [Boolean]$System = $False

    
    JtSnap_Recover([JtIoFile]$MySnaFile, [Int32]$MyDisk, [Int32]$MyPart, [String]$TheComputer) {
        $This.ClassName = "JtSnap_Partition"
        $This.Disk = $MyDisk
        $This.Part = $MyPart
        $This.Computer = $TheComputer
        $This.MyName = -join ("HD", $This.Disk, "", $This.Part)

        $This.SnaFile = $MySnaFile
        $This.System = $False
        
        # $MyPartition = "HD2:1"
        # $This.MyPartition = -join ("HD", $Disk, ":", $Part)
    }
    
    JtSnap_Recover([JtIoFile]$MySnaFile, [Int32]$MyDisk, [Int32]$MyPart, [String]$TheComputer, [Boolean]$IsSystem) {
        $This.ClassName = "JtSnap_Partition"
        $This.Disk = $MyDisk
        $This.Part = $MyPart
        $This.Computer = $TheComputer
        $This.MyName = -join ("HD", $This.Disk, "", $This.Part)

        $This.SnaFile = $MySnaFile
        $This.System = $IsSystem

        # $MyPartition = "HD2:1"
        # $This.MyPartition = -join ("HD", $Disk, ":", $Part)
    }

    [Boolean]DoIt() {
        if ($False -eq $This.DoPrepareTools()) {
            return $False
        }

        
        [String]$ImageFilePath = $This.SnaFile.GetPath()

    
        [String]$TheCommandNormal = -Join (" ", $ImageFilePath, " ", "hd", $This.Disk, ":", $This.Part, " ", "-y")
        [String]$TheCommandSystem = -Join (" ", "C:", " ", $ImageFilePath, " ", "--schedule", " ", "--autoreboot:success")

        [String]$TheCommand = ""
        if ($True -eq $This.System) {
            $TheCommand = $TheCommandSystem
        }
        else {
            $TheCommand = $TheCommandNormal
        }
        Write-JtLog -Text ( -join ("Snapshot.exe:", $This.JtSnapshotExe, ", Command:", $TheCommand))
        if ($True -eq $This.GetDev()) {
            Write-JtLog -Text ("Doing nothing. This is a dev system.")
        }
        else {
            Start-Process -FilePath $This.JtSnapshotExe -ArgumentList $TheCommand -NoNewWindow -Wait
            if ($True -eq $This.System) {
                $TheCommand = -join ('/c', ' ', '"', 'Computer wird neu gestartet. System wird recovered.', '"', ' ', '/r')
                #                Start-Process -FilePath $This.ShutdownExe -ArgumentList $TheCommand -NoNewWindow -Wait
            }
        }
        return $True
    }
}


class JtSnapshot : JtClass {

    [JtIoFolder]$TargetFolder = $Null
    [String]$ServerShare = '\\al-its-se-oslo\Snap$'

    JtSnapshot([JtIoFolder]$MyFolderTarget) : Base() {
        $This.ClassName = "JtSnapshot"
        $This.TargetFolder = $MyFolderTarget
    }


    [Boolean]DoJtSnapPart([Int32]$Disk, [Int32]$Part) {
        [JtSnap_Partition]$JtSnap_Partition = [JtSnap_Partition]::new($Disk, $Part)
        $JtSnap_Partition.DoIt($This.TargetFolder)
        return $True
    }
}




