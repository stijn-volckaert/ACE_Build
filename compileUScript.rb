#!/usr/bin/env ruby

# BUILD PARAMS
@major=0
@minor=0
@rev='a'
@aceshortver="" # e.g.: "v10d"
@acelongver="" # e.g.: "v1.0d"
@aceshortmajorver="" # e.g.: "v10"
@acelongmajorver="" # e.g.: "v1.0"
@newmajor=false

def replace_version_strings(folder)
  rules = {
    '@ACESHORTVERLOWER@' => @aceshortver,
    '@ACESHORTVERUPPER@' => @aceshortver.upcase,
    '@ACESHORTMAJORVERLOWER@' => @aceshortmajorver,
    '@ACESHORTMAJORVERUPPER@' => @aceshortmajorver.upcase,
    '@ACELONGVERLOWER@' => @acelongver,
    '@ACELONGVERUPPER@' => @acelongver.upcase,
    '@ACELONGMAJORVERLOWER@' => @acelongmajorver,
    '@ACELONGMAJORVERUPPER@' => @acelongmajorver.upcase   
  }
  
  Dir.glob("#{folder}/Classes/*.uc") { |filename|
    out = ""
    File.open(filename, 'r+') { |file|
      file.each { |line|
        out << line.gsub(/#{rules.keys.join('|')}/, rules)
      }
      file.pos=0
      file.print out
      file.truncate(file.pos)
    }
  }
end

def syntax()
  print("Syntax: setupUScript.rb <major version> <minor version> <rev> [all|server|fullclean]\n")
  exit -1
end

if ARGV.length < 4
  syntax()
end

# FETCH PARAMS 
@major=ARGV[0].to_i
@minor=ARGV[1].to_i
@rev=ARGV[2]
@build=ARGV[3]

# SANITY CHECKS
if (not @major.between?(0,100)) or (not @minor.between?(0,100)) or (@rev.length != 1)
  syntax()
end

@aceshortver="v#{@major}#{@minor}#{@rev}"
@acelongver="v#{@major}.#{@minor}#{@rev}"
@aceshortmajorver="v#{@major}#{@minor}"
@acelongmajorver="v#{@major}.#{@minor}"

if @build == "fullclean"
  print("> Doing full clean of ACE UScript...\n")
  olddir=Dir.pwd
  Dir.chdir("../System/")

  `rm ~/.utpg/System/ACE#{@aceshortmajorver}_AutoConfig.u`
  `rm ~/.utpg/System/IACE#{@aceshortmajorver}.u`
  `rm ~/.utpg/System/ACE#{@aceshortver}_C.u`
  `rm ~/.utpg/System/ACE#{@aceshortver}_Cdll.u`  
  `rm ~/.utpg/System/ACE#{@aceshortver}_S.u`
  `rm ~/.utpg/System/ACE#{@aceshortver}_EH.u`

  `rm ACE#{@aceshortmajorver}_AutoConfig.u`
  `rm IACE#{@aceshortmajorver}.u`
  `rm ACE#{@aceshortver}_C.u`
  `rm ACE#{@aceshortver}_Cdll.u`  
  `rm ACE#{@aceshortver}_S.u`
  `rm ACE#{@aceshortver}_EH.u`

  Dir.chdir(olddir)
  print("> Done!\n")
  exit 0
  
elsif @build == "server"
  `rm ~/.utpg/System/ACE#{@aceshortmajorver}_AutoConfig.u`
  `rm ~/.utpg/System/ACE#{@aceshortver}_S.u`
  `rm ~/.utpg/System/ACE#{@aceshortver}_EH.u`

  `rm ACE#{@aceshortmajorver}_AutoConfig.u`
  `rm ACE#{@aceshortver}_S.u`
  `rm ACE#{@aceshortver}_EH.u`

else
  `rm ~/.utpg/System/ACE#{@aceshortmajorver}_AutoConfig.u`
  `rm ~/.utpg/System/ACE#{@aceshortver}_C.u`
  `rm ~/.utpg/System/ACE#{@aceshortver}_Cdll.u`  
  `rm ~/.utpg/System/ACE#{@aceshortver}_S.u`
  `rm ~/.utpg/System/ACE#{@aceshortver}_EH.u`

  `rm ACE#{@aceshortmajorver}_AutoConfig.u`
  `rm ACE#{@aceshortver}_C.u`
  `rm ACE#{@aceshortver}_Cdll.u`  
  `rm ACE#{@aceshortver}_S.u`
  `rm ACE#{@aceshortver}_EH.u`
  
end


print("Setting up ACE #{@aceshortver} ...\n")

if not Dir.exist?("../ACE#{@aceshortmajorver}_AutoConfig") and not Dir.exist?("../IACE#{@aceshortmajorver}")
  @newmajor=true
end

# Step 1: Delete old folders
print("> Deleting old UScript folders\n")
`rm -rf ../ACE#{@aceshortver}_C/`
`rm -rf ../ACE#{@aceshortver}_S/`
`rm -rf ../ACE#{@aceshortver}_Cdll/`
`rm -rf ../ACE#{@aceshortver}_EH/`

# Step 2: Create folders
print("> Creating new UScript folders\n")
`mkdir ../ACE#{@aceshortver}_C/`
`mkdir ../ACE#{@aceshortver}_S/`
`mkdir ../ACE#{@aceshortver}_Cdll/`
`mkdir ../ACE#{@aceshortver}_EH/`
`mkdir ../ACE#{@aceshortmajorver}_AutoConfig/` if @newmajor
`mkdir ../IACE#{@aceshortmajorver}/` if @newmajor

# Step 3: Copy UScript classes
print("> Copying UScript classes\n")
`cp -R Client/Classes ../ACE#{@aceshortver}_C/`
`cp -R GameServer/Classes ../ACE#{@aceshortver}_S/`
`cp -R ClientDll/Classes ../ACE#{@aceshortver}_Cdll/`
`cp -R EventHandler/Classes ../ACE#{@aceshortver}_EH/`
`cp -R AutoConfig/Classes ../ACE#{@aceshortmajorver}_AutoConfig/` if @newmajor
`cp -R Interface/Classes ../IACE#{@aceshortmajorver}/` if @newmajor

# Step 4: Set version strings
print("> Setting versions\n")
replace_version_strings("../ACE#{@aceshortver}_C/")
replace_version_strings("../ACE#{@aceshortver}_S/")
replace_version_strings("../ACE#{@aceshortver}_Cdll/")
replace_version_strings("../ACE#{@aceshortver}_EH/")
replace_version_strings("../ACE#{@aceshortmajorver}_AutoConfig/") if @newmajor
replace_version_strings("../IACE#{@aceshortmajorver}/") if @newmajor

print("> Don't forget to update ACEInfo!!!\n")

# Step 5: Compile
olddir=Dir.pwd
conformclient=false
Dir.chdir("../System/")

`cp ~/.utpg/System/UnrealTournament.ini ~/.utpg/System/UnrealTournament.old`

if @build != "server"
  print("> Setting up ini file for Interface\n")
  `cp compACEInterface.ini ~/.utpg/System/UnrealTournament.ini`

  print("> Compiling Interface\n")
  print(`./ucc-bin-x86 make -nobind -bytehax`)
end

print("> Setting up ini file for EventHandler\n")
`cp compACEEH.ini ~/.utpg/System/UnrealTournament.ini`

print("> Compiling EventHandler\n")
print(`./ucc-bin-x86 make -nobind -bytehax`)

print("> Setting up ini file for AutoConfig\n")
`cp compACEAC.ini ~/.utpg/System/UnrealTournament.ini`

print("> Compiling AutoConfig\n")
print(`./ucc-bin-x86 make -nobind -bytehax`)

print("> Setting up ini file for ACE Client and Server\n")
`cp compACE.ini ~/.utpg/System/UnrealTournament.ini`

if @build == "server" and File.exist?("~/.utpg/System/ACE#{@aceshortver}_C.u")
  conformclient=true
  File.rename("~/.utpg/System/ACE#{@aceshortver}_C.u", "~/.utpg/System/ACE#{@aceshortver}_C_conform.u")
  print("> Compiling Conformed Client\n")
  print(`./ucc-bin-x86 make -nobind -bytehax`)
  print(`./ucc-bin-x86 conform ACE#{@aceshortver}_C.u ACE#{@aceshortver}_C_conform.u`)

  print("> Compiling server with conformed client\n")
  File.delete("~/.utpg/System/ACE#{@aceshortver}_S.u")
  print(`./ucc-bin-x86 make -nobind -bytehax`)
  File.delete("~/.utpg/System/ACE#{@aceshortver}_C.u")
  File.rename("~/.utpg/System/ACE#{@aceshortver}_C_conform.u", "~/.utpg/System/ACE#{@aceshortver}_C.u")
  
else
  print("> Compiling ACE Client and Server\n")
  print(`./ucc-bin-x86 make -nobind -bytehax`)

end


print("> Restoring ini\n")
`cp ~/.utpg/System/UnrealTournament.old ~/.utpg/System/UnrealTournament.ini`

print("> Removing old folders\n")
`rm -rf ../ACE#{@aceshortver}_C/`
`rm -rf ../ACE#{@aceshortver}_S/`
`rm -rf ../ACE#{@aceshortver}_Cdll/`
`rm -rf ../ACE#{@aceshortver}_EH/`
`rm -rf ../ACE#{@aceshortmajorver}_AutoConfig/` 
`rm -rf ../IACE#{@aceshortmajorver}/`

Dir.chdir(olddir)

