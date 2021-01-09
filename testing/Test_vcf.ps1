using module .\JtConfig\JtConfig.psm1
using module .\ColRen\ColRen.psm1


Clear-Host

Set-StrictMode -version latest
$ErrorActionPreference = "Stop"




function Out-vCard([String]$Path, [String]$Nachname, [String]$Vorname, [String]$Mobil, [String]$Tel, [String]$Email) {

    $Name = -join ($Nachname, ".", $Vorname)
    
    $filename = -join ($Path, "\", $Name, ".vcf")
    $filename = $filename.ToLower()
    

    Remove-Item $filename -ErrorAction SilentlyContinue
    add-content -path $filename "BEGIN:VCARD"
    add-content -path $filename "VERSION:2.1"
    add-content -path $filename ("N:" + $Nachname + ";" + $Vorname)
    add-content -path $filename ("FN:" + $Name)
    # add-content -path $filename ("ORG:" + $_.Company)
    # add-content -path $filename ("TITLE:" + $_.Title)
    add-content -path $filename ("TEL;WORK;VOICE:" + $Tel)
    # add-content -path $filename ("TEL;HOME;VOICE:" + $_.HomePhone)
    add-content -path $filename ("TEL;CELL;VOICE:" + $Mobil)
    # add-content -path $filename ("TEL;WORK;FAX:" + $_.Fax)
    # add-content -path $filename ("ADR;WORK;PREF:" + ";;" + $_.StreetAddress + ";" + $_.PostalCode + " " + $_.City + ";" + $_.co + ";;" + $_.Country)
    # add-content -path $filename ("URL;WORK:" + $_.WebPage)
    add-content -path $filename ("EMAIL;PREF;INTERNET:" + $Email)
    add-content -path $filename "END:VCARD"
}

Out-vCard -Path "c:\temp" -Nachname "Thome" -Vorname "Jost" -Mobil "+49 177 74 51 924" -Tel "+49 511 762 19874" -eMail "thome@al.uni-hannover.de"
Out-vCard -Path "c:\temp" -Nachname "Mäller" -Vorname "Jörg" -Mobil "+49 177 74 51 924" -Tel "+49 511 762 19874" -eMail "thome@al.uni-hannover.de"



<# 
FARBEN

Black 
DarkBlue 
DarkGreen 
DarkCyan 
DarkRed 
DarkMagenta 
DarkYellow 
Gray 
DarkGray 
Blue 
Green 
Cyan 
Red 
Magenta 
Yellow
White
#> 


# [String]$Message = "The quick brown fox jumps over the lazy dog."
# Write-Host -ForegroundColor Black         -BackgroundColor Cyan $Message
# Write-Host -ForegroundColor DarkBlue      -BackgroundColor Cyan $Message
# Write-Host -ForegroundColor DarkGreen     -BackgroundColor Cyan $Message
# Write-Host -ForegroundColor DarkCyan      -BackgroundColor Cyan $Message
# Write-Host -ForegroundColor DarkRed       -BackgroundColor Cyan $Message
# Write-Host -ForegroundColor DarkMagenta   -BackgroundColor Cyan $Message
# Write-Host -ForegroundColor DarkYellow    -BackgroundColor Cyan $Message
# Write-Host -ForegroundColor Gray          -BackgroundColor Cyan $Message
# Write-Host -ForegroundColor DarkGray      -BackgroundColor Cyan $Message
# Write-Host -ForegroundColor Blue          -BackgroundColor Cyan $Message
# Write-Host -ForegroundColor Green         -BackgroundColor Cyan $Message
# Write-Host -ForegroundColor Cyan          -BackgroundColor Cyan $Message
# Write-Host -ForegroundColor Red           -BackgroundColor Cyan $Message
# Write-Host -ForegroundColor Magenta       -BackgroundColor Cyan $Message
# Write-Host -ForegroundColor Yellow        -BackgroundColor Cyan $Message
# Write-Host -ForegroundColor White         -BackgroundColor Cyan $Message

# Write-Host -ForegroundColor Black         -BackgroundColor Black $Message
# Write-Host -ForegroundColor DarkBlue      -BackgroundColor Black $Message
# Write-Host -ForegroundColor DarkGreen     -BackgroundColor Black $Message
# Write-Host -ForegroundColor DarkCyan      -BackgroundColor Black $Message
# Write-Host -ForegroundColor DarkRed       -BackgroundColor Black $Message
# Write-Host -ForegroundColor DarkMagenta   -BackgroundColor Black $Message
# Write-Host -ForegroundColor DarkYellow    -BackgroundColor Black $Message
# Write-Host -ForegroundColor Gray          -BackgroundColor Black $Message
# Write-Host -ForegroundColor DarkGray      -BackgroundColor Black $Message
# Write-Host -ForegroundColor Blue          -BackgroundColor Black $Message
# Write-Host -ForegroundColor Green         -BackgroundColor Black $Message
# Write-Host -ForegroundColor Cyan          -BackgroundColor Black $Message
# Write-Host -ForegroundColor Red           -BackgroundColor Black $Message
# Write-Host -ForegroundColor Magenta       -BackgroundColor Black $Message
# Write-Host -ForegroundColor Yellow        -BackgroundColor Black $Message
# Write-Host -ForegroundColor White         -BackgroundColor Black $Message

# Write-Host -ForegroundColor Black         -BackgroundColor White $Message
# Write-Host -ForegroundColor DarkBlue      -BackgroundColor White $Message
# Write-Host -ForegroundColor DarkGreen     -BackgroundColor White $Message
# Write-Host -ForegroundColor DarkCyan      -BackgroundColor White $Message
# Write-Host -ForegroundColor DarkRed       -BackgroundColor White $Message
# Write-Host -ForegroundColor DarkMagenta   -BackgroundColor White $Message
# Write-Host -ForegroundColor DarkYellow    -BackgroundColor White $Message
# Write-Host -ForegroundColor Gray          -BackgroundColor White $Message
# Write-Host -ForegroundColor DarkGray      -BackgroundColor White $Message
# Write-Host -ForegroundColor Blue          -BackgroundColor White $Message
# Write-Host -ForegroundColor Green         -BackgroundColor White $Message
# Write-Host -ForegroundColor Cyan          -BackgroundColor White $Message
# Write-Host -ForegroundColor Red           -BackgroundColor White $Message
# Write-Host -ForegroundColor Magenta       -BackgroundColor White $Message
# Write-Host -ForegroundColor Yellow        -BackgroundColor White $Message
# Write-Host -ForegroundColor White         -BackgroundColor White $Message


# Write-Host -ForegroundColor White  -BackgroundColor Black        $Message
# Write-Host -ForegroundColor White  -BackgroundColor DarkBlue     $Message
# Write-Host -ForegroundColor White  -BackgroundColor DarkGreen    $Message
# Write-Host -ForegroundColor White  -BackgroundColor DarkCyan     $Message
# Write-Host -ForegroundColor White  -BackgroundColor DarkRed      $Message
# Write-Host -ForegroundColor White  -BackgroundColor DarkMagenta  $Message
# Write-Host -ForegroundColor White  -BackgroundColor DarkYellow   $Message
# Write-Host -ForegroundColor White  -BackgroundColor Gray         $Message
# Write-Host -ForegroundColor White  -BackgroundColor DarkGray     $Message
# Write-Host -ForegroundColor White  -BackgroundColor Blue         $Message
# Write-Host -ForegroundColor White  -BackgroundColor Green        $Message
# Write-Host -ForegroundColor White  -BackgroundColor Cyan         $Message
# Write-Host -ForegroundColor White  -BackgroundColor Red          $Message
# Write-Host -ForegroundColor White  -BackgroundColor Magenta      $Message
# Write-Host -ForegroundColor White  -BackgroundColor Yellow       $Message
# Write-Host -ForegroundColor White  -BackgroundColor White        $Message

# Write-Host -ForegroundColor Black  -BackgroundColor Black        $Message
# Write-Host -ForegroundColor Black  -BackgroundColor DarkBlue     $Message
# Write-Host -ForegroundColor Black  -BackgroundColor DarkGreen    $Message
# Write-Host -ForegroundColor Black  -BackgroundColor DarkCyan     $Message
# Write-Host -ForegroundColor Black  -BackgroundColor DarkRed      $Message
# Write-Host -ForegroundColor Black  -BackgroundColor DarkMagenta  $Message
# Write-Host -ForegroundColor Black  -BackgroundColor DarkYellow   $Message
# Write-Host -ForegroundColor Black  -BackgroundColor Gray         $Message
# Write-Host -ForegroundColor Black  -BackgroundColor DarkGray     $Message
# Write-Host -ForegroundColor Black  -BackgroundColor Blue         $Message
# Write-Host -ForegroundColor Black  -BackgroundColor Green        $Message
# Write-Host -ForegroundColor Black  -BackgroundColor Cyan         $Message
# Write-Host -ForegroundColor Black  -BackgroundColor Red          $Message
# Write-Host -ForegroundColor Black  -BackgroundColor Magenta      $Message
# Write-Host -ForegroundColor Black  -BackgroundColor Yellow       $Message
# Write-Host -ForegroundColor Black  -BackgroundColor White        $Message


# Write-Host -ForegroundColor Yellow  -BackgroundColor Darkblue        $Message
# Write-Host -ForegroundColor Yellow  -BackgroundColor Red        $Message
# Write-Host -ForegroundColor Darkblue  -BackgroundColor Darkred        $Message



