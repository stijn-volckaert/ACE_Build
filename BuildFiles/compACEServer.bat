@ECHO OFF
ECHO --- Deleting Old Files...
del ACEv12_AutoConfig.u
del ACEv12a_S.u
del ACEv12a_EH.u

ECHO --- Copying Binaries....
copy ..\ACE\System\GameServer.so ACEv12a_S.so
copy ..\ACE\System\GameServer.dll ACEv12a_S.dll
copy ..\ACE\System\PlayerManager\PlayerManager PlayerManager\ACEv12a_M
copy ..\ACE\System\PlayerManager\PlayerManager.dll PlayerManager\ACEv12a_M.dll

ECHO --- Setting up ini file...
copy UnrealTournament.ini UnrealTournament.old
copy DeusEx.ini DeusEx.old
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
rename ACEv12a_C.u ACEv12a_C_conform.u
del UnrealTournament.ini
del DeusEx.ini
copy compACE.ini UnrealTournament.ini
copy compACEDX.ini DeusEx.ini

ECHO --- Compiling Main Packages...
ucc make -nobind

ECHO --- Conforming Client...
del ACEv12a_S.u
ucc conform ACEv12a_C.u ACEv12a_C_conform.u
ucc make -nobind
del ACEv12a_C.u
rename ACEv12a_C_conform.u ACEv12a_C.u

REM ECHO --- Obfuscating Server File...
..\PortableJava\bin\java -jar AnthObfuscator.jar ACEv12a_S.u -s -o
del ACEv12a_S.u
rename ACEv12a_S_obfuscated.u ACEv12a_S.u

ECHO --- Restoring ini file...
del UnrealTournament.ini
del DeusEx.ini
rename UnrealTournament.old UnrealTournament.ini
rename DeusEx.old DeusEx.ini
