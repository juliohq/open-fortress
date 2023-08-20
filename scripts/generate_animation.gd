@tool
extends EditorScript


func _run():
	unit_animations("res://assets/sprites/units/archer")


static func unit_animations(root: String):
	var sprites = SpriteFrames.new()
	
	for animation in DirAccess.get_directories_at(root):
		var animation_path = root.path_join(animation)
		
		for direction in ["left", "up_left", "down_left", "right", "up_right", "down_right", "up", "down"]:
			var anim_name = "%s_%s" % [animation.to_upper(), direction.to_upper()]
			sprites.add_animation(anim_name)
			
			var direction_path = animation_path.path_join(direction)
			
			for file in DirAccess.get_files_at(direction_path):
				if file.get_extension() == "png":
					sprites.add_frame(anim_name, load(direction_path.path_join(file)))
	
	sprites.remove_animation("default")
	ResourceSaver.save(sprites, root.path_join(root.simplify_path().split("/")[-1]) + ".tres")
