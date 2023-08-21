class_name Assets


static var loaders: Array[GDScript]

## How many assets have been loaded.
static var load_progress := 0
## How many assets there are to be loaded.
static var asset_count := 0
## Whether assets are loaded.
static var is_loaded := false

static var music := []
static var sfx := []
static var speech := []
static var sprites := []
static var animations := []
static var units := []


static func _static_init():
	register_loader(MusicLoader)
	register_loader(SFXLoader)
	register_loader(SpeechLoader)
	register_loader(SpriteLoader)
	register_loader(AnimationLoader)
	register_loader(UnitLoader)


static func register_loader(loader: GDScript):
	assert(not loader in loaders)
	loaders.append(loader)


static func unload_assets():
	for loader in loaders:
		loader._unload_assets()
	is_loaded = false


static func load_assets(tree: SceneTree):
	unload_assets()
	
	# Count assets to be loaded
	for loader in loaders:
		var path: String = loader._path()
		var extensions: PackedStringArray = loader._extensions()
		asset_count += assets_in(path, extensions, loader._recursive()).size()
	
	# Load assets
	for loader in loaders:
		var path: String = loader._path()
		var extensions: PackedStringArray = loader._extensions()
		var assets = assets_in(path, extensions, loader._recursive())
		assert(assets)
		
		for file in assets:
			var err = ResourceLoader.load_threaded_request(file)
			assert(err == OK)
			
			var ticks = 0
			
			while ResourceLoader.load_threaded_get_status(file) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				if ticks % 1_000 == 999:
					await tree.process_frame
					ticks = 0
				else:
					ticks += 1
			
			assert(ResourceLoader.load_threaded_get_status(file) == ResourceLoader.THREAD_LOAD_LOADED)
			var asset = ResourceLoader.load_threaded_get(file)
			if loader._should_load(asset):
				loader._load_asset(asset)
				Events.asset_loaded.emit(file)
			load_progress += 1
	
	is_loaded = true


static func assets_in(path: String, extensions: PackedStringArray, recursive: bool = false) -> PackedStringArray:
	var array = []
	
	if recursive:
		for directory in DirAccess.get_directories_at(path):
			var next = path.path_join(directory)
			array.append_array(assets_in(next, extensions, true))
	
	for file in DirAccess.get_files_at(path):
		if file.get_extension() in extensions:
			array.append(path.path_join(file))
	
	return array


class AssetLoader:
	static func _path() -> String:
		return ""
	
	static func _extensions() -> PackedStringArray:
		return []
	
	static func _recursive() -> bool:
		return false
	
	static func _should_load(_asset: Resource) -> bool:
		return true
	
	static func _load_asset(_asset: Resource):
		pass
	
	static func _unload_assets():
		pass


class MusicLoader extends AssetLoader:
	static func _path() -> String:
		return "res://assets/music/"
	
	static func _extensions() -> PackedStringArray:
		return ["ogg"]
	
	static func _load_asset(asset: Resource):
		Assets.music.append(asset)
	
	static func _unload_assets():
		Assets.music.clear()


class SFXLoader extends AssetLoader:
	static func _path() -> String:
		return "res://assets/sfx/"
	
	static func _extensions() -> PackedStringArray:
		return ["wav"]
	
	static func _load_asset(asset: Resource):
		Assets.sfx.append(asset)
	
	static func _unload_assets():
		Assets.sfx.clear()


class SpeechLoader extends AssetLoader:
	static func _path() -> String:
		return "res://assets/sfx/speech/"
	
	static func _extensions() -> PackedStringArray:
		return ["wav"]
	
	static func _load_asset(asset: Resource):
		Assets.speech.append(asset)
	
	static func _unload_assets():
		Assets.speech.clear()


class SpriteLoader extends AssetLoader:
	static func _path() -> String:
		return "res://assets/sprites/"
	
	static func _extensions() -> PackedStringArray:
		return ["png"]
	
	static func _recursive() -> bool:
		return true
	
	static func _load_asset(asset: Resource):
		Assets.sprites.append(asset)
	
	static func _unload_assets():
		Assets.sprites.clear()


class AnimationLoader extends AssetLoader:
	static func _path() -> String:
		return "res://units/"
	
	static func _extensions() -> PackedStringArray:
		return ["tres"]
	
	static func _should_load(asset: Resource) -> bool:
		return asset is SpriteFrames
	
	static func _load_asset(asset: Resource):
		Assets.units.append(asset)
	
	static func _unload_assets():
		Assets.units.clear()


class UnitLoader extends AssetLoader:
	static func _path() -> String:
		return "res://units/"
	
	static func _extensions() -> PackedStringArray:
		return ["tscn", "remap"]
	
	static func _should_load(asset: Resource) -> bool:
		if not asset is PackedScene:
			return false
		
		var unit = asset.instantiate()
		var is_valid = unit is Unit
		unit.free()
		return is_valid
	
	static func _load_asset(asset: Resource):
		Assets.units.append(asset)
	
	static func _unload_assets():
		Assets.units.clear()
