@ECHO OFF
ECHO --- Deleting Old Files...
del ACEv10_AutoConfig.u
del ACEv10d_C.u
del ACEv10d_S.u
del ACEv10d_Cdll.u
del ACEv10d_EH.u
del ..\SystemNew\ACEv10d_C.u
del ..\SystemNew\ACEv10d_Cdll.u
del ..\SystemNew\ACEv10d_C.dll

ECHO --- Copying Binaries....
copy ..\ACE\System\GameServer.so ACEv10d_S.so
copy ..\ACE\System\GameServer.dll ACEv10d_S.dll
copy ..\ACE\System\Client_NonSSE.dll ACEv10d_C_NonSSE.dll
copy ..\ACE\System\Client_SSE_SSE2.dll ACEv10d_C_SSE_SSE2.dll
copy ..\ACE\System\Client_SSE_SSE2_AVX_AVX2.dll ACEv10d_C_SSE_SSE2_AVX_AVX2.dll
copy ..\ACE\System\PlayerManager\PlayerManager PlayerManager\ACEv10d_M
copy ..\ACE\System\PlayerManager\PlayerManager.dll PlayerManager\ACEv10d_M.dll

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
..\PortableJava\bin\java -jar AnthObfuscator.jar ACEv10d_C.u -s -n -o
del ACEv10d_C.u
rename ACEv10d_C_obfuscated.u ACEv10d_C.u

ECHO --- Obfuscating Server File...
..\PortableJava\bin\java -jar AnthObfuscator.jar ACEv10d_S.u -s -o
del ACEv10d_S.u
rename ACEv10d_S_obfuscated.u ACEv10d_S.u

ECHO --- Restoring ini file...
del UnrealTournament.ini
rename UnrealTournament.old UnrealTournament.ini

ECHO --- Signing Filelist ---

REM Delete old ACE files
ACESign.exe -r ACEFileList.txt ACEv10d_C.u
ACESign.exe -r ACEFileList.txt ACEv10d_C.dll

REM Add new ACE files
ACESign.exe -a ACEFileList.txt ACEv10d_C_NonSSE.dll ACEv10d_C.dll "ACE v1.0d for UT"
ACESign.exe -a ACEFileList.txt ACEv10d_C_SSE_SSE2.dll ACEv10d_C.dll "ACE v1.0d for UT"
ACESign.exe -a ACEFileList.txt ACEv10d_C_SSE_SSE2_AVX_AVX2.dll ACEv10d_C.dll "ACE v1.0d for UT"
ACESign.exe -a ACEFileList.txt ACEv10d_C.u ACEv10d_C.u "ACE v1.0d for UT"

REM Sign the list
ACESign.exe -s anthmasterkey.dat ACEFileList.txt
del ACEFileList.txt
copy ACEFileList.txt.signed ACEFileList.txt