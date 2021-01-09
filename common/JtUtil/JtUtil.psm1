Class JtUtil {

    static [System.Char]$Delimiter = ";"


    static [String]FullIp2IpPart([String]$Ip) {
        if ($Null -eq $Ip) {
            return "000"
        }
        if ($Ip.Length -gt 0) {
            [String[]]$Parts = $Ip.Split(".")
            if ($Parts.Count -eq 4) {
                [String]$Last = $Parts[3]

                [String]$Long = -Join ("000000", $Last)

                $Value = $Long.Substring($Long.length - 3, 3)
                return $Value
            }
        }
        return "000"
    }

    static [Boolean]GetIsValidAs_Decimal([String]$Value) {
        [Boolean]$Result = $True
        [Decimal]$Decimal = 0
        try {
            [Int32]$Inti = [Decimal]$Value
            [Decimal]$Decimal = $Inti / 100
            # [Decimal]$Decimal = $Inti
        }
        catch {
            # Write-JtError -Text ( -join ("Convert problem. Value:", $Value))
            $Result = $False
        }
        return $Result
    }
    
    
    <# 
    FARBEN
    
    Black 
    DarkBlue 
    DarkGreen 
    DarkCyan 
    DarkRed 
    DarkMagenta 
    DarkYellow 
    Gray 
    DarkGray 
    Blue 
    Green 
    Cyan 
    Red 
    Magenta 
    Yellow
    White
    #> 
    
    # --------------------------------------------------------------------------------------------------------------



    [Boolean]GetDev() {
        Write-JtLog -Text ("DEV__________________________________")
        if ($env:COMPUTERNAME -eq "AL-DEK-NB-DEK05") {
            return $True
        }
        elseif ($env:COMPUTERNAME -eq "G13-AL-PC-DELL") {
            return $True
        }
        else {
            return $False
        }
    }

    # not used? 
    static [System.Collections.Specialized.OrderedDictionary]GetDic($Hash) {
        $dictionary = [ordered]@{ }
        if ($Hash -is [System.Collections.Hashtable]) {
            $keys = $Hash.keys | Sort-Object
            foreach ($key in $keys) {
                $dictionary.add($key, $Hash[$key])
            }
            return $dictionary
        }
        elseif ($Hash -is [System.Array]) {
            for ($i = 0; $i -lt $hash.count; $i++) {
                $dictionary.add($i, $hash[$i])
            }
            return $dictionary
        }
        elseif ($Hash -is [System.Collections.Specialized.OrderedDictionary]) {
            return $dictionary
        }

        elseif ($Null -eq $Hash ) {
            Write-JtError -Text ("Hash is null in GetDic!")
            return $dictionary
        }
        else {
            Write-JtError -Text ( -join ("Enter a hash table or an array in GetDic. GetType:", $Hash.getType()))
            return $dictionary
        }

        <# 
 .SYNOPSIS
 Converts a hash table or an array to an ordered dictionary. 
 
 .DESCRIPTION
 ConvertTo-OrderedDictionary takes a hash table or an array and 
 returns an ordered dictionary. 
 
 If you enter a hash table, the keys in the hash table are ordered 
 alphanumerically in the dictionary. If you enter an array, the keys 
 are integers 0 - n.
 
 .PARAMETER $hash
 Specifies a hash table or an array. Enter the hash table or array, 
 or enter a variable that contains a hash table or array.

 .INPUTS
 System.Collections.Hashtable
 System.Array

 .OUTPUTS
 System.Collections.Specialized.OrderedDictionary

 .EXAMPLE
 PS c:\> $myHash = @{a=1; b=2; c=3}
 PS c:\> .\ConvertTo-OrderedDictionary.ps1 -Hash $myHash

 Name Value     
 ---- -----     
 a 1     
 b 2     
 c 3 

 .EXAMPLE
 PS c:\> $myHash = @{a=1; b=2; c=3}
 PS c:\> $myHash = .\ConvertTo-OrderedDictionary.ps1 -Hash $myHash
 PS c:\> $myHash

 Name Value     
 ---- -----     
 a 1     
 b 2     
 c 3
 

 PS c:\> $myHash | Get-Member
 
 TypeName: System.Collections.Specialized.OrderedDictionary
 . . .

 .EXAMPLE
 PS c:\> $colors = "red", "green", "blue"
 PS c:\> $colors = .\ConvertTo-OrderedDictionary.ps1 -Hash $colors
 PS c:\> $colors

 Name Value     
 ---- -----     
 0 red     
 1 green     
 2 blue 

 
 .LINK
 about_hash_tables
#>

    }

}


function ConvertTo-JtDecimalToString2([Decimal]$InputDec) {
    [Decimal]$MyDec = $InputDec
    
    [String]$Result = $MyDec.ToString("0.00")
    $Result = $Result.Replace(".", ",")
    
    return $Result
}

function ConvertTo-JtDecimalToString3([Decimal]$InputDec) {
    [Decimal]$MyDec = $InputDec

    [String]$Result = $MyDec.ToString("0.000")
    $Result = $Result.Replace(".", ",")

    return $Result
}

function ConvertTo-JtFileNameToArea([String]$Filename) {
    [String]$TheFilename = $FileName
    $Parts = $TheFilename.Split(".")
    [String]$MyFlaeche = ""
    try {
        [String]$MySize = $Parts[$Parts.count - 2]
        $SizeParts = $MySize.Split("x")
        if ($SizeParts.Count -lt 2) {
            Write-JtError -Text ( -join ("Problem with FLAECHE in file:", $TheFilename))
        }
        else {
            [String]$Breite = $SizeParts[0]
            [String]$Hoehe = $SizeParts[1]
            [Int32]$IntBreite = [Int32]$Breite
            [Int32]$IntHoehe = [Int32]$Hoehe
            [Int32]$IntFlaeche = $IntBreite * $IntHoehe
            [Decimal]$DecFlaeche = [Decimal]$IntFlaeche / 1000 / 1000
            # [Decimal]$DecFlaeche = [Decimal]$IntFlaeche
            [String]$MyFlaeche = $DecFlaeche.ToString("0.000")
            # [String]$MyFlaeche = $DecFlaeche.ToString("0")
            # $MyFlaeche = $MyFlaeche.Replace(",", ".")
        }
    }
    catch {
        Write-JtError -Text ( -join ("Problem with FLAECHE in file:", $TheFilename))
    }
    return $MyFlaeche
}

function ConvertTo-JtStringToDecimal([String]$MyInput) {
    [String]$Result = $MyInput
    $Result = $Result.Replace(",", ".")
    return [Decimal]$Result
}

function ConvertTo-JtStringToGb([String]$Memory) {
    [String]$In = $Memory
    [String]$Result = ""
    [int64]$IntNum = 0
    if($Null -eq $In) {
        Write-JtError "ConvertTo_StringToGb problem; input was NULL"
        return "NULL"
    }
    try{
        [int64]$IntNum = $In.ToInt64($Null)

    } catch {
        Write-JtError (-join("ConvertTo_StringToGb problem; input:", $In))
        return "ERROR"
    }
    [single]$Mini = $IntNum / 1024 / 1024 / 1024
    [int]$MiniInt = $Mini
    [String]$Giga = -join ($MiniInt , "")

    $Result = $Giga
    return $Result
} 

# quelle https://www.datenteiler.de/powershell-umlaute-ersetzen/
function ConvertTo-StringOhneUmlaute([String]$Text) {
    $UmlautObject = New-Object PSObject | Add-Member -MemberType NoteProperty -Name Name -Value $Text -PassThru
    
    # hash tables are by default case insensitive
    # we have to create a new hash table object for case sensitivity 
    
    $characterMap = New-Object system.collections.hashtable
    $characterMap.ä = "ae"
    $characterMap.ö = "oe"
    $characterMap.ü = "ue"
    $characterMap.Ä = "Ae"
    $characterMap.Ö = "Oe"
    $characterMap.Ü = "Ue"         
    $characterMap.ß = "ss"
    
    foreach ($property  in 'Name') { 
        foreach ($key in $characterMap.Keys) {
            $UmlautObject.$property = $UmlautObject.$property -creplace $key, $characterMap[$key] 
        }
    }
    
    $UmlautObject
    return $UmlautObject.Name
} # Replace-Umlaute 

function ConvertTo-LabelToFilename([String]$MyInput) {
    [String]$Result = $MyInput
    $Result = $Result.Replace(",", "_")
    $Result = $Result.Replace(" ", "_")
    $Result = $Result.Replace("+", "_plus_")
    $Result = $Result.Replace("&", "_und_")
    $Result = $Result.Replace("__", "_")
    $Result = ConvertTo-StringOhneUmlaute $Result
    $Result = $Result.Trim()
    return $Result
}


function ConvertTo-JtExpandedPath([String]$MyPath) {
        
        [String]$Result = $MyPath
        if ($Null -eq $Result) {
            $Result = ""
        }
        $Result = $Result.Replace("%OneDrive%", $env:OneDrive)
        $Result = $Result.Replace("%COMPUTERNAME%", $env:COMPUTERNAME)

        return $Result
    } 

