using module JtTbl
using module JtInf

class JtInf_AFolder : JtInf {

    [Boolean]$IsValid = $True

    [JtField]$Name
    [JtField]$JtVersion
    [JtField]$Alias
    [JtField]$Computername
    [JtField]$DaysAgo
    [JtField]$Errors
    [JtField]$FolderPath
    [JtField]$Ip
    [JtField]$KlonVersion
    [JtField]$LabelC
    [JtField]$Org
    [JtField]$Org1
    [JtField]$Org2
    [JtField]$ReportExists
    [JtField]$SystemId
    [JtField]$Timestamp
    [JtField]$Type
    [JtField]$User
    [JtField]$WinBuild
    [JtField]$WinGen
    [JtField]$WinVersion
    


    JtInf_AFolder() {
        $This.Name = New-JtField -Label "Name"
        $This.JtVersion = New-JtField -Label "JtVersion"
        $This.Alias = New-JtField -Label "Alias"
        $This.Computername = New-JtField -Label "Computername"
        $This.DaysAgo = New-JtField -Label "DaysAgo"
        $This.Errors = New-JtField -Label "Errors"
        $This.FolderPath = New-JtField -Label "FolderPath"
        $This.Ip = New-JtField -Label "Ip"
        $This.KlonVersion = New-JtField -Label "KlonVersion"
        $This.LabelC = New-JtField -Label "LabelC"
        $This.Org = New-JtField -Label "Org"
        $This.Org1 = New-JtField -Label "Org1"
        $This.Org2 = New-JtField -Label "Org2"
        $This.ReportExists = New-JtField -Label "ReportExists"
        $This.SystemId = New-JtField -Label "SystemId"
        $This.Timestamp = New-JtField -Label "Timestamp"
        $This.Type = New-JtField -Label "Type"
        $This.User = New-JtField -Label "User"
        $This.WinVersion = New-JtField -Label "WinVersion"
        $This.WinBuild = New-JtField -Label "WinBuild"
        $This.WinGen = New-JtField -Label "WinGen"
    }

}
Function New-JtInf_AFolder {

    [JtInf_AFolder]::new()
}
function New-JtInit_Inf_AFolder {

    Param (
        [Parameter(Mandatory = $true)]
        [JtIoFolder]$JtIoFolder
    )

    $JtInf = New-JtInf_AFolder

    [JtTimeStop]$Uhr = [JtTimeStop]::new()
    [String]$Message = -join ("Preparing Information for:", $JtIoFolder.GetPath())
    $Uhr.Start($Message)


    [String]$MyId = $JtIoFolder.GetPath()
    $JtInf.SetId($Myid)
    [String]$MyName = $JtIoFolder.GetName()
    $JtInf.Get_Name().SetValue($MyName)
    $JtInf.IsValid = $True

    $JtInf.Get_FolderPath().SetValue($JtIoFolder.GetPath())
    
    [String]$MyLabelC = "label_c"
    [String]$MyComputername = "computername"
    [String]$MySystemId = "systemid"
    
    [String]$FolderName = $JtIoFolder.GetName()
    if ("report" -eq $FolderName) {
        $MyComputername = $env:COMPUTERNAME
        $MyLabelC = [JtIo]::GetLabelC()
        # $JtInf.Alias
    }
    else {
        [String[]]$Parts = $FolderName.Split(".")
        if ($Parts.length -lt 2) {
            Write-JtError -Text ( -join ("Ungueltiger Name:", $FolderName, " - ", $JtIoFolder.GetPath()))
            $JtInf.IsValid = $False
        }
        else {
            $MyComputername = $Parts[0]

            $MyLabelC = $Parts[1]
        }
    }



    $JtInf.Get_LabelC().SetValue($MyLabelC)

    $MyComputername = $MyComputername.ToLower()
    $JtInf.Get_Computername().SetValue($MyComputername)

    $MySystemId = -join ($MyComputername, ".", $MyLabelC)
    $JtInf.Get_SystemId().SetValue($MySystemId)

    [String]$MyAlias = [JtInfi]::GetAliasForComputername($MyComputername)
    $JtInf.Get_Alias().SetValue($MyAlias)

    [String]$MyOrg1 = [JtInfi]::GetOrg1ForComputername($MyAlias)
    $JtInf.Get_Org1().SetValue($MyOrg1)

    [String]$MyOrg2 = [JtInfi]::GetOrg2ForComputername($MyAlias)
    $JtInf.Get_Org2().SetValue($MyOrg2)

    [String]$MyType = [JtInfi]::GetTypeForComputername($MyAlias)
    $JtInf.Get_Type().SetValue($MyType)

    if ($MyAlias.Length -gt 5) {
        $JtInf.Get_Org().SetValue($MyAlias.Substring(0, 6))
    }

    if (Test-Path ($JtInf.Get_FolderPath())) {
        [String]$MyJtVersion = [JtInfi]::GetJtVersion($JtIoFolder.GetPath())
        $JtInf.Get_JtVersion().SetValue($MyJtVersion)

        [String]$MyTimestamp = [JtInfi]::GetTheTimestamp($JtInf.Get_FolderPath())
        $JtInf.Get_Timestamp().SetValue($MyTimestamp)

        [String]$MyDaysAgo = [JtInfi]::GetDaysAgo($JtIoFolder.GetPath())
        $JtInf.Get_DaysAgo().SetValue($MyDaysAgo)

        [String]$MyWinVersion = [JtInfi]::GetWinVersion($JtInf.Get_FolderPath())
        $JtInf.Get_WinVersion().SetValue($MyWinVersion)

        [String]$MyWinGen = [JtInfi]::GetWinVersionGen($MyWinVersion)
        $JtInf.Get_WinGen().SetValue($MyWinGen)

        [String]$MyWinBuild = [JtInfi]::GetWinVersionBuild($MyWinVersion)
        $JtInf.Get_WinBuild().SetValue($MyWinBuild)

        [String]$MyKlonVersion = [JtInfi]::GetKlonVersion($JtInf.Get_FolderPath())
        $JtInf.Get_KlonVersion().SetValue($MyKlonVersion)

        [String]$MyIp = [JtInfi]::GetIp($JtInf.Get_FolderPath())
        $JtInf.Get_Ip().SetValue($MyIp)

        [String]$MyUser = [JtInfi]::GetMasterUser($JtInf.Get_FolderPath())
        $JtInf.Get_User().SetValue($MyUser)
    }
    else {
        $JtInf.IsValid = $False
    }

    return [JtInf_AFolder]$JtInf

}


