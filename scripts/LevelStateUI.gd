extends Control

onready var healthValue = $HealthBox/HealthValue
onready var waveValue = $WaveBox/WaveValue
onready var energyValue = $EnergyBox/EnergyValue

var healthFormat = "%02d"
var energyFormat = "%04d"
var waveFormat = "%02d"


func _process(_delta):
	if $"/root/LevelProcessState".isReady:
		healthValue.text = str(healthFormat % $"/root/LevelProcessState".healthCounter)
		waveValue.text = (
			str(waveFormat % $"/root/LevelProcessState".currentWaveCounter)
			+ "/"
			+ str(waveFormat % $"/root/LevelProcessState".maxWaveCounter)
		)
		energyValue.text = str(energyFormat % $"/root/LevelProcessState".energyCounter)
