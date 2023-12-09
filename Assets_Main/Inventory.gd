extends Control

@onready var animation = $AnimationPlayer
func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func open_inventory():
	animation.play("Show")
func close_inventory():
	animation.play_backwards("Show")
