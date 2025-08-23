extends Node2D

var rätt = 0;
var fel = 0;
var points = 0;
var used: Array[String] = [];

func _input(event):
	if event is InputEventKey and event.pressed and $LineEdit.has_focus(): #and not event.echo:
		if event.unicode > 0:
			$LineEdit/type.pitch_scale = float(len($LineEdit.text))/24+1
			$LineEdit/type.play()

func _ready():
	$CharRequester.newRequest()

func _on_line_edit_text_submitted(new_text):
	$WordChecker.newCheck(new_text)
