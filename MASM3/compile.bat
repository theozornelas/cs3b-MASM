set projectName=masm3
cls
\masm32\bin\ml /c /Zi /coff %projectName%.asm
\masm32\bin\Link /debug /SUBSYSTEM:CONSOLE /entry:_start /out:%projectName%.exe %projectName%.obj \masm32\lib\kernel32.lib ..\macros\*.obj
%projectName%.exe