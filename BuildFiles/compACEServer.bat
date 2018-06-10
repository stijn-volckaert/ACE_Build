@ECHO OFF
ECHO --- Deleting Old Files...
del ACEv10_AutoConfig.u
del ACEv10h_S.u
del ACEv10h_EH.u

ECHO --- Copying Binaries....
copy ..\ACE\System\GameServer.so ACEv10h_S.so
copy ..\ACE\System\GameServer.dll ACEv10h_S.dll
copy ..\ACE\System\PlayerManager\PlayerManager PlayerManager\ACEv10h_M
copy ..\ACE\System\PlayerManager\PlayerManager.dll PlayerManager\ACEv10h_M.dll

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
rename ACEv10h_C.u ACEv10h_C_conform.u
del UnrealTournament.ini
copy compACE.ini UnrealTournament.ini

ECHO --- Compiling Main Packages...
ucc make -nobind

ECHO --- Conforming Client...
del ACEv10h_S.u
ucc conform ACEv10h_C.u ACEv10h_C_conform.u
ucc make -nobind
del ACEv10h_C.u
rename ACEv10h_C_conform.u ACEv10h_C.u

REM ECHO --- Obfuscating Server File...
..\PortableJava\bin\java -jar AnthObfuscator.jar ACEv10h_S.u -s -o
del ACEv10h_S.u
rename ACEv10h_S_obfuscated.u ACEv10h_S.u

ECHO --- Restoring ini file...
del UnrealTournament.ini
rename UnrealTournament.old UnrealTournament.ini
