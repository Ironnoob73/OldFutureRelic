extends Node3D

@onready var player = $Player
func _ready():
	load_world()

func load_world():
	get_parent().add_child(load(Global.map_path).instantiate())
	print(Global.map_path,Global.player_pos)
	player.position = Global.player_pos
