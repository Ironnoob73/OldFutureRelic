extends VoxelStreamScript

var file_path : DirAccess
var blocky_terrain_region_path : String

func _init():
	file_path = DirAccess.open(Global.current_save_path())
	blocky_terrain_region_path = Global.current_save_path() + "\\region\\blocky"
func _load_voxel_block(out_buffer:VoxelBuffer, origin_in_voxels:Vector3i, lod:int):
	if file_path and FileAccess.file_exists(blocky_terrain_region_path + "\\r" + str(origin_in_voxels)):
		var file = FileAccess.open(blocky_terrain_region_path + "\\r" + str(origin_in_voxels),FileAccess.READ)
		var data = file.get_buffer(file.get_length()).decompress_dynamic(VoxelBuffer.MAX_SIZE,1)
		for ix in range(16):
			for iz in range(16):
				for iy in range(16):
					var index = ix * 256 + iz * 16 + iy
					if data[index] != 0:
						out_buffer.set_voxel(data[index],ix,iy,iz)
		return 2
	else:return 1
func _save_voxel_block(out_buffer:VoxelBuffer, origin_in_voxels:Vector3i, lod:int):
	var blocky_terrain_region = DirAccess.open(blocky_terrain_region_path)
	if !blocky_terrain_region:
		file_path.make_dir_recursive(blocky_terrain_region_path)
	var file = FileAccess.open(blocky_terrain_region_path + "\\r" + str(origin_in_voxels),FileAccess.WRITE)
	var data = PackedByteArray()
	for ix in range(16):
		for iz in range(16):
			for iy in range(16):
				data.append(out_buffer.get_voxel(ix,iy,iz))
	file.store_buffer(data.compress(1))
	
