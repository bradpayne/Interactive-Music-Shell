require 'pstore'

@store = PStore.new('DJ.pstore')

class Artist

	attr_reader :artist_name, :tracklist
	def initialize (name)
		@artist_name = name 
		@tracklist = Array.new
	end 

	def add_track(song)
		@tracklist << song 
	end 

	def count_track
		@tracklist.size 
	end 

	def total_plays
		spins = 0 
		@tracklist.each do |s|
			spins = spins + s.play_count
		end 
		return spins
	end 

	def artist_name 
		@artist_name 
	end 

	def sings?(name)
		i = 0 
		@tracklist.each do |s|
			if (s.name == name)
				return i 
			end
			i = i + 1
		end 
		return -1
	end 

	def list_songs
		string = ""
		i = @tracklist.size
		@tracklist.each do |s|
			string = string + s.name
			i = i - 1
			string = string + ", " unless (i == 0 )
		end 
		return string
	end
end 

class Song

	attr_reader :name, :artist
	def initialize(artist, name)
		@artist = artist 
		@name = name 
		@count = 0
	end 

	def play
		@count = @count + 1
	end 

	def play_count
		@count
	end 

	def name 
		@name
	end 

	def to_s
		@name
	end 
end 

@DJ = @store.transaction { @store[:data] }
if(@DJ == nil) then @DJ = Hash.new end 

@countinue = true 

def artist_exist?
	puts "\tArtist?"
	aname = gets.chomp
	if(@DJ.keys.include?(aname))
		artist = @DJ[aname]
		return artist
	else
		puts "I'm sorry, that artist is not there, please go back and add them first"
		return -1
	end 
end 

def song_exist?(artist)
	puts "\Track Name?"
	tname = gets.chomp

	index = artist.sings?(tname)

	if(index == -1)
		puts "I'm sorry, please go back and add that song first"
		return -1
	else 
		return artist.tracklist[index]
	end 
end 

def help 
	puts "\tHere are your Options"
	puts "\tExit - to end the program"
	puts "\tInfo - for Info abuot this DJ"
	puts "\tInfo Track - for info about a track"
	puts "\tAdd Artist - to add an Artist to the system"
	puts "\tAdd Track [Track Name] [Track Artist] - to add a song to the system"
	puts "\tPlay Track [Track Name] - to play a song"
	puts "\tCount Tracks - for info about how many tracks there are"
	puts "\tList Tracks - for a list of the artists"
end 

def exit
	@countinue = false 
	puts "Come back soon!"

	@store.transaction do
		# Save the data to the store.
		@store[:data] = @DJ

		@store.commit 

		@store[:last_run] = Time.now
	end
end 

def info
	puts "There are #{@DJ.keys.size} Artist(s) in the system" 
	num = 1
	@DJ.values.each do |a|
		ls = a.list_songs 
		puts "Artist #{num}: #{a.artist_name}|| Songs: #{ls}"
		num = num + 1
	end 
end 

def info_track
	artist = artist_exist?
	if (artist == -1) then return -1 end 

	song = song_exist?(artist)
	if (song == -1) 
		return -1 
	else
		puts "This song has been played #{song.play_count} times"
	end 
end 

def add_artist
	puts "What is the artist's name?"
	aname = gets.chomp
	if (@DJ.keys.include?(aname) == false )
		artist = Artist.new(aname)
		@DJ[aname] = artist
	end
	return @DJ[aname]
end 

def add_track	
	artist = add_artist
	puts "What is the track?"
	tname  = gets.chomp
	song = Song.new(artist, tname)

	if(artist.sings?(song) == -1)
		artist.add_track(song)
	else
		puts "Song is already in the system!"
	end 
end 

def play_track
	artist = artist_exist?
	if (artist == -1) then return -1 end 

	song = song_exist?(artist)
	if (song == -1) then return -1 end 

	song.play
end 

def count_track 
	artist = artist_exist?
	if (artist == -1) then return -1 end 

	number = artist.count_track
	spins = artist.total_plays
	puts "#{number} songs in the system, #{spins} total plays"
end 

def list_tracks
	artist = artist_exist?
	if (artist == -1) then return -1 end 

	number = artist.count_track
	string = artist.list_songs
	puts "#{number} Total Songs: #{string}"
end 

def reset
	@DJ = Hash.new
	puts "System Wiped!"
end

########
# Testing Data for manual testing without pstore
#test1 = Artist.new("Drake")
#tsong1 = Song.new(test1, "Take Care")
#test1.add_track(tsong1)
#@DJ["Drake"] = test1

#tsong3 = Song.new(test1, "Controlla")
#@DJ["Drake"].add_track(tsong3)

#test2 = Artist.new("Foo Fighters")
#tsong2 = Song.new(test2, "DOA")
#test2.add_track(tsong2)
#@DJ["Foo Fighters"] = test2

########
while @countinue == true
	puts "\nWhat can I do for you [Type 'Help' to see options]"
	response = gets.chomp.downcase

	if(response == "help")
		help
	elsif(response == "exit")
		exit
	elsif(response == "info")
		info
	elsif(response.include?("info track"))
		info_track
	elsif(response.include?("add artist"))
		add_artist
	elsif(response.include?("add track"))
		add_track
	elsif(response.include?("play track"))
		play_track
	elsif(response.include?("count track"))
		count_track
	elsif(response.include?("list tracks"))
		list_tracks
	elsif(response.include?("reset"))
		reset
	else 
		puts "Sorry, command not recgonized."
	end
end
