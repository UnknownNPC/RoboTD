extends Control

export(Array, PackedScene) var towers

onready var horizontalScroll = $ScrollContainer/HorizontalScroll
onready var grid = $ScrollContainer/HorizontalScroll/Grid

onready var buyButtons = []

signal towerBuy(resourcePath)


func _ready():
	for tower in towers:
		var towerInstance = tower.instance()

		var nameVal = copySampleNode("NameValSample", towerInstance.unitName)
		grid.add_child(nameVal)

		var dmgV = "-" if towerInstance.damageValue == 0 else towerInstance.damageValue
		var dmgVal = copySampleNode("DmgValSample", dmgV)
		grid.add_child(dmgVal)

		var rateVal = copySampleNode("RateValSample", towerInstance.attackCooldown)
		grid.add_child(rateVal)

		var rangeVal = copySampleNode("RangeValSample", towerInstance.attackRadius)
		grid.add_child(rangeVal)

		var buyBtn = copySampleNode("BuyBtnSample", towerInstance.buyCost)
		grid.add_child(buyBtn)
		buyBtn.connect("pressed", self, "_onButtonPressed", [tower.resource_path])

		buyButtons.append(buyBtn)


func copySampleNode(nodeName, textField):
	var newNode = grid.get_node(nodeName).duplicate()
	newNode.text = str(textField)
	newNode.show()
	return newNode


func _process(delta):
	for buyBtn in buyButtons:
		if $"/root/GameProcessState".energyCounter >= int(buyBtn.text):
			buyBtn.disabled = false
		else:
			buyBtn.disabled = true


func _onButtonPressed(resourcePath):
	emit_signal("towerBuy", resourcePath)
