extends Control

@onready var cursor = $Setting/Cursor

func _ready():
	pass
func _process(delta):
	cursor.position = get_global_mouse_position()

func _on_left_pressed():
	get_parent().get_parent().switch_block(true)
func _on_right_pressed():
	get_parent().get_parent().switch_block(false)
