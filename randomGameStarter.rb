#!/usr/bin/env ruby

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
		if File.extname(file)==".exe"
			return path + "/" + file
		end
	end
	Dir.foreach(Dir.pwd) do |file|
		if file == "Binaries" || file == "bin"
			Dir.chdir file
			return binPath(Dir.pwd)
		end
	end
	Dir.foreach(Dir.pwd) do |file|
		if file == "Game"
			Dir.chdir file
			file.each do |file2|
				if File.extname(file) == ".exe"
					return Dir.pwd + "/" + file
				end
			end
			
		end
	end
	return -1
	
end

def binPath(path)
	Dir.chdir = path
	Dir.foreach(Dir.pwd) do |file|
		if file == "Win32" || file == "Win64"
			Dir.chdir file
			file.each do |inFile|
				if File.extname(file)
					return path + "/" + file
				end
			end
		
		elsif File.extname(file)==".exe"
			return path + "/" + file
		end
	end
end

def test
	path= "/mnt/f/Steam/steamapps/common/BioShock Remastered"
	puts getGameExe(path)
end

def main()
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
	path="/mnt/"+dirlst[hdd]+"/Steam/steamapps/common/"+gamelst[hdd][game]
	exeFile = getGameExe(path)
	while exeFile == -1
		hdd = rand(dirlst.length())
		game = rand(gamelst[hdd].length())
		path="/mnt/"+dirlst[hdd]+"/Steam/steamapps/common/"+gamelst[hdd][game]
		exeFile = getGameExe(path)
	end
	
	exec(exeFile)
	puts gamelst[hdd][game]
end
main()
