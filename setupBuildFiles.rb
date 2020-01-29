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

def syntax()
  print("Syntax: setupBuildFiles.rb <major version> <minor version> <rev>\n")
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
@aceshortmajorver="v#{@major}#{@minor}"
@acelongmajorver="v#{@major}.#{@minor}"

print("Setting up ACE #{@aceshortver} ...\n")

Dir.glob("BuildFiles/*.{bat,ini}") { |filename|
  File.open(filename, 'r+') { |file|
    out = ""
    file.each { |line|
      orig = line
      line = line.gsub(/v[0-9]\.[0-9][a-z]/, @acelongver)
      line = line.gsub(/V[0-9]\.[0-9][A-Z]/, @acelongver.upcase)
      line = line.gsub(/v[0-9][0-9][a-z]/, @aceshortver)
      line = line.gsub(/V[0-9][0-9][A-Z]/, @aceshortver.upcase)
      line = line.gsub(/v[0-9][0-9]/, @aceshortmajorver)
      line = line.gsub(/V[0-9][0-9]/, @aceshortmajorver.upcase)

#      print("#{filename}: #{orig.chomp} => #{line.chomp}\n") if orig != line
      out << line
    }
    file.pos=0
    file.print out
    file.truncate(file.pos)
  }
}

`cp BuildFiles/* ../System/`




