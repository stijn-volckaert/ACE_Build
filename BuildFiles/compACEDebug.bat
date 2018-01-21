@ECHO OFF
ECHO --- Deleting Old Files...
del ACEv10_AutoConfig.u
del ACEv10f_C.u
del ACEv10f_S.u
del ACEv10f_Cdll.u
del ACEv10f_EH.u
del ..\SystemNew\ACEv10f_C.u
del ..\SystemNew\ACEv10f_Cdll.u
del ..\SystemNew\ACEv10f_C.dll

ECHO --- Copying Binaries....
copy ..\ACE\System\ACEv10f_S.dll ACEv10f_S.dll
copy ..\ACE\System\ACEv10f_C.dll ACEv10f_C_SSE_SSE2_AVX_AVX2.dll
copy ..\ACE\System\PlayerManager\ACEv10f_M.dll PlayerManager\ACEv10f_M.dll

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

ECHO --- Restoring ini file...
del UnrealTournament.ini
rename UnrealTournament.old UnrealTournament.ini

ECHO --- Signing Filelist ---

REM Delete old ACE files
ACESign.exe -r ACEFileList.txt ACEv10f_C.u
ACESign.exe -r ACEFileList.txt ACEv10f_C.dll

REM Add new ACE files
ACESign.exe -a ACEFileList.txt ACEv10f_C_NonSSE.dll ACEv10f_C.dll "ACE v1.0f for UT"
ACESign.exe -a ACEFileList.txt ACEv10f_C_SSE_SSE2.dll ACEv10f_C.dll "ACE v1.0f for UT"
ACESign.exe -a ACEFileList.txt ACEv10f_C_SSE_SSE2_AVX_AVX2.dll ACEv10f_C.dll "ACE v1.0f for UT"
ACESign.exe -a ACEFileList.txt ACEv10f_C.u ACEv10f_C.u "ACE v1.0f for UT"