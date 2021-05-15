using module JtIo

Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"

Describe "Write-JtIoFile" {

    It "Should write file" {

        $MyParams = @{
            FolderPath_Output = (Get-JtFolderPath_TestsOutput)
            Filename = "JtIo.Tests.txt"
            Content = "Hello world!"
            Overwrite = $True
        }
        $o = Write-JtIoFile  @MyParams
        $o | Should -BeOfType String
    }
}


Describe "Write-JtIoFile_Meta" {

    It "Should write meta file" {

        $MyParams = @{
            FolderPath_Input = (Get-JtFolderPath_TestsOutput)
            FolderPath_Output = (Get-JtFolderPath_TestsOutput)
            Prefix = [JtIo]::FilePrefix_Report
            Label = "test1234"
            Value = "hallo2b"
            Extension2 = [JtIo]::FileExtension_Meta_Report
            OnlyOne = $True
            Overwrite = $True
        }
        $o = Write-JtIoFile_Meta @MyParams
        $o | Should -BeOfType String
    }
}


Describe "New-JtConfig" {

    It "Should ... config" {

        New-JtConfig
    }

}


