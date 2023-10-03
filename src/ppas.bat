@echo off
SET THEFILE=D:\Development\nfse-backend\src\nfse_service.exe
echo Linking %THEFILE%
C:\fpcupdeluxe\fpc\bin\i386-win32\ld.exe -b pei-i386 -m i386pe  --gc-sections    --entry=_mainCRTStartup    -o D:\Development\nfse-backend\src\nfse_service.exe D:\Development\nfse-backend\src\link6044.res
if errorlevel 1 goto linkend
C:\fpcupdeluxe\fpc\bin\i386-win32\postw32.exe --subsystem console --input D:\Development\nfse-backend\src\nfse_service.exe --stack 16777216
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occurred while assembling %THEFILE%
goto end
:linkend
echo An error occurred while linking %THEFILE%
:end
