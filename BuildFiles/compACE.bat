@ECHO OFF
ECHO --- Deleting Old Files...
del ACEv12_AutoConfig.u
del ACEv12a_C.u
del ACEv12a_S.u
del ACEv12a_Cdll.u
del ACEv12a_EH.u
del ..\SystemNew\ACEv12a_C.u
del ..\SystemNew\ACEv12a_Cdll.u
del ..\SystemNew\ACEv12a_C.dll
del ..\..\UnrealTournament436\SystemNew\ACEv12a_C.u
del ..\..\UnrealTournament436\SystemNew\ACEv12a_C.dll
del ..\..\UnrealTournament436\SystemNew\ACEv12a_Cdll.u

ECHO --- Copying Binaries....
copy ..\ACE\System\GameServer.so ACEv12a_S.so
copy ..\ACE\System\GameServer.dll ACEv12a_S.dll
copy ..\ACE\System\Client_NonSSE.dll ACEv12a_C_NonSSE.dll
copy ..\ACE\System\Client_SSE_SSE2.dll ACEv12a_C_SSE_SSE2.dll
copy ..\ACE\System\Client_SSE_SSE2_AVX_AVX2.dll ACEv12a_C_SSE_SSE2_AVX_AVX2.dll
copy ..\ACE\System\PlayerManager\PlayerManager PlayerManager\ACEv12a_M
copy ..\ACE\System\PlayerManager\PlayerManager.dll PlayerManager\ACEv12a_M.dll

ECHO --- Setting up ini file...
copy UnrealTournament.ini UnrealTournament.old
copy DeusEx.ini DeusEx.old
del UnrealTournament.ini
del DeusEx.ini

ECHO --- Compiling ACE Interface...
copy compACEInterface.ini UnrealTournament.ini
copy compACEInterfaceDX.ini DeusEx.ini
ucc make -bytehax

ECHO --- Switching ini file...
del UnrealTournament.ini
del DeusEx.ini
copy compACEEH.ini UnrealTournament.ini
copy compACEEHDX.ini DeusEx.ini

ECHO --- Compiling ACE EventHandler...
ucc make

ECHO --- Switching ini file...
del UnrealTournament.ini
del DeusEx.ini
copy compACEAC.ini UnrealTournament.ini
copy compACEACDX.ini DeusEx.ini

ECHO --- Compiling ACE AutoConfig...
ucc make

ECHO --- Switching ini file...
del UnrealTournament.ini
del DeusEx.ini
copy compACE.ini UnrealTournament.ini
copy compACEDX.ini DeusEx.ini

ECHO --- Compiling Main Packages...
ucc make -nobind

ECHO --- Obfuscating/Reflagging Client File...
..\PortableJava\bin\java -jar AnthObfuscator.jar ACEv12a_C.u -s -n -o
del ACEv12a_C.u
rename ACEv12a_C_obfuscated.u ACEv12a_C.u

ECHO --- Obfuscating Server File...
..\PortableJava\bin\java -jar AnthObfuscator.jar ACEv12a_S.u -s -o
del ACEv12a_S.u
rename ACEv12a_S_obfuscated.u ACEv12a_S.u

ECHO --- Restoring ini file...
del UnrealTournament.ini
del DeusEx.ini
rename UnrealTournament.old UnrealTournament.ini
rename DeusEx.old DeusEx.ini

ECHO --- Signing Filelist ---

REM Delete old ACE files
ACESign.exe -r ACEFileList.txt ACEv12a_C.u
ACESign.exe -r ACEFileList.txt ACEv12a_C.dll

REM Add new ACE files
ACESign.exe -a ACEFileList.txt ACEv12a_C_NonSSE.dll ACEv12a_C.dll "ACE v1.2a for UEngine 1"
ACESign.exe -a ACEFileList.txt ACEv12a_C_SSE_SSE2.dll ACEv12a_C.dll "ACE v1.2a for UEngine 1"
ACESign.exe -a ACEFileList.txt ACEv12a_C_SSE_SSE2_AVX_AVX2.dll ACEv12a_C.dll "ACE v1.2a for UEngine 1"
ACESign.exe -a ACEFileList.txt ACEv12a_C.u ACEv12a_C.u "ACE v1.2a for UEngine 1"

REM Sign the list
ACESign.exe -s anthmasterkey.dat ACEFileList.txt
del ACEFileList.txt
copy ACEFileList.txt.signed ACEFileList.txt
