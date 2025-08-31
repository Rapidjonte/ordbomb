extends Node

var bombTimer = 100
var bombTime = randi_range(10,30)

@onready var conf = $"../Settings".room

func _process(delta):
	var t = fmod(Time.get_ticks_msec() * 0.006, 1.0)
	$Sprite.scale = Vector2.ONE * lerp(1.07, 1.0, t)
	if $Label.text != "..." and $"../WordChecker".pending == 0:
		bombTimer -= delta
	if bombTimer <= 0:
		bombed()
	
	$Spark.rotation = randf() * PI * 2
	var s = 0.8 + 0.4 * randf()
	$Spark.scale = Vector2(s,s)

func light_fuse():
	print("im bombing")
	$ignite.play()
	$tick.play()
	$"../CharRequester".newRequest()
	bombTime = randi_range(10,30)
	bombTimer = bombTime

func fuel():
	if bombTimer < 5:
		bombTime = bombTimer

func bombed():
	$explosion.play()
	light_fuse()
