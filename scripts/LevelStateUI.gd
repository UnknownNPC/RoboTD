extends CanvasLayer

onready var healthValue = $HealthBox/HealthValue
onready var waveValue = $WaveBox/WaveValue
onready var energyValue = $EnergyBox/EnergyValue

var energyFormat = "%04d"
var waveFormat = "%02d"

var maxWaveCounterVal

func init(healthVal, maxWaveValue, energyVal):
	maxWaveCounterVal = maxWaveValue
	healthValue.text = str(healthVal)
	waveValue.text = str(waveFormat % maxWaveCounterVal) + "/" + str(waveFormat % 1)
	energyValue.text = str(energyFormat % energyVal) 

func setEnergy(value):
	energyValue.text = energyFormat % value
	
func setWaveValue(value):
	waveValue.text = str(waveFormat % maxWaveCounterVal) + "/" + str(waveFormat % value)

func setHealth(value):
	healthValue.text = str(value)
