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
ACESign.exe -r ACEFileList.txt ACEv12a_C.u
ACESign.exe -r ACEFileList.txt ACEv12a_C.dll

REM Add new ACE files
ACESign.exe -a ACEFileList.txt ACEv12a_C_NonSSE.dll ACEv12a_C.dll "ACE v1.2a for UEngine 1"
ACESign.exe -a ACEFileList.txt ACEv12a_C_SSE_SSE2.dll ACEv12a_C.dll "ACE v1.2a for UEngine 1"
ACESign.exe -a ACEFileList.txt ACEv12a_C_SSE_SSE2_AVX_AVX2.dll ACEv12a_C.dll "ACE v1.2a for UEngine 1"
ACESign.exe -a ACEFileList.txt ACEv12a_C.u ACEv12a_C.u "ACE v1.2a for UEngine 1"
