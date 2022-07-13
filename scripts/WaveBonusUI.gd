extends Control

onready var nextWaveTimer = $NextWaveTimer
onready var energyValue = $Body/BonusContainer/EnergyBox/EnergyValue
onready var nextWaveSecondsValue = $Body/NextWaveContainer/SecondsValue


func display(energySize, inputNextWaveTimer):
	energyValue.text = str(energySize)
	nextWaveSecondsValue.text = str(floor(nextWaveTimer.time_left))
	nextWaveTimer = inputNextWaveTimer


func _process(delta):
	nextWaveSecondsValue.text = str(floor(nextWaveTimer.time_left))


func _on_WaveBonusUI_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		self.queue_free()
