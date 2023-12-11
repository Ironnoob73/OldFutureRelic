extends Control

@onready var main_menu = $Main
@onready var saves_menu = $Saves
@onready var beginning_menu = $Beginning
@onready var online_menu = $Online
@onready var options_menu = $Options
@onready var exit_menu = $Exit

@onready var launch_button = $LaunchButton
@onready var back_button = $BackButton

@onready var beginning_title = $Beginning_title
@onready var beginning_subtitle = $Beginning_title/subtitle_background/subtitle
@onready var beginning_description = $Beginning_description
@onready var beginning_description_text = $Beginning_description/description/description_text
@onready var beginning_arrow = $Beginning_arrow
@onready var beginning_tutorial = $Beginning/Tutorial
@onready var saves_s0 = $Saves/List
@onready var saves_pan_u = $Save_pan_u
@onready var saves_pan_d = $Save_pan_d
@onready var main_menu_button = $Main/ScrollContainer/MainMenu
@onready var main_menu_start = $Main/ScrollContainer/MainMenu/Start
@onready var exit_menu_cancel = $Exit/VSplitContainer/CancelButton

@onready var background = $Background
@onready var click_sound = $ClickSound
@onready var main_player = $MainPlayer
@onready var sub_player = $SubPlayer

@onready var sub_garb_focus = {
	"Start":	beginning_tutorial.grab_focus,
	"Continue":	saves_s0.grab_focus,
	"Online":	func(): pass,
	"Options":	options_menu.tab_focus,
	"Exit":		exit_menu_cancel.grab_focus
}

var current_menu = "null"

func _ready():
	current_menu = "Title"
	main_menu_start.grab_focus()
	button_sound(self)
	launch_button.size.x = 200
	#Mainmenu behavior
	for button in main_menu_button.get_children():
		button.pressed.connect(sub_menu_enter.bind(button.name), CONNECT_REFERENCE_COUNTED)

func _process(_delta):
	#Follow mouse
	background.material.set_shader_parameter("mouse",get_global_mouse_position()*0.0005)

# 子窗口进入
func sub_menu_enter(menu_name):
	if current_menu == "Title" and not sub_player.is_playing():
		main_player.play_backwards("Title")
		sub_player.play(menu_name)
		current_menu = menu_name
		print(current_menu)
		sub_garb_focus[current_menu].call()

# 子窗口退出
func sub_menu_exit():
	if current_menu != "Title" and not sub_player.is_playing():
		main_player.play("Title")
		sub_player.play_backwards(current_menu)
		current_menu = "Title"
		main_menu_start.grab_focus()

# 退出游戏
func exit_game():
	if current_menu == "Exit":
		get_tree().quit()
#
#Button sound
func button_sound(node):
	for child in node.get_children():
		if child is Button :	child.button_down.connect(click_sound.play)
		else :					button_sound(child)

#Change beginning discription
func _on_beginning_index_changed():
	#Set Beginning subtitle text & Beginning description
	if beginning_menu.get_child(beginning_menu.current_index) is Button:
		beginning_subtitle.text = beginning_menu.get_child(beginning_menu.current_index).text
		beginning_description_text.text = "{beginning_description." + str(beginning_menu.current_index) + ":[color=red]TRANSLATION NOT FOUND[/color]}"
	#Disable Launch
	if beginning_menu.current_index not in [1,3] :	launch_button.disabled = true
	else:											launch_button.disabled = false
#Refresh saves
func _on_continue_pressed():
	saves_menu.refresh()
	#button_sound(self)
func _on_refresh_button_pressed():
	saves_menu.refresh()
	#button_sound(self)

#Launch game
func _on_launch_button_pressed():
	Global.load_world_info(beginning_menu.get_child(beginning_menu.current_index).name,Vector3(0.0,100.0,0.0))
