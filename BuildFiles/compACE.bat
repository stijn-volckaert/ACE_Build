@ECHO OFF
ECHO --- Deleting Old Files...
del ACEv10_AutoConfig.u
del ACEv10g_C.u
del ACEv10g_S.u
del ACEv10g_Cdll.u
del ACEv10g_EH.u
del ..\SystemNew\ACEv10g_C.u
del ..\SystemNew\ACEv10g_Cdll.u
del ..\SystemNew\ACEv10g_C.dll

ECHO --- Copying Binaries....
copy ..\ACE\System\GameServer.so ACEv10g_S.so
copy ..\ACE\System\GameServer.dll ACEv10g_S.dll
copy ..\ACE\System\Client_NonSSE.dll ACEv10g_C_NonSSE.dll
copy ..\ACE\System\Client_SSE_SSE2.dll ACEv10g_C_SSE_SSE2.dll
copy ..\ACE\System\Client_SSE_SSE2_AVX_AVX2.dll ACEv10g_C_SSE_SSE2_AVX_AVX2.dll
copy ..\ACE\System\PlayerManager\PlayerManager PlayerManager\ACEv10g_M
copy ..\ACE\System\PlayerManager\PlayerManager.dll PlayerManager\ACEv10g_M.dll

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
..\PortableJava\bin\java -jar AnthObfuscator.jar ACEv10g_C.u -s -n -o
del ACEv10g_C.u
rename ACEv10g_C_obfuscated.u ACEv10g_C.u

ECHO --- Obfuscating Server File...
..\PortableJava\bin\java -jar AnthObfuscator.jar ACEv10g_S.u -s -o
del ACEv10g_S.u
rename ACEv10g_S_obfuscated.u ACEv10g_S.u

ECHO --- Restoring ini file...
del UnrealTournament.ini
rename UnrealTournament.old UnrealTournament.ini

ECHO --- Signing Filelist ---

REM Delete old ACE files
ACESign.exe -r ACEFileList.txt ACEv10g_C.u
ACESign.exe -r ACEFileList.txt ACEv10g_C.dll

REM Add new ACE files
ACESign.exe -a ACEFileList.txt ACEv10g_C_NonSSE.dll ACEv10g_C.dll "ACE v1.0g for UT"
ACESign.exe -a ACEFileList.txt ACEv10g_C_SSE_SSE2.dll ACEv10g_C.dll "ACE v1.0g for UT"
ACESign.exe -a ACEFileList.txt ACEv10g_C_SSE_SSE2_AVX_AVX2.dll ACEv10g_C.dll "ACE v1.0g for UT"
ACESign.exe -a ACEFileList.txt ACEv10g_C.u ACEv10g_C.u "ACE v1.0g for UT"

REM Sign the list
ACESign.exe -s anthmasterkey.dat ACEFileList.txt
del ACEFileList.txt
copy ACEFileList.txt.signed ACEFileList.txt