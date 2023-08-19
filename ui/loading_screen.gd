extends MarginContainer


@onready var Load = $Center/Load


func _ready():
	Assets.load_assets(get_tree())


func _process(_delta):
	Load.value = Assets.load_progress
	Load.max_value = Assets.asset_count
