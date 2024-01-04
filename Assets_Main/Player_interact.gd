extends RayCast3D

var hit_point : Vector3

var _terrain : VoxelTerrain = null
var _terrain_tool = null
@onready var _cursor = $"../../Cursor"

@onready var block_lib = preload("res://Resources/Block/BlockLib_basic.tres")

@onready var inventory = preload("res://Assets_Main/Inventory/Player_inventory.tres")
@onready var HandHeldItem = $"../FirstPersonHandled/SubViewport/FirstPersonCam/HandHeld".get_child(0)
@onready var Player = get_node("/root/Happend/Player")

func get_world_terrain():
	_terrain = get_node("/root/Happend").blockTerrain
	_terrain_tool = _terrain.get_voxel_tool()
	
func get_pointed_voxel() -> VoxelRaycastResult:
	var origin = get_global_transform().origin
	var forward = get_global_transform().basis.z.normalized()
	var hit = _terrain_tool.raycast(origin, -forward, 20)
	return hit
	
func _physics_process(_delta):
	#Get terrain
	if is_colliding() and get_collider() is VoxelTerrain:
		_terrain = get_collider()
		_terrain_tool = _terrain.get_voxel_tool()
	else :	get_world_terrain()
	#Get hit point
	if is_colliding() :
		if _terrain_tool == null:
			hit_point = floor(get_collision_point())
			_cursor.material.set_shader_parameter("color",Vector3(1,0,0))
		else:
			var hit := get_pointed_voxel()
			if !(get_collider() is VoxelTerrain) :
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
		
