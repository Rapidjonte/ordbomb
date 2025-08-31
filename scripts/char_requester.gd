extends Node

var char_response: String;
var actualword = ""

@onready var so_list = $new_char

func newRequest():
	if $"../Settings".extension_enabled:
		if randf() < $"../Settings".extension_chance or $"../Settings".force_extension_chars or not $"../Settings".http_requests_enabled:
			randomize()
			var randchar = $"../Settings".extension[randi() % $"../Settings".extension.size()]
			finalize_chars(randchar)
			print("char request from extension! (from the word " + randchar + ")")
			return
	var target = "https://svenska.se/so/?id=%s&pz=5" % randi_range(100001, 198119)
	var url = $"../Settings".corsproxy + target
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
	chars = chars.replace(" ", "").replace("-", "")
	chars = filter_string(chars, $"../Settings".poäng)
	
	if chars.length() == 0:
		newRequest()
		return
		
	actualword = chars
	$"../Bomb/Label".text = get_random_chunk(chars, 3)
	
func filter_string(input: String, allowed_chars: Dictionary) -> String:
	print("filtering ", input, "...")
	var result = ""
	for char in input.to_upper(): 
		if allowed_chars.has(char):
			result += char
		
	result = result.to_lower().strip_edges()

	print("filtered: ", result)
	return result

func trim_minus(result: String) -> String:
	print("trimming ", result, "...")
	if result.length() > 0 and result[result.length()-1] == "-":
		result[result.length()-1] = ""
	if result.length() > 0 and result[0] == "-":
		result[0] = ""
	print("trimmed: ", result)
	return result

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
		return word
	var start_index = randi() % (word.length() - length + 1)
	return word.substr(start_index, length)
