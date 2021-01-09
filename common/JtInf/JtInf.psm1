using module JtClass
using module JtTbl


class JtInf : JtClass{

    [JtField]$Id

    [String]$JtInf_Name

    JtInf() {
        $This.ClassName = "Inf"
        $This.Id = New-JtField -Label "Id"
        $This.JtInf_Name = $This.GetType()
    }

    SetId([String]$MyId) {
        $This.Id.SetValue($MyId)
    }

    [String]GetKey() {
        [String]$Key = -Join ($This.Id.getValue(), ".", $This.Id)
        return $Key
    }

    [Object[]]GetProperties() {
        [Object[]]$Prop = Get-Member -InputObject $This -MemberType Property -force
        return $Prop 
    }

    [Boolean]SetObjValue([System.Object]$JtObj, [String]$FieldName, [String]$Prop) {
        if ($Null -ne $JtObj) {
          #  try {
                $This.($FieldName).SetValue($JtObj.($Prop))
           # } 
           # catch {
           #     Write-JtError -Text ( -join ("Field:", "xxxx", ", Error in ", $JtField.GetLabel()))
           # } 
        }
        else {
            Write-JtError -Text ( -join ("Obj is NULL, field:", $FieldName))
        }
        return $True
    }
}

function New-JtInf {
    [JtInf]::new()
}

