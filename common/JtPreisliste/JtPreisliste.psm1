using module JtClass
using module JtIo

using module JtTbl

class JtPreisliste : JtClass {

    [System.Data.Datatable]$DataTable = $Null
    
    [String]$Title = ""
    [String]$ColPreisId = "PREIS_ID"
    [String]$ColPapierLabel = "PAPIER"
    [String]$ColTinteLabel = "TINTE"
    [String]$ColTinteGrundpreis = "BASIS_TINTE"
    [String]$ColPapierGrundpreis = "BASIS_PAPIER"
    [String]$TemplateFileName = "BASIS_PAPIER"

    JtPreisliste([String]$MyTitle) {
        $This.ClassName = "JtPreisliste"
        $This.Title = $MyTitle
        $This.TemplateFileName = -join ("_NACHNAME.VORNAME.LABEL.PAPIER.BxH", [JtIo]::FilenameExtension_Poster)


        $This.DataTable = New-Object System.Data.Datatable

        $This.DataTable.Columns.Add($This.ColPreisId, "String")
        $This.DataTable.Columns.Add($This.ColPapierLabel, "String")
        $This.DataTable.Columns.Add($This.ColTinteLabel, "String")
        $This.DataTable.Columns.Add($This.ColPapierGrundpreis, "String")
        $This.DataTable.Columns.Add($This.ColTinteGrundpreis, "String")
    }

    AddRow([String]$PreisId, [String]$PapierLabel, [String]$TinteLabel, [String]$PapierGrundpreis, [String]$TinteGrundpreis) {
        $Row = $This.DataTable.NewRow()

        [String]$Label = ""
        [String]$Value = ""

        $Label = $This.ColPreisId
        $Value = $PreisId
        $Row.($Label) = $Value

        $Label = $This.ColPapierLabel
        $Value = $PapierLabel
        $Row.($Label) = $Value

        $Label = $This.ColTinteLabel
        $Value = $TinteLabel
        $Row.($Label) = $Value

        $Label = $This.ColPapierGrundpreis
        $Value = $PapierGrundpreis
        $Row.($Label) = $Value

        $Label = $This.ColTinteGrundpreis
        $Value = $TinteGrundpreis
        $Row.($Label) = $Value

        $This.DataTable.Rows.Add($Row)
    }

    [String]GetTitle() {
        return $This.Title
    }

    [System.Object]GetRow([String]$Label) {
        [System.Data.DataRow]$Row = $This.DataTable.Rows | Where-Object {$_.PREIS_ID -eq $Label}

        if($Null -eq $Row) {
            return $Null
        } else {
            return $Row
        }
    }

    [String]GetPapierGrundpreis([String]$Label) {
        [System.Object]$Row = $This.GetRow($Label)

        if ($Null -eq $Row) {
            return "0"
        }
        else {
            return $Row.($This.ColPapierGrundpreis)
        }
    }

    [String]GetTinteGrundpreis([String]$Label) {
        [System.Object]$Row = $This.GetRow($Label)

        if ($Null -eq $Row) {
            return "0"
        }
        else {
            return $Row.($This.ColTinteGrundpreis)
        }
    }
}



Function New-JtPreisliste_Plotten_2020_07_01 {

    [String]$Tarif_Papier_Normal = "1.25"
    [String]$Tarif_Papier_Spezial = "2.50"

    [String]$Tarif_Tinte_Normal = "6.5"
    [String]$Tarif_Tinte_Minimal = "1.00"

    [JtPreisliste]$JtPreisliste = [JtPreisliste]::new("Plotten_2020_07_01")

    $JtPreisliste.AddRow("fabriano", "FABRIANO", "NORMAL", $Tarif_Papier_Spezial, $Tarif_Tinte_Normal)
    $JtPreisliste.AddRow("fabriano_minimal", "FABRIANO", "MINIMAL", $Tarif_Papier_Spezial, $Tarif_Tinte_Minimal)

    $JtPreisliste.AddRow("semi", "Fotopapier, matt", "NORMAL", $Tarif_Papier_Spezial, $Tarif_Tinte_Normal)
    $JtPreisliste.AddRow("semi_minimal", "Fotopapier, matt", "MINIMAL", $Tarif_Papier_Spezial, $Tarif_Tinte_Minimal)

    $JtPreisliste.AddRow("glossy", "Fotopapier, glanz", "NORMAL", $Tarif_Papier_Spezial, $Tarif_Tinte_Normal)
    $JtPreisliste.AddRow("glossy_minimal", "Fotopapier, glanz", "MINIMAL", $Tarif_Papier_Spezial, $Tarif_Tinte_Minimal)

    $JtPreisliste.AddRow("trans", "Transparent-Papier", "NORMAL", $Tarif_Papier_Spezial, $Tarif_Tinte_Normal)
    $JtPreisliste.AddRow("trans_minimal", "Transparent-Papier", "MINIMAL", $Tarif_Papier_Spezial, $Tarif_Tinte_Minimal)

    $JtPreisliste.AddRow("180g", "180g-Papier", "NORMAL", $Tarif_Papier_Spezial, $Tarif_Tinte_Normal)
    $JtPreisliste.AddRow("180g_minimal", "180g-Papier", "MINIMAL", $Tarif_Papier_Spezial, $Tarif_Tinte_Minimal)

    $JtPreisliste.AddRow("90g", "90g-Papier", "NORMAL", $Tarif_Papier_Normal, $Tarif_Tinte_Normal)
    $JtPreisliste.AddRow("90g_minimal", "90g-Papier", "MINIMAL", $Tarif_Papier_Normal, $Tarif_Tinte_Minimal)

    $JtPreisliste.AddRow("own", "Eigenes Papier", "NORMAL", $Tarif_Papier_Normal, $Tarif_Tinte_Normal)
    $JtPreisliste.AddRow("own_minimal", "Eigenes Papier", "MINIMAL", $Tarif_Papier_Normal, $Tarif_Tinte_Minimal)
    [JtPreisliste]$JtPreisliste
}

