@ECHO OFF
ECHO --- Deleting Old Files...
del ACEv11_AutoConfig.u
del ACEv11d_S.u
del ACEv11d_EH.u

ECHO --- Copying Binaries....
copy ..\ACE\System\GameServer.so ACEv11d_S.so
copy ..\ACE\System\GameServer.dll ACEv11d_S.dll
copy ..\ACE\System\PlayerManager\PlayerManager PlayerManager\ACEv11d_M
copy ..\ACE\System\PlayerManager\PlayerManager.dll PlayerManager\ACEv11d_M.dll

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
rename ACEv11d_C.u ACEv11d_C_conform.u
del UnrealTournament.ini
del DeusEx.ini
copy compACE.ini UnrealTournament.ini
copy compACEDX.ini DeusEx.ini

ECHO --- Compiling Main Packages...
ucc make -nobind

ECHO --- Conforming Client...
del ACEv11d_S.u
ucc conform ACEv11d_C.u ACEv11d_C_conform.u
ucc make -nobind
del ACEv11d_C.u
rename ACEv11d_C_conform.u ACEv11d_C.u

REM ECHO --- Obfuscating Server File...
..\PortableJava\bin\java -jar AnthObfuscator.jar ACEv11d_S.u -s -o
del ACEv11d_S.u
rename ACEv11d_S_obfuscated.u ACEv11d_S.u

ECHO --- Restoring ini file...
del UnrealTournament.ini
del DeusEx.ini
rename UnrealTournament.old UnrealTournament.ini
rename DeusEx.old DeusEx.ini
