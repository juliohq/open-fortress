extends CanvasLayer


@export var pause_scene: PackedScene


func _ready():
	assert(pause_scene)


func _input(event):
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		add_child(pause_scene.instantiate())
