extends Control

onready var showTime = $ShowTime
onready var nextWaveTimer = $NextWaveTimer
onready var energyValue = $Body/BonusContainer/EnergyBox/EnergyValue
onready var nextWaveSecondsValue = $Body/NextWaveContainer/SecondsValue


func display(energySize, inputNextWaveTimer):
	energyValue.text = str(energySize)
	nextWaveSecondsValue.text = str(floor(nextWaveTimer.time_left))
	nextWaveTimer = inputNextWaveTimer
	showTime.start()


func _process(delta):
	nextWaveSecondsValue.text = str(floor(nextWaveTimer.time_left))


func _on_ShowTime_timeout():
	showTime.stop()
	self.queue_free()
