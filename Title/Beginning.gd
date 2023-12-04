extends VBoxContainer

@export var current_index = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	button_selected(self)

func _process(delta):
	position.y = lerp( position.y , 250.0 - current_index * 65.0 , 0.1 )

func button_selected(node):
	for child in node.get_children():
		if child is Button :	child.focus_entered.connect(set_index.bind(child.get_index()))
func set_index(index):
	current_index = index

