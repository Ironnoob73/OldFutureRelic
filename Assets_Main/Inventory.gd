extends Control

@onready var animation = $AnimationPlayer
@onready var title = $Panel_u/Title

@onready var item_list = $ItemInv/List
@onready var item_name = $ItemInv/Preview/Name

var current_inv = "Main"
func _ready():
	pass # Replace with function body.

func open_inventory():
	animation.play("Show")
func close_inventory():
	title.text = "inventory.title"
	match current_inv:
		"Main" :	animation.play_backwards("Show")
		"Item" :
			current_inv = "Main"
			animation.play_backwards("Item")

func _on_back_button_pressed():
	if current_inv == "Main":
		get_parent().current_menu = "HUD"
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	close_inventory()
func _on_item_button_pressed():
	if current_inv == "Main":
		title.text = "inventory.item.t"
		animation.play("Item")
		current_inv = "Item"

#Inventory
func _on_list_item_selected(index):
	item_name.text = item_list.get_item_text(index)
