extends Node

const CONFIG_PATH = "user://settings.cfg"
var DATA_PATH = "user://"
#Load world
var map_path = "null"
var player_pos = Vector3(0.0,0.0,0.0)

func _ready():
	load_config()
	window_min_limit()
func _process(delta):
	pass
	
#Limit min window size
func window_min_limit():
	DisplayServer.window_set_min_size(Vector2(500,500),0)
	
#Config
func save_config():
	var file = ConfigFile.new()
	file.set_value("game","language",TranslationServer.get_locale())
	file.set_value("game","data_path",DATA_PATH)
	file.set_value("video","fullscreen",DisplayServer.window_get_mode())
	file.set_value("audio","master",AudioServer.get_bus_volume_db(0))
	file.set_value("audio","bgm",AudioServer.get_bus_volume_db(1))
	file.set_value("audio","sfx",AudioServer.get_bus_volume_db(2))
	var err = file.save(CONFIG_PATH)
	if err != OK:	push_error("Fail to save config: %d" % err)
func load_config():
	var file = ConfigFile.new()
	var err = file.load(CONFIG_PATH)
	if err == OK:
		TranslationServer.set_locale(file.get_value("game","language",TranslationServer.get_locale()))
		DATA_PATH = file.get_value("game","data_path","user://")
		DisplayServer.window_set_mode(file.get_value("video","fullscreen",DisplayServer.window_get_mode()))
		AudioServer.set_bus_volume_db(0,file.get_value("audio","master",AudioServer.get_bus_volume_db(0)))
		AudioServer.set_bus_volume_db(1,file.get_value("audio","bgm",AudioServer.get_bus_volume_db(1)))
		AudioServer.set_bus_volume_db(2,file.get_value("audio","sfx",AudioServer.get_bus_volume_db(2)))
	else:			push_warning("Fail to load config: %d" % err)

#Load world
func load_world_info(m_name,player_pos_f = Vector3(0.0,0.0,0.0),m_path = "null"):
	player_pos = player_pos_f
	if m_path == "null" :	map_path = "res://Map/"+m_name+".tscn"
	else :					map_path = "res://Map/"+m_path+"/"+m_name+".tscn"
	get_tree().change_scene_to_file("res://Assets_Main/Happend.tscn")
	print(map_path,player_pos)
