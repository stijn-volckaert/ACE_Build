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
del ..\..\utpg\SystemTest\ACEv12a_C.u
del ..\..\utpg\SystemTest\ACEv12a_Cdll.u
del ..\..\utpg\SystemTest\ACEv12a_C.dll
del ..\..\UnrealTournament436\SystemXC\ACEv12a_C.u
del ..\..\UnrealTournament436\SystemXC\ACEv12a_Cdll.u
del ..\..\UnrealTournament436\SystemXC\ACEv12a_C.dll
del ..\..\UnrealTournament436\SystemNew\ACEv12a_C.u
del ..\..\UnrealTournament436\SystemNew\ACEv12a_C.dll
del ..\..\UnrealTournament436\SystemNew\ACEv12a_Cdll.u

ECHO --- Copying Binaries....
REM copy ..\ACE\System\ACEv12a_S.dll ACEv12a_S.dll
copy ACEv12a_C.dll ACEv12a_C_NonSSE.dll
copy ACEv12a_C.dll ACEv12a_C_SSE_SSE2.dll
copy ACEv12a_C.dll ACEv12a_C_SSE_SSE2_AVX_AVX2.dll
REM copy ..\ACE\System\PlayerManager\ACEv12a_M.dll PlayerManager\ACEv12a_M.dll

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