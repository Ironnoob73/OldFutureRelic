extends RayCast3D

var hit_point : Vector3

var _terrain : VoxelTerrain = null
var _terrain_tool = null
@onready var _cursor = $"../../Cursor"

@onready var block_lib = preload("res://Resources/Block/BlockLib_basic.tres")
var current_block : int = 0
@onready var current_block_show = $"../../CurrentBlock"

signal on_block_break(block_name:String)
signal on_block_put(block_name:String,center:Vector3i)

func _ready():
	pass
	
func get_pointed_voxel() -> VoxelRaycastResult:
	var origin = get_global_transform().origin
	var forward = get_global_transform().basis.z.normalized()
	var hit = _terrain_tool.raycast(origin, -forward, 5)
	return hit
	
func _physics_process(_delta):
	#Get terrain
	if is_colliding() and get_collider() is VoxelTerrain:
			_terrain = get_collider()
			_terrain_tool = _terrain.get_voxel_tool()
	#Get hit point
	if _terrain_tool != null:
		var hit := get_pointed_voxel()
		if is_colliding() and !(get_collider() is VoxelTerrain) :	hit_point = floor(get_collision_point())
		elif hit != null :	hit_point = hit.position
		
	#Move cursor
	if !is_colliding():	_cursor.hide()
	elif _cursor.visible == true:
		_cursor.set_global_position(lerp(_cursor.global_position,Vector3(hit_point)+Vector3(0.5,0.5,0.5),0.5))
	else:
		_cursor.show()
		_cursor.set_global_position(Vector3(hit_point)+Vector3(0.5,0.5,0.5))
		

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if _terrain_tool != null:
			var hit := get_pointed_voxel()
			if event.pressed and is_colliding():
				match event.button_index:
					MOUSE_BUTTON_LEFT:
						if hit != null :	dig(hit_point)
					MOUSE_BUTTON_RIGHT:
						var pos : Vector3
						if is_colliding() and !(get_collider() is VoxelTerrain) : pos = hit_point
						elif hit != null :	pos = hit.previous_position
						if can_place_voxel_at(pos):
							place_detect(pos)
	#Switch block
		if get_parent().get_parent().current_menu == "HUD":
			if Input.is_action_just_pressed("roll_up") and event.pressed:
				current_block += 1
				current_block_show.text = str(current_block)
			if Input.is_action_just_pressed("roll_down") and event.pressed:
				current_block -= 1
				current_block_show.text = str(current_block)
							
func can_place_voxel_at(pos: Vector3i):
	var space_state = get_viewport().get_world_3d().get_direct_space_state()
	var params = PhysicsShapeQueryParameters3D.new()
	params.collision_mask = 10
	params.transform = Transform3D(Basis(), Vector3(pos) + Vector3(0.5,0.5,0.5))
	var shape = BoxShape3D.new()
	var ex = 0.5
	shape.extents = Vector3(ex, ex, ex)
	params.set_shape(shape)
	var hits = space_state.intersect_shape(params)
	return hits.size() == 0
	
func dig(center: Vector3i):
	if _terrain_tool.get_voxel(center):
		on_block_break.emit(block_lib.get_model(_terrain_tool.get_voxel(center)).resource_name)
		_terrain_tool.channel = VoxelBuffer.CHANNEL_TYPE
		_terrain_tool.value = 0
		_terrain_tool.do_point(center)
	
func place_detect(center: Vector3i):
	on_block_put.emit(block_lib.get_model(current_block).resource_name,center)
func place(center: Vector3i):
	_terrain_tool.channel = VoxelBuffer.CHANNEL_TYPE
	_terrain_tool.value = current_block
	_terrain_tool.do_point(center)
