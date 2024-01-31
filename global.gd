extends Node

const CONFIG_PATH = "user://settings.cfg"
var DATA_PATH : String = "user://"
var SAVE_PATH : String = "null"
#Voxel usability
var Voxel_useability : bool = false
#Load world
var MapPath_block = "null"
var MapPath_smooth = "null"
var player_pos = Vector3(0.0,0.0,0.0)
#In game control
var mouse_sens = 0.4

func _ready():
	load_config()
	window_min_limit()
	if ClassDB.class_exists("VoxelEngine") :	Voxel_useability = true
	
#Limit min window size
func window_min_limit():
	DisplayServer.window_set_min_size(Vector2(500,500),0)
	
#Config
func save_config():
	var file = ConfigFile.new()
	file.set_value("game","language",TranslationServer.get_locale())
	file.set_value("game","data_path",DATA_PATH)
	file.set_value("video","fullscreen",DisplayServer.window_get_mode())
	file.set_value("video","scale",get_window().content_scale_factor)
	file.set_value("audio","master",AudioServer.get_bus_volume_db(0))
	file.set_value("audio","bgm",AudioServer.get_bus_volume_db(1))
	file.set_value("audio","sfx",AudioServer.get_bus_volume_db(2))
	file.set_value("control","mouse_sens",mouse_sens)
	var err = file.save(CONFIG_PATH)
	if err != OK:	push_error("Fail to save config: %d" % err)
func load_config():
	var file = ConfigFile.new()
	var err = file.load(CONFIG_PATH)
	if err == OK:
		TranslationServer.set_locale(file.get_value("game","language",TranslationServer.get_locale()))
		DATA_PATH = file.get_value("game","data_path","user://")
		DisplayServer.window_set_mode(file.get_value("video","fullscreen",DisplayServer.window_get_mode()))
		get_window().content_scale_factor = file.get_value("video","scale",1)
		AudioServer.set_bus_volume_db(0,file.get_value("audio","master",AudioServer.get_bus_volume_db(0)))
		AudioServer.set_bus_volume_db(1,file.get_value("audio","bgm",AudioServer.get_bus_volume_db(1)))
		AudioServer.set_bus_volume_db(2,file.get_value("audio","sfx",AudioServer.get_bus_volume_db(2)))
		mouse_sens = file.get_value("control","mouse_sens",0.4)
	else:			push_warning("Fail to load config: %d" % err)

#Back to title
func back_to_title():
	get_tree().change_scene_to_file("res://Title/TitleScene.tscn")
#Load world
func load_world_info(m_name,player_pos_f = Vector3(0.0,0.0,0.0)):
	player_pos = player_pos_f
	MapPath_block = "res://Map/"+m_name+"_generator_block.tres"
	get_tree().change_scene_to_file("res://Assets_Main/Happend.tscn")
	MapPath_smooth = "res://Map/"+m_name+"_generator_smooth.tres"
	if FileAccess.file_exists(MapPath_smooth):
		get_tree().change_scene_to_file("res://Assets_Main/Happend.tscn")

#Current save
func current_save_path():
	if SAVE_PATH != "null" :	return SAVE_PATH
	else :
		DirAccess.open(DATA_PATH).make_dir_recursive(DATA_PATH + "/TEMP/")
		SAVE_PATH = DATA_PATH + "/TEMP/"
		return str(DATA_PATH + "/TEMP/")
