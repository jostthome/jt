Set-StrictMode -Version "2.0"
$ErrorActionPreference = "Stop"


# New-JtCsv_FolderSummaryMeta -Label "023.PCS_NOTEBOOKS" -FolderPath "D:\Seafile\al-it\0.INVENTORY\02.INPUT" -Sub "023.PCS_NOTEBOOKS"

New-JtCsv_ComputerRoomUser -FolderPath_Input "D:\Seafile\al-it\0.INVENTORY\02.INPUT\023.PCS_NOTEBOOKS" -FolderPath_Output "D:\Seafile\al-it\0.INVENTORY\01.OUTPUT\ComputerRoomUser" -Expected ".room.meta,.user.meta,.homeoffice.meta"
