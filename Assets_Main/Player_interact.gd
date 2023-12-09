extends RayCast3D

var _terrain : VoxelTerrain = null
var _terrain_tool = null

func _ready():
	pass
	
func get_pointed_voxel() -> VoxelRaycastResult:
	var origin = get_global_transform().origin
	var forward = get_transform().basis.z.normalized()
	var hit = _terrain_tool.raycast(origin, forward, 10)
	return hit
	
func _physics_process(delta):
	print(get_collider())
	if is_colliding() and get_collider() is VoxelTerrain:
		_terrain = get_collider()
		_terrain_tool = _terrain.get_voxel_tool()

func _unhandled_input(event):
	if _terrain_tool != null:
		var hit := get_pointed_voxel()
		if event is InputEventMouseButton:
			if event.pressed:
				match event.button_index:
					MOUSE_BUTTON_LEFT:
						dig(hit.position)
						print(_terrain_tool)
					MOUSE_BUTTON_RIGHT:
						pass

func dig(center: Vector3i):
	#var type : int = _inventory[_inventory_index]
	_terrain_tool.channel = VoxelBuffer.CHANNEL_TYPE
	_terrain_tool.value = 0
	_terrain_tool.do_point(center)
