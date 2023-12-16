extends RayCast3D

var hit_point : Vector3

var _terrain : VoxelTerrain = null
var _terrain_tool = null
@onready var _cursor = $"../../Cursor"

@onready var block_lib = preload("res://Resources/Block/BlockLib_basic.tres")
var current_block : int = 1

@onready var inventory = preload("res://Assets_Main/Player_inventory.tres")
@onready var HandHeldItem = $"../HandHeld/BlockPlacer"

func _ready():
	get_world_terrain()
	#refresh_bp_tool()
	
func get_world_terrain():
	_terrain = get_parent().get_parent().get_parent().blockTerrain
	
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
	if is_colliding() :
		if _terrain_tool == null:
			hit_point = floor(get_collision_point())
			_cursor.material.set_shader_parameter("color",Vector3(1,0,0))
		else:
			var hit := get_pointed_voxel()
			if !(get_collider() is VoxelTerrain) :
				get_world_terrain()
				hit_point = floor(get_collision_point())
				_cursor.material.set_shader_parameter("color",Vector3(0,0,1))
			elif hit != null :
				hit_point = hit.position
				_cursor.material.set_shader_parameter("color",Vector3(1,1,1))
		
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
				if current_block >= block_lib.models.size():
					current_block = 1
				refresh_bp_tool()
			if Input.is_action_just_pressed("roll_down") and event.pressed:
				current_block -= 1
				if current_block <= 0:
					current_block = block_lib.models.size() - 1
				refresh_bp_tool()
							
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
		inventory.add_item(block_lib.get_model(_terrain_tool.get_voxel(center)).resource_name)
		_terrain_tool.channel = VoxelBuffer.CHANNEL_TYPE
		_terrain_tool.value = 0
		_terrain_tool.do_point(center)
		create_trail(Color(1.0,0.0,0.0))
	refresh_bp_tool()
	
func place_detect(center: Vector3i):
	if block_lib.get_model(current_block) and inventory.get_item_count(block_lib.get_model(current_block).resource_name) > 0:
		inventory.remove_item(block_lib.get_model(current_block).resource_name)
		_terrain_tool.channel = VoxelBuffer.CHANNEL_TYPE
		_terrain_tool.value = current_block
		_terrain_tool.do_point(center)
		create_trail(Color(0.0,1.0,1.0))
	refresh_bp_tool()

func refresh_bp_tool():
	var block_name = block_lib.get_model(current_block).resource_name
	HandHeldItem.refresh_screen(AllItems.get_tran_from_name(block_name),AllItems.get_icon_from_name(block_name),inventory.get_item_count(block_name))

func create_trail(light_color:Color):
	var trail_model = MeshInstance3D.new()
	var trail = ImmediateMesh.new()
	var trail_material = StandardMaterial3D.new()
	trail_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	trail_material.albedo_color = Color(0.0,0.0,0.0,1.0)
	trail_material.emission_enabled = true
	trail_material.emission_energy_multiplier = 5.0
	trail_material.emission = light_color
	trail.surface_begin(Mesh.PRIMITIVE_LINE_STRIP,trail_material)
	trail.surface_add_vertex(HandHeldItem.global_position)
	trail.surface_add_vertex(get_collision_point())
	trail.surface_end()
	trail_model.mesh = trail
	get_parent().get_parent().get_parent().add_child(trail_model)
	var trail_tween = get_tree().create_tween()
	trail_tween.tween_property(trail_material, "albedo_color:a", 0.0, 0.5)
	trail_tween.tween_callback(trail_model.queue_free)
