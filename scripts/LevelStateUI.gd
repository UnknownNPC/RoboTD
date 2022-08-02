extends CanvasLayer

onready var healthValue = $HealthBox/HealthValue
onready var waveValue = $WaveBox/WaveValue
onready var energyValue = $EnergyBox/EnergyValue

var healthFormat = "%02d"
var energyFormat = "%04d"
var waveFormat = "%02d"


func _process(delta):
	if $"/root/GameProcessState".isReady:
		healthValue.text = str(healthFormat % $"/root/GameProcessState".healthCounter)
		waveValue.text = (
			str(waveFormat % $"/root/GameProcessState".currentWaveCounter)
			+ "/"
			+ str(waveFormat % $"/root/GameProcessState".maxWaveCounter)
		)
		energyValue.text = str(energyFormat % $"/root/GameProcessState".energyCounter)
