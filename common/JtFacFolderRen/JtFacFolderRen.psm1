using module JtClass
using module JtIo
using module JtIndex
using module JtPreisliste

class JtFacFolderRen : JtClass {

    [JtIoFolder]$JtIoFolder = $Null
    [JtIndex]$JtIndex = $Null
    [String]$Kind = "default"

    JtFacFolderRen([JtIoFile]$JtIoFile) {

        $This.JtIoFolder = [JtIoFolder]::new($JtIoFile)

        [String]$FilePath = $JtIoFile.GetPath()

        $This.JtIndex = $This.GetJtIndex_Default()
        $This.Kind = $This.JtIndex.GetLabel()

        if($FilePath.EndsWith(".ANZAHL.folder")) {
            $This.JtIndex = $This.GetJtIndex_Anzahl()
            $This.Kind = $This.JtIndex.GetLabel()
        }

        if($FilePath.EndsWith(".BxH.folder")) {
            $This.JtIndex = $This.GetJtIndex_BxH()
            $This.Kind = $This.JtIndex.GetLabel()
        }

        if($FilePath.EndsWith(".BETRAG.folder")) {
            $This.JtIndex = $This.GetJtIndex_Betrag()
            $This.Kind = $This.JtIndex.GetLabel()
        }

        if($FilePath.EndsWith(".PREIS.folder")) {
            $This.JtIndex = $This.GetJtIndex_Betrag()
            $This.Kind = $This.JtIndex.GetLabel()
        }

        if($FilePath.EndsWith(".ZAHLUNG.folder")) {
            $This.JtIndex = $This.GetJtIndex_Zahlung()
            $This.Kind = $This.JtIndex.GetLabel()
        }
    }

    [JtIndex]GetJtIndex() {
        return $This.JtIndex
    }

    [JtIndex]GetJtIndex_Anzahl() {
        [JtIndex]$Ren = [JtIndex_Anzahl]::new()
        return $Ren
    }


    [JtIndex]GetJtIndex_Betrag() {
        [JtIndex]$Ren = [JtIndex_Betrag]::new()
        return $Ren
    }

    [JtIndex]GetJtIndex_Default() {
        [JtIndex]$Ren = [JtIndex_Default]::new()
        return $Ren
    }

    [JtIndex]GetJtIndex_BxH() {
        [JtIndex]$Ren = [JtIndex_BxH]::new()
        return $Ren
    }

    [JtIndex]GetJtIndex_Zahlung() {
        [JtIndex]$Ren = [JtIndex_Zahlung]::new()
        return $Ren
    }

    [String]GetKind() {
        return $This.Kind
    }

}
