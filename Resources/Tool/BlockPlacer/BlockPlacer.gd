extends MeshInstance3D

@onready var screen = $Screen
@onready var viewport = $Viewport
@onready var animation = $AnimationPlayer
@onready var setting = $Viewport/ScreenTexture/Setting

@onready var Player = get_node("/root/Happend/Player")

@onready var ToolMode = $Viewport/ScreenTexture/Main/Mode
@onready var ToolBlockName = $Viewport/ScreenTexture/Main/BlockName
@onready var ToolBlockIcon = $Viewport/ScreenTexture/Main/BlockIcon
@onready var ToolLeftNumber = $Viewport/ScreenTexture/Main/LeftNumber

@onready var InteractRay = get_node("/root/Happend/Player/PlayerCam/InteractRay")

@onready var screen_cursor = $Viewport/ScreenTexture/Setting/Cursor
@onready var screen_texture = $Viewport/ScreenTexture

var current_block : int = 1
var current_mode : bool = false #False is blocky & True is smooth

func _ready():
	screen.material_override.albedo_texture = viewport.get_texture()
	screen.material_override.emission_texture = viewport.get_texture()
	setting.hide()

func _tool_init():
	refresh_screen()
	if !current_mode :	InteractRay.affect_terrain = "blocky"
	else :	InteractRay.affect_terrain = "smooth"

func _process(delta):
	screen_cursor.position = screen_texture.get_global_mouse_position()

func refresh_screen():
	var block = InteractRay.block_lib.get_model(current_block).resource_name
	var block_name = AllItems.get_tran_from_name(block)
	ToolBlockName.text = "[scroll span=" + str(block_name.length()) + "]" + tr(block_name) + "[/scroll]"
	ToolBlockIcon.texture = AllItems.get_icon_from_name(block)
	ToolLeftNumber.text = str(InteractRay.inventory.get_item_count_from_en(block))
	ToolMode.text =(	"terrain.blocky" if !current_mode
				else	"terrain.smooth" )

#Interact
func _unhandled_input(event):
	if InteractRay.Bterrain_tool != null and !(event is InputEventMouseMotion):
		if InteractRay.Player.current_menu == "HUD":
	#Dig & Place
			var hit = InteractRay.get_pointed_voxel(current_mode)
			if event.pressed and InteractRay.is_colliding():
				if Input.is_action_just_pressed("main_attack"):
					if hit != null :	dig(InteractRay.hit_point)
				elif Input.is_action_just_pressed("secondary_attack"):
					var pos : Vector3
					if !current_mode:
						if InteractRay.is_colliding() and !(InteractRay.get_collider() is VoxelTerrain) : pos = InteractRay.hit_point
						elif hit != null :	pos = hit.previous_position
						if can_place_voxel_at(pos):
							place(pos)
					else:
						if InteractRay.is_colliding() and !(InteractRay.get_collider() is VoxelLodTerrain) : pos = InteractRay.hit_point
						elif hit != null :	pos = hit.previous_position
						place(pos)
	#Switch block
			if event.pressed:
				if Input.is_action_just_pressed("tab_right") or Input.is_action_just_pressed("roll_down") and ( Input.is_action_pressed("tool_function_switch") or InteractRay.Player.current_menu == "ToolSetting" ):
					switch_block(true)
				elif Input.is_action_just_pressed("tab_left") or Input.is_action_just_pressed("roll_up") and ( Input.is_action_pressed("tool_function_switch") or InteractRay.Player.current_menu == "ToolSetting" ):
					switch_block(false)
			if Input.is_action_just_pressed("tool_function_switch"):
				animation.play("Switch_block")
			if Input.is_action_just_released("tool_function_switch"):
				animation.play_backwards("Switch_block")
	#Setting
		if Input.is_action_just_pressed("tool_setting"):
			if InteractRay.Player.current_menu == "HUD":
				InteractRay.Player.current_menu = "ToolSetting"
				animation.play("Setting")
				setting.show()
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			elif InteractRay.Player.current_menu == "ToolSetting":
				InteractRay.Player.current_menu = "HUD"
				setting_off()
func setting_off():
	setting.hide()
	animation.play_backwards("Setting")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func switch_block(direction: bool):
	if direction:
		current_block += 1
		if current_block >= InteractRay.block_lib.models.size():
			current_block = 1
	else:
		current_block -= 1
		if current_block <= 0:
			current_block = InteractRay.block_lib.models.size() - 1
	_tool_init()
func switch_mode():
	current_mode = !current_mode
	print(current_mode)
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
	if !current_mode and InteractRay.Bterrain_tool.get_voxel(center):
		InteractRay.inventory.add_item(InteractRay.block_lib.get_model(InteractRay.Bterrain_tool.get_voxel(center)).resource_name)
		InteractRay.Bterrain_tool.channel = VoxelBuffer.CHANNEL_TYPE
		InteractRay.Bterrain_tool.value = 0
		InteractRay.Bterrain_tool.do_point(center)
		create_trail(Color(1.0,0.0,0.0))
	elif current_mode and InteractRay.Sterrain_tool.get_voxel(center):
		InteractRay.Sterrain_tool.channel = VoxelBuffer.CHANNEL_SDF
		InteractRay.Sterrain_tool.mode = VoxelTool.MODE_REMOVE
		#InteractRay.Sterrain_tool.do_sphere(center,1.0)
		InteractRay.Sterrain_tool.do_point(center)
		create_trail(Color(1.0,0.0,0.0))
	refresh_screen()
	Player.Inventory.ToolHotbar[Player.current_hotbar].damage += randf_range(0.0,2.0)
	InteractRay.Bterrain.save_modified_blocks()
	
func place(center: Vector3i):
	if !current_mode:
		if InteractRay.block_lib.get_model(current_block) and InteractRay.inventory.get_item_count_from_en(InteractRay.block_lib.get_model(current_block).resource_name) > 0:
			InteractRay.inventory.remove_item(InteractRay.block_lib.get_model(current_block).resource_name)
			InteractRay.Bterrain_tool.channel = VoxelBuffer.CHANNEL_TYPE
			InteractRay.Bterrain_tool.value = current_block
			InteractRay.Bterrain_tool.do_point(center)
			create_trail(Color(0.0,1.0,1.0))
	else:
		InteractRay.Sterrain_tool.channel = VoxelBuffer.CHANNEL_SDF
		InteractRay.Sterrain_tool.mode = VoxelTool.MODE_ADD
		InteractRay.Sterrain_tool.set_sdf_scale(0.002)
		#InteractRay.Sterrain_tool.do_sphere(center,1)
		InteractRay.Sterrain_tool.do_point(center)
		create_trail(Color(1.0,1.0,0.0))
	refresh_screen()
	Player.Inventory.ToolHotbar[Player.current_hotbar].damage += randf_range(0.0,2.0)

func create_trail(light_color:Color):
	var trail = load("res://Resources/Tool/BlockPlacer/trail.tscn").instantiate()
	get_parent().get_parent().get_parent().add_child(trail)
	trail.material_override.albedo_color = Color(0.0,0.0,0.0,1.0)
	trail.material_override.emission = light_color
	trail.init_pos(global_position,InteractRay.get_collision_point())
	var trail_tween = get_tree().create_tween()
	trail_tween.tween_property(trail.material_override, "albedo_color:a", 0.0, 0.5)
	trail_tween.tween_callback(trail.queue_free)

#Setting
#Menthod from GOAT Template : https://github.com/miskatonicstudio/goat/blob/master/addons/goat/main_scenes/InteractiveScreen.gd
func move_event(pos: Vector3):
	var screen_coordinates = _convert_to_screen_coordinates(pos)
	var event = InputEventMouseMotion.new()
	event.global_position = screen_coordinates
	event.position = screen_coordinates
	viewport.push_input(event)
func click_event(pos: Vector3):
	var screen_coordinates = _convert_to_screen_coordinates(pos)
	var event = InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.global_position = screen_coordinates
	event.position = screen_coordinates
	event.pressed = true
	event.button_mask = 1
	viewport.push_input(event)
	event.pressed = false
	event.button_mask = 1
	viewport.push_input(event)
func _convert_to_screen_coordinates(global_point):
	var local_point = screen.to_local(global_point)
	return Vector2i(
		Vector2( - ( local_point.z * 4 ) + 0.5 , 0.9 - ( local_point.y * 2.6 ) ) * Vector2(viewport.size)
	)

#Setting screen
func _on_left_block_pressed():
	switch_block(true)
func _on_right_block_pressed():
	switch_block(false)

func _on_left_mode_pressed():
	switch_mode()
func _on_right_mode_pressed():
	switch_mode()
