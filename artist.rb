require './song'

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

	def sings?(test)
		i = 0 
		@tracklist.each do |s|
			if (s.name == test.name)
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