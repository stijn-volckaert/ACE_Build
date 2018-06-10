@ECHO OFF
ECHO --- Deleting Old Files...
del ACEv10_AutoConfig.u
del ACEv10h_C.u
del ACEv10h_S.u
del ACEv10h_Cdll.u
del ACEv10h_EH.u
del ..\SystemNew\ACEv10h_C.u
del ..\SystemNew\ACEv10h_Cdll.u
del ..\SystemNew\ACEv10h_C.dll

ECHO --- Copying Binaries....
copy ..\ACE\System\ACEv10h_S.dll ACEv10h_S.dll
copy ..\ACE\System\ACEv10h_C.dll ACEv10h_C_SSE_SSE2_AVX_AVX2.dll
copy ..\ACE\System\PlayerManager\ACEv10h_M.dll PlayerManager\ACEv10h_M.dll

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
ACESign.exe -r ACEFileList.txt ACEv10h_C.u
ACESign.exe -r ACEFileList.txt ACEv10h_C.dll

REM Add new ACE files
ACESign.exe -a ACEFileList.txt ACEv10h_C_NonSSE.dll ACEv10h_C.dll "ACE v1.0h for UT"
ACESign.exe -a ACEFileList.txt ACEv10h_C_SSE_SSE2.dll ACEv10h_C.dll "ACE v1.0h for UT"
ACESign.exe -a ACEFileList.txt ACEv10h_C_SSE_SSE2_AVX_AVX2.dll ACEv10h_C.dll "ACE v1.0h for UT"
ACESign.exe -a ACEFileList.txt ACEv10h_C.u ACEv10h_C.u "ACE v1.0h for UT"