set projectName=masm4
cls
\masm32\bin\ml /c /Zi /coff String1.asm
\masm32\bin\ml /c /Zi /coff String2.asm
\masm32\bin\ml /c /Zi /coff %projectName%.asm
\masm32\bin\Link /debug /SUBSYSTEM:CONSOLE /entry:start /out:%projectName%.exe String1.obj String2.obj %projectName%.obj \masm32\lib\kernel32.lib ..\macros\*.obj
%projectName%.exe