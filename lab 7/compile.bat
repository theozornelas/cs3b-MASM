set projectName=Struct1
\masm32\bin\ml /c /Zi /coff %projectName%.asm
\masm32\bin\Link   /SUBSYSTEM:CONSOLE /out:%projectName%.exe %projectName%.obj
%projectName%.exe
pause