extends Sprite2D
class_name Bomb

# Called when the node enters the scene tree for the first time.
func _ready():
	$"../ignite".play()
	print("im bombing")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
