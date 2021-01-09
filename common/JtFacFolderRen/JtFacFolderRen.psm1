using module JtClass
using module JtIo
using module JtFolderRenderer
using module JtPreisliste

class JtFacFolderRen : JtClass {

    [JtIoFolder]$JtIoFolder = $Null
    [JtFolderRenderer]$JtFolderRenderer = $Null
    [String]$Kind = "default"

    JtFacFolderRen([JtIoFile]$JtIoFile) {

        $This.JtIoFolder = [JtIoFolder]::new($JtIoFile)

        [String]$FilePath = $JtIoFile.GetPath()

        $This.JtFolderRenderer = $This.GetJtFolderRenderer_Default()
        $This.Kind = $This.JtFolderRenderer.GetLabel()

        if($FilePath.EndsWith(".ANZAHL.folder")) {
            $This.JtFolderRenderer = $This.GetJtFolderRenderer_Count()
            $This.Kind = $This.JtFolderRenderer.GetLabel()
        }

        if($FilePath.EndsWith(".BxH.folder")) {
            $This.JtFolderRenderer = $This.GetJtFolderRenderer_Poster()
            $This.Kind = $This.JtFolderRenderer.GetLabel()
        }

        if($FilePath.EndsWith(".BETRAG.folder")) {
            $This.JtFolderRenderer = $This.GetJtFolderRenderer_Sum()
            $This.Kind = $This.JtFolderRenderer.GetLabel()
        }

        if($FilePath.EndsWith(".PREIS.folder")) {
            $This.JtFolderRenderer = $This.GetJtFolderRenderer_Sum()
            $This.Kind = $This.JtFolderRenderer.GetLabel()
        }
    }

    [JtFolderRenderer]GetJtFolderRenderer() {
        return $This.JtFolderRenderer
    }

    [JtFolderRenderer]GetJtFolderRenderer_Count() {
        [JtFolderRenderer]$Ren = [JtFolderRenderer_Count]::new($This.JtIoFolder)
        return $Ren
    }

    [JtFolderRenderer]GetJtFolderRenderer_Default() {
        [JtFolderRenderer]$Ren = [JtFolderRenderer_Default]::new($This.JtIoFolder)
        return $Ren
    }

    [JtFolderRenderer]GetJtFolderRenderer_Poster() {
        [JtPreisliste]$JtPreisliste = New-JtPreisliste_Plotten_2020_07_01

        [JtFolderRenderer]$Ren = [JtFolderRenderer_Poster]::new($This.JtIoFolder, $JtPreisliste)
        return $Ren
    }

    [JtFolderRenderer]GetJtFolderRenderer_Sum() {
        [JtFolderRenderer]$Ren = [JtFolderRenderer_Sum]::new($This.JtIoFolder)
        return $Ren
    }

    [String]GetKind() {
        return $This.Kind
    }

}
