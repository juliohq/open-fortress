extends MarginContainer


@onready var Asset = $Center/Vertical/Asset
@onready var Load = $Center/Vertical/Load


func _ready():
	Events.asset_loaded.connect(show_asset)
	Assets.load_assets(get_tree())


func _process(_delta):
	Load.value = Assets.load_progress
	Load.max_value = Assets.asset_count


func show_asset(path: String):
	Asset.text = path
