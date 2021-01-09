using module JtPreisliste


Clear-Host

Set-StrictMode -version latest
$ErrorActionPreference = "Stop"

# $JtPreisliste = New-JtPreisliste_Plotten_2020_07_01




Function New-JtPreisliste_Plotten_2021_01_01 {

    [String]$Tarif_Papier_Normal = "1.25"
    [String]$Tarif_Papier_Spezial = "2.50"

    [String]$Tarif_Tinte_Normal = "6.5"
    [String]$Tarif_Tinte_Minimal = "1.00"

    [JtPreisliste]$JtPreisliste = [JtPreisliste]::new("Plotten_2021_01_01")

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

$JtPreisliste = New-JtPreisliste_Plotten_2021_01_01
$JtPreisliste = New-JtPreisliste_Plotten_2020_07_01

$p = $JtPreisliste.GetPapierGrundpreis("90g")
$p 

$k = $JtPreisliste.GetTinteGrundpreis("90g")
$k 







