$ErrorActionPreference = 'Stop'

Describe 'Basic Pester Tests' {

    It 'A test that should be true' {
        $false | Should -BeFalse
    }

    It 'A test that should be false' {
        $false | Should -BeTrue
    }
}


