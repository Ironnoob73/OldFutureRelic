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

var mouse_sens = 0.4

var INERTIA:Vector2 = Vector2.ZERO

var isPause = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	# Lock Mouse.
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Pause init.
	#process_mode=1
	
	#self.add_to_group("Player")
	
func _input(event):
	# Player camera.
	if event is InputEventMouseMotion and !isPause:
		rotate_y(-deg_to_rad(event.relative.x * mouse_sens))
		player_camera.rotate_x(-deg_to_rad(event.relative.y * mouse_sens))
		player_camera.rotation.x = clamp(player_camera.rotation.x,deg_to_rad(-90),deg_to_rad(90))
	
func _physics_process(delta):
	
	# Pause.
	if Input.is_action_just_pressed("pause"):
		if isPause:
			isPause=false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			#get_tree().paused=false
		else:
			isPause=true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			#get_tree().paused=true
	
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
		player_collision.shape.height = lerp(player_collision.shape.height,2 - CROUCH_depth,0.5)
		player_camera.position.y = lerp(player_camera.position.y,1.8 - CROUCH_depth,0.5)
	elif !standing_detected.is_colliding():
		player_collision.shape.height = lerp(player_collision.shape.height,2.0,0.5)
		player_camera.position.y = lerp(player_camera.position.y,1.8,0.5)
	
	move_and_slide()
	
	# Debug.
	#print(velocity,position,input_vec,Input.is_action_pressed("crouch"),$StandingDetect.get_collider(0))
