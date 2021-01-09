using module JtClass
using module JtInf
using module JtIo
using module JtTbl
using module JtUtil

enum JtSoftSrc {
    InstalledSoftware = 0
    Un32 = 32
    Un64 = 64
}


class JtInf_Soft : JtInf {

    [String]$ClassName = "JtInf_Soft"

    [JtFldSoft]$Acrobat_DC
    [JtFldSoft]$AcrobatReader
    [JtFldSoft]$AdobeCreativeCloud
    [JtFldSoft]$AfterEffects_CC
    [JtFldSoft]$AffinityDesigner
    [JtFldSoft]$AffinityPhoto
    [JtFldSoft]$AffinityPublisher
    [JtFldSoft]$Air
    [JtFldSoft]$Allplan_2012
    [JtFldSoft]$Allplan_2019
    [JtFldSoft]$AntiVirus
    [JtFldSoft]$ArchiCAD
    [JtFldSoft]$Arduino
    [JtFldSoft]$ASBwin
    [JtFldSoft]$AutoCAD_2020
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
    [JtFldSoft]$Java
    [JtFldSoft]$Krita
    [JtFldSoft]$Laubwerk
    [JtFldSoft]$LenovoSysUp
    [JtFldSoft]$LibreOffice
    [JtFldSoft]$Lightroom_CC
    [JtFldSoft]$LUH_Rotis
    [JtFldSoft]$Max_2019
    [JtFldSoft]$Max_2020
    [JtFldSoft]$Max_2021
    [JtFldSoft]$Maya_2019
    [JtFldSoft]$Maya_2020
    [JtFldSoft]$Nanocad
    [JtFldSoft]$Notepad
    [JtFldSoft]$OBS
    [JtFldSoft]$Office
    [JtFldSoft]$Office365
    [JtFldSoft]$OfficeStandard
    [JtFldSoft]$OfficeTxt
    [JtFldSoft]$OPSI
    [JtFldSoft]$Orca
    [JtFldSoft]$PDF24
    [JtFldSoft]$Photoshop_CC
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
    [JtFldSoft]$WibuKey
    [JtFldSoft]$Zip

    
    static [String]GetLabelForOffice([String]$Version) {
        [String]$Result = ""
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
                        $Result = "Office2007"
                    } 
                    "v13" { 
                        $Result = "Office2010"
                    } 
                    "v15" { 
                        $Result = "Office2013"
                    } 
                    "v16" { 
                        if ($Part3 -eq "4266") {
                            $Result = "Office2016"
                        }
                        elseif ($Part3 -eq "10827") {
                            $Result = "Office2019"
                        }
                        else {
                            $Result = "OfficeXXX"
                        }
                    } 
                    default {
                        $Result = $Version
                    }
                }
            }
        }
        return $Result
    }


    static [System.Collections.ArrayList]GetFilteredArrayList([System.Collections.ArrayList]$MyArray, [String]$FilterProperty) {
        [System.Collections.ArrayList]$Re = [System.Collections.ArrayList]::new()
 
        if ($Null -eq $MyArray) {
            Write-Host("GetFilteredArrayList;  ArrayList is null ------------------------------------")
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
        $This.Acrobat_DC = New-JtFldSoft -Label "Acrobat_DC" -JtSoftSrc Un32 -Search "Adobe Acrobat DC*"
        $This.AcrobatReader = New-JtFldSoft -Label "AcrobatReader" -JtSoftSrc Un32 -Search "Adobe Acrobat Reader DC*"
        $This.AdobeCreativeCloud = New-JtFldSoft -Label "AdobeCreativeCloud" -JtSoftSrc Un32 -Search "Adobe Creative Cloud*"
        $This.AfterEffects_CC = New-JtFldSoft -Label "AfterEffects_CC" -JtSoftSrc Un32 -Search "Adobe After Effects 2020*"
        $This.AffinityDesigner = New-JtFldSoft -Label "AffinityDesigner" -JtSoftSrc Un64 -Search "Affinity Designer*"
        $This.AffinityPhoto = New-JtFldSoft -Label "AffinityPhoto" -JtSoftSrc Un64 -Search "Affinity Photo*"
        $This.AffinityPublisher = New-JtFldSoft -Label "AffinityPublisher" -JtSoftSrc Un64 -Search "Affinity Publisher*"
        $This.Air = New-JtFldSoft -Label "Air" -JtSoftSrc Un32 -Search "Adobe AIR*"
        $This.Allplan_2012 = New-JtFldSoft -Label "Allplan_2012" -JtSoftSrc Un32 -Search "Allplan 2012*"
        $This.Allplan_2019 = New-JtFldSoft -Label "Allplan_2019" -JtSoftSrc Un32 -Search "Allplan 2019*"
        $This.AntiVirus = New-JtFldSoft -Label "AntiVirus" -JtSoftSrc Un32 -Search "Sophos Anti-Virus*"
        $This.ArchiCAD = New-JtFldSoft -Label "ArchiCAD" -JtSoftSrc Un64 -Search "ARCHICAD *"
        $This.Arduino = New-JtFldSoft -Label "Arduino" -JtSoftSrc Un32 -Search "Arduino*"
        $This.ASBwin = New-JtFldSoft -Label "ASBwin" -JtSoftSrc Un32 -Search "ASBwin*"
        $This.AutoCAD_2020 = New-JtFldSoft -Label "AutoCAD_2020" -JtSoftSrc Un64 -Search "Autodesk AutoCAD Jtecture 2020*"
        $This.AutoCAD_2021 = New-JtFldSoft -Label "AutoCAD_2021" -JtSoftSrc Un64 -Search "Autodesk AutoCAD Jtecture 2021*"
        $This.Bacula = New-JtFldSoft -Label "Bacula" -JtSoftSrc Un32 -Search "Bacula Systems*"
        $This.BkiKosten = New-JtFldSoft -Label "BkiKosten" -JtSoftSrc Un32 -Search "BKI Kostenplaner*"
        $This.BkiPos = New-JtFldSoft -Label "BkiPos" -JtSoftSrc Un32 -Search "BKI Positionen*"
        $This.Chrome = New-JtFldSoft -Label "Chrome" -JtSoftSrc Un64 -Search "Google Chrome*"
        $This.Chromium = New-JtFldSoft -Label "Chromium" -JtSoftSrc Un32 -Search "Chromium*"
        $This.Cinema4D = New-JtFldSoft -Label "Cinema4D" -JtSoftSrc Un64 -Search "Cinema 4D *"
        $This.CiscoAnyConnect = New-JtFldSoft -Label "CiscoAnyConnect" -JtSoftSrc Un64 -Search "Cisco AnyConnect*"
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
        $This.Java = New-JtFldSoft -Label "Java" -JtSoftSrc Un64 -Search "Java 8*"
        $This.Krita = New-JtFldSoft -Label "Krita" -JtSoftSrc Un64 -Search "Krita (x64)*"
        $This.Laubwerk = New-JtFldSoft -Label "Laubwerk" -JtSoftSrc Un64 -Search "Laubwerk Plants*"
        $This.LenovoSysUp = New-JtFldSoft -Label "LenovoSysUp" -JtSoftSrc Un32 -Search "Lenovo System Update*"
        $This.LibreOffice = New-JtFldSoft -Label "LibreOffice" -JtSoftSrc Un64 -Search "LibreOffice*"
        $This.Lightroom_CC = New-JtFldSoft -Label "Lightroom_CC" -JtSoftSrc Un32 -Search "Adobe Lightroom Classic 2020*"
        $This.LUH_Rotis = New-JtFldSoft -Label "LUH_Rotis" -JtSoftSrc Un32 -Search "LUH-Rotis-Font*"
        $This.Max_2019 = New-JtFldSoft -Label "Max_2019" -JtSoftSrc Un64 -Search "Autodesk 3ds Max 2019*"
        $This.Max_2020 = New-JtFldSoft -Label "Max_2020" -JtSoftSrc Un64 -Search "Autodesk 3ds Max 2020*"
        $This.Max_2021 = New-JtFldSoft -Label "Max_2021" -JtSoftSrc Un64 -Search "Autodesk 3ds Max 2021*"
        $This.Maya_2019 = New-JtFldSoft -Label "Maya_2019" -JtSoftSrc Un64 -Search "Autodesk Maya 2019*"
        $This.Maya_2020 = New-JtFldSoft -Label "Maya_2020" -JtSoftSrc Un64 -Search "Autodesk Maya 2020*"
        $This.Nanocad = New-JtFldSoft -Label "Nanocad" -JtSoftSrc Un32 -Search "Nanocad*"
        $This.Notepad = New-JtFldSoft -Label "Notepad" -JtSoftSrc Un64 -Search "Notepad++*"
        $This.OBS = New-JtFldSoft -Label "OBS" -JtSoftSrc Un32 -Search "OBS Studio*"
        $This.Office = New-JtFldSoft -Label "Office" -JtSoftSrc Un64 -Search "Microsoft Office Standard*"
        $This.Office365 = New-JtFldSoft -Label "Office365" -JtSoftSrc Un64 -Search "Microsoft 365*"
        $This.OfficeStandard = New-JtFldSoft -Label "OfficeStandard" -JtSoftSrc Un64 -Search "Microsoft Office Standard*"
        $This.OfficeTxt = New-JtFldSoft -Label "OfficeTxt" -JtSoftSrc Un64 -Search "Microsoft Office Standard*"
        $This.OPSI = New-JtFldSoft -Label "OPSI" -JtSoftSrc Un32 -Search "opsi-client-agent*"
        $This.Orca = New-JtFldSoft -Label "Orca" -JtSoftSrc Un32 -Search "ORCA AVA*"
        $This.PDF24 = New-JtFldSoft -Label "PDF24" -JtSoftSrc Un32 -Search "PDF24 Creator*"
        $This.Photoshop_CC = New-JtFldSoft -Label "Photoshop_CC" -JtSoftSrc Un32 -Search "Adobe Photoshop 2020*"
        $This.Premiere_CC = New-JtFldSoft -Label "Premiere_CC" -JtSoftSrc Un32 -Search "Adobe Premiere Pro 2020*"
        $This.Project = New-JtFldSoft -Label "Project" -JtSoftSrc Un64 -Search "Microsoft Project MUI*"
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
        $This.WibuKey = New-JtFldSoft -Label "WibuKey" -JtSoftSrc Un64 -Search "WibuKey Setup*"
        $This.Zip = New-JtFldSoft -Label "Zip" -JtSoftSrc Un64 -Search "7-Zip*"
    }
        
    [Object[]]GetFields() {
        [JtInf_Soft]$JtInf = [JtInf_Soft]::new()

        [Object[]]$Result = @()
        [System.Array]$Properties = $This.GetProperties()

        foreach ($Property in $Properties) {

            [String]$PropertyName = $Property.Name
#            Write-Host "PropertyName:" $PropertyName
            
            $Field = $JtInf.($PropertyName)
            [String]$FieldType = $Field.GetType()
            # Write-Host "Field-Type:" $FieldType
            if ($FieldType.StartsWith("JtFldSoft")) {
                $Result += $Field
            }
        }
        # $Result
        return $Result
    }

    [System.Array]GetProperties() {
        [JtInf_Soft]$JtInf_Soft = [JtInf_Soft]::new()
        $Properties = $JtInf_Soft | Get-Member -MemberType Property
        return $Properties
    }

    # [JtTblTable]GetPropertyTable() {
    #     [JtTblTable]$JtTblTable = New-JtTblTable -Label $This.ClassName
    #     foreach($Property in $This.GetProperties()) {
    #         [JtTblRow]$JtTblRow = New-JtTblRow
    #         $JtTblRow.Add($Property.Name, $Property.Name)
    #         $JtTblTable.AddRow($JtTblRow)
    #     }
    #     return $JtTblTable
    # }
}

Function New-JtInf_Soft {

    [JtInf_Soft]::new()
}

Function New-JtInit_Inf_Soft {

    Param (
        [Parameter(Mandatory = $true)]
        [JtIoFolder]$JtIoFolder)

    [String]$Name = "soft"
    [String]$FilterProperty32 = "DisplayName"
    [String]$VersionProperty32 = "DisplayVersion"

    [String]$FilterProperty64 = "DisplayName"
    [String]$VersionProperty64 = "DisplayVersion"

    [System.Object]$JtObjXml32 = Get-XmlReportSoftware -JtIoFolder $JtIoFolder -Name "Uninstall32"
    [System.Object]$JtObjXml64 = Get-XmlReportSoftware -JtIoFolder $JtIoFolder -Name "Uninstall64"
    
    # [System.Object]$JtObjXml32
    # [System.Object]$JtObjXml64

    [JtInf_Soft]$JtInf_Soft = New-JtInf_Soft

    [System.Collections.ArrayList]$MyArray32 = [JtInf_Soft]::GetFilteredArrayList($JtObjXml32, $FilterProperty32)
    [System.Collections.ArrayList]$MyArray64 = [JtInf_Soft]::GetFilteredArrayList($JtObjXml64, $FilterProperty64)

    [Object[]]$Fields = $JtInf_Soft.GetFields() 
    foreach ($MyField in $Fields) {
        [String]$Version = ""
        [JtFldSoft]$Field = $MyField
        [String]$Keyword = $Field.GetSearch()
        [JtSoftSrc]$Source = $Field.GetSource()

        [System.Collections.ArrayList]$TheArray = $Null
        [String]$FilterProperty = ""
        [String]$VersionProperty = ""
        if ($Source -eq ([JtSoftSrc]::Un32)) {
            $TheArray = $MyArray32
            $FilterProperty = $FilterProperty32
            $VersionProperty = $VersionProperty32
        }
        else {
            $TheArray = $MyArray64
            $FilterProperty = $FilterProperty64
            $VersionProperty = $VersionProperty64
        }

        # try {
        $MyResult = $TheArray | Where-Object { $_.($FilterProperty) -like $Keyword }
        if ($Null -ne $MyResult) {
            $Version = "v" + $MyResult[0].($VersionProperty)
            Write-JtLog ( -join ("Label:", $Field.GetLabel(), " Version:", $Version))
            $JtInf_Soft.($Field.GetLabel()).SetValue($Version)
        }
        # }
        # catch {
        #     $TheArray
        #     Write-JtError -Text ( -join ("In: ", $Name, ". ", $FilterProperty, " does not exist. key:", $key, "---Keyword:", $Keyword))
        # }
        $MyField.SetValue($Version)
    }

    #[JtObj] GetInit([JtInf_Soft]$JtInf, [String]$Name, [JtIoFolder]$JtIoFolder, [JtSearchSet_Software]$JtSearchSet, [String]$FilterProperty, [String]$VersionProperty) {
        
    [String]$ValOff = [JtInf_Soft]::GetLabelForOffice($JtInf_Soft.Office.GetValue())
    $JtInf_Soft.OfficeTxt.SetValue($ValOff)
    [JtInf_Soft]$JtInf_Soft
}

class JtObj : JtClass {

    hidden [String]$Name
}

class JtInf_Soft_InstalledSoftware : JtInf_Soft {

    [Object[]]GetFieldsInstalledSoftware() {
        [Object[]]$Fields = [JtObj]::Cache_Fields_InstalledSoftware

        if ($Null -eq $Fields) {
            [Object[]]$JtObjects = $This.GetFields()
            [Object[]]$Result = @()
            foreach ($JtObject in $JtObjects) {
                [JtFldSoft]$Field = $JtObject
                [JtSoftSrc]$Source = $Field.GetSource()
                if ($Source -eq ([JtSoftSrc]::InstalledSoftware)) {
                    $Result += $Field
                }
            }
            $Fields = $Result
            [JtObj]::Cache_Fields_InstalledSoftware = $Result
        }
        return $Fields
    }
}

Function New-JtInf_Soft_InstalledSoftware {

    [JtInf_Soft_InstalledSoftware]::new()
}

Function New-JtInit_Inf_Soft_InstalledSoftware {
    Param (
        [Parameter(Mandatory = $True)]
        [JtIoFolder]$JtIoFolder)

    [JtInf_Soft_InstalledSoftware]$Inf = New-JtInf_Soft_InstalledSoftware 
    [String]$Name = "InstalledSoftware"


    #    [JtSoftSrc]$SoftSrc = [JtSoftSrc]::InstalledSoftware

    
    [String]$FilterProperty = "Name"
    [String]$VersionProperty = "Version"
    
    [JtSearchSet_Software]$JtSearchSet = [JtSearchSet_Software]::new()
    $JtSearchSet
            
    $JtInf = [JtObj]::GetInit($Inf, $Name, $JtIoFolder, $JtSearchSet, $FilterProperty, $VersionProperty)
    return [JtInf_Soft_InstalledSoftware]$JtInf
}

# static [JtInf]GetInit(
#     [JtInf]$JtInf, 
#     [String]$Name, 
#     [JtIoFolder]$JtIoFolder, 
#     [JtSearchSet_Software]$JtSearchSet, 
#     [String]$FilterProperty, 
#     [String]$VersionProperty) 



class JtFldSoft : JtField {

    hidden [JtSoftSrc]$Source
    hidden [String]$Search = ""

    JtFldSoft([String]$MyLabel, [JtSoftSrc]$JtSoftSrc, [String]$Search) : base($MyLabel) {
        $This.Label = $MyLabel
        switch ($JtSoftSrc) {
            ([JtSoftSrc]::InstalledSoftware) { 
                $This.Source = [JtSoftSrc]::InstalledSoftware
            } 
            ([JtSoftSrc]::Un32) { 
                $This.Source = [JtSoftSrc]::Un32
            } 
            ([JtSoftSrc]::Un64) { 
                $This.Source = [JtSoftSrc]::Un64
            } 
            default {
                Write-Host "This should not happen! Error with JtFldSoft"
                Exit
            }
        }
        $This.Search = $Search
    }

    SetSource([JtSoftSrc]$Source) {
        $This.Source = $Source
    } 

    [JtSoftSrc]GetSource() {
        return $This.Source
    } 
 
    [String]GetSearch() {
        return $This.Search
    } 

    SetValue([String]$MyValue) {
        $This.Value = $MyValue
    } 

    [String]GetValue() {
        return $This.Value
    } 

    [String]GetLabel() {
        return $This.Label
    } 
}

Function New-JtFldSoft {
    Param (
        [Parameter(Mandatory = $true)]
        [String]$Label,
        [Parameter(Mandatory = $true)]
        [JtSoftSrc]$JtSoftSrc,
        [Parameter(Mandatory = $true)]
        [String]$Search
    )
    [JtFldSoft]::new($Label, $JtSoftSrc, $Search)
}

Function Get-XmlReportSoftware() {

    param (
        [Parameter(Mandatory = $true)]
        [JtIoFolder]$JtIoFolder, 
        [Parameter(Mandatory = $true)]
        [String]$Name
    )

    [System.Object]$JtObject = $Null

    Write-JtLog ( -Join ("GetXmlReportSoftware - Name:", $Name))
    Write-JtLog ( -Join ("GetXmlReportSoftware - Path:", $JtIoFolder.GetPath()))
    
    [String]$FilenameXml = -Join ($Name, [JtIo]::FilenameExtension_Xml)
    [JtIoFolder]$FolderXml = $JtIoFolder.GetSubfolder("software")
    [String]$FilePathXml = $FolderXml.GetFilePath($FilenameXml)
    Write-JtLog -Text ( -join ("FilePathXml:", $FilePathXml))
    if (Test-Path ($FilePathXml)) {
        try {
            $JtObject = Import-Clixml $FilePathXml
        }
        catch {
            Write-JtError -Text ( -join ("GetXmlReportSoftware; problem while reading Xml:", $FilePathXml))
            Throw ( -join ("GetXmlReportSoftware; problem while reading Xml:", $FilePathXml))
        }
    }
    return [System.Object]$JtObject
}