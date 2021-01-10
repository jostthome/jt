New-JtIoFileVersionMeta -Path "%OneDrive%\1.UNI\11.DMA1"

[String]$LEKTION_NAME = "rote_waende"
[String]$STUNDE_NR = "07"
[String]$ABSCHNITT_BUCHSTABE = "f"

[String]$Source = -join($env:OneDrive, "\1.UNI\11.DMA1\s", $STUNDE_NR, ".", $ABSCHNITT_BUCHSTABE, ".lektion.", $LEKTION_NAME, "\lektion.", $LEKTION_NAME, ".rvt")
[String]$Target = -join($env:ONEDRIVE, "\1.UNI\11.DMA1\s", $STUNDE_NR, ".", $ABSCHNITT_BUCHSTABE, ".lektion.", $LEKTION_NAME, "\download.lektion.", $LEKTION_NAME, "\lektion.", $LEKTION_NAME, ".rvt")
Copy-Item -Path $Source -Destination $Target

[String]$LEKTION_NAME = "treppe"
[String]$STUNDE_NR = "08"
[String]$ABSCHNITT_BUCHSTABE = "e"

[String]$Source = -join($env:OneDrive, "\1.UNI\11.DMA1\s", $STUNDE_NR, ".", $ABSCHNITT_BUCHSTABE, ".lektion.", $LEKTION_NAME, "\lektion.", $LEKTION_NAME, ".rvt")
[String]$Target = -join($env:ONEDRIVE, "\1.UNI\11.DMA1\s", $STUNDE_NR, ".", $ABSCHNITT_BUCHSTABE, ".lektion.", $LEKTION_NAME, "\download.lektion.", $LEKTION_NAME, "\lektion.", $LEKTION_NAME, ".rvt")
Copy-Item -Path $Source -Destination $Target

[String]$Source = -join($env:OneDrive, "\1.UNI\11.DMA1")
[String]$Target = "D:\Seafile\al-cad\1.DMA1\11.DMA1.mirror"
New-JtRobocopy -Source $Source -Target $Target


[String]$Source = -join($env:OneDrive, "\1.UNI\12.DOKU")
[String]$Target = "D:\Seafile\al-cad\1.DMA1\12.DOKU.mirror"
New-JtRobocopy -Source $Source -Target $Target

[String]$TARGET_FOLDER = "D:\Seafile\al-public\SUPPORT\TIPPS_UND_TOOLS\COMPUTER_FUER_DAS_STUDIUM\DOWNLOAD.COMPUTER_FUER_DAS_STUDIUM"

New-JtRobocopy -Source $Source -Target $Target

[String]$Source = -join($env:OneDrive, "\1.UNI\12.DOKU\e01.doku.eigene_hardware\*.pdf")
Copy-Item -Path $Source -Destination $TARGET_FOLDER

[String]$Source = -join($env:OneDrive, "\1.UNI\12.DOKU\e02.doku.eigene_software\*.pdf")
Copy-Item -Path $Source -Destination $TARGET_FOLDER

[String]$Source = -join($env:OneDrive, "\1.UNI\12.DOKU\e03.doku.eigene_konfiguration\*.pdf")
Copy-Item -Path $Source -Destination $TARGET_FOLDER






