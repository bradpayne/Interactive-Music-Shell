require 'pstore'
require_relative 'artist.rb'
require_relative 'song.rb'

# either creates a new file called DJ or calls on the file that already exists
@store = PStore.new('DJ.pstore')

# this line sees to see if the pstore has any data saved 
@DJ = @store.transaction { @store[:data] }
#if there isn't any saved data on the pstore, then it initializes a new hash 
if(@DJ == nil) then @DJ = Hash.new end 

#boolean for a while loop 
@countinue = true 

def artist_exist?
	# makes sure that an artist exists before adding them to the system 
	# returns the artist if they do exist
	# returns -1 if they don't, allows me to write if statements that end methods
	puts "Artist?"
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
	# makes sure that an song exists before adding them to the system 
	# returns the song it does exist
	# returns -1 if it doesn't, allows me to write if statements that end methods
	puts "Track Name?"
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
	# when the user calls the exit method, the current state of the hash is saved in a pstore file so that it can be called later
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
	# makes sure a song and artist exist and then uses a song method to find the play count 
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
	# checks to see if an artist is in the system and then adds them 
	puts "What is the artist's name?"
	aname = gets.chomp
	if (@DJ.keys.include?(aname) == false )
		artist = Artist.new(aname)
		@DJ[aname] = artist
	end
	return @DJ[aname]
end 

def add_track	
	# A user could also add an artist with this method because I felt like having to add the artist seperately every time felt tedious 
	# makes sure that the artist / song aren't already in the system before it adds them 
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
	# checks to see if an artist does have a song and then plays it 
	artist = artist_exist?
	if (artist == -1) then return -1 end 

	song = song_exist?(artist)
	if (song == -1) then return -1 end 

	song.play
end 

def count_track 
	# uses artist methods to find how many total plays a artist has had 
	artist = artist_exist?
	if (artist == -1) then return -1 end 

	number = artist.count_track
	spins = artist.total_plays
	puts "#{number} songs in the system, #{spins} total plays"
end 

def list_tracks
	# calls on the count_track and list_songs method of the artist class to show the number of all songs and hteir names 
	artist = artist_exist?
	if (artist == -1) then return -1 end 

	number = artist.count_track
	string = artist.list_songs
	puts "#{number} Total Songs: #{string}"
end 

def reset
	# clears the system for testing, resets the value of the DJ hash whihc also resets the pstore file once it is saved in the exit method
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
