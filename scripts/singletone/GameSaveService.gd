extends Node

var savePath = "user://savegame.save"

var initSaveGameJson := {"lastLevel": 0, "musicIsOn": true, "sfxIsOn": true}


func _ready():
	var save_game = File.new()
	if !save_game.file_exists(savePath):
		print("Initializing user save")
		_saveSaveGame(initSaveGameJson)
	else:
		print("user save already exists. skipping")


func saveLastLevelIfProgressHappens(levelId: int):
	var saveGame = _loadSaveGame()
	if saveGame["lastLevel"] < levelId:
		saveGame["lastLevel"] = levelId
		_saveSaveGame(saveGame)


func loadLastLevel() -> int:
	var saveGame = _loadSaveGame()
	return saveGame["lastLevel"]


func isMusicOn() -> bool:
	var saveGame = _loadSaveGame()
	return saveGame["musicIsOn"]


func setMusicOn(isOn: bool):
	var saveGame = _loadSaveGame()
	saveGame["musicIsOn"] = isOn
	_saveSaveGame(saveGame)


func isSfxOn() -> bool:
	var saveGame = _loadSaveGame()
	return saveGame["sfxIsOn"]


func setSfxOn(isOn: bool):
	var saveGame = _loadSaveGame()
	saveGame["sfxIsOn"] = isOn
	_saveSaveGame(saveGame)


func _saveSaveGame(saveGame: Dictionary):
	print("Updating savegame" + str(saveGame))
	var file = File.new()
	file.open(savePath, File.WRITE)
	file.store_string(JSON.print(saveGame))
	file.close()


func _loadSaveGame() -> Dictionary:
	var file = File.new()
	file.open(savePath, File.READ)
	var jsonParseResult := JSON.parse(file.get_as_text())

	file.close()

	if jsonParseResult.error:
		printerr("Failed to parse save file: ", file.error_string)

	var result = jsonParseResult.result as Dictionary
	print("reading savegame" + str(result))
	return result
