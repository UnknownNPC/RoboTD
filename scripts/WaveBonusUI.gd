extends Control

onready var showTime = $ShowTime
onready var energyValue = $TextHContainer/EnergyBox/EnergyValue


func display(energySize):
	energyValue.text = str(energySize)
	self.show()
	showTime.start()


func _on_ShowTime_timeout():
	showTime.stop()
	self.hide()
