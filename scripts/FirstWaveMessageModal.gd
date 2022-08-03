extends Control

onready var nextWaveSecondsValue = $Body/NextWaveContainer/SecondsValue

var nextWaveTimer = null


func display(inputNextWaveTimer):
	nextWaveTimer = inputNextWaveTimer
	nextWaveTimer.connect("timeout", self, "_nextWaveTimerTimeout")
	nextWaveSecondsValue.text = str(floor(nextWaveTimer.time_left))


func _process(delta):
	if is_instance_valid(nextWaveTimer):
		nextWaveSecondsValue.text = str(floor(nextWaveTimer.time_left))


func _on_FirstWaveMessageModal_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		self.queue_free()


func _nextWaveTimerTimeout():
	self.queue_free()
