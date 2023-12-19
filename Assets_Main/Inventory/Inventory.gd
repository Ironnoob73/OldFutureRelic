extends Control

@onready var animation = $AnimationPlayer
@onready var title = $Panel_u/Title

@onready var inventory = preload("res://Assets_Main/Inventory/Player_inventory.tres")

@onready var item_list = $ItemInv/ItemList
@onready var item_name = $ItemInv/Preview/Name
@onready var item_model = $ItemInv/Preview/View/Viewport/MeshView2d/Mesh
@onready var item_discription = $ItemInv/Preview/Discription

@onready var equipment_list = $EquipmentInv/EquipmentList
@onready var equipment_name = $EquipmentInv/Preview/Container/VBoxContainer/Name
@onready var equipment_subname = $EquipmentInv/Preview/Container/VBoxContainer/Subname
@onready var equipment_info = $EquipmentInv/Preview/Container/VBoxContainer/Info
@onready var equipment_model = $EquipmentInv/Preview/View/Viewport/MeshView2d/Mesh
@onready var equipment_discription = $EquipmentInv/Preview/Discription
@onready var equipped_star = preload("res://Resources/Image/blue_star.svg")

var current_inv = "Main"

func _ready():
	item_list.set_column_expand_ratio(0,7)
	item_list.set_column_expand_ratio(1,1)
	equipment_list.set_column_expand_ratio(0,7)
	equipment_list.set_column_expand_ratio(1,1)
	item_inv_update()
	equipment_inv_update()
	inventory.on_items_changed.connect(item_inv_update)
	inventory.on_equipments_changed.connect(equipment_inv_update)

func open_inventory():
	animation.play("Show")
func close_inventory():
	title.text = "inventory.title"
	if !animation.is_playing():
		match current_inv:
			"Main" :	animation.play_backwards("Show")
			"Item" :
				current_inv = "Main"
				animation.play_backwards("Item")
			"Equipment" :
				current_inv = "Main"
				animation.play_backwards("Equipment")

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
func _on_equipment_button_pressed():
	if current_inv == "Main":
		title.text = "inventory.equipment.t"
		animation.play("Equipment")
		current_inv = "Equipment"
	equipment_inv_update()

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
		#match i.item:
		#	IBlockClass :	group = block_group
		#	ItemClass :	group = item_group
		if i.item is IBlockClass :	group = block_group
		elif i.item is ItemClass :	group = item_group
		var subitem = item_list.create_item(group)
		subitem.set_icon(0,i.item.icon)
		subitem.set_icon_max_width(0,30)
		subitem.set_text(0,tr(i.item.name0))
		subitem.set_tooltip_text(0,tr(i.item.get_discription()))
		subitem.set_text(1,str(i.count))
		subitem.set_text_alignment(1,HORIZONTAL_ALIGNMENT_RIGHT)
		subitem.set_metadata(0,inventory.itemStack.find(i))
#View details
func _on_item_list_item_selected():
	var index = item_list.get_selected().get_metadata(0)
	if index != null:
		item_name.text = inventory.itemStack[index].item.name0
		item_model.mesh = inventory.itemStack[index].item.model
		item_discription.text = inventory.itemStack[index].item.get_discription()
#Sort
func _on_item_list_column_title_clicked(column, mouse_button_index):
	inventory.sort_item(bool(column),bool(mouse_button_index-1))

#Equipment
func equipment_inv_update():
	equipment_list.set_column_title(0,tr("list.name"))
	equipment_list.set_column_title(1,tr("list.performance"))
	equipment_list.clear()
	var root = equipment_list.create_item()
	var tool_group = equipment_list.create_item(root)
	tool_group.set_text(0,tr("inventory.equipment.tool"))
	var weapon_group = equipment_list.create_item(root)
	weapon_group.set_text(0,tr("inventory.equipment.weapon"))
	var armor_group = equipment_list.create_item(root)
	armor_group.set_text(0,tr("inventory.equipment.armor"))
	for i in inventory.eqMeta:
		var group : Object
		if i.equipment is EToolClass :	group = tool_group
		var subitem = equipment_list.create_item(group)
		subitem.set_icon(0,i.equipment.icon)
		subitem.set_icon_max_width(0,30)
		subitem.set_text(0,tr(i.equipment.name0) + "   [" + str(int(((i.equipment.durability - i.damage)/i.equipment.durability)*100)) + "%]")
		subitem.set_tooltip_text(0,tr(i.equipment.get_subname()) + "\n" + str(i.equipment.durability - i.damage) + "/" + str(i.equipment.durability))
		subitem.set_text(1,str(i.equipment.performance))
		subitem.set_text_alignment(1,HORIZONTAL_ALIGNMENT_RIGHT)
		subitem.set_metadata(0,inventory.eqMeta.find(i))
#View details
func _on_equipment_list_item_selected():
	var index = equipment_list.get_selected().get_metadata(0)
	if index != null:
		equipment_name.text = inventory.eqMeta[index].equipment.name0
		equipment_subname.text = inventory.eqMeta[index].equipment.get_subname()
		equipment_info.text = \
			tr("list.performance") + ":" + str(inventory.eqMeta[index].equipment.performance) + "\n" + \
			tr("equipment.durability") + ":" + \
			str(inventory.eqMeta[index].equipment.durability - inventory.eqMeta[index].damage) + "/" + str(inventory.eqMeta[index].equipment.durability)
		equipment_model.mesh = inventory.eqMeta[index].equipment.model
		equipment_discription.text = inventory.eqMeta[index].equipment.get_discription()
#Sort
func _on_equipment_list_column_title_clicked(column, mouse_button_index):
	inventory.sort_equipment(bool(column),bool(mouse_button_index-1))


