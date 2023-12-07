extends Node3D

@onready var player = $Player
func _ready():
	load_world()

func _process(delta):
	pass

func load_world():
	get_parent().add_child(load(Global.map_path).instantiate())
	print(Global.map_path)
	player.position = Global.player_pos
