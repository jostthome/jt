using module JtRep
using module JtRep_Bitlocker
using module JtRep_Folder
using module JtRep_Hardware
using module JtRep_HardwareSn
using module JtRep_Net
using module JtRep_Software
using module JtRep_SoftwareAdobe
using module JtRep_SoftwareMicrosoft
using module JtRep_SoftwareMicrosoftNormal
using module JtRep_SoftwareOpsi
using module JtRep_SoftwareSecurity
using module JtRep_SoftwareSupport
using module JtRep_SoftwareVray
using module JtRep_Z_G13
using module JtRep_Z_Iat
using module JtRep_Z_Lab
using module JtRep_Z_Pools
using module JtRep_Z_Server
using module JtRep_Z_Vorwag
using module JtRep_Timestamps
using module JtRep_Obj_Win32Bios
using module JtRep_Obj_Win32Computersystem
using module JtRep_Obj_Win32LogicalDisk
using module JtRep_Obj_Win32NetworkAdapter
using module JtRep_Obj_Win32OperatingSystem
using module JtRep_Obj_Win32Processor
using module JtRep_Obj_Win32VideoController


class JtReps {

    static [System.Collections.ArrayList]GetReps() {
        [System.Collections.ArrayList]$MyReps = [System.Collections.ArrayList]::new()

        [JtRep]$Rep = New-JtRep_Folder
        $MyReps.Add($Rep)
        [JtRep]$Rep = New-JtRep_Obj_Win32Bios
        $MyReps.Add($Rep)
        [JtRep]$Rep = New-JtRep_Obj_Win32Computersystem
        $MyReps.Add($Rep)
        [JtRep]$Rep = New-JtRep_Obj_Win32LogicalDisk
        $MyReps.Add($Rep)
        [JtRep]$Rep = New-JtRep_Obj_Win32NetworkAdapter
        $MyReps.Add($Rep)
        [JtRep]$Rep = New-JtRep_Obj_Win32OperatingSystem
        $MyReps.Add($Rep)
        [JtRep]$Rep = New-JtRep_Obj_Win32Processor
        $MyReps.Add($Rep)
        [JtRep]$Rep = New-JtRep_Obj_Win32VideoController
        $MyReps.Add($Rep)
        # [JtRep]$Rep = New-JtRep_InstalledSoftware
        # $MyReps.Add($Rep)
        [JtRep]$Rep = New-JtRep_Bitlocker
        $MyReps.Add($Rep)
        [JtRep]$Rep = New-JtRep_Hardware
        $MyReps.Add($Rep)
        [JtRep]$Rep = New-JtRep_HardwareSn
        $MyReps.Add($Rep)
        [JtRep]$Rep = New-JtRep_Net
        $MyReps.Add($Rep)
        [JtRep]$Rep = New-JtRep_Software
        $MyReps.Add($Rep)
        [JtRep]$Rep = New-JtRep_SoftwareAdobe
        $MyReps.Add($Rep)
        [JtRep]$Rep = New-JtRep_SoftwareMicrosoft
        $MyReps.Add($Rep)
        [JtRep]$Rep = New-JtRep_SoftwareMicrosoftNormal
        $MyReps.Add($Rep)
        [JtRep]$Rep = New-JtRep_SoftwareOpsi
        $MyReps.Add($Rep)
        [JtRep]$Rep = New-JtRep_SoftwareSecurity
        $MyReps.Add($Rep)
        [JtRep]$Rep = New-JtRep_SoftwareSupport
        $MyReps.Add($Rep)
        [JtRep]$Rep = New-JtRep_SoftwareVray
        $MyReps.Add($Rep)
        [JtRep]$Rep = New-JtRep_Timestamps
        $MyReps.Add($Rep)
        [JtRep]$Rep = New-JtRep_Z_G13
        $MyReps.Add($Rep)
        [JtRep]$Rep = New-JtRep_Z_Iat
        $MyReps.Add($Rep)
        [JtRep]$Rep = New-JtRep_Z_Lab
        $MyReps.Add($Rep)
        [JtRep]$Rep = New-JtRep_Z_Pools
        $MyReps.Add($Rep)
        [JtRep]$Rep = New-JtRep_Z_Server
        $MyReps.Add($Rep)
        [JtRep]$Rep = New-JtRep_Z_Vorwag
        $MyReps.Add($Rep)
        return $MyReps
    }

}
