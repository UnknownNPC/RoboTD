extends Control

onready var showTime = $ShowTime
onready var energyValue = $Body/BonusContainer/EnergyBox/EnergyValue
onready var nextWaveSecondsValue = $Body/NextWaveContainer/SecondsValue


func display(energySize, nextWaveSeconds):
	energyValue.text = str(energySize)
	nextWaveSecondsValue.text = str(nextWaveSeconds)
	showTime.start()


func _on_ShowTime_timeout():
	showTime.stop()
	self.queue_free()
