extends Node

var bombTimer = 100
var bombTime = randi_range(10,30)

@onready var conf = $"../Settings".room

var frameDelay = 0.04

func _process(delta):
	var t = fmod(Time.get_ticks_msec() * 0.007, 1.0)
	$Sprite.scale = Vector2.ONE * lerp(1.1, 1.0, t)
	if $Label.text != "..." and $"../WordChecker".pending == 0:
		bombTimer -= delta
	if bombTimer <= 0:
		bombed()
	
	frameDelay -= delta
	if frameDelay < 0:
		$Spark.rotation += 15
		frameDelay = 0.02

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
