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
del ..\..\utpg\SystemTest\ACEv11f_C.u
del ..\..\utpg\SystemTest\ACEv11f_Cdll.u
del ..\..\utpg\SystemTest\ACEv11f_C.dll
del ..\..\UnrealTournament436\SystemXC\ACEv11f_C.u
del ..\..\UnrealTournament436\SystemXC\ACEv11f_Cdll.u
del ..\..\UnrealTournament436\SystemXC\ACEv11f_C.dll
del ..\..\UnrealTournament436\SystemNew\ACEv11f_C.u
del ..\..\UnrealTournament436\SystemNew\ACEv11f_C.dll
del ..\..\UnrealTournament436\SystemNew\ACEv11f_Cdll.u

ECHO --- Copying Binaries....
REM copy ..\ACE\System\ACEv11f_S.dll ACEv11f_S.dll
copy ACEv11f_C.dll ACEv11f_C_NonSSE.dll
copy ACEv11f_C.dll ACEv11f_C_SSE_SSE2.dll
copy ACEv11f_C.dll ACEv11f_C_SSE_SSE2_AVX_AVX2.dll
REM copy ..\ACE\System\PlayerManager\ACEv11f_M.dll PlayerManager\ACEv11f_M.dll

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
ACESign.exe -r ACEFileList.txt ACEv11f_C.u
ACESign.exe -r ACEFileList.txt ACEv11f_C.dll

REM Add new ACE files
ACESign.exe -a ACEFileList.txt ACEv11f_C_NonSSE.dll ACEv11f_C.dll "ACE v1.1f for UEngine 1"
ACESign.exe -a ACEFileList.txt ACEv11f_C_SSE_SSE2.dll ACEv11f_C.dll "ACE v1.1f for UEngine 1"
ACESign.exe -a ACEFileList.txt ACEv11f_C_SSE_SSE2_AVX_AVX2.dll ACEv11f_C.dll "ACE v1.1f for UEngine 1"
ACESign.exe -a ACEFileList.txt ACEv11f_C.u ACEv11f_C.u "ACE v1.1f for UEngine 1"