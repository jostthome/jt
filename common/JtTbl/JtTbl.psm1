using module JtClass

class JtTbl : JtClass {

    JtTbl() {
        $This.ClassName = "JtTbl"
    }
}

class JtField {

    hidden [String]$Label = ""
    hidden [String]$Value = ""

    JtField([String]$MyLabel) {
        $This.Label = $MyLabel
    } 

    JtField([String]$MyLabel, [String]$MyValue) {
        $This.Label = $MyLabel
        $This.Value = $MyValue
    } 

    SetValue([String]$MyValue) {
        $This.Value = $MyValue
    } 

    [String]GetValue() {
        return $This.Value
    } 

    [String]GetLabel() {
        return $This.Label
    } 

    [String]ToString() {
        return $This.Value
    } 
} 

Function New-JtField {

    Param (
        [OutputType([JtField])]
        [Parameter(Mandatory = $true)]
        [String]$Label,
        [Parameter(Mandatory = $false)]
        [String]$Value

    )
    [String]$MyValue = ""

    if (!($Value)) {
        $MyValue = ""
    }
    else {
        $MyValue = $Value
    }

    [JtField]::new($Label, $MyValue)
}


class JtTblRow : JtTbl {

    [System.Collections.Specialized.OrderedDictionary]$HashTable = [System.Collections.Specialized.OrderedDictionary]::new()

    
    JtTblRow () {
        $This.ClassName = "JtTblRow"
        $This.HashTable = [System.Collections.Specialized.OrderedDictionary]::new()
    }

    [Boolean]Add([String]$Key, [String]$Value) {
        if ($This.HashTable.Contains($Key)) {
            $This.HashTable.($Key) = $Value
            return $True
        }
        else {
            try {
                $This.HashTable.add($Key, $Value) | Out-Null
                return $True
            }
            catch {
                Write-JtError -Text ( -join ("Error for ", $Key, " and ", $Value))
                return $False
            }
        }
    }


    [Boolean]Add([JtField]$Field) {
        if ($Null -eq $Field) {
            Write-JtError -Text ("Field is null!")
            # Throw "Field is null!"
        }
        else {
            [String]$Key = $Field.GetLabel()
            [String]$Value = $Field.GetValue()

            return $This.Add([String]$Key, [String]$Value)
        }
        return $False
    }

    [Int32]GetColsCount() {
        return $This.HashTable.Count
    }

    [System.Collections.Specialized.OrderedDictionary]GetHashTable() {
        return $This.HashTable
    }

    [String]GetHeaderFromColumnByNumber([Int32]$IntColNumber) {
        [String]$Result = ""
        $Keys = $This.HashTable.Keys
        if ($Keys.Count -gt $IntColNumber) {
            [int32]$i = 0
            foreach ($Key in $This.HashTable.Keys) {
                
                if ($i -eq $IntColNumber) {
                    $Result = $Key

                }
                $i = $i + 1
            }
        }
        return $Result
    }

    [System.Collections.ICollection]GetKeys() {
        [System.Collections.ICollection]$Keys = $This.HashTable.Keys
        return $Keys
    }

    [System.Collections.Specialized.OrderedDictionary]GetObject() {
        Return $This.HashTable
    }
    
    [String]GetValue ([String]$Key) {
        $MyHash = $This.HashTable
        [String]$Value = $MyHash.($Key)
        return $Value
    }

    [System.Array]GetValues() {
        return $This.HashTable.values
    }

    [String]GetValueFromColumnByNumber([Int32]$IntColNumber) {
        [String]$Result = ""
        $Values = $This.HashTable.Values
        if ($Values.Count -gt $IntColNumber) {
            [int32]$i = 0
            foreach ($Key in $This.HashTable.Keys) {
                
                if ($i -eq $IntColNumber) {
                    $Result = $This.HashTable.Item($Key)

                }
                $i = $i + 1
            }
        }
        return $Result
    }

    # ==============================================================================
    [System.Collections.Specialized.OrderedDictionary]JoinHashtable ([System.Collections.Specialized.OrderedDictionary]$First, [System.Collections.Specialized.OrderedDictionary]$Second) {
        [System.Collections.Specialized.OrderedDictionary]$Fir = $First
        [System.Collections.Specialized.OrderedDictionary]$Sec = $Second
        [System.Collections.Specialized.OrderedDictionary]$Result = [System.Collections.Specialized.OrderedDictionary]::new()

        if ($Null -eq $Fir) {
            Write-Host "This should not happen in JoinHashtable: $Fir is NULL" 
            return $Sec
        }

        if ($Null -eq $Sec) {
            Write-Host "This should not happen in JoinHashtable: $Sec is NULL" 
            return $Fir
        }
 
        foreach ($MyItem in $Fir.Keys) {
            if ($Sec.Contains($MyItem)) {
                $Sec.Remove($MyItem)
            }
        }
 
        foreach ($MyItem in $Fir.keys) {
            $Result.Add($MyItem, $Fir[$MyItem])
        }
 
        foreach ($MyItem in $Sec.keys) {
            $Result.Add($MyItem, $Sec[$MyItem])
        }
 
        return $Result
 
    } #end Join-Hashtable
 
    [Boolean]Join ([JtTblRow]$JtTblRow) {
        $MyHash = $JtTblRow.HashTable
 
        $This.HashTable = $This.JoinHashtable($This.HashTable, $MyHash)
        return $True
    }
}

Function New-JtTblRow {

    Param(

    )

    [JtTblRow]::new()
}


class JtTblTable : JtTbl {
 
    hidden [String]$Label
    hidden [System.Collections.ArrayList]$Objects = [System.Collections.ArrayList]::new()

    [int32]$ColsCount = 0

 
    JtTblTable([String]$MyLabel) {
        $This.ClassName = "JtTblTable"
        $This.Label = $MyLabel
        $This.Objects = [System.Collections.ArrayList]::new()
    }

    [Boolean]AddRow([JtTblRow]$JtTblRow) {
        [int32]$RowColsCount = $JtTblRow.GetColsCount()
        if ($RowColsCount -gt $This.ColsCount) {
            $This.ColsCount = $RowColsCount
        }
        [System.Collections.Specialized.OrderedDictionary]$HashTable = $JtTblRow.HashTable
        $This.Objects.add($HashTable)
        return $true
    }

    [String]GetLabel() {
        return $This.Label
    }

    [System.Collections.ArrayList]GetObjects() {
        [System.Collections.ArrayList]$MyObjects = $This.Objects
        return $MyObjects
    }
    
    [System.Collections.ArrayList]GetOutput() {
        [System.Collections.ArrayList]$Output = [System.Collections.ArrayList]::new()
        foreach ($MyLine In $This.Objects) {
            $Mlo = $MyLine
            $Output.add($Mlo)
        }
        return $Output
    }

    [System.Collections.ArrayList]GetRows() {
        [System.Collections.ArrayList]$MyRows = $This.Rows

        return $MyRows
    }
}

Function New-JtTblTable {

    Param (
        [Parameter(Mandatory = $true)]
        [String]$Label
    )

    [JtTblTable]::new($Label)
}

Function Get-JtDataTableFromTable {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [JtTblTable]$JtTblTable
    )

    [System.Data.DataTable]$DataTable = New-Object System.Data.DataTable
    [System.Collections.ArrayList]$MyObjects = $JtTblTable.GetObjects()

    [System.Collections.Specialized.OrderedDictionary]$OrdDic = $MyObjects[0]
    foreach ($MyKey in $OrdDic.keys) {
        $DataTable.Columns.Add($MyKey, "String")
    }
    [System.Collections.ArrayList]$MyObjects = $JtTblTable.GetObjects()

    foreach ($Element in $MyObjects) {
        [System.Collections.Specialized.OrderedDictionary]$OrdDic = $Element

        $Row = $DataTable.NewRow()

        foreach ($MyKey in $OrdDic.keys) {
            $row.($MyKey) = $OrdDic[$MyKey]
        }
        $DataTable.Rows.Add($Row)
    }
    # [System.Data.DataTable]$DataTable | Format-Table
    
    # return [System.Data.DataTable]$DataTable
    # return [System.Data.DataTable]$DataTable
    Write-Host "Get-JtDataTableFromTable - Type:" $DataTable.GetType()
    return $DataTable
}



Export-ModuleMember -Function New-JtField, New-JtTbl, New-JtTblTable, New-JtTblRow, Get-JtDataTableFromTable