@ECHO OFF
ECHO --- Deleting Old Files...
del ACEv12_AutoConfig.u
del ACEv12d_C.u
del ACEv12d_S.u
del ACEv12d_Cdll.u
del ACEv12d_EH.u
del ..\SystemNew\ACEv12d_C.u
del ..\SystemNew\ACEv12d_Cdll.u
del ..\SystemNew\ACEv12d_C.dll
del ..\..\utpg\SystemTest\ACEv12d_C.u
del ..\..\utpg\SystemTest\ACEv12d_Cdll.u
del ..\..\utpg\SystemTest\ACEv12d_C.dll
del ..\..\UnrealTournament436\SystemXC\ACEv12d_C.u
del ..\..\UnrealTournament436\SystemXC\ACEv12d_Cdll.u
del ..\..\UnrealTournament436\SystemXC\ACEv12d_C.dll
del ..\..\UnrealTournament436\SystemNew\ACEv12d_C.u
del ..\..\UnrealTournament436\SystemNew\ACEv12d_C.dll
del ..\..\UnrealTournament436\SystemNew\ACEv12d_Cdll.u

ECHO --- Copying Binaries....
REM copy ..\ACE\System\ACEv12d_S.dll ACEv12d_S.dll
copy ACEv12d_C.dll ACEv12d_C_NonSSE.dll
copy ACEv12d_C.dll ACEv12d_C_SSE_SSE2.dll
copy ACEv12d_C.dll ACEv12d_C_SSE_SSE2_AVX_AVX2.dll

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
ucc make -nobind

ECHO --- Restoring ini file...
del UnrealTournament.ini
rename UnrealTournament.old UnrealTournament.ini

ECHO --- Signing Filelist ---

REM Delete old ACE files
ACESign.exe -r ACEFileList.txt ACEv12d_C.u
ACESign.exe -r ACEFileList.txt ACEv12d_C.dll

REM Add new ACE files
ACESign.exe -a ACEFileList.txt ACEv12d_C_NonSSE.dll ACEv12d_C.dll "ACE v1.2d for UEngine 1"
ACESign.exe -a ACEFileList.txt ACEv12d_C_SSE_SSE2.dll ACEv12d_C.dll "ACE v1.2d for UEngine 1"
ACESign.exe -a ACEFileList.txt ACEv12d_C_SSE_SSE2_AVX_AVX2.dll ACEv12d_C.dll "ACE v1.2d for UEngine 1"
ACESign.exe -a ACEFileList.txt ACEv12d_C.u ACEv12d_C.u "ACE v1.2d for UEngine 1"
