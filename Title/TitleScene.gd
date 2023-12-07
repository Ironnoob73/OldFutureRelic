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
@onready var beginning_tutorial = $Beginning/DemoScene
@onready var saves_s0 = $Saves/VBox/Slot0
@onready var saves_pan_u = $Save_pan_u
@onready var saves_pan_d = $Save_pan_d
@onready var main_menu_start = $Main/ScrollContainer/MainMenu/Start
@onready var exit_menu_cancel = $Exit/VSplitContainer/CancelButton

@onready var background = $Background
@onready var click_sound = $ClickSound
@onready var main_player = $MainPlayer
@onready var sub_player = $SubPlayer

@onready var sub_garb_focus = {
	"Start": $Beginning/DemoScene.grab_focus,
	"Continue": $Saves/VBox/Slot0.grab_focus,
	"Online": func(): pass,
	"Options": $Options.tab_focus,
	"Exit": $Exit/VSplitContainer/CancelButton.grab_focus
}

var current_menu = "null"

func _ready():
	current_menu = "Title"
	main_menu_start.grab_focus()
	button_sound(self)
	launch_button.size.x = 200
	for button in $Main/ScrollContainer/MainMenu.get_children():
		button.pressed.connect(sub_menu_enter.bind(button.name), CONNECT_REFERENCE_COUNTED)

func _process(delta):
	#Follow mouse
	background.material.set_shader_parameter("mouse",get_global_mouse_position()*0.0005)

# 子窗口进入
func sub_menu_enter(menu_name):
	if current_menu == "Title" and not sub_player.is_playing():
		$MainPlayer.play_backwards("Title")
		$SubPlayer.play(menu_name)
		current_menu = menu_name
		sub_garb_focus[current_menu].call()

# 子窗口退出
func sub_menu_exit():
	if current_menu != "Title" and not sub_player.is_playing():
		$MainPlayer.play("Title")
		$SubPlayer.play_backwards(current_menu)
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
