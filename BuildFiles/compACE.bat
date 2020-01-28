@ECHO OFF
ECHO --- Deleting Old Files...
del ACEv11_AutoConfig.u
del ACEv11f_C.u
del ACEv11f_S.u
del ACEv11f_Cdll.u
del ACEv11f_EH.u
del ..\SystemNew\ACEv11f_C.u
del ..\SystemNew\ACEv11f_Cdll.u
del ..\SystemNew\ACEv11f_C.dll
del ..\..\UnrealTournament436\SystemNew\ACEv11f_C.u
del ..\..\UnrealTournament436\SystemNew\ACEv11f_C.dll
del ..\..\UnrealTournament436\SystemNew\ACEv11f_Cdll.u

ECHO --- Copying Binaries....
copy ..\ACE\System\GameServer.so ACEv11f_S.so
copy ..\ACE\System\GameServer.dll ACEv11f_S.dll
copy ..\ACE\System\Client_NonSSE.dll ACEv11f_C_NonSSE.dll
copy ..\ACE\System\Client_SSE_SSE2.dll ACEv11f_C_SSE_SSE2.dll
copy ..\ACE\System\Client_SSE_SSE2_AVX_AVX2.dll ACEv11f_C_SSE_SSE2_AVX_AVX2.dll
copy ..\ACE\System\PlayerManager\PlayerManager PlayerManager\ACEv11f_M
copy ..\ACE\System\PlayerManager\PlayerManager.dll PlayerManager\ACEv11f_M.dll

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
..\PortableJava\bin\java -jar AnthObfuscator.jar ACEv11f_C.u -s -n -o
del ACEv11f_C.u
rename ACEv11f_C_obfuscated.u ACEv11f_C.u

ECHO --- Obfuscating Server File...
..\PortableJava\bin\java -jar AnthObfuscator.jar ACEv11f_S.u -s -o
del ACEv11f_S.u
rename ACEv11f_S_obfuscated.u ACEv11f_S.u

ECHO --- Restoring ini file...
del UnrealTournament.ini
del DeusEx.ini
rename UnrealTournament.old UnrealTournament.ini
rename DeusEx.old DeusEx.ini

ECHO --- Signing Filelist ---

REM Delete old ACE files
ACESign.exe -r ACEFileList.txt ACEv11f_C.u
ACESign.exe -r ACEFileList.txt ACEv11f_C.dll

REM Add new ACE files
ACESign.exe -a ACEFileList.txt ACEv11f_C_NonSSE.dll ACEv11f_C.dll "ACE v1.1f for UEngine 1"
ACESign.exe -a ACEFileList.txt ACEv11f_C_SSE_SSE2.dll ACEv11f_C.dll "ACE v1.1f for UEngine 1"
ACESign.exe -a ACEFileList.txt ACEv11f_C_SSE_SSE2_AVX_AVX2.dll ACEv11f_C.dll "ACE v1.1f for UEngine 1"
ACESign.exe -a ACEFileList.txt ACEv11f_C.u ACEv11f_C.u "ACE v1.1f for UEngine 1"

REM Sign the list
ACESign.exe -s anthmasterkey.dat ACEFileList.txt
del ACEFileList.txt
copy ACEFileList.txt.signed ACEFileList.txt
