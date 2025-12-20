class_name ExampleLevelLoader
extends Node


static func parse_level_file(path: String) -> void:
	var file_str: String = FileAccess.get_file_as_string(path)
	var file_data: Dictionary = JSON.to_native(JSON.parse_string(file_str), true)
	
	var test: Dictionary = JSON.from_native({
	"tiles": [
		[1, 15, 15, 30, 10]
	],
	"sprites": [
		{"simple_enemy": {"position": Vector2(450,100), "hp": 5}},
		{"simple_enemy": {"position": Vector2(312,300), "hp": 1}},
		{"simple_enemy": {"position": Vector2(505,400), "hp": 2}},
		{"simple_enemy": {"position": Vector2(412,500), "hp": 4}}
	]
	}, true)
	
	
	print(JSON.stringify(JSON.from_native(test, true)))
	
