extends Control

onready var energyValue = $Body/BonusContainer/EnergyBox/EnergyValue
onready var nextWaveSecondsValue = $Body/NextWaveContainer/SecondsValue

var nextWaveTimer = null


func display(energySize, inputNextWaveTimer):
	nextWaveTimer = inputNextWaveTimer
	nextWaveTimer.connect("timeout", self, "_nextWaveTimerTimeout")

	energyValue.text = str(energySize)
	nextWaveSecondsValue.text = str(floor(nextWaveTimer.time_left))


func _process(delta):
	if is_instance_valid(nextWaveTimer):
		nextWaveSecondsValue.text = str(floor(nextWaveTimer.time_left))


func _on_WaveBonusUI_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		self.queue_free()


func _nextWaveTimerTimeout():
	self.queue_free()
