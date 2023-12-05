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
	launch_button.size.x = 200

func _process(delta):
	#Menu switch animate
	if current_menu == "title":
		main_menu.position.x = lerp( main_menu.position.x , 0.0 , 0.1 )
	else:
		main_menu.position.x = lerp( main_menu.position.x , -501.0 , 0.1 )
		if main_menu.position.x < -500.0 : main_menu.visible = false

	if current_menu in ["saves","beginning","online","options"]:
		back_button.position.y = lerp( back_button.position.y , get_viewport().size.y - 75.0 , 0.1 )
	else:
		back_button.position.y = lerp( back_button.position.y , get_viewport().size.y + 1.0 , 0.1 )
		if back_button.position.x > get_viewport().size.y : back_button.visible = false
		
	if current_menu in ["saves","beginning"]:
		saves_pan_d.position.y = lerp( saves_pan_d.position.y , get_viewport().size.y - 100.0 , 0.1 )
		background_color_fr = lerp(background_color_fr,0.75,0.1)
		background_color_fg = lerp(background_color_fg,0.9375,0.1)
	else:
		saves_pan_d.position.y = lerp( saves_pan_d.position.y , get_viewport().size.y + 1.0 , 0.1 )
		if saves_pan_d.position.y > get_viewport().size.y + 0.0 : saves_pan_d.visible = false
		background_color_fr = lerp(background_color_fr,0.0,0.1)
		
	if current_menu == "saves":
		saves_menu.position.x = lerp( saves_menu.position.x , (get_viewport().size.x - saves_menu.size.x)/2.0 , 0.1 )
		saves_pan_u.position.y = lerp( saves_pan_u.position.y , 0.0 , 0.1 )
	else:
		saves_menu.position.x = lerp( saves_menu.position.x ,get_viewport().size.x + 1.0 , 0.1 )
		if saves_menu.position.x > get_viewport().size.x : saves_menu.visible = false
		saves_pan_u.position.y = lerp( saves_pan_u.position.y , -101.0 , 0.1 )
		if saves_pan_u.position.y < -100.0 : saves_pan_u.visible = false
	
	if current_menu == "beginning":
		beginning_menu.position.x = lerp( beginning_menu.position.x , get_viewport().size.x -450.0 , 0.1 )
		beginning_title.position.y = lerp( beginning_title.position.y , 25.0 , 0.1 )
		beginning_description.position.x = lerp( beginning_description.position.x , 10.0 , 0.1 )
		beginning_arrow.position.x = lerp( beginning_arrow.position.x , get_viewport().size.x -470.0 , 0.1 )
		launch_button.position.y = lerp( launch_button.position.y , get_viewport().size.y - 150.0 , 0.1 )
	else:
		beginning_menu.position.x = lerp( beginning_menu.position.x , get_viewport().size.x +1.0 , 0.1 )
		if beginning_menu.position.x > get_viewport().size.x : beginning_menu.visible = false
		beginning_title.position.y = lerp( beginning_title.position.y , -201.0 , 0.1 )
		if beginning_title.position.y < -80 : beginning_title.visible = false
		beginning_description.position.x = lerp( beginning_description.position.x , - beginning_description.size.x - 1.0 , 0.1 )
		if beginning_description.position.x < - beginning_description.size.x : beginning_description.visible = false
		beginning_arrow.position.x = lerp( beginning_arrow.position.x , get_viewport().size.x +1.0 , 0.1 )
		if beginning_arrow.position.x > get_viewport().size.x : beginning_arrow.visible = false
		launch_button.position.y = lerp( launch_button.position.y , get_viewport().size.y +1.0 , 0.1 )
		if launch_button.position.y > get_viewport().size.y : launch_button.visible = false
	
	if current_menu == "online":
		online_menu.position.x = lerp( online_menu.position.x , (get_viewport().size.x - online_menu.size.x)/2.0 , 0.1 )
	else:
		online_menu.position.x = lerp( online_menu.position.x , get_viewport().size.x + 1.0 , 0.1 )
		if online_menu.position.x > get_viewport().size.x : online_menu.visible = false
		
	if current_menu == "options":
		options_menu.position.y = lerp( options_menu.position.y , (get_viewport().size.y - options_menu.size.y)/2.0 , 0.1 )
	else:
		options_menu.position.y = lerp( options_menu.position.y , get_viewport().size.y + 1.0 , 0.1 )
		if options_menu.position.y > get_viewport().size.y : options_menu.visible = false
		
	if current_menu == "exit":
		exit_menu.position.x = lerp( exit_menu.position.x , (get_viewport().size.x - exit_menu.size.x)/2.0 , 0.1 )
		background_color = lerp(background_color,0.0,0.1)
		background_color_fg = lerp(background_color_fg,0.0,0.1)
	else:
		exit_menu.position.x = lerp( exit_menu.position.x ,get_viewport().size.x + 1.0 , 0.1 )
		if exit_menu.position.x > get_viewport().size.x : exit_menu.visible = false
		background_color = lerp(background_color,1.0,0.1)
	
	#Change width
	saves_pan_u.size.x = get_viewport().size.x
	saves_pan_d.size.x = get_viewport().size.x
	beginning_description.size.x = get_viewport().size.x - 500.0
	beginning_description.size.y = get_viewport().size.y - 250.0
	#Set Background color
	if current_menu not in ["saves","beginning","exit"]:
		background_color_fg = lerp(background_color_fg,0.75,0.1)
	background.texture.gradient.set_color( 0 , Color(background_color,background_color,background_color) )
	background.texture.gradient.set_color( 1 , Color(background_color_fr,background_color_fg,1.0) )
	#Follow mouse
	background.material.set_shader_parameter("mouse",get_global_mouse_position()*0.0005)
	
#Start & Options
func _on_start_button_pressed():
	if current_menu == "title":
		current_menu = "beginning"
		back_button.visible = true
		saves_pan_d.visible = true
		beginning_menu.visible = true
		beginning_title.visible = true
		beginning_description.visible = true
		beginning_arrow.visible = true
		launch_button.visible = true
		beginning_tutorial.grab_focus()
func _on_continue_button_pressed():
	if current_menu == "title":
		current_menu = "saves"
		back_button.visible = true
		saves_pan_d.visible = true
		saves_menu.visible = true
		saves_pan_u.visible = true
		saves_s0.grab_focus()
func _on_online_button_pressed():
	if current_menu == "title":
		current_menu = "online"
		back_button.visible = true
		online_menu.visible = true
func _on_options_button_pressed():
	if current_menu == "title":
		current_menu = "options"
		back_button.visible = true
		options_menu.visible = true
		options_menu.tab_focus()
func _on_back_button_pressed():
	if current_menu != "title":
		current_menu = "title"
		main_menu.visible = true
		main_menu_start.grab_focus()
#Exit
func _on_exit_button_pressed():
	if current_menu == "title":
		current_menu = "exit"
		exit_menu.visible = true
		exit_menu_cancel.grab_focus()
func _on_cancel_button_pressed():
	if current_menu == "exit":
		current_menu = "title"
		main_menu.visible = true
		main_menu_start.grab_focus()
func _on_confirm_button_pressed():
	if current_menu == "exit":
		get_tree().quit()

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
