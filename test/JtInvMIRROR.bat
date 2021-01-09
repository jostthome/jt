@echo off
SET PATH_BASE=%~dp0
SET PATH_BASE=%PATH_BASE:~0,-1%

set MY_PS1=A_Mirror.ps1
set MY_COMMON=%OneDrive%\0.INVENTORY\common
powershell -executionpolicy bypass -file "%MY_COMMON%\a\%MY_PS1%"