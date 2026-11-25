@echo off
tools\nasm.exe -f bin source\mario.asm -o MARIO.COM
if errorlevel 1 goto build_failed
echo ====================================
echo BUILD SUCCESSFUL! Created MARIO.COM
echo ====================================
goto end
:build_failed
echo ====================================
echo BUILD FAILED! Check NASM errors above.
echo ====================================
:end
