class_name sayer

static func say(string):
	var popup = preload("res://scenes/popup.tscn").instantiate()
	popup.text = string
	var root = Engine.get_main_loop().root
	root.add_child(popup)
