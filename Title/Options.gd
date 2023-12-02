extends TabContainer

@onready var GameLanguage = $"#options_game#/GameSetting/HSplit/Button/language_button"
@onready var Fullscreen = $"#options_video#/VideoSetting/HSplit/Button/fullscreen_button"
@onready var MasterVolume = $"#options_audio#/AudioSetting/HSpilt/Button/master_button"
@onready var BgmVolume = $"#options_audio#/AudioSetting/HSpilt/Button/bgm_button"
@onready var SfxVolume = $"#options_audio#/AudioSetting/HSpilt/Button/sfx_button"

func _ready():
	#Language
	match TranslationServer.get_locale():
		"en_US":	GameLanguage.set_indexed("selected",0)
		"zh_CN":	GameLanguage.set_indexed("selected",1)
	#Fullscreen
	match DisplayServer.window_get_mode():
		0:	Fullscreen.set_pressed_no_signal(false)
		3:	Fullscreen.set_pressed_no_signal(true)
	#Volume
	MasterVolume.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	MasterVolume.set_tooltip_text( str(db_to_linear(AudioServer.get_bus_volume_db(0))*100) + "%")
	BgmVolume.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	BgmVolume.set_tooltip_text( str(db_to_linear(AudioServer.get_bus_volume_db(1))*100) + "%")
	SfxVolume.value = db_to_linear(AudioServer.get_bus_volume_db(2))
	SfxVolume.set_tooltip_text( str(db_to_linear(AudioServer.get_bus_volume_db(2))*100) + "%")

func _process(delta):
	if get_parent().current_menu == "options":
		if Input.is_action_just_pressed("tab_right"):
			if current_tab == get_tab_count()-1 :	current_tab = 0
			else :									current_tab += 1
			tab_focus()
		if Input.is_action_just_pressed("tab_left"):
			if current_tab == 0 :	current_tab = get_tab_count()-1
			else :					current_tab -= 1
			tab_focus()
	
	#Fit the window size
	if get_viewport().size.x < 1600 :	size.x = get_viewport().size.x * 0.75
	else :								size.x = 1200
	if get_viewport().size.y < 900 :	size.y = get_viewport().size.y * 0.8
	else :								size.y = 750
	position.x = ( get_viewport().size.x - size.x ) / 2

#Language
func _on_option_button_item_selected(index):
	match index:
		0:	TranslationServer.set_locale("en_US")
		1:	TranslationServer.set_locale("zh_CN")
	print(TranslationServer.get_locale())
	Global.save_config()
	Global.window_min_limit()
	
#Fullscreen
func _on_fullscreen_button_toggled(toggled_on):
	if toggled_on == true :	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else :					DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	print(DisplayServer.window_get_mode())
	Global.save_config()
#Scale
func _on_scale_button_value_changed(value):
	ProjectSettings.set_setting("display/window/stretch/scale",value)
	
#Master volume
func _on_master_button_value_changed(value):
	AudioServer.set_bus_volume_db(0,linear_to_db(value))
	MasterVolume.set_tooltip_text( str(value*100) + "%")
	Global.save_config()
#Bgm volume
func _on_bgm_button_value_changed(value):
	AudioServer.set_bus_volume_db(1,linear_to_db(value))
	BgmVolume.set_tooltip_text( str(value*100) + "%")
	Global.save_config()
#Sfx volume
func _on_sfx_button_value_changed(value):
	AudioServer.set_bus_volume_db(2,linear_to_db(value))
	SfxVolume.set_tooltip_text( str(value*100) + "%")
	Global.save_config()

func tab_focus():
	match current_tab:
		0:GameLanguage.grab_focus()
		1:Fullscreen.grab_focus()
		2:MasterVolume.grab_focus()
		3:pass
