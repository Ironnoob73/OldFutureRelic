extends RayCast3D

var _terrain : VoxelTerrain = null
var _terrain_tool = null
var _cursor = null

func _ready():
	_cursor = $"../../Cursor"
	
	
func get_pointed_voxel() -> VoxelRaycastResult:
	var origin = get_global_transform().origin
	var forward = get_global_transform().basis.z.normalized()
	var hit = _terrain_tool.raycast(origin, -forward, 5)
	return hit
	
func _physics_process(delta):
	if is_colliding() and get_collider() is VoxelTerrain:
		_terrain = get_collider()
		_terrain_tool = _terrain.get_voxel_tool()
	
	if _terrain_tool != null:
		var hit := get_pointed_voxel()
		if hit != null:
			_cursor.show()
			_cursor.set_global_position(Vector3(hit.position)+Vector3(0.5,0.5,0.5))
		else:
			_cursor.hide()

func _unhandled_input(event):
	if _terrain_tool != null:
		var hit := get_pointed_voxel()
		if event is InputEventMouseButton:
			if event.pressed and hit != null:
				match event.button_index:
					MOUSE_BUTTON_LEFT:
						dig(hit.position)
					MOUSE_BUTTON_RIGHT:
						var pos = hit.previous_position
						if can_place_voxel_at(pos):
							place(pos)
							
func can_place_voxel_at(pos: Vector3i):
	var space_state = get_viewport().get_world_3d().get_direct_space_state()
	var params = PhysicsShapeQueryParameters3D.new()
	params.collision_mask = 2
	params.transform = Transform3D(Basis(), Vector3(pos) + Vector3(0.5,0.5,0.5))
	var shape = BoxShape3D.new()
	var ex = 0.5
	shape.extents = Vector3(ex, ex, ex)
	params.set_shape(shape)
	var hits = space_state.intersect_shape(params)
	return hits.size() == 0
	
func dig(center: Vector3i):
	#var type : int = _inventory[_inventory_index]
	_terrain_tool.channel = VoxelBuffer.CHANNEL_TYPE
	_terrain_tool.value = 0
	_terrain_tool.do_point(center)
	
func place(center: Vector3i):
	_terrain_tool.channel = VoxelBuffer.CHANNEL_TYPE
	_terrain_tool.value = 2
	_terrain_tool.do_point(center)
