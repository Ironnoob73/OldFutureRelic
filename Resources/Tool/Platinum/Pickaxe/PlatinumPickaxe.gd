extends MeshInstance3D

@onready var animation = $AnimationPlayer
@onready var Player = get_node("/root/Happend/Player")

func _tool_init():
	pass

#Interact
func _physics_process(_delta):
	if Player.current_menu == "HUD":
		if Input.is_action_pressed("main_attack") and !animation.is_playing():
			animation.play("Attack")
		elif Input.is_action_just_pressed("secondary_attack"):
			pass
