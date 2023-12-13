extends Control

@onready var animation = $AnimationPlayer
@onready var title = $Panel_u/Title

@onready var inventory = preload("res://Assets_Main/Player_inventory.tres")

@onready var item_list = $ItemInv/ItemList
@onready var item_name = $ItemInv/Preview/Name
@onready var item_model = $ItemInv/Preview/View/Viewport/MeshView2d/Mesh

var current_inv = "Main"
func _ready():
	item_list.set_column_expand_ratio(0,9)
	item_list.set_column_expand_ratio(1,1)
	item_inv_update()
	#print(inventory.get_signal_list())
	inventory.on_items_changed.connect(item_inv_update)

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
	item_inv_update()

#Inventory
#Item
func item_inv_update():
	item_list.set_column_title(0,tr("list.name"))
	item_list.set_column_title(1,tr("list.count"))
	item_list.clear()
	var root = item_list.create_item()
	var item_group = item_list.create_item(root)
	item_group.set_text(0,tr("inventory.item.item"))
	var block_group = item_list.create_item(root)
	block_group.set_text(0,tr("inventory.item.block"))
	for i in inventory.itemStack:
		var group : Object
		match i.item.item_type:
			0:group = item_group
			1:group = block_group
		var subitem = item_list.create_item(group)
		subitem.set_icon(0,i.item.item_icon)
		subitem.set_text(0,i.item.item_name)
		subitem.set_icon_max_width(0,25)
		subitem.set_text(1,str(i.count))
		subitem.set_text_alignment(1,HORIZONTAL_ALIGNMENT_RIGHT)
		subitem.set_metadata(0,inventory.itemStack.find(i))

func _on_item_list_item_selected():
	var index = item_list.get_selected().get_metadata(0)
	if index != null:
		item_name.text = inventory.itemStack[index].item.item_name
		item_model.mesh = inventory.itemStack[index].item.item_model
