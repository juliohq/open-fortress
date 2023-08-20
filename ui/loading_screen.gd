extends MarginContainer


var scene: String

@onready var Asset = %Asset
@onready var Load = %Load


func _ready():
	assert(ResourceLoader.exists(scene))
	Events.asset_loaded.connect(show_asset)
	Assets.load_assets(get_tree())
	
	while not Assets.is_loaded:
		await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file(scene)


func _process(_delta):
	Load.value = Assets.load_progress
	Load.max_value = Assets.asset_count


func show_asset(path: String):
	Asset.text = path
