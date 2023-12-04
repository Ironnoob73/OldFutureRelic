extends Control

@onready var main_menu = $Main
@onready var saves_menu = $Saves
@onready var online_menu = $Online
@onready var options_menu = $Options
@onready var exit_menu = $Exit
@onready var back_button = $BackButton

@onready var saves_s0 = $Saves/VBox/Slot0
@onready var saves_pan_u = $Save_pan_u
@onready var saves_pan_d = $Save_pan_d
@onready var main_menu_start = $Main/ScrollContainer/MainMenu/StartButton
@onready var exit_menu_cancel = $Exit/VSplitContainer/CancelButton

@onready var background = $Background
@onready var click_sound = $ClickSound

var current_menu = "title"

var background_color = 1.0
var background_color_fr = 0.0
var background_color_fg = 0.75

@onready var dir_x = get_viewport().size.x
@onready var dir_y = get_viewport().size.y

func _ready():
	main_menu_start.grab_focus()
	button_sound(self)

func _process(delta):
	#Menu switch animate
	if current_menu == "title":
		main_menu.visible = true
		main_menu.position.x = lerp( main_menu.position.x , 0.0 , 0.1 )
	else:
		main_menu.position.x = lerp( main_menu.position.x , -501.0 , 0.1 )
		if main_menu.position.x < -500.0 : main_menu.visible = false

	if current_menu == "saves" or current_menu == "online" or current_menu == "options":
		back_button.visible = true
		back_button.position.y = lerp( back_button.position.y , get_viewport().size.y - 75.0 , 0.1 )
	else:
		back_button.position.y = lerp( back_button.position.y , get_viewport().size.y + 1.0 , 0.1 )
		if back_button.position.x > get_viewport().size.y : back_button.visible = false
		
	if current_menu == "saves":
		saves_menu.visible = true
		saves_pan_u.visible = true
		saves_pan_d.visible = true
		saves_menu.position.x = lerp( saves_menu.position.x , (get_viewport().size.x - saves_menu.size.x)/2.0 , 0.1 )
		saves_pan_u.position.y = lerp( saves_pan_u.position.y , 0.0 , 0.1 )
		saves_pan_d.position.y = lerp( saves_pan_d.position.y , get_viewport().size.y - 100.0 , 0.1 )
		background_color_fr = lerp(background_color_fr,0.5,0.1)
		background_color_fg = lerp(background_color_fg,0.875,0.1)
	else:
		saves_menu.position.x = lerp( saves_menu.position.x ,get_viewport().size.x + 1.0 , 0.1 )
		if saves_menu.position.x > get_viewport().size.x : saves_menu.visible = false
		saves_pan_u.position.y = lerp( saves_pan_u.position.y , -101.0 , 0.1 )
		if saves_pan_u.position.y < -100.0 : saves_pan_u.visible = false
		saves_pan_d.position.y = lerp( saves_pan_d.position.y , get_viewport().size.y + 1.0 , 0.1 )
		if saves_pan_d.position.y > get_viewport().size.y + 0.0 : saves_pan_d.visible = false
		background_color_fr = lerp(background_color_fr,0.0,0.1)
	
	if current_menu == "online":
		online_menu.visible = true
		online_menu.position.x = lerp( online_menu.position.x , (get_viewport().size.x - online_menu.size.x)/2.0 , 0.1 )
	else:
		online_menu.position.x = lerp( online_menu.position.x , get_viewport().size.x + 1.0 , 0.1 )
		if online_menu.position.x > get_viewport().size.x : online_menu.visible = false
		
	if current_menu == "options":
		options_menu.visible = true
		options_menu.position.y = lerp( options_menu.position.y , (get_viewport().size.y - options_menu.size.y)/2.0 , 0.1 )
	else:
		options_menu.position.y = lerp( options_menu.position.y , get_viewport().size.y + 1.0 , 0.1 )
		if options_menu.position.y > get_viewport().size.y : options_menu.visible = false
		
	if current_menu == "exit":
		exit_menu.visible = true
		exit_menu.position.x = lerp( exit_menu.position.x , (get_viewport().size.x - exit_menu.size.x)/2.0 , 0.1 )
		background_color = lerp(background_color,0.0,0.1)
		background_color_fg = lerp(background_color_fg,0.0,0.1)
	else:
		exit_menu.position.x = lerp( exit_menu.position.x ,get_viewport().size.x + 1.0 , 0.1 )
		if exit_menu.position.x > get_viewport().size.x : exit_menu.visible = false
		background_color = lerp(background_color,1.0,0.1)
	
	#Chage width
	saves_pan_u.size.x = get_viewport().size.x
	saves_pan_d.size.x = get_viewport().size.x
	#Set Background color & follow mouse
	if current_menu != "saves" and current_menu != "exit":
		background_color_fg = lerp(background_color_fg,0.75,0.1)
	background.texture.gradient.set_color( 0 , Color(background_color,background_color,background_color) )
	background.texture.gradient.set_color( 1 , Color(background_color_fr,background_color_fg,1.0) )
	background.material.set_shader_parameter("mouse",get_global_mouse_position()*0.0005)
	
#Start & Options
func _on_start_button_pressed():
	if current_menu == "title":
		current_menu = "saves"
		saves_s0.grab_focus()
func _on_continue_button_pressed():
	if current_menu == "title":
		current_menu = "saves"
		saves_s0.grab_focus()
func _on_online_button_pressed():
	if current_menu == "title":
		current_menu = "online"
func _on_options_button_pressed():
	if current_menu == "title":
		current_menu = "options"
		options_menu.tab_focus()
func _on_back_button_pressed():
	if current_menu != "title":
		current_menu = "title"
		main_menu_start.grab_focus()
#Exit
func _on_exit_button_pressed():
	if current_menu == "title":
		current_menu = "exit"
		exit_menu_cancel.grab_focus()
func _on_cancel_button_pressed():
	if current_menu == "exit":
		current_menu = "title"
		main_menu_start.grab_focus()
func _on_confirm_button_pressed():
	if current_menu == "exit":
		get_tree().quit()

#Button sound
func button_sound(node):
	for child in node.get_children():
		if child is Button :	child.button_down.connect(func():click_sound.play())
		else :					button_sound(child)
