@ECHO OFF
ECHO --- Deleting Old Files...
del ACEv11_AutoConfig.u
del ACEv11d_C.u
del ACEv11d_S.u
del ACEv11d_Cdll.u
del ACEv11d_EH.u
del ..\SystemNew\ACEv11d_C.u
del ..\SystemNew\ACEv11d_Cdll.u
del ..\SystemNew\ACEv11d_C.dll

ECHO --- Copying Binaries....
copy ..\ACE\System\ACEv11d_S.dll ACEv11d_S.dll
copy ..\ACE\System\ACEv11d_C.dll ACEv11d_C_NoSSE.dll
copy ..\ACE\System\ACEv11d_C.dll ACEv11d_C_SSE_SSE2.dll
copy ..\ACE\System\ACEv11d_C.dll ACEv11d_C_SSE_SSE2_AVX_AVX2.dll
copy ..\ACE\System\PlayerManager\ACEv11d_M.dll PlayerManager\ACEv11d_M.dll

ECHO --- Setting up ini file...
copy UnrealTournament.ini UnrealTournament.old
copy DeusEx.ini DeusEx.old
del UnrealTournament.ini
del DeusEx.ini

ECHO --- Compiling ACE Interface...
copy compACEInterface.ini UnrealTournament.ini
copy compACEInterfaceDX.ini DeusEx.ini
del Uweb.u
copy UWebHacked.u UWeb.u
ucc make
del UWeb.u
copy UWebClean.u UWeb.u

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
ACESign.exe -r ACEFileList.txt ACEv11d_C.u
ACESign.exe -r ACEFileList.txt ACEv11d_C.dll

REM Add new ACE files
ACESign.exe -a ACEFileList.txt ACEv11d_C_NonSSE.dll ACEv11d_C.dll "ACE v1.1d for UEngine 1"
ACESign.exe -a ACEFileList.txt ACEv11d_C_SSE_SSE2.dll ACEv11d_C.dll "ACE v1.1d for UEngine 1"
ACESign.exe -a ACEFileList.txt ACEv11d_C_SSE_SSE2_AVX_AVX2.dll ACEv11d_C.dll "ACE v1.1d for UEngine 1"
ACESign.exe -a ACEFileList.txt ACEv11d_C.u ACEv11d_C.u "ACE v1.1d for UEngine 1"