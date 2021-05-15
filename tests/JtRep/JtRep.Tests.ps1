using module JtIo
using module JtRep
using module JtTbl
using module JtInf


Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"

Describe "JtRep" {


    Context "c_inventory_report" {

        
        [String]$MyFolderPath_Input = "c:\_inventory\report"
        [JtInfi]$MyJtInfi = New-JtInfi -FolderPath $MyFolderPath_Input
        
        It "Get-JtRep_Folder" {
            [JtTblRow]$MyJtTblRow = Get-JtRep_Folder -JtInfi $MyJtInfi
            $MyJtTblRow | Should -BeOfType JtTblRow
        }
        
        It "Get-JtRep_Folder" {
            [JtTblRow]$MyJtTblRow = Get-JtRep_ObjWin32Bios -JtInfi $MyJtInfi
            $MyJtTblRow | Should -BeOfType JtTblRow
        }
        
        It "Get-JtRep_Folder" {
            [JtTblRow]$MyJtTblRow = Get-JtRep_ObjWin32Computersystem -JtInfi $MyJtInfi
            $MyJtTblRow | Should -BeOfType JtTblRow
        }
        
        It "Get-JtRep_Folder" {
            [JtTblRow]$MyJtTblRow = Get-JtRep_ObjWin32LogicalDisk -JtInfi $MyJtInfi
            $MyJtTblRow | Should -BeOfType JtTblRow
        }
        
        It "Get-JtRep_Folder" {
            [JtTblRow]$MyJtTblRow = Get-JtRep_ObjWin32NetworkAdapter -JtInfi $MyJtInfi
            $MyJtTblRow | Should -BeOfType JtTblRow
        }
        It "Get-JtRep_Folder" {
            [JtTblRow]$MyJtTblRow = Get-JtRep_ObjWin32OperatingSystem -JtInfi $MyJtInfi
            $MyJtTblRow | Should -BeOfType JtTblRow
        }
        It "Get-JtRep_Folder" {
            [JtTblRow]$MyJtTblRow = Get-JtRep_ObjWin32Processor -JtInfi $MyJtInfi
            $MyJtTblRow | Should -BeOfType JtTblRow
        }
        
        It "Get-JtRep_Folder" {
            [JtTblRow]$MyJtTblRow = Get-JtRep_ObjWin32VideoController -JtInfi $MyJtInfi
        $MyJtTblRow | Should -BeOfType JtTblRow
    }
    
    It "Get-JtRep_Folder" {
        [JtTblRow]$MyJtTblRow = Get-JtRep_Bitlocker -JtInfi $MyJtInfi
        $MyJtTblRow | Should -BeOfType JtTblRow
    }
    
    It "Get-JtRep_Folder" {
        [JtTblRow]$MyJtTblRow = Get-JtRep_Hardware -JtInfi $MyJtInfi
        $MyJtTblRow | Should -BeOfType JtTblRow
    }
    
    It "Get-JtRep_Folder" {
        [JtTblRow]$MyJtTblRow = Get-JtRep_HardwareSn -JtInfi $MyJtInfi
        $MyJtTblRow | Should -BeOfType JtTblRow
    }
    
    It "Get-JtRep_Folder" {
        [JtTblRow]$MyJtTblRow = Get-JtRep_Net -JtInfi $MyJtInfi
        $MyJtTblRow | Should -BeOfType JtTblRow
    }
    
    It "Get-JtRep_Folder" {
        [JtTblRow]$MyJtTblRow = Get-JtRep_Software -JtInfi $MyJtInfi
        $MyJtTblRow | Should -BeOfType JtTblRow
    }
    
    It "Get-JtRep_Folder" {
        [JtTblRow]$MyJtTblRow = Get-JtRep_SoftwareAdobe -JtInfi $MyJtInfi
        $MyJtTblRow | Should -BeOfType JtTblRow
    }
    
    It "Get-JtRep_Folder" {
        [JtTblRow]$MyJtTblRow = Get-JtRep_SoftwareMicrosoft -JtInfi $MyJtInfi
        $MyJtTblRow | Should -BeOfType JtTblRow
    }
    
    It "Get-JtRep_Folder" {
        [JtTblRow]$MyJtTblRow = Get-JtRep_SoftwareMicrosoftNormal -JtInfi $MyJtInfi
        $MyJtTblRow | Should -BeOfType JtTblRow
    }
    
    It "Get-JtRep_Folder" {
        [JtTblRow]$MyJtTblRow = Get-JtRep_SoftwareOpsi -JtInfi $MyJtInfi
        $MyJtTblRow | Should -BeOfType JtTblRow
    }
    
    It "Get-JtRep_Folder" {
        [JtTblRow]$MyJtTblRow = Get-JtRep_SoftwareSecurity -JtInfi $MyJtInfi
        $MyJtTblRow | Should -BeOfType JtTblRow
    }
    
    It "Get-JtRep_Folder" {
        [JtTblRow]$MyJtTblRow = Get-JtRep_SoftwareSupport -JtInfi $MyJtInfi
        $MyJtTblRow | Should -BeOfType JtTblRow
    }
    
    It "Get-JtRep_Folder" {
        [JtTblRow]$MyJtTblRow = Get-JtRep_SoftwareVray -JtInfi $MyJtInfi
        $MyJtTblRow | Should -BeOfType JtTblRow
    }
    
    It "Get-JtRep_Folder" {
        [JtTblRow]$MyJtTblRow = Get-JtRep_Timestamps -JtInfi $MyJtInfi
        $MyJtTblRow | Should -BeOfType JtTblRow
    }
    
    It "Get-JtRep_Folder" {
        [JtTblRow]$MyJtTblRow = Get-JtRep_Z_G13 -JtInfi $MyJtInfi
        $MyJtTblRow | Should -BeOfType JtTblRow
    }
    
    It "Get-JtRep_Folder" {
        [JtTblRow]$MyJtTblRow = Get-JtRep_Z_Iat -JtInfi $MyJtInfi
        $MyJtTblRow | Should -BeOfType JtTblRow
    }
    
    It "Get-JtRep_Folder" {
        [JtTblRow]$MyJtTblRow = Get-JtRep_Z_Lab -JtInfi $MyJtInfi
        $MyJtTblRow | Should -BeOfType JtTblRow
    }
    
    It "Get-JtRep_Folder" {
        [JtTblRow]$MyJtTblRow = Get-JtRep_Z_Pools -JtInfi $MyJtInfi
        $MyJtTblRow | Should -BeOfType JtTblRow
    }
    
    It "Get-JtRep_Folder" {
        [JtTblRow]$MyJtTblRow = Get-JtRep_Z_Server -JtInfi $MyJtInfi
        $MyJtTblRow | Should -BeOfType JtTblRow
    }
    
    It "Get-JtRep_Folder" {
        [JtTblRow]$MyJtTblRow = Get-JtRep_Z_Vorwag -JtInfi $MyJtInfi
        $MyJtTblRow | Should -BeOfType JtTblRow
    }
}
}



