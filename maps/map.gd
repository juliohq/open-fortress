extends Node


@onready var Tiles = $Tiles


func _ready():
	randomize()
	
	for x in 128:
		for y in 128:
			Tiles.set_cell(0, Vector2i(x, y), 0, Vector2i(randi() % 26, 0))
