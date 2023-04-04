extends Node

var menuMusicPlayer: AudioStreamPlayer = AudioStreamPlayer.new()
var levelMusicPlayer: AudioStreamPlayer = AudioStreamPlayer.new()
var btnClickMusicPlayer: AudioStreamPlayer = AudioStreamPlayer.new()

var levelMusicStreamSamples := {}

var menuMusicFile = "res://sounds/music/Leap_menu.ogg"
var btnClickV2SoundFile = "res://sounds/btn_click_v2.ogg"
var levelMusicFileNames = ["DarkMusic.ogg", "Challange.ogg", "Unstable_field.ogg"]
var levelMusicFolder = "res://sounds/music/%s"

var currentTrackIndex = null
var rng = RandomNumberGenerator.new()


func _ready():
	rng.randomize()

	var index = 0
	for fileName in levelMusicFileNames:
		var fileResouseUrl = levelMusicFolder % fileName
		print(fileResouseUrl)
		var songStream = _getSongStreamFromFilePath(fileResouseUrl, true)
		levelMusicStreamSamples[index] = songStream
		index += 1
	print("Total songs: " + str(levelMusicStreamSamples.size()))

	levelMusicPlayer.pause_mode = Node.PAUSE_MODE_PROCESS
	levelMusicPlayer.set_bus("bgm")
	add_child(levelMusicPlayer)

	menuMusicPlayer.stream = _getSongStreamFromFilePath(menuMusicFile, true)
	menuMusicPlayer.set_bus("bgm")
	add_child(menuMusicPlayer)

	btnClickMusicPlayer.stream = _getSongStreamFromFilePath(btnClickV2SoundFile, false)
	btnClickMusicPlayer.set_bus("sfx")
	add_child(btnClickMusicPlayer)


func playNextLevelMusic():
	if currentTrackIndex == null:
		currentTrackIndex = rng.randi_range(0, levelMusicStreamSamples.size() - 1)
		print(
			(
				"Music levelMusicPlayer. First song initilizing. Starting song index: "
				+ str(currentTrackIndex)
			)
		)
	else:
		var nextSongIndex = currentTrackIndex + 1
		if nextSongIndex > levelMusicStreamSamples.size() - 1:
			print("Music levelMusicPlayer. Playlist end. starting from 0")
			currentTrackIndex = 0
		else:
			print("Music levelMusicPlayer. Next song exist, index: " + str(nextSongIndex))
			currentTrackIndex = nextSongIndex

	var track = levelMusicStreamSamples[currentTrackIndex]

	if levelMusicPlayer.playing:
		levelMusicPlayer.stop()

	levelMusicPlayer.stream = track
	levelMusicPlayer.play()


func makeLevelMusicQuiet():
	levelMusicPlayer.volume_db += -5


func makeLevelMusicLouder():
	levelMusicPlayer.volume_db -= -5


func stopPlayingLevelMusic():
	levelMusicPlayer.stop()


func playMenuMusic():
	menuMusicPlayer.play()


func stopMenuMusic():
	menuMusicPlayer.stop()


func playClickBtnSound():
	btnClickMusicPlayer.play()


func _getSongStreamFromFilePath(fileResouseUrl, loop):
	var songFile = File.new()

	songFile.open(fileResouseUrl, songFile.READ)
	var buffer = songFile.get_buffer(songFile.get_len())

	var songStream = null
	if fileResouseUrl.ends_with("mp3"):
		songStream = AudioStreamMP3.new()
	elif fileResouseUrl.ends_with("ogg"):
		songStream = AudioStreamOGGVorbis.new()
	songStream.data = buffer
	songStream.loop = loop

	songFile.close()
	return songStream
