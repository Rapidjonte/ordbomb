extends Node2D

@onready var lineedit = $LineEdit
@onready var label = $LineEdit

var rätt = 0;
var fel = 0;
var points = 0;
var used: Array[String] = [];

func _input(event):
	if event is InputEventKey and event.pressed and lineedit.has_focus(): #and not event.echo:
		if event.unicode > 0:
			$type.pitch_scale = float(len(lineedit.text))/24+1
			$type.play()

func _ready():
	$CharRequester.newRequest()
