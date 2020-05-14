@ECHO OFF
ECHO --- Deleting Old Files...
del ACEv12_AutoConfig.u
del ACEv12c_C.u
del ACEv12c_S.u
del ACEv12c_Cdll.u
del ACEv12c_EH.u
del ..\SystemNew\ACEv12c_C.u
del ..\SystemNew\ACEv12c_Cdll.u
del ..\SystemNew\ACEv12c_C.dll
del ..\..\utpg\SystemTest\ACEv12c_C.u
del ..\..\utpg\SystemTest\ACEv12c_Cdll.u
del ..\..\utpg\SystemTest\ACEv12c_C.dll
del ..\..\UnrealTournament436\SystemXC\ACEv12c_C.u
del ..\..\UnrealTournament436\SystemXC\ACEv12c_Cdll.u
del ..\..\UnrealTournament436\SystemXC\ACEv12c_C.dll
del ..\..\UnrealTournament436\SystemNew\ACEv12c_C.u
del ..\..\UnrealTournament436\SystemNew\ACEv12c_C.dll
del ..\..\UnrealTournament436\SystemNew\ACEv12c_Cdll.u

ECHO --- Copying Binaries....
REM copy ..\ACE\System\ACEv12c_S.dll ACEv12c_S.dll
copy ACEv12c_C.dll ACEv12c_C_NonSSE.dll
copy ACEv12c_C.dll ACEv12c_C_SSE_SSE2.dll
copy ACEv12c_C.dll ACEv12c_C_SSE_SSE2_AVX_AVX2.dll

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
ACESign.exe -r ACEFileList.txt ACEv12c_C.u
ACESign.exe -r ACEFileList.txt ACEv12c_C.dll

REM Add new ACE files
ACESign.exe -a ACEFileList.txt ACEv12c_C_NonSSE.dll ACEv12c_C.dll "ACE v1.2c for UEngine 1"
ACESign.exe -a ACEFileList.txt ACEv12c_C_SSE_SSE2.dll ACEv12c_C.dll "ACE v1.2c for UEngine 1"
ACESign.exe -a ACEFileList.txt ACEv12c_C_SSE_SSE2_AVX_AVX2.dll ACEv12c_C.dll "ACE v1.2c for UEngine 1"
ACESign.exe -a ACEFileList.txt ACEv12c_C.u ACEv12c_C.u "ACE v1.2c for UEngine 1"
