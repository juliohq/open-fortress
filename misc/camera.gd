extends Camera2D


@export var locked = false:
	set(value):
		locked = value
		
		set_process(not locked)
		set_process_unhandled_input(not locked)
@export var speed = 512.0
@export var friction = 48.0

var dragging := false
var velocity := Vector2()
var zooming := false


func _ready():
	set_process(not locked)
	set_process_input(not locked)


func _process(delta):
	# Zoom logic
	var zoom_axis = Input.get_axis("zoom_out", "zoom_in")
	
	if zoom_axis != 0.0:
		zoom += Vector2(0.1, 0.1) * zoom_axis * zoom
		clamp_zoom()
	
	# Pan logic
	velocity = velocity.move_toward(Input.get_vector("left", "right", "up", "down") * speed, friction)
	translate(velocity / zoom * delta)


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			get_viewport().set_input_as_handled()
			
			if event.is_pressed():
				dragging = true
			else:
				dragging = false
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			get_viewport().set_input_as_handled()
			
			# Zoom in
			zoom += 0.1 * zoom
			clamp_zoom()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			get_viewport().set_input_as_handled()
			
			# Zoom out
			zoom -= 0.1 * zoom
			clamp_zoom()
	elif dragging and event is InputEventMouseMotion:
		get_viewport().set_input_as_handled()
		translate(-event.relative / zoom)
	elif event is InputEventAction:
		if event.action in ["zoom_in", "zoom_out"]:
			get_viewport().set_input_as_handled()
			
			if event.is_pressed():
				zooming = true
			else:
				zooming = false


func clamp_zoom():
	zoom = zoom.clamp(Vector2(0.1, 0.1), Vector2(2.0, 2.0))
