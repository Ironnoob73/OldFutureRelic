extends ScrollContainer

@onready var list = $List

func _ready():
	refresh()
func refresh():
	for n in list.get_children():
		list.remove_child(n)
		n.free()
	var dir = DirAccess.open(Global.DATA_PATH)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("发现目录：" + file_name)
				var slot = Button.new()
				slot.name = file_name
				slot.text = file_name
				list.add_child(slot)
			else:
				print("发现文件：" + file_name)
			file_name = dir.get_next()
	else:
		print("尝试访问路径时出错。")



