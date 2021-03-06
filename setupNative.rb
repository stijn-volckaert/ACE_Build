#!/usr/bin/env ruby

# BUILD PARAMS
@major=0
@minor=0
@rev='a'
@aceshortver="" # e.g.: "v10d"
@acelongver="" # e.g.: "v1.0d"

def fixup(line)
  return line.gsub(/v[0-9][0-9][a-z]/, "#{@aceshortver}") if line.match(/@ACESHORTVERLOWER@/)
  return line.gsub(/v[0-9][0-9][a-z]/, "#{@aceshortver}") if line.match(/<TargetName>ACEv[0-9][0-9][a-z]_[A-Z]<\/TargetName>/)
  return line.gsub(/v[0-9][0-9][a-z]/, "#{@aceshortver}") if line.match(/UPACKAGE_NAME "ACEv[0-9][0-9][a-z]_[A-Z]/)
  return line.gsub(/V[0-9][0-9][A-Z]/, "#{@aceshortver.upcase}") if line.match(/@ACESHORTVERUPPER@/)
  return line.gsub(/v[0-9]\.[0-9][a-z]/, "#{@aceshortver}") if line.match(/@ACELONGVERLOWER@/)
  return line.gsub(/V[0-9]\.[0-9][A-Z]/, "#{@aceshortver}") if line.match(/@ACELONGVERUPPER@/)
  return line
end

def replace_version_strings_for_file(filename)
  out=""
  File.open(filename, "r+:UTF-8") { |file|
    file.each { |line|
      line = line.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
      out << fixup(line)
    }
    file.pos=0
    file.print(out)
    file.truncate(file.pos)
  }
end

def replace_version_strings_for_folder(folder)
  Dir.glob("#{folder}/**/*.{cpp,c,h}") { |filename|
    replace_version_strings_for_file(filename)
  }
end

def syntax()
  print("Syntax: setupNative.rb <major version> <minor version> <rev>\n")
  exit -1
end

if ARGV.length < 3
  syntax()
end

# FETCH PARAMS 
@major=ARGV[0].to_i
@minor=ARGV[1].to_i
@rev=ARGV[2]

# SANITY CHECKS
if (not @major.between?(0,100)) or (not @minor.between?(0,100)) or (@rev.length != 1)
  syntax()
end

@aceshortver="v#{@major}#{@minor}#{@rev}"
@acelongver="v#{@major}.#{@minor}#{@rev}"

print("Setting up ACE #{@aceshortver} ...\n")

replace_version_strings_for_folder("./Client/Src/")
replace_version_strings_for_folder("./Client/Inc/")
replace_version_strings_for_folder("./GameServer/Src/")
replace_version_strings_for_folder("./GameServer/Inc/")
replace_version_strings_for_folder("./GameServer/PlayerManager/Src/")
replace_version_strings_for_folder("./GameServer/PlayerManager/Inc/")
replace_version_strings_for_file("./Client/Client.vcxproj")
replace_version_strings_for_file("./GameServer/GameServer.vcxproj")
replace_version_strings_for_file("./GameServer/CMakeLists.txt")

print("Done!")
