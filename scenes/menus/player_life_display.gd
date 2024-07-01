extends HBoxContainer


func update_display(lives):
	for i in get_child_count():
		if lives > i:
			get_child(i).show()
		else:
			get_child(i).hide()
