extends Node3D

@onready var player = $Player
@onready var blockTerrain = $BlockTerrain
@onready var smoothTerrain = $SmoothTerrain

func _ready():
	load_world()

func load_world():
	if FileAccess.file_exists(Global.MapPath_block):
		blockTerrain.generator = load(Global.MapPath_block)
	if FileAccess.file_exists(Global.MapPath_smooth):
		smoothTerrain.generator = load(Global.MapPath_smooth)
	print(Global.MapPath_block,Global.MapPath_smooth,Global.player_pos)
	player.position = Global.player_pos
	
