extends Node

var save_path = "res://savefile.save"
var level_1_score = 0

var data = {
	"level_1_score": 234
}


func save_data():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	var savedata = {
		"level_1_score": level_1_score
	}
	var jstr = JSON.stringify(savedata)
	file.store_line(jstr)


func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var savedata = JSON.parse_string(file.get_line())
		if savedata:
			level_1_score = savedata["level_1_score"]
	else:
		print("No save data found.")
		level_1_score = 0
		
