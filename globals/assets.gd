class_name Assets


const MUSIC_PATH := "res://assets/music/"

static var load_progress := 0
static var asset_count := 0

static var music := []


static func unload_assets():
	for ref in [
		music,
	]:
		ref.clear()


static func load_assets(tree: SceneTree):
	unload_assets()
	
	# Count assets to be loaded
	for count in [
		assets_in(MUSIC_PATH, ["ogg"]).size(),
	]:
		asset_count += count
	
	# Load music
	for path in assets_in(MUSIC_PATH, ["ogg"]):
		var err = ResourceLoader.load_threaded_request(path)
		assert(err == OK)
		
		while ResourceLoader.load_threaded_get_status(path) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			await tree.process_frame
		
		assert(ResourceLoader.load_threaded_get_status(path) == ResourceLoader.THREAD_LOAD_LOADED)
		music.append(ResourceLoader.load_threaded_get(path))
		load_progress += 1


static func assets_in(path: String, extensions: PackedStringArray) -> PackedStringArray:
	var array = []
	for file in DirAccess.get_files_at(path):
		if file.get_extension() in extensions:
			array.append(path.path_join(file))
	return array
