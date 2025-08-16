extends Node2D

@export var id : int

@onready var name_label = $name_label
@onready var word_label  = $word_label
@onready var sprite = $sprite

func set_word(str: String):
	word_label.text = str
	
func set_player_name(str: String):
	name_label.text = str

func set_position_on_circle(center: Vector2, radius: float, index: int, total: int):
	var angle = index * 2 * PI / total
	position = center + Vector2(cos(angle), sin(angle)) * radius
	print("im at: ", position)
