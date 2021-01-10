New-JtIoFileVersionMeta -Path "%OneDrive%\jt"
New-JtIoFileVersionMeta -Path "%OneDrive%\jt\common"
New-JtIoFileVersionMeta -Path "D:\Seafile\al-apps\apps"

New-JtRobocopy -Source "%OneDrive%\jt\common" -Target "D:\Seafile\al-apps\apps\jt\common"

pause



