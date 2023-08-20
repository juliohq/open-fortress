class_name Assets


static var loaders: Array[GDScript]

## How many assets have been loaded.
static var load_progress := 0
## How many assets there are to be loaded.
static var asset_count := 0

static var music := []
static var sfx := []
static var speech := []
static var sprites := []


static func _static_init():
	register_loader(MusicLoader)
	register_loader(SFXLoader)
	register_loader(SpeechLoader)
	register_loader(SpriteLoader)


static func register_loader(loader: GDScript):
	assert(not loader in loaders)
	loaders.append(loader)


static func unload_assets():
	for ref in [
		music,
	]:
		ref.clear()


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
			
			while ResourceLoader.load_threaded_get_status(file) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				await tree.process_frame
			
			assert(ResourceLoader.load_threaded_get_status(file) == ResourceLoader.THREAD_LOAD_LOADED)
			loader._load_asset(ResourceLoader.load_threaded_get(file))
			Events.asset_loaded.emit(file)
			load_progress += 1


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
	
	static func _load_asset(_asset: Resource):
		pass


class MusicLoader extends AssetLoader:
	static func _path() -> String:
		return "res://assets/music/"
	
	static func _extensions() -> PackedStringArray:
		return ["ogg"]
	
	static func _load_asset(asset: Resource):
		Assets.music.append(asset)


class SFXLoader extends AssetLoader:
	static func _path() -> String:
		return "res://assets/sfx/"
	
	static func _extensions() -> PackedStringArray:
		return ["wav"]
	
	static func _load_asset(asset: Resource):
		Assets.sfx.append(asset)


class SpeechLoader extends AssetLoader:
	static func _path() -> String:
		return "res://assets/sfx/speech/"
	
	static func _extensions() -> PackedStringArray:
		return ["wav"]
	
	static func _load_asset(asset: Resource):
		Assets.speech.append(asset)


class SpriteLoader extends AssetLoader:
	static func _path() -> String:
		return "res://assets/sprites/"
	
	static func _extensions() -> PackedStringArray:
		return ["png"]
	
	static func _recursive() -> bool:
		return true
	
	static func _load_asset(asset: Resource):
		Assets.sprites.append(asset)
