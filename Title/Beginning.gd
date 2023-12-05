extends VBoxContainer

@export var current_index = 0
signal index_changed
# Called when the node enters the scene tree for the first time.
func _ready():
	button_selected(self)

func _process(delta):
	position.y = lerp( position.y , 250.0 - current_index * 65.0 , 0.1 )
#Change button
func _input(event):
	if get_parent().current_menu == "beginning":
		if Input.is_action_just_pressed("tab_right"):
			if current_index == get_child_count() -1 :	current_index = 1
			else :										current_index += 1
			get_child(current_index).grab_focus()
		if Input.is_action_just_pressed("tab_left"):
			if current_index == 1 :	current_index = get_child_count()-1
			else :					current_index -= 1
			get_child(current_index).grab_focus()
			
func button_selected(node):
	for child in node.get_children():
		if child is Button :	child.focus_entered.connect(set_index.bind(child.get_index()))
func set_index(index):
	current_index = index
	emit_signal("index_changed")

