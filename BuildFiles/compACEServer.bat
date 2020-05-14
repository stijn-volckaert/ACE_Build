@ECHO OFF
ECHO --- Deleting Old Files...
del ACEv12_AutoConfig.u
del ACEv12c_S.u
del ACEv12c_EH.u

ECHO --- Copying Binaries....
copy ..\ACE\System\GameServer.so ACEv12c_S.so
copy ..\ACE\System\GameServer.dll ACEv12c_S.dll

ECHO --- Setting up ini file...
copy UnrealTournament.ini UnrealTournament.old
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
rename ACEv12c_C.u ACEv12c_C_conform.u
del UnrealTournament.ini
copy compACE.ini UnrealTournament.ini

ECHO --- Compiling Main Packages...
ucc make -nobind

ECHO --- Conforming Client...
del ACEv12c_S.u
ucc conform ACEv12c_C.u ACEv12c_C_conform.u
ucc make -nobind
del ACEv12c_C.u
rename ACEv12c_C_conform.u ACEv12c_C.u

REM ECHO --- Obfuscating Server File...
..\PortableJava\bin\java -jar AnthObfuscator.jar ACEv12c_S.u -s -o
del ACEv12c_S.u
rename ACEv12c_S_obfuscated.u ACEv12c_S.u

ECHO --- Restoring ini file...
del UnrealTournament.ini
rename UnrealTournament.old UnrealTournament.ini
