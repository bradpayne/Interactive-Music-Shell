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