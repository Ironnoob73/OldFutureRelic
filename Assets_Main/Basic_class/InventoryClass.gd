extends Resource
class_name InventoryClass

signal on_items_changed

@export var itemStack : Array[ItemStackClass]
		
func add_item(item :ItemClass , count :int = 1 ):
	var stacks = itemStack.filter(func(stack):return stack.item == item)
	if !stacks.is_empty():
		stacks[0].count += count
	else:
		var newStack = ItemStackClass.new()
		newStack.item = item
		newStack.count = count
		itemStack.append(newStack)
	on_items_changed.emit()
	
func remove_item(item :ItemClass , count :int = 1 ):
	var stacks = itemStack.filter(func(stack):return stack.item == item)
	if !stacks.is_empty():
		if stacks[0].count >= count:
			stacks[0].count -= count
		else :	return "out"
		if stacks[0].count == 0:
			itemStack.erase(stacks[0])
	else :	return "off"
	on_items_changed.emit()
