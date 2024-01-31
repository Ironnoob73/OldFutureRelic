extends MeshInstance3D

@onready var animation = $AnimationPlayer
@onready var Player = get_node("/root/Happend/Player")

@onready var InteractRay = get_node("/root/Happend/Player/PlayerCam/InteractRay")

func _tool_init():
	pass

#Interact
func _physics_process(_delta):
	if Player.current_menu == "HUD":
		if Input.is_action_pressed("main_attack") and !animation.is_playing():
			animation.play("Attack")
			if InteractRay.Bterrain_tool != null:
				var hit = InteractRay.get_pointed_voxel(false)
				if hit != null :	dig(InteractRay.hit_point)
		elif Input.is_action_just_pressed("secondary_attack"):
			pass
					
func dig(center: Vector3i):
	var tool_info = Player.Inventory.ToolHotbar[Player.current_hotbar]
	if InteractRay.Bterrain_tool.get_voxel(center):
		#InteractRay.inventory.add_item(InteractRay.block_lib.get_model(InteractRay._terrain_tool.get_voxel(center)).resource_name)
		InteractRay.Bterrain_tool.channel = VoxelBuffer.CHANNEL_TYPE
		var interacted_block = AllItems.get_item_from_name(InteractRay.block_lib.get_model(InteractRay.Bterrain_tool.get_voxel(center)).resource_name)
		# By Lry722:
		var break_progress = tool_info.equipment.performance / interacted_block.hardness
		var block_meta = InteractRay.Bterrain_tool.get_voxel_metadata(center)
		if block_meta:
			block_meta["damage"] += break_progress
		else:
			block_meta = {"damage":break_progress}
		if block_meta["damage"] >= 1.0 :
			InteractRay.Bterrain_tool.value = 0
			InteractRay.Bterrain_tool.do_point(center)
			block_meta = null
		InteractRay.Bterrain_tool.set_voxel_metadata(center,block_meta)
		# ---
		print(InteractRay.Bterrain_tool.get_voxel_metadata(center))
		tool_info.damage += randf_range(0.0,2.0)
		Player.refresh_handheld_info()
		
	InteractRay.Bterrain.save_modified_blocks()
