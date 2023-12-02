extends TabContainer

@onready var GameLanguage = $"#options_game#/Button/Language_scroll"
# Called when the node enters the scene tree for the first time.
func _ready():
	print(TranslationServer.get_locale())
	match TranslationServer.get_locale():
		"en_US":	GameLanguage.set_indexed("selected",0)
		"zh_CN":	GameLanguage.set_indexed("selected",1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
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

func _on_option_button_item_selected(index):
	match index:
		0:	TranslationServer.set_locale("en_US")
		1:	TranslationServer.set_locale("zh_CN")
	print(TranslationServer.get_locale())
	Global.save_config()
	Global.window_min_limit()

func tab_focus():
	match current_tab:
		0:GameLanguage.grab_focus()
		1:pass
		2:pass
		3:pass
