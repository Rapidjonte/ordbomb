extends Node

var char_response: String;

@onready var so_list = $new_char

func newRequest():
	if Settings.extension_enabled:
		if randf() < 0.3:
			randomize()
			var randchar = Settings.extension[randi() % Settings.extension.size()]
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
		newRequest()
		return
	var chars = char_response.substr(char_response.find("<span class=\"orto\">"), 55)
	chars = chars.split("</span>", true, 0)[0]
	chars = chars.split(">", true, 0)[1]
	finalize_chars(chars);

func finalize_chars(chars: String):
	chars = filter_string(chars, $"/root/Settings".poäng)
	$"../Label".text = get_random_chunk(chars, 3).strip_edges().replace(" ", "")
	
func filter_string(input: String, allowed_chars: Dictionary) -> String:
	var result = ""
	for char in input.to_upper(): 
		if allowed_chars.has(char):
			result += char
	return result.to_lower()

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
