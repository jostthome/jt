
function createDT() {
    ###Creating a new DataTable###
    $tempTable = New-Object System.Data.DataTable
   
    ##Creating Columns for DataTable##
    $col1 = New-Object System.Data.DataColumn("ColumnName1")
    $col2 = New-Object System.Data.DataColumn("ColumnName2")
    $col3 = New-Object System.Data.DataColumn("ColumnName3")
           
    ###Adding Columns for DataTable###
    $tempTable.columns.Add($col1)
    $tempTable.columns.Add($col2)
    $tempTable.columns.Add($col3)
       
    return , $tempTable
}
function addRow {

    param (
        [Parameter()]
        [System.Data.DataTable]$Table,
        [Parameter()]
        [String]$Val1,
        [Parameter()]
        [String]$Val2,
        [Parameter()]
        [String]$Val3

    )

    $row = $Table.NewRow()
    $row.ColumnName1 = $Val1
    $row.ColumnName2 = $Val2
    $row.ColumnName3 = $Val2
    $row
}

[System.Data.DataTable]$dTable = createDT
#Add a row to DataTable


$row = addRow -Table $dTable -Val1 "11" -Val2 "12" -Val3 "13"
$dTable.rows.add($row)
$row = addRow -Table $dTable -Val1 "21" -Val2 "22" -Val3 "23"
$dTable.rows.add($row)
$row = addRow -Table $dTable -Val1 "31" -Val2 "32" -Val3 "33"
$dTable.rows.add($row)



$dTable.GetType()
$dTable


