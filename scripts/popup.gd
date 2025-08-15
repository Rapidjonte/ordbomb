extends Label

@export var move_speed := 40.0   
@export var fade_speed := 1.0      
@export var lifetime := 1.5      

var _time_alive := 0.0

func _ready():
	modulate.a = 1.0  
	_time_alive = 0.0

func _process(delta: float):
	position.y -= move_speed * delta
	
	modulate.a -= fade_speed * delta

	_time_alive += delta
	if _time_alive >= lifetime:
		queue_free()
