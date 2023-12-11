extends CharacterBody3D

const SPEED = 5
const DASH = 8
const CROUCH = 3
const CROUCH_depth = 0.5
const JUMP_VELOCITY = 8

const ACCELERATION = 0.1
const FRICTION = 0.3

@onready var player_collision = $PlayerColl
@onready var player_camera = $PlayerCam
@onready var standing_detected= $StandingDetected
@onready var pause_menu = $Pause_menu
@onready var inventory_menu = $Inventory

var INERTIA:Vector2 = Vector2.ZERO

var current_menu = "HUD"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	# Lock Mouse.
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	pause_menu.visible = false
	inventory_menu.visible = false
	
func _input(event):
	# Player camera.
	if event is InputEventMouseMotion and current_menu == "HUD":
		rotate_y(-deg_to_rad(event.relative.x * Global.mouse_sens))
		player_camera.rotate_x(-deg_to_rad(event.relative.y * Global.mouse_sens))
		player_camera.rotation.x = clamp(player_camera.rotation.x,deg_to_rad(-90),deg_to_rad(90))
func _unhandled_key_input(_event):
	# Pause.
	if Input.is_action_just_pressed("pause"):
		if current_menu == "HUD":
			current_menu = "Pause"
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			pause_menu.visible = true
		elif current_menu == "Inventory":
			current_menu = "HUD"
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			inventory_menu.close_inventory()
		else:
			current_menu = "HUD"
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Inventory
	if Input.is_action_just_pressed("inventory"):
		if current_menu == "HUD":
			current_menu = "Inventory"
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			inventory_menu.open_inventory()
		else:
			current_menu = "HUD"
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			inventory_menu.close_inventory()
	
func _physics_process(_delta):
	# Record Inerita & Add the gravity.
	if is_on_floor():
		INERTIA.x = velocity.x
		INERTIA.y = velocity.z
	else:
		velocity.y -= gravity * 0.05

	# Handle Jump.
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Move Input.
	var input_vec = Vector3.ZERO
	input_vec.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vec.z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vec = (transform.basis * Vector3(input_vec.x,0,input_vec.z)).normalized()
	
	var isDash = 0
	isDash = Input.get_action_strength("shift")
	var isCrouch = 0
	isCrouch = Input.get_action_strength("crouch")
	
	# Move.
	velocity.x = lerp(velocity.x,input_vec.x * (SPEED + isDash * DASH * (1 - isCrouch) - isCrouch * CROUCH ) , ACCELERATION)
	velocity.z = lerp(velocity.z,input_vec.z * (SPEED + isDash * DASH * (1 - isCrouch) - isCrouch * CROUCH ) , ACCELERATION)
	# Stop.
	if velocity.x * input_vec.x <= 0 and velocity.x!=0:
		if is_on_floor():	velocity.x = lerp(velocity.x,0.0,FRICTION)
		else:				velocity.x = lerp(INERTIA.x,0.0,FRICTION)
	if velocity.z * input_vec.z <= 0 and velocity.z!=0:
		if is_on_floor():	velocity.z = lerp(velocity.z,0.0,FRICTION)
		else:				velocity.z = lerp(INERTIA.y,0.0,FRICTION)
	
	# Crouch.
	if Input.is_action_pressed("crouch"):
		player_collision.shape.height = lerp(player_collision.shape.height,1.8 * CROUCH_depth,0.5)
		player_camera.position.y = lerp(player_camera.position.y,0.5 * CROUCH_depth,0.5)
	elif !standing_detected.is_colliding():
		player_collision.shape.height = lerp(player_collision.shape.height,1.8,0.5)
		player_camera.position.y = lerp(player_camera.position.y,0.5,0.5)
	
	move_and_slide()
	
	# Debug.
	#print(velocity,position,input_vec,Input.is_action_pressed("crouch"),$StandingDetect.get_collider(0))
