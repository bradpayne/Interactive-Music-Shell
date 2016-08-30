require './artist'
require './song'
require 'minitest/autorun'

describe Artist do
   before do
      @one = Artist.new("Drake")
   end

   it "saves name correctly" do 
   		(@one.artist_name).must_equal("Drake") # not sure of the better way to write this yet 
   	end 

   	it "Addes a song correctly - count" do 
   		start = @one.count_track
   		fake_song = "fake"
   		@one.add_track(fake_song)
   		(@one.count_track).must_equal(start + 1)
   	end 

   	it "Addes a song correctly - name" do 
   		start = @one.count_track
   		fake_song = "fake"
   		@one.add_track(fake_song)
   		(@one.tracklist.include?(fake_song)).must_equal(true)
   	end 

   	it "Finds total plays correctly" do 
		tester = Artist.new("tester")
		song = Song.new(tester, "Test")
		tester.add_track(song)
		10.times { song.play }
		(tester.total_plays).must_equal(10)
	end 

	it "'Sings? works correctly - negative" do 
		tester2 = Artist.new("tester")
		song2 = Song.new(tester2, "Test")
		(@one.sings?(song2.name)).must_equal(-1)
	end 

	it "'Sings? works correctly - positive" do 
		song1 = Song.new(@one, "Test")
		@one.add_track(song1)
		(@one.sings?(song1.name)).wont_equal(-1)
	end 
end 

describe Song do 
	before do
		@Drake = Artist.new("Drake")
		@a = Song.new(@Drake, "One Dance")
	end 

	it "creates a song correctly - artist" do 
		(@a.artist.artist_name).must_equal("Drake")
	end 

	it "creates a song correctly -  name" do 
		(@a.name).must_equal("One Dance")
	end 

	it "counts plays correctly" do 
		start = @a.play_count 
		@a.play()
		(@a.play_count).must_equal(start + 1)
	end 
end 