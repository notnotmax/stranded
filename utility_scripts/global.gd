extends Node

var save_path = "res://savefile.txt"

var savedata: Dictionary
var level_count: int = 3


# Utility function. Usage: await delay(seconds)
func delay(seconds: float):
	await get_tree().create_timer(seconds, false).timeout


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


func set_level_score(level: int, score: int, overwrite_high_score: bool = false):
	if overwrite_high_score or score > get_level_score(level):
		var key = "level_" + str(level) + "_score"
		savedata[key] = score


func unlock_all_levels():
	for i in range(1, level_count + 1):
		set_level_score(i, 1, false) # unlock by putting score > 0
	save_data()


func reset_scores():
	for i in range(1, level_count + 1):
		set_level_score(i, 0, true)
	save_data()
