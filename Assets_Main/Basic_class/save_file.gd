extends Node

var file_path : DirAccess
var blocky_terrain_region_path : String

func _init():
	file_path = DirAccess.open(Global.current_save_path())
	blocky_terrain_region_path = Global.current_save_path() + "\\region\\blocky"
func save_to_file():
	if file_path:
		file_path.list_dir_begin()
		var file_name = file_path.get_next()
		while file_name != "":
			if !file_path.current_is_dir():
				print("发现坐标：" + file_name)
			file_name = file_path.get_next()
