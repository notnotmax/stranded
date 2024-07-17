extends Node

var save_path = "res://savefile.txt"

var savedata: Dictionary


func save_data():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	var data = {
		"level_1_score": savedata.get("level_1_score", 0),
		"level_2_score": savedata.get("level_2_score", 0),
		"level_3_score": savedata.get("level_3_score", 0)
	}
	var jstr = JSON.stringify(data)
	file.store_line(jstr)


func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var data = JSON.parse_string(file.get_line())
		if data:
			savedata = data
		else:
			print("Savefile corrupted.")
	else:
		print("No save data found.")
		save_data() # saves a default template with scores of 0


func get_level_score(level: int):
	var key = "level_" + str(level) + "_score"
	return savedata.get(key, 0)


func set_level_score(level: int, score: int):
	var key = "level_" + str(level) + "_score"
	savedata[key] = score
