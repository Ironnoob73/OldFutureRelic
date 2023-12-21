extends MeshInstance3D

@onready var screen = $Screen.material_override
@onready var viewport = $Viewport

@onready var ToolMode = $Viewport/ScreenTexture/Main/Mode
@onready var ToolBlockName = $Viewport/ScreenTexture/Main/BlockName
@onready var ToolBlockIcon = $Viewport/ScreenTexture/Main/BlockIcon
@onready var ToolLeftNumber = $Viewport/ScreenTexture/Main/LeftNumber

@onready var InteractRay = get_node("/root/Happend/Player/PlayerCam/VoxelInteractRay")

var current_block : int = 1

func _ready():
	screen.albedo_texture = viewport.get_texture()
	screen.emission_texture = viewport.get_texture()

func _tool_init():
	refresh_screen()

func refresh_screen():
	var block = InteractRay.block_lib.get_model(current_block).resource_name
	var block_name = AllItems.get_tran_from_name(block)
	ToolBlockName.text = "[scroll span=" + str(block_name.length()) + "]" + tr(block_name) + "[/scroll]"
	ToolBlockIcon.texture = AllItems.get_icon_from_name(block)
	ToolLeftNumber.text = str(InteractRay.inventory.get_item_count_from_en(block))

#Interact
func _unhandled_input(event):
	if InteractRay._terrain_tool != null and !(event is InputEventMouseMotion):
		var hit = InteractRay.get_pointed_voxel()
		if event.pressed and InteractRay.is_colliding():
			if Input.is_action_just_pressed("main_attack"):
				if hit != null :	dig(InteractRay.hit_point)
			elif Input.is_action_just_pressed("secondary_attack"):
				var pos : Vector3
				if InteractRay.is_colliding() and !(InteractRay.get_collider() is VoxelTerrain) : pos = InteractRay.hit_point
				elif hit != null :	pos = hit.previous_position
				if can_place_voxel_at(pos):
					place_detect(pos)
	#Switch block
		if InteractRay.Player.current_menu == "HUD" and event.pressed:
			if Input.is_action_just_pressed("tab_right"):
				current_block += 1
				if current_block >= InteractRay.block_lib.models.size():
					current_block = 1
				_tool_init()
			elif Input.is_action_just_pressed("tab_left"):
				current_block -= 1
				if current_block <= 0:
					current_block = InteractRay.block_lib.models.size() - 1
				_tool_init()
				
func can_place_voxel_at(pos: Vector3i):
	var space_state = InteractRay.get_viewport().get_world_3d().get_direct_space_state()
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
	if InteractRay._terrain_tool.get_voxel(center):
		InteractRay.inventory.add_item(InteractRay.block_lib.get_model(InteractRay._terrain_tool.get_voxel(center)).resource_name)
		InteractRay._terrain_tool.channel = VoxelBuffer.CHANNEL_TYPE
		InteractRay._terrain_tool.value = 0
		InteractRay._terrain_tool.do_point(center)
		create_trail(Color(1.0,0.0,0.0))
	refresh_screen()
	InteractRay._terrain.save_modified_blocks()
	
func place_detect(center: Vector3i):
	if InteractRay.block_lib.get_model(current_block) and InteractRay.inventory.get_item_count_from_en(InteractRay.block_lib.get_model(current_block).resource_name) > 0:
		InteractRay.inventory.remove_item(InteractRay.block_lib.get_model(current_block).resource_name)
		InteractRay._terrain_tool.channel = VoxelBuffer.CHANNEL_TYPE
		InteractRay._terrain_tool.value = current_block
		InteractRay._terrain_tool.do_point(center)
		create_trail(Color(0.0,1.0,1.0))
	refresh_screen()

func create_trail(light_color:Color):
	var trail = load("res://Resources/Tool/BlockPlacer/trail.tscn").instantiate()
	get_parent().get_parent().get_parent().add_child(trail)
	trail.material_override.albedo_color = Color(0.0,0.0,0.0,1.0)
	trail.material_override.emission = light_color
	trail.init_pos(global_position,InteractRay.get_collision_point())
	var trail_tween = get_tree().create_tween()
	trail_tween.tween_property(trail.material_override, "albedo_color:a", 0.0, 0.5)
	trail_tween.tween_callback(trail.queue_free)
