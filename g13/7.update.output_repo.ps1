using module JtColRen
using module JtIo
using module JtTbl

Set-StrictMode -Version "2.0"
# $ErrorActionPreference = "Inquire"
$ErrorActionPreference = "Stop"

Function Get-JtFolderPath_Input_Repo_Data {
    [String]$MyFolderPath_Input = -join ($env:OneDrive, "\", "DATA")
    return $MyFolderPath_Input
}
Function Get-JtFolderPath_Output_Repo_Data {
    [String]$MyComputername = Get-JtComputername
    [String]$MyFolderPath_Output = -join ($env:OneDrive, "\", "0.INVENTORY", "\", "01.OUTPUT", "\", "repo", "\", $MyComputername)
    return $MyFolderPath_Output
}

Function Get-JtFolderPath_Input_Repo_Seafile {
    [String]$MyFolderPath_Input = -join ("D:\seafile\al-it")
    return $MyFolderPath_Input
}

Function Get-JtFolderPath_Output_Repo_Seafile {
    [String]$MyComputername = Get-JtComputername
    [String]$MyFolderPath_Output = -join ($env:OneDrive, "\", "0.INVENTORY", "\", "01.OUTPUT", "\", "repo", "\", $MyComputername)
    return $MyFolderPath_Output
}


Function New-JtReportFiles_Data {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "New-JtReportFiles_Data"
    
    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output

    [JtDataRepository]$MyJtDataRepository = Get-JtDataRepository -FolderPath $MyFolderPath_Input

    Write-JtLog -Where $MyFunctionName -Text "Alle Dateien sind unterhalb von $MyFolderPath_Input"

    [Decimal]$MyDecValue = $MyJtDataRepository.GetDecSize()
    [String]$MyValue = Convert-JtDecimal_To_String3 -Decimal $MyDecValue
    $MyParams = @{
        FolderPath_Input  = $MyFolderPath_Input
        FolderPath_Output = $MyFolderPath_Output
        Name              = "size"
        Value             = $MyValue
    }
    Write-JtIoFile_Meta_Report @MyParams
    
    $MyParams = @{
        FolderPath_Input  = $MyFolderPath_Input
        FolderPath_Output = $MyFolderPath_Output
        Name              = "files"
        Value             = $MyJtDataRepository.GetIntFiles()
    }
    Write-JtIoFile_Meta_Report @MyParams
    
    $MyParams = @{
        FolderPath_Input  = $MyFolderPath_Input
        FolderPath_Output = $MyFolderPath_Output
        Name              = "folders_all"
        Value             = $MyJtDataRepository.GetAlJtDataFolders().Count
    }
    Write-JtIoFile_Meta_Report @MyParams

    $MyParams = @{
        FolderPath_Input  = $MyFolderPath_Input
        FolderPath_Output = $MyFolderPath_Output
        Name              = "folders_betrag"
        Value             = $MyJtDataRepository.GetAlJtDataFolders_Betrag().Count
    }
    Write-JtIoFile_Meta_Report @MyParams
}

Function Update-JtMeta {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input
    )

    # [String]$MyFunctionName = "Update-JtMeta"

    [String]$MyFolderPath_Input = $FolderPath_Input
    # [String]$MyFolderPath_Output = $FolderPath_Output
    

    [JtDataRepository]$MyJtDataRepository = Get-JtDataRepository -FolderPath $MyFolderPath_Input

    [System.Collections.ArrayList]$MyAlJtDataFolders = $MyJtDataRepository.GetAlJtDataFolders_Zahlung()
    ForEach ($Folder in $MyAlJtDataFolders) {
        [JtDataFolder]$MyJtDataFolder = $Folder
        $MyJtDataFolder.DoUpdateMeta()
    }

    [System.Collections.ArrayList]$MyAlJtDataFolders = $MyJtDataRepository.GetAlJtDataFolders_Betrag()
    ForEach ($Folder in $MyAlJtDataFolders) {
        [JtDataFolder]$MyJtDataFolder = $Folder
        $MyJtDataFolder.DoUpdateMeta()
    }
}

Function Update-JtMd {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )

    [String]$MyFunctionName = "Update-JtMd"

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = -join($FolderPath_Output, "\", "md")
    

    [JtDataRepository]$MyJtDataRepository = Get-JtDataRepository -FolderPath $MyFolderPath_Input

    [System.Collections.ArrayList]$MyAlJtDataFolders = $MyJtDataRepository.GetAlJtDataFolders()
    ForEach ($Folder in $MyAlJtDataFolders) {
        [JtDataFolder]$MyJtDataFolder = $Folder
        [System.Collections.ArrayList]$MyAlJtIoFiles_Normal = $MyJtDataFolder.GetAlJtIoFiles_Normal()
        
        #[String]$MyLabel = $Label
        [String]$MyLabel = $MyJtDataFolder.GetName()
    
        Write-JtLog -Where $MyFunctionName -Text "MyLabel: $MyLabel"
    
        [JtTblTable]$MyJtTblTable = New-JtTblTable -Label $MyLabel
        foreach ($File in $MyAlJtIoFiles_Normal) {
            [JtIoFile]$MyJtIoFile = $File
    
            [JtTblRow]$MyJtTblRow = Convert-JtIoFile_To_JtTblRow_Document -FilePath $MyJtIoFile
            $MyJtTblTable.AddRow($MyJtTblRow)  | Out-Null
        }
        $MyDatatable = Convert-JtTblTable_To_Datatable -JtTblTable $MyJtTblTable
        if($MyDatatable.rows.count -gt 0) {
            Convert-JtDataTable_To_Csv -DataTable $MyDatatable -Label $MyLabel -FolderPath_Output $MyFolderPath_Output
        } else {
            Write-JtLog_Error -Where $MyFunctionName -Text "DataTable is empty. MyFolderPath_Input: $MyFolderPath_Input"
        }
    }
}

Function Update-JtOutput_Repo {
    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Input,
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$FolderPath_Output
    )    

    [String]$MyFolderPath_Input = $FolderPath_Input
    [String]$MyFolderPath_Output = $FolderPath_Output

    # Update-JtMd -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
    Test-JtFolder_Recurse -FolderPath_Input $MyFolderPath_Input

    New-JtRepo_Report_NormalFiles -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output

    
    New-JtRepo_Report_Parts -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
    New-JtRepo_Report_Templates -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
    
    New-JtRepo_Report_Problems -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output

    New-JtRepo_Report_Foldertypes -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
    New-JtRepo_Report_YyyJpg -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output

    New-JtRepo_Report_Meta -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
    
    New-JtRepo_Report_Foldernames -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
    
    New-JtReportFiles_Data -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
    
    New-JtRepo_Report_Repo -FolderPath_Input $MyFolderPath_Input -FolderPath_Output $MyFolderPath_Output
    
    New-JtRepo_Report_Betraege -Years "2018.2019.2020" -FolderPath_Input $MyFolderPath_Input  -FolderPath_Output $MyFolderPath_Output
    
    Update-JtMeta -FolderPath_Input $MyFolderPath_Input
}

[String]$FolderPath_Input_Seafile = Get-JtFolderPath_Input_Repo_Seafile
[String]$FolderPath_Output_Seafile = Get-JtFolderPath_Output_Repo_Seafile

Update-JtOutput_Repo -FolderPath_Input $FolderPath_Input_Seafile -FolderPath_Output $FolderPath_Output_Seafile

[String]$FolderPath_Input_Data = Get-JtFolderPath_Input_Repo_Data
[String]$FolderPath_Output_Data = Get-JtFolderPath_Output_Repo_Data

Update-JtOutput_Repo -FolderPath_Input $FolderPath_Input_Data -FolderPath_Output $FolderPath_Output_Data

[String]$FolderPath_Input_Seafile = Get-JtFolderPath_Input_Repo_Seafile
[String]$FolderPath_Output_Seafile = Get-JtFolderPath_Output_Repo_Seafile

Update-JtOutput_Repo -FolderPath_Input $FolderPath_Input_Seafile -FolderPath_Output $FolderPath_Output_Seafile