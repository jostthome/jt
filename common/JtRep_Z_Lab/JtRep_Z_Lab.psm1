using module JtTbl
using module JtInf_Soft
using module JtInfi
using module JtRep

class JtRep_Z_Lab : JtRep {

    JtRep_Z_Lab() : Base("z.lab") {
        $This.HideSpezial = $False
    }

    [JtTblRow]GetJtTblRow([JtInfi]$JtInfi) {
        [JtTblRow]$JtTblRow = $This.GetJtTblRowDefault($JtInfi)

        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Unity)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().UnityHub)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Office)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().CreativeSuite_CS6)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().AutoCAD_2020)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Max_2020)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Maya_2020)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Revit_2020)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().ArchiCAD)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Vectorworks)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Cinema4D)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().SketchUp)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Rhino_6)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().vRay3ds)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().vRayRevit)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().vRayRhino)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().vRaySketchup)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().GoogleEarth)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Arduino)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().LibreOffice)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().AcrobatReader)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().AntiVirus)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Chrome)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Firefox64)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Java)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().PDF24)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().DellCommand)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().DellSuppAs)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Seafile)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Seadrive)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Sumatra)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().VLC)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().WibuKey)
        $JtTblRow.Add($JtInfi.GetJtInf_Soft().Zip)
        $JtTblRow.Add($JtInfi.GetJtInf_Win32OperatingSystem().OsCaption)
        $JtTblRow.Add($JtInfi.GetJtInf_Win32OperatingSystem().OsVersion)
        $JtTblRow.Add($JtInfi.GetJtInf_Win32VideoController().Grafikkarte)
        $JtTblRow.Add($JtInfi.GetJtInf_Win32VideoController().TreiberVersion) 
    
        $JtTblRow.Add($JtInfi.GetJtInf_AFolder().Get_WinVersion())

        return $JtTblRow
    }


}


function New-JtRep_Z_Lab {

    [JtRep_Z_Lab]::new() 

}

