extends Node

@onready var saol = $saol
@onready var so = $so
@onready var saob = $saob

var input

func url_encode(s: String) -> String:
	var encoded = ""
	var bytes = s.to_utf8_buffer() 
	for b in bytes:
		encoded += "%" + "%02X" % b
	return encoded

func newCheck(word):
	if pending == 0:
		$".."/LineEdit.text = "" ###################
		
		input = word.replace("_", "")
		input = $"../CharRequester".filter_string(input, $"../Settings".poäng)
		if pending == 0 and input.contains($"../Label".text) and !(input in $"..".used):
			print("input: " + input)
			if $"../Settings".extension_enabled and !($"../Settings".extension.find(input) == -1):
				print("word in extension!")
				accept()
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
			if (input in $"..".used): 
				pass
				$failWord_alreadyUsed.play()
			if not input.contains($"../Label".text):
				pass
				$fail.play()

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
	svar[0] = svar[0].to_lower()
	svar[1] = svar[1].to_lower()
	svar[2] = svar[2].to_lower()
	
	if svar[0].contains("gav inga svar.") and svar[1].contains("gav inga svar.") and svar[2].contains("gav inga svar."):
		$"..".fel += 1
		print("fel: " + str($"..".fel))
		$fail.play()
	elif ((svar[0].contains(input) and not svar[0].contains("gav inga svar.")) or (svar[1].contains(input) and not svar[1].contains("gav inga svar.")) or (checkSAOB(input) and not svar[2].contains("gav inga svar."))): 
		accept()
	else:
		$"..".fel += 1
		print("fel: " + str($"..".fel))
		$fail.play()

func checkSAOB(_input) -> bool:
	var part1 = _input.substr(0, _input.find("-"))
	var part2 = _input.substr(_input.find("-"))
	if svar[2].contains(part1) and svar[2].contains(part2):
		return true
	else:
		return false

func calculate_word_score(word: String) -> int:
	var score = 0
	for char in word.to_upper():
		if char in $"../Settings".poäng:
			score += $"../Settings".poäng[char]
	return score

func accept() -> void:
	$"..".rätt += 1
	print("rätt: " + str($"..".rätt))
	$correct.play()
	var point_gain = calculate_word_score(input)
	print(str($"..".points) + "\t+" + str(point_gain))
	$"..".points += point_gain
	sayer.say("+" + str(point_gain))
	$"../score".text = "Poäng: " + str($"..".points)
	$"..".used.append(input)
	$"../Label".text = "..."
	$"../CharRequester".newRequest()
