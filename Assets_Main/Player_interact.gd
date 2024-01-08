extends RayCast3D

var hit_point : Vector3

var Bterrain : VoxelTerrain = null
var Sterrain : VoxelLodTerrain = null
var Bterrain_tool = null
var Sterrain_tool = null
@onready var _cursor = $"../../Cursor"

@onready var block_lib = preload("res://Resources/Block/BlockLib_basic.tres")

@onready var inventory = preload("res://Assets_Main/Inventory/Player_inventory.tres")
@onready var HandHeldItem = $"../FirstPersonHandled/SubViewport/FirstPersonCam/HandHeld".get_child(0)
@onready var Player = get_node("/root/Happend/Player")

var affect_terrain : String = "none" :
	set(value):
		change_cursor_shape()
		affect_terrain = value
	
func get_world_terrain():
	Bterrain = get_node("/root/Happend").blockTerrain
	Sterrain = get_node("/root/Happend").smoothTerrain
	Bterrain_tool = Bterrain.get_voxel_tool()
	Sterrain_tool = Sterrain.get_voxel_tool()
	
func get_pointed_voxel(Mode: bool) -> VoxelRaycastResult:
	var origin = get_global_transform().origin
	var forward = get_global_transform().basis.z.normalized()
	var hit =	Bterrain_tool.raycast(origin, -forward, 20) if !Mode \
		else	Sterrain_tool.raycast(origin, -forward, 20)
	return hit
	
func _physics_process(_delta):
	#Get terrain
	if is_colliding() and get_collider() is VoxelTerrain:
		Bterrain = get_collider()
		Bterrain_tool = Bterrain.get_voxel_tool()
	else :	get_world_terrain()
	#Get hit point & Change cursor color
	if is_colliding() :
		match affect_terrain:
			"blocky":
				_cursor.material.get_shader_parameter("albedo").set_fill(2)
				if Bterrain_tool == null:
					hit_point = floor(get_collision_point())
					_cursor.material.set_shader_parameter("color",Vector3(1,0,0))
				else:
					var hit := get_pointed_voxel(false)
					if !(get_collider() is VoxelTerrain) :
						hit_point = floor(get_collision_point())
						_cursor.material.set_shader_parameter("color",Vector3(0,0,1))
					elif hit != null :
						hit_point = hit.position
						_cursor.material.set_shader_parameter("color",Vector3(1,1,1))
			"smooth":
				_cursor.material.get_shader_parameter("albedo").set_fill(1)
				if Sterrain_tool == null:
					hit_point = floor(get_collision_point())
					_cursor.material.set_shader_parameter("color",Vector3(1,0,0))
				else:
					var hit := get_pointed_voxel(true)
					if !(get_collider() is VoxelLodTerrain):
						hit_point = floor(get_collision_point())
						_cursor.material.set_shader_parameter("color",Vector3(0,0,1))
					elif hit != null :
						hit_point = hit.position
						#hit_point = floor(get_collision_point())
						_cursor.material.set_shader_parameter("color",Vector3(1,1,0))
	#Dynamic
	if Player.handheld_tool:
		if Player.handheld_tool.equipment.affect_terrain == "dynamic":
			if get_collider() is VoxelTerrain :
				affect_terrain = "blocky"
			else :
				affect_terrain = "smooth"
		
	#Move cursor
	if affect_terrain == "none" or !is_colliding() :	_cursor.hide()
	elif _cursor.visible == true:
		_cursor.set_global_position(lerp(_cursor.global_position,Vector3(hit_point)+Vector3(0.5,0.5,0.5),0.5))
	else:
		_cursor.show()
		_cursor.set_global_position(Vector3(hit_point)+Vector3(0.5,0.5,0.5))
		
func change_cursor_shape():
	match affect_terrain:
		"blocky" :	_cursor.material.get_shader_parameter("albedo").set_fill(2)
		"smooth" :	_cursor.material.get_shader_parameter("albedo").set_fill(1)
