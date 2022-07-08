extends CanvasLayer

onready var healthValue = $HealthBox/HealthValue
onready var waveValue = $WaveBox/WaveValue
onready var energyValue = $EnergyBox/EnergyValue

var energyFormat = "%04d"
var waveFormat = "%02d"


func _process(delta):
	if $"/root/GameProcessState".isReady:
		healthValue.text = str($"/root/GameProcessState".healthCounter)
		waveValue.text = (
			str(waveFormat % $"/root/GameProcessState".maxWaveCounter)
			+ "/"
			+ str(waveFormat % $"/root/GameProcessState".currentWaveCounter)
		)
		energyValue.text = str(energyFormat % $"/root/GameProcessState".energyCounter)
