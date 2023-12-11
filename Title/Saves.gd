extends HBoxContainer

@onready var list = $List
@onready var file_name = $Preview/Name

func _ready():
	refresh()
func refresh():
	list.clear()
	var dir = DirAccess.open(Global.DATA_PATH)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("发现目录：" + file_name)
				list.add_item(file_name)
			else:
				print("发现文件：" + file_name)
				list.set_item_custom_fg_color(list.add_item(file_name),Color(0.75,0.75,0.75))
			file_name = dir.get_next()
	else:
		print("尝试访问路径时出错。")

func _on_list_item_selected(index):
	file_name.text = list.get_item_text(index)
