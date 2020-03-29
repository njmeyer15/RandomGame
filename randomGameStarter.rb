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
	puts gamelst[hdd][game]
end
main()