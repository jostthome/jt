using module JtClass
using module JtIo
using module JtUtil


class JtRobocopy : JtClass {


    [String]$RoboExe = -join ($env:windir, '\system32\', 'robocopy.exe')

    hidden [String]$Source = ""
    hidden [String]$Target = ""
    hidden [String]$Info = ""
    hidden [Boolean]$ExitOnError = $False
    
    JtRobocopy([JtIoFolder]$Source, [JtIoFolder]$Target) {
        $This.ClassName = "JtRobocopy"
        $This.DoInit([String]$Source.GetPath(), [String]$Target.GetPath(), $False) 
    }
    
    
    JtRobocopy([String]$Source, [String]$Target) {
        $This.ClassName = "JtRobocopy"
        $This.DoInit([String]$Source, [String]$Target, $False) 
    }
    
    
    JtRobocopy([String]$Source, [String]$Target, $ExitOnError) {
        $This.ClassName = "JtRobocopy"
        $This.DoInit([String]$Source, [String]$Target, $ExitOnError) 
    }
        
    hidden [Boolean]DoInit([String]$MySource, [String]$MyTarget, $ExitOnError) {
        $This.ExitOnError = $ExitOnError
        $This.Source = ConvertTo-JtExpandedPath $MySource
        $This.Target = $MyTarget
        return $True
    }
    
    [Boolean]SetInfo([String]$MyInfo) {
        $This.Info = $MyInfo
        return $True
    }

    [Boolean]DoIt() {
        Write-JtLog -Text ( -join ("Info:", $This.Info))

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

        $TheArgs = -join (' /MIR ', ' /w:2 ', ' ', ' /r:2 ', ' ', '"', $This.Source, '"', ' ', '"', $This.Target, '"')

        Write-JtLog -Text ( -join ("JtRobocopy; ", "Source:", $This.Source, ";", "Target:", $This.Target))



        if (Test-Path $This.Target) {
            Write-JtLog -Text ( -join ("robo args:", $TheArgs))
            Start-Process -NoNewWindow -FilePath $This.RoboExe -ArgumentList $TheArgs -Wait 
            return $true
        }
        else {
            Write-JtError -Text ( -join ("ERROR! JtRobocopy. No access:", $This.Target))

            try {
                New-Item -ItemType Directory -Force -Path $This.Target
            } catch {
                Write-JtError -Text ( -join ("ERROR! JtRobocopy. No access while creating:", $This.Target))
            }


            if ($This.ExitOnError -eq $True) {
                Exit
            }
            return $false
        }
    }
}

function New-JtRobocopy {
    
    Param (
        [Parameter(Mandatory = $true)]
        [String]$Source,
        [Parameter(Mandatory = $true)]
        [String]$Target,
        [Parameter(Mandatory = $false)]
        [String]$Info
    )

    [JtRobocopy]$JtRobocopy = [JtRobocopy]::new($Source, $Target)
    if(!($Info)) {
        
    } else {
        $JtRobocopy.SetInfo($Info)
    }
    $JtRobocopy.DoIt()

}

function New-JtRobocopyIO {
    
    Param (
        [Parameter(Mandatory = $true)]
        [JtIoFolder]$IoSource,
        [Parameter(Mandatory = $true)]
        [JtIoFolder]$IoTarget,
        [Parameter(Mandatory = $false)]
        [String]$Info
    )

    [JtRobocopy]$JtRobocopy = [JtRobocopy]::new($IoSource, $IoTarget)
    if(!($Info)) {
        
    } else {
        $JtRobocopy.SetInfo($Info)
    }
    $JtRobocopy.DoIt()

}

class JtToolWol : JtClass {

    [String]$WolExe = -join ("c:\apps\tools\wol\wol.exe")
    [String]$Label = ""
    [String]$Mac = ""

    JtToolWol([String]$MyLabel, [String]$MyMac) {
        $This.ClassName = "JtToolWol"
        $This.Label = $MyLabel
        $This.Mac = $MyMac
    }

    JtToolWol([String]$Computername) {
        $This.ClassName = "JtToolWol"
        $This.Label = $Computername

        [String]$MyMac = [JtToolWol]::GetMac($Computername)

        if($MyMac.Length -lt 1) {
            Write-JtError -Text (-join("No MAC address found for computer:", $Computername))
        }

        $This.Mac = $MyMac
    }    

    
    static [String]GetMac([String]$ComputerName) {
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

    
    [Boolean]DoIt() {
        Write-JtLog -Text ( -join ("JtToolWol; ", " Label:", $This.Label, "; ", "MAC:", $This.Mac))

        [String]$TheArgs = -join (" ", $This.Mac)


        if (Test-Path $This.WolExe) {
            Write-JtLog -Text ( -join ("WOL args:", $TheArgs))
            Start-Process -NoNewWindow -FilePath $This.WolExe -ArgumentList $TheArgs -Wait 
            return $true
        }
        else {
            Write-JtError -Text ( -join ("ERROR! JtToolWol. wol.exe is missing:", $This.WolExe))

            if ($This.ExitOnError -eq $True) {
                Exit
            }
            return $false
        }
    }
}

