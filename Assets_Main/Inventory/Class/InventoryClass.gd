extends Resource
class_name InventoryClass

signal on_items_changed

@export var itemStack : Array[ItemStackClass]
@export var eqMeta : Array[EqMetaClass]
		
func add_item(item_name :String , count :int = 1 ):
	var item = AllItems.get_item_from_name(item_name)
	var stacks = itemStack.filter(func(stack):return stack.item == item)
	if !stacks.is_empty():
		stacks[0].count += count
	else:
		var newStack = ItemStackClass.new()
		newStack.item = item
		newStack.count = count
		itemStack.append(newStack)
	on_items_changed.emit()
	
func remove_item(item_name :String , count :int = 1 ):
	var item = AllItems.get_item_from_name(item_name)
	var stacks = itemStack.filter(func(stack):return stack.item == item)
	if !stacks.is_empty():
		if stacks[0].count >= count:
			stacks[0].count -= count
		else :	return "out"
		if stacks[0].count == 0:
			itemStack.erase(stacks[0])
	else :	return "off"
	on_items_changed.emit()

func sort_item(by_count:bool,direction:bool):
	if by_count :	itemStack.sort_custom(func(a, b): return (a.count < b.count)!=direction)
	else :	itemStack.sort_custom(func(a, b): return (a.item.item_name < b.item.item_name)!=direction)
	on_items_changed.emit()

func get_item_count(item_name :String):
	var item = AllItems.get_item_from_name(item_name)
	var stacks = itemStack.filter(func(stack):return stack.item == item)
	if !stacks.is_empty() :	return stacks[0].count
	else :	return 0
