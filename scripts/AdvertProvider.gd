extends Node2D

onready var advertMob = $AdMob
onready var openAdvertBtn = $GameMenuIconUI/AdvertBtn
onready var rewardedVideoRetry = $RewardedVideoRetry
onready var animatioonPlayer = $AnimationPlayer

onready var pauseInAudioPlayer = $PauseInAudioPlayer as AudioStreamPlayer

onready var GAME_STATE := $"/root/LevelProcessState"


func _ready():
	advertMob.load_rewarded_video()
	openAdvertBtn.connect("pressed", self, "_openAdvertBtnClicked")


func _process(_delta):
	if advertMob.is_rewarded_video_loaded():
		openAdvertBtn.disabled = false
	else:
		openAdvertBtn.disabled = true


# will trigger advert opening
func _openAdvertBtnClicked():
	pauseInAudioPlayer.play()
	yield(pauseInAudioPlayer, "finished")

	$"/root/ScreenUISingleton".showAdvertModal(advertMob)


func _on_AdMob_rewarded(_currency, amount):
	print("Rewarded energy added")
	GAME_STATE.addEnergy(amount)
	advertMob.load_rewarded_video()


func _on_AdMob_rewarded_video_closed():
	print("Rewarded video closed")
	advertMob.load_rewarded_video()


func _on_AdMob_rewarded_video_loaded():
	animatioonPlayer.play("warn")
	print("Rewarded video loaded")


func _on_AdMob_rewarded_video_failed_to_load(error_code):
	print("Rewarded video failed to load:" + str(error_code) + ". Starting timer")
	rewardedVideoRetry.start()


func _on_RewardedVideoRetry_timeout():
	print("Retry timer left. Trying to load one more time")
	advertMob.load_rewarded_video()
