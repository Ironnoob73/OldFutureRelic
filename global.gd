extends Node

const CONFIG_PATH = "user://settings.cfg"
func _ready():
	window_min_limit()
	load_config()
func _process(delta):
	pass
	
#Limit min window size
func window_min_limit():
	DisplayServer.window_set_min_size(Vector2(500,500),0)
	
#Config
func save_config():
	var file = ConfigFile.new()
	file.set_value("game","language",TranslationServer.get_locale())
	var err = file.save(CONFIG_PATH)
	if err != OK:	push_error("Fail to save config: %d" % err)
func load_config():
	var file = ConfigFile.new()
	var err = file.load(CONFIG_PATH)
	if err == OK:	TranslationServer.set_locale(file.get_value("game","language",TranslationServer.get_locale()))
	else:			push_warning("Fail to load config: %d" % err)
