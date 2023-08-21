extends MarginContainer


func _ready():
	get_tree().paused = true


func _exit_tree():
	get_tree().paused = false


func _input(event):
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		queue_free()


func restart_mission():
	get_tree().reload_current_scene()


func show_options():
	pass


func quit_mission():
	pass


func quit_game():
	get_tree().quit()
