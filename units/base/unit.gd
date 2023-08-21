extends Node2D
class_name Unit


const TILE_TRANSFORM = Vector2(1.0, 0.5)
const QUARTER = PI / 4.0

@export var speed := 128.0

var direction := Vector2()
var angle := 0.0

@onready var Sprites = $Sprites


func _process(delta):
	angle += delta * 0.25
	direction = Vector2.from_angle(angle)
	translate(direction * TILE_TRANSFORM * speed * delta)
	
	var side := posmod(snappedf((direction).angle(), QUARTER) / QUARTER, 8)
	Sprites.play([
		"WALK_RIGHT",
		"WALK_DOWN_RIGHT",
		"WALK_DOWN",
		"WALK_DOWN_LEFT",
		"WALK_LEFT",
		"WALK_UP_LEFT",
		"WALK_UP",
		"WALK_UP_RIGHT",
	][side])
