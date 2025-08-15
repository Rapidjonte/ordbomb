extends Node2D

@onready var label = $Label
@onready var lineedit = $LineEdit
@onready var saol = $saol
@onready var so = $so
@onready var saob = $saob
@onready var so_list = $new_char

var rätt = 0;
var fel = 0;
var points = 0;

var used: Array[String] = [];

var alfabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "Å", "Ä", "Ö"]
var poäng = {
	"A": 1, "B": 4, "C": 8, "D": 1, "E": 1, "F": 4, "G": 2,
	"H": 3, "I": 1, "J": 8, "K": 3, "L": 1, "M": 3, "N": 1,
	"O": 2, "P": 3, "Q": 10, "R": 1, "S": 1, "T": 1, "U": 3,
	"V": 4, "W": 7, "X": 10, "Y": 8, "Z": 10, "Å": 4, "Ä": 4, "Ö": 4,
	"É": 6, "Ô": 12, "-": 10, " ": 7, "3": 3, "4": 4, "5": 5
}

func say(string, x = 160, y = 480):
	var popup = preload("res://scenes/popup.tscn").instantiate()
	popup.text = string
	popup.position = Vector2(x, y)
	add_child(popup)

func _input(event):
	if event is InputEventKey and event.pressed and lineedit.has_focus(): #and not event.echo:
		if event.unicode > 0:
			$type.pitch_scale = float(len(lineedit.text))/24+1
			$type.play()

func _ready():
	$ignite.play()
	char_req()

#func _process(delta):
	#pass

var char_response: String;

func char_req():
	if extension_enabled:
		if randf() < 0.3:
			randomize()
			var randchar = extension[randi() % extension.size()]
			finalize_chars(randchar.to_lower())
			print("char request from extension! (from the word " + randchar + ")")
		else:
			var url = "https://svenska.se/so/?id=%s&pz=5" % randi_range(100001, 198119)
			so_list.request(url)
			print("char request sent to " + url)
	else:
		var url = "https://svenska.se/so/?id=%s&pz=5" % randi_range(100001, 198119)
		so_list.request(url)
		print("char request sent to " + url)
	
func _on_new_char_request_completed(result, response_code, headers, body):
	char_response = body.get_string_from_utf8()
	if check_for_underscores(char_response):
		char_req()
		return
	var chars = char_response.substr(char_response.find("<span class=\"orto\">"), 55)
	chars = chars.split("</span>", true, 0)[0]
	chars = chars.split(">", true, 0)[1]
	finalize_chars(chars);
	
func filter_string(input: String, allowed_chars: Dictionary) -> String:
	var result = ""
	for char in input.to_upper(): 
		if allowed_chars.has(char):
			result += char
	return result.to_lower()

func finalize_chars(chars: String):
	chars = filter_string(chars, poäng)
	if true: # if (SELF_TURN):
		$selfTurn.play()
	label.text = get_random_chunk(chars, 3).strip_edges().replace(" ", "")
	
func check_for_underscores(chars: String) -> bool:
	chars = chars.substr(chars.find("<span class=\"orto\">"), 55)
	chars = chars.split("</span>", true, 0)[0]
	print(chars.split(">", true, 0))
	if chars.split(">", true, 0)[0] == "":
		print("underscore error")
		return true 
	else:
		return false
	
func get_random_chunk(word: String, length: int) -> String:
	if word.length() < length:
		return word[0] 
	var start_index = randi() % (word.length() - length + 1)
	return word.substr(start_index, length)

var input

func url_encode(s: String) -> String:
	var encoded = ""
	var bytes = s.to_utf8_buffer() 
	for b in bytes:
		encoded += "%" + "%02X" % b
	return encoded

func _on_line_edit_text_submitted(new_text):
	#$submit.play()
	input = lineedit.text.strip_edges().to_lower().replace("_", "")
	input = filter_string(input, poäng)
	if pending == 0 and input.contains(label.text) and !(input in used):
		print("input: " + input)
		if extension_enabled and !(extension.find(input) == -1):
			print("word in extension!")
			rätt += 1
			print("rätt: " + str(rätt))
			$correct.play()
			var point_gain = calculate_word_score(input)
			print(str(points) + "\t+" + str(point_gain))
			points += point_gain
			say("+" + str(point_gain))
			$score.text = "Poäng: " + str(points)
			used.append(input)
			label.text = "..."
			char_req()
			lineedit.text = "";
			return
		svar = ["gav inga svar.", "gav inga svar.", "gav inga svar."];
		pending = 3
		var encoded_input = url_encode(input)
		saol.request("https://svenska.se/tri/f_saol.php?sok=" + encoded_input)
		print("request sent to: " + "https://svenska.se/tri/f_saol.php?sok=" + encoded_input)
		so.request("https://svenska.se/tri/f_so.php?sok=" + encoded_input)
		print("request sent to: " + "https://svenska.se/tri/f_so.php?sok=" + encoded_input)
		saob.request("https://svenska.se/tri/f_saob.php?sok=" + encoded_input)
		print("request sent to: " + "https://svenska.se/tri/f_saob.php?sok=" + encoded_input)
	else: 
		if (input in used): 
			pass
			$failWord_alreadyUsed.play()
		if not input.contains(label.text):
			pass
			$fail.play()
	lineedit.text = "";

var svar: Array[String] = ["gav inga svar.", "gav inga svar.", "gav inga svar."];
var pending = 0

func _on_http_request_request_completed(result, response_code, headers, body): # saol
	svar[0] = body.get_string_from_utf8()
	print("saol responded! (response code: " + str(response_code) + ")")
	finished()

func _on_so_request_completed(result, response_code, headers, body): # so
	svar[1] = body.get_string_from_utf8()
	print("so responded! (response code: " + str(response_code) + ")")
	finished()

func _on_saob_request_completed(result, response_code, headers, body): # saob
	svar[2] = body.get_string_from_utf8()
	print("saob responded! (response code: " + str(response_code) + ")")
	finished()

func finished():
	pending -= 1
	if pending == 0:
		review()

func review():
	#print("\nSAOL svar: " + svar[0])
	#print("SO svar: " + svar[1])
	#print("SAOB svar: " + svar[2] + "\n")
	if svar[0].contains("gav inga svar.") and svar[1].contains("gav inga svar.") and svar[2].contains("gav inga svar."):
		fel += 1
		print("fel: " + str(fel))
		$fail.play()
	elif ((svar[0].contains(input) and not svar[0].contains("gav inga svar.")) or (svar[1].contains(input) and not svar[1].contains("gav inga svar.")) or (svar[2].contains(input) and not svar[2].contains("gav inga svar."))): 
		rätt += 1
		print("rätt: " + str(rätt))
		$correct.play()
		var point_gain = calculate_word_score(input)
		print(str(points) + "\t+" + str(point_gain))
		points += point_gain
		say("+" + str(point_gain))
		$score.text = "Poäng: " + str(points)
		used.append(input)
		label.text = "..."
		char_req()
	else:
		fel += 1
		print("fel: " + str(fel))
		$fail.play()

func calculate_word_score(word: String) -> int:
	var score = 0
	for char in word.to_upper():
		if char in poäng:
			score += poäng[char]
	return score

func read_lines_from_file(file_path: String) -> Array:
	var file = FileAccess.open(file_path, FileAccess.READ)
	var lines = file.get_as_text().split("\n")
	for i in range(lines.size()):
		lines[i] = lines[i].to_lower().strip_edges()  
	lines.remove_at(lines.find(""))
	return lines

var extension_enabled = true
@onready var extension = get_extension("res://extension.txt")

func get_extension(extension_path: String) -> Array:
	var extension_file = FileAccess.open(extension_path, FileAccess.READ)
	var data
	if extension_file: 
		data = extension_file.get_as_text().strip_edges().to_lower().split("\n")
		extension_file.close()
		print("successfully retrieved extension")
		return data
	else:
		print("failed to retrieve extension")
		extension_enabled = false
	return []
