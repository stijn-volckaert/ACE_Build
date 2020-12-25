@ECHO OFF
ECHO --- Deleting Old Files...
del ACEv12_AutoConfig.u
del ACEv12e_C.u
del ACEv12e_S.u
del ACEv12e_Cdll.u
del ACEv12e_EH.u
del ACEv12e_C.dll
del ..\SystemNew\ACEv12e_C.u
del ..\SystemNew\ACEv12e_Cdll.u
del ..\SystemNew\ACEv12e_C.dll
del ..\..\UnrealTournament436\SystemNew\ACEv12e_C.u
del ..\..\UnrealTournament436\SystemNew\ACEv12e_C.dll
del ..\..\UnrealTournament436\SystemNew\ACEv12e_Cdll.u

ECHO --- Copying Binaries....
copy ..\ACE\System\GameServer.so ACEv12e_S.so
copy ..\ACE\System\GameServer.dll ACEv12e_S.dll
copy ..\ACE\System\Client_NonSSE.dll ACEv12e_C_NonSSE.dll
copy ..\ACE\System\Client_SSE_SSE2.dll ACEv12e_C_SSE_SSE2.dll
copy ..\ACE\System\Client_SSE_SSE2_AVX_AVX2.dll ACEv12e_C_SSE_SSE2_AVX_AVX2.dll

ECHO --- Setting up ini file...
copy UnrealTournament.ini UnrealTournament.old
del UnrealTournament.ini

ECHO --- Compiling ACE Interface...
copy compACEInterface.ini UnrealTournament.ini
ucc make -bytehax

ECHO --- Switching ini file...
del UnrealTournament.ini
copy compACEEH.ini UnrealTournament.ini

ECHO --- Compiling ACE EventHandler...
ucc make

ECHO --- Switching ini file...
del UnrealTournament.ini
copy compACEAC.ini UnrealTournament.ini

ECHO --- Compiling ACE AutoConfig...
ucc make

ECHO --- Switching ini file...
del UnrealTournament.ini
copy compACE.ini UnrealTournament.ini

ECHO --- Compiling Main Packages...
ucc make -nobind -bytehax

ECHO --- Obfuscating/Reflagging Client File...
..\PortableJava\bin\java -jar AnthObfuscator.jar ACEv12e_C.u -s -n -o
del ACEv12e_C.u
rename ACEv12e_C_obfuscated.u ACEv12e_C.u

ECHO --- Obfuscating Server File...
..\PortableJava\bin\java -jar AnthObfuscator.jar ACEv12e_S.u -s -o
del ACEv12e_S.u
rename ACEv12e_S_obfuscated.u ACEv12e_S.u

ECHO --- Restoring ini file...
del UnrealTournament.ini
rename UnrealTournament.old UnrealTournament.ini

ECHO --- Signing Filelist ---

REM Delete old ACE files
ACESign.exe -r ACEFileList.txt ACEv12e_C.u
ACESign.exe -r ACEFileList.txt ACEv12e_C.dll

REM Add new ACE files
ACESign.exe -a ACEFileList.txt ACEv12e_C_NonSSE.dll ACEv12e_C.dll "ACE v1.2e for UEngine 1"
ACESign.exe -a ACEFileList.txt ACEv12e_C_SSE_SSE2.dll ACEv12e_C.dll "ACE v1.2e for UEngine 1"
ACESign.exe -a ACEFileList.txt ACEv12e_C_SSE_SSE2_AVX_AVX2.dll ACEv12e_C.dll "ACE v1.2e for UEngine 1"
ACESign.exe -a ACEFileList.txt ACEv12e_C.u ACEv12e_C.u "ACE v1.2e for UEngine 1"

REM Sign the list
ACESign.exe -s anthmasterkey.dat ACEFileList.txt
del ACEFileList.txt
copy ACEFileList.txt.signed ACEFileList.txt
