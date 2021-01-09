@echo off
SET PATH_BASE=%~dp0
SET PATH_BASE=%PATH_BASE:~0,-1%

set MY_PS1=AA_Pools_Login.ps1
powershell -executionpolicy bypass -file "%onedrive%\0.INVENTORY\aa\%MY_PS1%"