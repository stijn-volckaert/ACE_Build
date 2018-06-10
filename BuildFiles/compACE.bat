@ECHO OFF
ECHO --- Deleting Old Files...
del ACEv10_AutoConfig.u
del ACEv10h_C.u
del ACEv10h_S.u
del ACEv10h_Cdll.u
del ACEv10h_EH.u
del ..\SystemNew\ACEv10h_C.u
del ..\SystemNew\ACEv10h_Cdll.u
del ..\SystemNew\ACEv10h_C.dll

ECHO --- Copying Binaries....
copy ..\ACE\System\GameServer.so ACEv10h_S.so
copy ..\ACE\System\GameServer.dll ACEv10h_S.dll
copy ..\ACE\System\Client_NonSSE.dll ACEv10h_C_NonSSE.dll
copy ..\ACE\System\Client_SSE_SSE2.dll ACEv10h_C_SSE_SSE2.dll
copy ..\ACE\System\Client_SSE_SSE2_AVX_AVX2.dll ACEv10h_C_SSE_SSE2_AVX_AVX2.dll
copy ..\ACE\System\PlayerManager\PlayerManager PlayerManager\ACEv10h_M
copy ..\ACE\System\PlayerManager\PlayerManager.dll PlayerManager\ACEv10h_M.dll

ECHO --- Setting up ini file...
copy UnrealTournament.ini UnrealTournament.old
del UnrealTournament.ini

ECHO --- Compiling ACE Interface...
copy compACEInterface.ini UnrealTournament.ini
del Uweb.u
copy UWebHacked.u UWeb.u
ucc make
del UWeb.u
copy UWebClean.u UWeb.u

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
ucc make -nobind

ECHO --- Obfuscating/Reflagging Client File...
..\PortableJava\bin\java -jar AnthObfuscator.jar ACEv10h_C.u -s -n -o
del ACEv10h_C.u
rename ACEv10h_C_obfuscated.u ACEv10h_C.u

ECHO --- Obfuscating Server File...
..\PortableJava\bin\java -jar AnthObfuscator.jar ACEv10h_S.u -s -o
del ACEv10h_S.u
rename ACEv10h_S_obfuscated.u ACEv10h_S.u

ECHO --- Restoring ini file...
del UnrealTournament.ini
rename UnrealTournament.old UnrealTournament.ini

ECHO --- Signing Filelist ---

REM Delete old ACE files
ACESign.exe -r ACEFileList.txt ACEv10h_C.u
ACESign.exe -r ACEFileList.txt ACEv10h_C.dll

REM Add new ACE files
ACESign.exe -a ACEFileList.txt ACEv10h_C_NonSSE.dll ACEv10h_C.dll "ACE v1.0h for UT"
ACESign.exe -a ACEFileList.txt ACEv10h_C_SSE_SSE2.dll ACEv10h_C.dll "ACE v1.0h for UT"
ACESign.exe -a ACEFileList.txt ACEv10h_C_SSE_SSE2_AVX_AVX2.dll ACEv10h_C.dll "ACE v1.0h for UT"
ACESign.exe -a ACEFileList.txt ACEv10h_C.u ACEv10h_C.u "ACE v1.0h for UT"

REM Sign the list
ACESign.exe -s anthmasterkey.dat ACEFileList.txt
del ACEFileList.txt
copy ACEFileList.txt.signed ACEFileList.txt