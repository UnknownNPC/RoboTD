extends Node2D

onready var advertMob = $AdMob
onready var openAdvertBtn = $GameMenuIconUI/AdvertBtn

onready var GAME_STATE := $"/root/GameProcessState"


func _ready():
	advertMob.load_rewarded_video()
	openAdvertBtn.connect("pressed", self, "_openAdvertBtnClicked")


func _process(delta):
	if advertMob.is_rewarded_video_loaded():
		openAdvertBtn.disabled = false
	else:
		openAdvertBtn.disabled = true


# will trigger advert opening
func _openAdvertBtnClicked():
	$"/root/ScreenUISingleton".showAdvertModal(advertMob)


func _on_AdMob_rewarded(currency, amount):
	print("Rewarded energy added")
	GAME_STATE.addEnergy(amount)
	advertMob.load_rewarded_video()


func _on_AdMob_rewarded_video_closed():
	print("Rewarded video closed")
	advertMob.load_rewarded_video()


func _on_AdMob_rewarded_video_failed_to_load(error_code):
	pass  # Replace with function body.


func _on_AdMob_rewarded_video_loaded():
	print("Rewarded video loaded")
