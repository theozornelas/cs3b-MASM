set projectName=MASM2
\masm32\bin\ml /c /Zi /coff %projectName%.asm
\masm32\bin\Link /debug /SUBSYSTEM:CONSOLE /entry:start /out:%projectName%.exe %projectName%.obj \masm32\lib\kernel32.lib masm32\macros\convutil201604.obj masm32\macros\utility201609.obj
%projectName%.exe