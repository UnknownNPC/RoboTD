extends CanvasLayer

onready var healthValue = $MarginContainer/TopMenu/HealthBox/HealthValue
onready var waveValue = $MarginContainer/TopMenu/WaveBox/WaveValue
onready var energyValue = $MarginContainer/TopMenu/EnergyBox/EnergyValue

func init(healthVal, maxWaveValue, energyVal):
	healthValue.text = str(healthVal)
	waveValue.text = str(maxWaveValue) + "/1"
	energyValue.text = str(energyVal) 

func increaseEnegy(value):
	energyValue.text = str(int(energyValue.text) + value)
	
func dicreaseEnegy(value):
	energyValue.text = str(int(energyValue.text) - value)
	
func setWaveValue(value):
	waveValue.text = value

func dicreaseHealth(value):
	healthValue.text = str(int(healthValue.text) - value)
