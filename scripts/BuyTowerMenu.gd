extends Control

export (Array, PackedScene) var towers

onready var horizontalScroll = $ScrollContainer/HorizontalScroll
onready var hiddenRowSample = $ScrollContainer/HorizontalScroll/RowSample

onready var rows = []

signal towerBuy(resourcePath)

func _ready():
	for tower in towers:
		var row = hiddenRowSample.duplicate()
		var towerInstance = tower.instance()
		row.get_node("NameVal").text = towerInstance.unitName
		row.get_node("DmgVal").text = str(towerInstance.damageValue)
		row.get_node("RateVal").text = str(towerInstance.attackCooldown)
		row.get_node("RangeVal").text = str(towerInstance.attackRadius)
		row.get_node("BuyBtn").text = str(towerInstance.buyCost)
		row.show()
		rows.append(row)

		var buyBtn = row.get_node("BuyBtn")
		buyBtn.connect("pressed", self, "_onButtonPressed", [tower.resource_path])

		horizontalScroll.add_child(row)

func _process(delta):
	for row in rows:
		var buyBtn = row.get_node("BuyBtn")
		if ($"/root/GameProcessState".energyCounter >= int(buyBtn.text)):
			buyBtn.disabled = false
		else:
			buyBtn.disabled = true

func _onButtonPressed(resourcePath):
	emit_signal("towerBuy", resourcePath)
