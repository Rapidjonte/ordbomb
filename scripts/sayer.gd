class_name sayer

static func say(string, x = 16, y = 536):
	var popup = preload("res://scenes/popup.tscn").instantiate()
	popup.text = string
	popup.position = Vector2(x, y)
	var root = Engine.get_main_loop().root
	root.add_child(popup)
