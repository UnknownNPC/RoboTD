extends Control

const BaseTowerPreload = preload("res://scripts/BaseTower.gd")

var attackTowerInfoUrl = "res://scenes/UI/AttackTowerInfoUI.tscn"
var bufferTowerInfoUrl = "res://scenes/UI/BufferTowerInfoUI.tscn"
var debufferTowerInfoUrl = "res://scenes/UI/DebufferTowerInfoUI.tscn"

export(Array, PackedScene) var towers

onready var horizontalScroll = $ScrollContainer/HorizontalScroll

onready var invisibleSpawnBlock = $InvisibleSpawnBlock

onready var buyButtons = []

signal towerBuy(resourcePath)


func _ready():
	for tower in towers:
		var towerInstance = tower.instance()
		invisibleSpawnBlock.add_child(towerInstance)

		var modalUrl = null
		match towerInstance.towerType:
			BaseTowerPreload.TowerType.Attack:
				modalUrl = attackTowerInfoUrl
			BaseTowerPreload.TowerType.Buffer:
				modalUrl = bufferTowerInfoUrl
			BaseTowerPreload.TowerType.Debuffer:
				modalUrl = debufferTowerInfoUrl

		var modalInstance = load(modalUrl).instance()

		horizontalScroll.add_child(modalInstance)

		modalInstance.init(towerInstance)


func _process(delta):
	for buyBtn in buyButtons:
		if $"/root/GameProcessState".energyCounter >= int(buyBtn.text):
			buyBtn.disabled = false
		else:
			buyBtn.disabled = true


func _onButtonPressed(resourcePath):
	emit_signal("towerBuy", resourcePath)
