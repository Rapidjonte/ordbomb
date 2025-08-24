extends Node2D

var rätt = 0;
var fel = 0;
var points = 0;

func _input(event):
	if event is InputEventKey and event.pressed and $LineEdit.has_focus(): #and not event.echo:
		if event.unicode > 0:
			$LineEdit/type.pitch_scale = float(len($LineEdit.text))/24+1
			$LineEdit/type.play()
			
func _ready():
	$CharRequester.newRequest()

func _on_line_edit_text_submitted(new_text):
	$WordChecker.newCheck(new_text)
	
## AUTOPLAYER ##
#	var delay = 0
#	var i = 0
#	var prevword = ""
#	var accepted = false
#	func _process(delta):
#		delay -= delta
#		if delay <= 0 and $CharRequester.actualword == prevword and not accepted and $Bomb/Label.text != "..." :
#			if i < $CharRequester.actualword.length():
#				$LineEdit.text += $CharRequester.actualword[i]
#				$LineEdit/type.pitch_scale = float(len($LineEdit.text))/24+1
#				$LineEdit/type.play()
#				i += 1
#			else:
#				i = 0
#				$WordChecker.input = $LineEdit.text
#				accepted = true
#				$WordChecker.accept()
#				$LineEdit.text = ""
#		else:
#			if prevword != $CharRequester.actualword and delay <= 0 and $Bomb/Label.text != "..." :
#				prevword = $CharRequester.actualword
#				accepted = false
#				$WordChecker.used.clear()
#		if delay <= 0:
#			delay = 0 # TYPING DELAY
