extends Node

var extension_chance = 0.3
var force_extension_chars = true

var extension_enabled = true
var extension = get_extension("res://extension.txt")

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

var poäng = {
	"A": 1, "B": 4, "C": 8, "D": 1, "E": 1, "F": 4, "G": 2,
	"H": 3, "I": 1, "J": 8, "K": 3, "L": 1, "M": 3, "N": 1,
	"O": 2, "P": 3, "Q": 10, "R": 1, "S": 1, "T": 1, "U": 3,
	"V": 4, "W": 7, "X": 10, "Y": 8, "Z": 10, "Å": 4, "Ä": 4, "Ö": 4,
	"É": 6, "Ô": 12, "-": 10, " ": 7, "3": 4, "4": 4, "5": 4, "À": 6
}

var corsproxy = "https://corsproxy.io/?url="

var room = {
	"Minimum turn duration": 5,
	"Maximum syllable lifespan": 2,
	"Initial lives": 2,
	"Maximum lives": 3,
	"Maximum number of players": 16,
}
