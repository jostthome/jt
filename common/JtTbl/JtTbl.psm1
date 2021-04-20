using module Jt  

class JtTbl : JtClass {

    JtTbl() {
        $This.ClassName = "JtTbl"
    }
}

class JtFld : JtClass {

    hidden [String]$Label = ""
    hidden [String]$Value = ""

    JtFld([String]$TheLabel) {
        $This.ClassName = "JtFld"
        $This.Label = $TheLabel
    } 

    JtFld([String]$TheLabel, [String]$TheValue) {
        $This.Label = $TheLabel
        $This.Value = $TheValue
    } 

    SetValue([String]$TheValue) {
        $This.Value = $TheValue
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

Function New-JtFld {

    Param (
        [OutputType([JtFld])][Parameter(Mandatory = $True)][String]$Label,
        [Parameter(Mandatory = $False)][String]$Value

    )
    [String]$MyValue = ""

    if (!($Value)) {
        $MyValue = ""
    }
    else {
        $MyValue = $Value
    }

    [JtFld]::new($Label, $MyValue)
}


class JtTblRow : JtTbl {

    [System.Collections.Specialized.OrderedDictionary]$HashTable = [System.Collections.Specialized.OrderedDictionary]::new()
    [String]$Label = $TheLabel

    
    JtTblRow () {
        $This.ClassName = "JtTblRow"
        $This.Label = $This.ClassName
        $This.HashTable = [System.Collections.Specialized.OrderedDictionary]::new()
    }

    JtTblRow ([String]$TheLabel) {
        $This.ClassName = "JtTblRow"
        $This.Label = $TheLabel
        $This.HashTable = [System.Collections.Specialized.OrderedDictionary]::new()
    }

    [Void]Add([String]$TheKey, [String]$TheValue) {
        [String]$MyKey = $TheKey
        [String]$MyValue = $TheValue

        if ($This.HashTable.Contains($MyKey)) {
            $This.HashTable.($MyKey) = $MyValue
        }
        else {
            try {
                $This.HashTable.add($MyKey, $MyValue) | Out-Null
            }
            catch {
                Write-JtLog_Error -Where $This.ClassName -Text "Error for MyKey: $MyKey VALUE: $MyValue"
            }
        }
    }


    [Void]Add([JtFld]$TheField) {
        [JtFld]$MyField = $TheField
        if ($Null -eq $MyField) {
            Write-JtLog_Error -Where $This.ClassName -Text "Add. MyField is null!"
            # Throw "Field is null!"
        }
        else {
            [String]$MyKey = $MyField.GetLabel()
            [String]$MyValue = $MyField.GetValue()

            $This.Add([String]$MyKey, [String]$MyValue)
        }
    }

    [Int32]GetColsCount() {
        return $This.HashTable.Count
    }

    [System.Collections.Specialized.OrderedDictionary]GetHashTable() {
        return $This.HashTable
    }

    [String]GetHeaderFromColumnByNumber([Int32]$IntColNumber) {
        [String]$MyResult = ""
        $MyAlKeys = $This.HashTable.Keys
        if ($MyAlKeys.Count -gt $IntColNumber) {
            [int32]$i = 0
            foreach ($Key in $MyAlKeys) {
                if ($i -eq $IntColNumber) {
                    $MyResult = $Key
                }
                $i = $i + 1
            }
        }
        return $MyResult
    }

    [System.Collections.ICollection]GetKeys() {
        [System.Collections.ICollection]$MyKeys = $This.HashTable.Keys
        return $MyKeys
    }

    [System.Collections.Specialized.OrderedDictionary]GetObject() {
        Return $This.HashTable
    }

    
    [String]GetLabel() {
        Return $This.Label
    }
    
    [String]GetValue([String]$TheKey) {
        [String]$MyKey = $TheKey
        $MyHash = $This.HashTable
        [String]$MyValue = $MyHash.($MyKey)
        return $MyValue
    }

    [System.Array]GetValues() {
        return $This.HashTable.values
    }

    [String]GetValueFromColumnByNumber([Int32]$IntColNumber) {
        [String]$MyResult = ""
        $MyAlValues = $This.HashTable.Values
        if ($MyAlValues.Count -gt $IntColNumber) {
            [int32]$i = 0
            foreach ($Key in $This.HashTable.Keys) {
                if ($i -eq $IntColNumber) {
                    $MyResult = $This.HashTable.Item($Key)
                }
                $i = $i + 1
            }
        }
        return $MyResult
    }

    # ==============================================================================
    [System.Collections.Specialized.OrderedDictionary]JoinHashtable ([System.Collections.Specialized.OrderedDictionary]$First, [System.Collections.Specialized.OrderedDictionary]$Second) {
        [System.Collections.Specialized.OrderedDictionary]$Fir = $First
        [System.Collections.Specialized.OrderedDictionary]$Sec = $Second
        [System.Collections.Specialized.OrderedDictionary]$MyResult = [System.Collections.Specialized.OrderedDictionary]::new()

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
            $MyResult.Add($MyItem, $Fir[$MyItem])
        }
 
        foreach ($MyItem in $Sec.keys) {
            $MyResult.Add($MyItem, $Sec[$MyItem])
        }
 
        return $MyResult
 
    } #end Join-Hashtable

 
    Join ([JtTblRow]$TheJtTblRow) {
        $MyHash = $TheJtTblRow.HashTable
 
        $This.HashTable = $This.JoinHashtable($This.HashTable, $MyHash)
    }


}

Function New-JtTblRow {

    Param(
        [Parameter(Mandatory = $False)][ValidateNotNullOrEmpty()][String]$Label
    )

    [String]$MyFunctionName = "New-JtTblRow"
    [String]$MyLabel = $MyFunctionName

    if ($Label) {
        $MyLabel = $Label
    }

    [JtTblRow]$MyRow = [JtTblRow]::new($MyLabel)
$MyRow
}


class JtTblTable : JtTbl {
 
    hidden [String]$Label
    hidden [System.Collections.ArrayList]$Objects = [System.Collections.ArrayList]::new()

    [int32]$ColsCount = 0

 
    JtTblTable([String]$TheLabel) {
        $This.ClassName = "JtTblTable"
        $This.Label = $TheLabel
        $This.Objects = [System.Collections.ArrayList]::new()
    }

    [Void]AddRow([JtTblRow]$TheJtTblRow) {
        [JtTblRow]$MyJtTblRow = $TheJtTblRow
        if ($MyJtTblRow) {
            [int32]$MyIntColsCount = $MyJtTblRow.GetColsCount()
            if ($MyIntColsCount -gt $This.ColsCount) {
                $This.ColsCount = $MyIntColsCount
            }
            [System.Collections.Specialized.OrderedDictionary]$MyHashTable = $MyJtTblRow.HashTable
            $This.Objects.add($MyHashTable)
        }
        else {
            Write-JtLog_Error -Where $This.ClassName -Text "AddRow. MyJtTblRow is NULL."
        }
    }

    [String]GetLabel() {
        return $This.Label
    }

    [System.Collections.ArrayList]GetObjects() {
        [System.Collections.ArrayList]$MyObjects = $This.Objects
        return $MyObjects
    }
    
    [System.Collections.ArrayList]GetOutput() {
        [System.Collections.ArrayList]$MyAlOutput = [System.Collections.ArrayList]::new()
        foreach ($Line In $This.Objects) {
            $MyLo = $Line
            $MyAlOutput.add($MyLo)
        }
        return $MyAlOutput
    }

    [System.Collections.ArrayList]GetRows() {
        [System.Collections.ArrayList]$MyRows = $This.Rows

        return $MyRows
    }
}

Function New-JtTblTable {

    Param (
        [Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()][String]$Label
    )

    [JtTblTable]::new($Label)
}

Export-ModuleMember -Function New-JtFld
Export-ModuleMember -Function New-JtTbl
Export-ModuleMember -Function New-JtTblTable
Export-ModuleMember -Function New-JtTblRow