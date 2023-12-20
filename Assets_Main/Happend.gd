extends Node3D

@onready var player = $Player
@onready var blockTerrain = $BlockTerrain

func _ready():
	load_world()

func load_world():
	blockTerrain.generator = load(Global.MapPath_block)
	print(Global.MapPath_block,Global.player_pos)
	player.position = Global.player_pos
	
