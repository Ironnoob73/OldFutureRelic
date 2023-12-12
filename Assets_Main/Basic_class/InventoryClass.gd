extends Resource
class_name InventoryClass

signal on_items_changed

@export var items : Array[ItemStackClass]
		
#func add_item(item:ItemClass,count:int):
#	if item in items:
#		items[str(item)] += count
#	else:
#		items[str(item)] += count
#	emit_signal("on_items_changed")
