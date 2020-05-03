#!/usr/bin/env ruby
require 'shellwords'

def findSteam(drive)
	path = "/mnt/" + drive
	Dir.chdir path
		Dir.foreach(Dir.pwd) do |folder|
			if folder=="Steam"
				return true

			elsif folder =="Program Files"
				if findSteam(drive+"/Program Files")
					return true
				end

			elsif folder =="Program Files (x86)"
				if findSteam(drive+"/Program Files (x86)")
					return true
				end
			end
		end
	return false
end

def findSteamPath(drive)
path = "/mnt/" + drive
Dir.chdir path
Dir.foreach(Dir.pwd) do |folder|
			if folder=="Steam"
				return path+"/Steam/steamapps/common"

			elsif folder =="Program Files"
				if findSteam(drive+"/Program Files")
					return path+ "/Program Files/Steam/steamapps/common"
				end

			elsif folder =="Program Files (x86)"
				if findSteam(drive+"/Program Files (x86)")
					return path + "/Program Files (x86)/Steam/steamapps/common"
				end
			end
		end

end

def findGames(drive)
	path = findSteamPath(drive)
	Dir.chdir path
	gamelst=[]
		Dir.foreach(Dir.pwd) do |game|
			if game!="." && game!=".."
				gamelst.append(game)
			end
		end
	return gamelst
end

def getGameExe(gamepath)
	path = gamepath
	Dir.chdir path
	#below is for looking through the first level for the .exe
	Dir.foreach(Dir.pwd) do |file|
		if File.extname(file)==".exe" || File.extname(file)==".EXE"
			return gamepath+"/" + file
		end
	end
	Dir.foreach(Dir.pwd) do |file|
		if file == "Binaries" || file == "bin"
			Dir.chdir file
			path = binPath(Dir.pwd)
			if path == -1
				return -1
			else
				return path
			end
		end
	end
	Dir.foreach(Dir.pwd) do |file|
		#below is for just going one extra level through to the .exe
		if file == "Game" || file == "GameData" || file =="x64" || file =="System"
			Dir.chdir file
			Dir.foreach(Dir.pwd) do |file2|
				if File.extname(file) == ".exe" || File.extname(file)==".EXE"
					return Dir.pwd + "/" + file
				end
			end
			
		end
	end
	return -1
	
end

def binPath(path)
	Dir.chdir path
	Dir.foreach(Dir.pwd) do |file|
		if file == "Win32" || file == "Win64"
			Dir.chdir file
			Dir.foreach(Dir.pwd) do |inFile|
				if File.extname(inFile)==".exe" || File.extname(file)==".EXE"
					return path+"/" + file+ "/"+inFile
				end
			end
		
		elsif File.extname(file)==".exe" || File.extname(file)==".EXE"
			return path+ "/" + file
		end
	end
	return -1
end

#def test
	#path= "/mnt/f/Steam/steamapps/common/BioShock Remastered"
	#puts getGameExe(path)
	#puts findSteamPath("c")
#end
def randomGame
Dir.chdir "/mnt"
	dirlst=[]
	Dir.foreach(Dir.pwd) do |drive|
		if findSteam(drive)
			dirlst.append(drive)
		end
	end

	gamelst=[]
	dirlst.each do |drive|
		gamelst.append(findGames(drive))
	end
	hdd = rand(dirlst.length())
	game = rand(gamelst[hdd].length())
	path=findSteamPath(dirlst[hdd])+"/"+gamelst[hdd][game]
	exeFile = getGameExe(path)
	while exeFile == -1
		hdd = rand(dirlst.length())
		game = rand(gamelst[hdd].length())
		path=findSteamPath(dirlst[hdd])+"/"+gamelst[hdd][game]
		exeFile = getGameExe(path)
	end
	return gamelst[hdd][game],exeFile
end
def main
	lst=randomGame
	game=lst[0] 
	exeFile=lst[1]
	puts "note: not all games will run correctly"
	puts "Would you like to play " + game + "?"
	choice = gets.chomp.downcase
	while choice!= "yes" 
		lst=randomGame
		game=lst[0] 
		exeFile=lst[1]
		puts "Would you like to play " + game + "?"
		choice = gets.chomp.downcase
	end
	puts "Does #{exeFile} look right?"
	choice = gets.chomp.downcase
	while choice!= "yes"
		puts "Choosing a different game"
		lst=randomGame
		game=lst[0] 
		exeFile=[1]
		puts "Would you like to play " + game + "?"
		choice = gets.chomp.downcase
	end
	if File.exist?(exeFile)
		exec("#{exeFile.shellescape}")
	else
		while exeFile == -1
			hdd = rand(dirlst.length())
			game = rand(gamelst[hdd].length())
			path=findSteamPath(dirlst[hdd])+"/"+gamelst[hdd][game]
			exeFile = getGameExe(path)
			exec("#{exeFile.shellescape}")
		end
	end
	
end

main