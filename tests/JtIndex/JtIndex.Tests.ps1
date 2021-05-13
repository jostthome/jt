using module JtIo
using module JtTbl
using module JtTest

Set-StrictMode -Version "2.0"
# $ErrorActionPreference = "Stop"

# Convert-JtFolderPath_To_Decimal_Betrag_BxH -FolderPath_Input C:\Users\jostt\OneDrive\jt\testing\1.EXAMPLE\14.DATA.POSTER\141.POSTER.Beispiel1
# D:\backup\stb\s2\FAMILIE\fa.pri.auto\fa.pri.AUTO.RECHNUNG.jahr


# [String]$TheFolderPath = "C:\Users\thome.ARCHLAND\OneDrive\BANK\jt.ste.BANK.KSKWD.FACH.SCHLIESSFACH"
# Convert-JtFolderPath_To_Decimal_Betrag_Part -FolderPath_Input $TheFolderPath -Part "Betrag"
# Convert-JtFolderPath_To_Meta_Betrag -FolderPath_Input $TheFolderPath -FolderPath_Output $TheFolderPath
# New-JtIndex_Betrag -FolderPath_Input $TheFolderPath -FolderPath_Output $TheFolderPath

# Function Test-MdTest {
#     [String]$MyFolderPath_Test = Get-JtFolderPath_Index_Files
#     Convert-JtFolderPath_To_Md_Test -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
# }
# Test-MdTest
# return 

Describe "Convert-JtFolderPath_To_JtTblTable_Anzahl" {


    It "Should be JtTblTable" {
        [String]$MyFolderPath_Test = Get-JtFolderPath_Index_Anzahl
        $MyJtTblTable = Convert-JtFolderPath_To_JtTblTable_Anzahl -FolderPath_Input $MyFolderPath_Test 
        $MyJtTblTable | Should -BeOfType JtTblTable
    }

    It "Should be JtTblTable" {
        [String]$MyFolderPath_Test = Get-JtFolderPath_Index_Betrag
        $MyJtTblTable = Convert-JtFolderPath_To_JtTblTable_Betrag -FolderPath_Input $MyFolderPath_Test 
        $MyJtTblTable | Should -BeOfType JtTblTable
    }

    It "Should be JtTblTable" {
        [String]$MyFolderPath_Test = Get-JtFolderPath_Index_BxH
        $MyJtTblTable = Convert-JtFolderPath_To_JtTblTable_BxH -FolderPath_Input $MyFolderPath_Test 
        $MyJtTblTable | Should -BeOfType JtTblTable
    }

    It "Should be JtTblTable" {
        [String]$MyFolderPath_Test = Get-JtFolderPath_Index_Files
        $MyJtTblTable = Convert-JtFolderPath_To_JtTblTable_Files -FolderPath_Input $MyFolderPath_Test 
        $MyJtTblTable | Should -BeOfType JtTblTable
    }
    
    It "Should be JtTblTable" {
        [String]$MyFolderPath_Test = Get-JtFolderPath_Index_Zahlung
        $MyJtTblTable = Convert-JtFolderPath_To_JtTblTable_Zahlung -FolderPath_Input $MyFolderPath_Test 
        $MyJtTblTable | Should -BeOfType JtTblTable
    }

}

Describe "New-JtIndex_Anzahl" {

    It "Should be ... Anzahl" {

        [String]$MyFolderPath_Test = Get-JtFolderPath_Index_Anzahl
        $o = New-JtIndex_Anzahl -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
        $o | Should -BeOfType JtIndex_Anzahl
    }
}

Describe "New-JtIndex_Betrag" {

    It "Should be ... betrag" {
        [String]$MyFolderPath_Test = Get-JtFolderPath_Index_Betrag
        $o = New-JtIndex_Betrag -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
        $o | Should -BeOfType JtIndex_Betrag
    }
}


Describe "New-JtIndex_BxH" {
    It "Should be ... BxH" {

        [String]$MyFolderPath_Test = Get-JtFolderPath_Index_BxH
        New-JtIndex_BxH -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
        $o | Should -BeOfType JtIndex_BxH
    }
}


Describe "New-JtIndex_Stunden" {
    It "Should be ... stunden" {
        [String]$MyFolderPath_Test = Get-JtFolderPath_Index_Stunden
        New-JtIndex_Stunden -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
        $o | Should -BeOfType JtIndex_Stunden
    }
}


Describe "New-JtIndex_Zahlung" {

    It "Should be ... zahlung" {
        [String]$MyFolderPath_Test = Get-JtFolderPath_Index_Zahlung
        $o = New-JtIndex_Zahlung -FolderPath_Input $MyFolderPath_Test -FolderPath_Output $MyFolderPath_Test 
        $o | Should -BeOfType JtIndex_Zahlung
    }
    # [JtIoFolder]$MyJtIoFolder = New-JtIoFolder -FolderPath $MyFolderPath_Test 
    # Invoke-Item $MyJtIoFolder
}

