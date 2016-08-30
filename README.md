# Interactive-Music-Shell
<a href="https://codeclimate.com/repos/57c4cfc459129850cf004192/feed"><img src="https://codeclimate.com/repos/57c4cfc459129850cf004192/badges/56e1e639df1c2d45f8ac/gpa.svg" /></a>


Description 

Over view 
	To make the ims, I created two objects song and artist and used a hash in ims to store them (string artist name => artist & its list of songs)
	In ims I used pstore to save the state of the hash between uses of the file. Each time the program starts up it either loads the hash from 
	the pstore file or creates a new hash if the pstore is empty. I choose to only add to the pstore file when the user is done and calls the exit method 
	because that gives the user the ability to cntrl-c out of the program without saving if they catch themselves making a mistake. 

	In my methods in ims I check to see if an artist or song already exists before I add them to the system or try to access them. I also broke those checks into two methods to reduce redundancy. 

	My ims_testing file does unit testing on the methods for songs and artists. I put those up on Codeship to get some practice setting that up. 


URL's
https://github.com/bradpayne/Interactive-Music-Shell/blob/master/README.md
https://codeclimate.com/repos/57c4cfc459129850cf004192/feed
https://codeship.com/projects/171021
