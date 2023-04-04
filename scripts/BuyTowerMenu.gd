extends Control

onready var invisibleContainer = $InvisibleContainer

const BaseTowerPreload = preload("res://scripts/BaseTower.gd")

var attackTowerInfoUrl = "res://scenes/UI/AttackTowerInfoUI.tscn"
var bufferTowerInfoUrl = "res://scenes/UI/BufferTowerInfoUI.tscn"
var debufferTowerInfoUrl = "res://scenes/UI/DebufferTowerInfoUI.tscn"

onready var energyIcon = load("res://tiles/UI/icon2.png")

export(Array, PackedScene) var towers

onready var scrollContainer = $ScrollContainer
onready var mainElementsBox = $ScrollContainer/MainBox

onready var buyButtons = {}

signal towerBuy(resourcePath)

var buyTextFmt = "Buy -%s"


func _ready():
	scrollContainer.get_v_scrollbar().rect_scale.x = 0

	for tower in towers:
		var box = VBoxContainer.new()
		box.set_h_size_flags(SIZE_SHRINK_CENTER)
		box.set_v_size_flags(SIZE_FILL)
		box.add_constant_override("separation", 0)
		#hack
		box.rect_min_size = Vector2(260, 100)
		mainElementsBox.add_child(box)
#
		var towerInstance = tower.instance()
		invisibleContainer.add_child(towerInstance)

		var modalUrl = null
		match towerInstance.towerType:
			BaseTowerPreload.TowerType.Attack:
				modalUrl = attackTowerInfoUrl
			BaseTowerPreload.TowerType.Buffer:
				modalUrl = bufferTowerInfoUrl
			BaseTowerPreload.TowerType.Debuffer:
				modalUrl = debufferTowerInfoUrl
		var modalInstance = load(modalUrl).instance()
		modalInstance.set_h_size_flags(SIZE_SHRINK_CENTER)

		box.add_child(modalInstance)
		modalInstance.mouse_filter = Control.MOUSE_FILTER_PASS
		modalInstance.get_node("BaseInfoUI").mouse_filter = Control.MOUSE_FILTER_PASS
		modalInstance.get_node("BaseInfoUI/Animation").position = Vector2(208, 40)
		modalInstance.get_node("BaseInfoUI/Focus").position = Vector2(61, 3)
		modalInstance.init(towerInstance)

		var buyBtn = getBtn(towerInstance.buyCost)
		buyBtn.rect_position = Vector2(133, 70)
		modalInstance.add_child(buyBtn)

		buyBtn.connect("pressed", self, "_onButtonPressed", [tower.resource_path])

		buyButtons[buyBtn] = towerInstance.buyCost


func getBtn(cost) -> Button:
	var btn = Button.new()
	btn.icon = energyIcon
	btn.expand_icon = true
	btn.icon_align = Button.ALIGN_RIGHT
	btn.align = Button.ALIGN_RIGHT
	btn.rect_min_size = Vector2(100, 24)
	btn.rect_size = Vector2(100, 24)
	btn.set_h_size_flags(SIZE_SHRINK_CENTER)
	btn.set_v_size_flags(SIZE_FILL)
	btn.text = buyTextFmt % cost
	return btn


func _process(delta):
	for buyBtn in buyButtons:
		var cost = buyButtons[buyBtn]
		if $"/root/LevelProcessState".energyCounter >= cost:
			buyBtn.disabled = false
		else:
			buyBtn.disabled = true


func _onButtonPressed(resourcePath):
	emit_signal("towerBuy", resourcePath)
