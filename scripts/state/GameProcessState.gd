extends Node

var currentWaveCounter
var maxWaveCounter
var healthCounter
var energyCounter

var isReady = false


func init(startWaveCounter, maxWaveCounterVal, healthCounterVal, startEnergyCounter):
	currentWaveCounter = startWaveCounter
	maxWaveCounter = maxWaveCounterVal
	healthCounter = healthCounterVal
	energyCounter = startEnergyCounter + 5000

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
	healthCounter -= 1
