using module JtInv

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"

Describe "New-JtInvClient" {

    It "Should ... JtInvClient" {
    
        $o = New-JtInvClient
        $o | Should -BeLessThan 10
    }
}


Describe "New-JtInvClientExport" {

    It "Should ... JtInvClientExport" {
    
        $o = New-JtInvClientExport
        $o | Should -BeLessThan 2
    }
}

    # New-JtInvClientErrors
    # New-JtInvClientExport 
    # New-JtInvClientConfig
    # New-JtInvClientReport
    # New-JtInvClientObjects
    # New-JtInvClientCsvs
    # New-JtInvClientExport 



