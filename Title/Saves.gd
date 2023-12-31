extends HBoxContainer

@onready var list = $List
@onready var file_name_label = $Preview/Name
@onready var file_cover = $Preview/Cover
@onready var file_discription = $Preview/Description

var broken_file_image = preload("res://Resources/Image/broken_file.svg")
var unknown_file_image = preload("res://Resources/Image/unknown_file.svg")

func _ready():
	refresh()
	
func refresh():
	list.clear()
	var file_path = DirAccess.open(Global.DATA_PATH)
	if file_path:
		file_path.list_dir_begin()
		var file_name = file_path.get_next()
		while file_name != "":
			if file_path.current_is_dir():
				print("发现目录：" + file_name)
				list.add_item(file_name)
			else:
				print("发现文件：" + file_name)
				list.set_item_custom_fg_color(list.add_item(file_name),Color(0.75,0.75,0.75))
			file_name = file_path.get_next()
	else:
		print("尝试访问路径时出错。")

func _on_list_item_selected(index):
	file_name_label.text = list.get_item_text(index)
	var current_file_path = Global.DATA_PATH + "\\" + file_name_label.text
	if DirAccess.open(current_file_path):
		file_discription.text = "AVALIABLE"
		var image = Image.load_from_file(current_file_path + "\\cover.png")
		if image == null:
			file_cover.texture = unknown_file_image
		else:
			var texture = ImageTexture.create_from_image(image)
			file_cover.texture = texture
	else:
		file_discription.text = "[color=red]NOT AVALIABLE[/color]"
		file_cover.texture = broken_file_image
