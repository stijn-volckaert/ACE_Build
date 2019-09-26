@ECHO OFF
ECHO --- Deleting Old Files...
del ACEv11_AutoConfig.u
del ACEv11e_C.u
del ACEv11e_S.u
del ACEv11e_Cdll.u
del ACEv11e_EH.u
del ..\SystemNew\ACEv11e_C.u
del ..\SystemNew\ACEv11e_Cdll.u
del ..\SystemNew\ACEv11e_C.dll
del ..\..\UnrealTournament436\SystemNew\ACEv11e_C.u
del ..\..\UnrealTournament436\SystemNew\ACEv11e_C.dll
del ..\..\UnrealTournament436\SystemNew\ACEv11e_Cdll.u

ECHO --- Copying Binaries....
copy ..\ACE\System\GameServer.so ACEv11e_S.so
copy ..\ACE\System\GameServer.dll ACEv11e_S.dll
copy ..\ACE\System\Client.dll ACEv11e_C.dll
copy ..\ACE\System\PlayerManager\PlayerManager PlayerManager\ACEv11e_M
copy ..\ACE\System\PlayerManager\PlayerManager.dll PlayerManager\ACEv11e_M.dll

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

ECHO --- Obfuscating/Reflagging Client File...
..\PortableJava\bin\java -jar AnthObfuscator.jar ACEv11e_C.u -s -n -o
del ACEv11e_C.u
rename ACEv11e_C_obfuscated.u ACEv11e_C.u

ECHO --- Obfuscating Server File...
..\PortableJava\bin\java -jar AnthObfuscator.jar ACEv11e_S.u -s -o
del ACEv11e_S.u
rename ACEv11e_S_obfuscated.u ACEv11e_S.u

ECHO --- Restoring ini file...
del UnrealTournament.ini
del DeusEx.ini
rename UnrealTournament.old UnrealTournament.ini
rename DeusEx.old DeusEx.ini

ECHO --- Signing Filelist ---

REM Delete old ACE files
ACESign.exe -r ACEFileList.txt ACEv11e_C.u
ACESign.exe -r ACEFileList.txt ACEv11e_C.dll

REM Add new ACE files
ACESign.exe -a ACEFileList.txt ACEv11e_C.dll ACEv11e_C.dll "ACE v1.1e for UEngine 1"
ACESign.exe -a ACEFileList.txt ACEv11e_C.u ACEv11e_C.u "ACE v1.1e for UEngine 1"

REM Sign the list
ACESign.exe -s anthmasterkey.dat ACEFileList.txt
del ACEFileList.txt
copy ACEFileList.txt.signed ACEFileList.txt