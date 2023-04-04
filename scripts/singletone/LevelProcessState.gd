extends Node

var currentWaveCounter
var maxWaveCounter
var healthCounter
var energyCounter

var isReady = false


func init(maxWaveCounterVal, healthCounterVal, startEnergyCounter):
	currentWaveCounter = 0
	maxWaveCounter = maxWaveCounterVal
	healthCounter = healthCounterVal
	energyCounter = startEnergyCounter

	isReady = true


func increaseCurrentWave():
	currentWaveCounter += 1


func addEnergy(value):
	energyCounter += value


func getEnergy(value):
	energyCounter -= value


func isEnergyEnough(value):
	return energyCounter >= value


func dicreaseHealth():
	if healthCounter > 0:
		healthCounter -= 1
