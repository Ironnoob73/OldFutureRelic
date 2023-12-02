extends ScrollContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_viewport().size.x < 1600 :	size.x = get_viewport().size.x * 0.625
	else :								size.x = 1000
	if get_viewport().size.y < 950 :	size.y = get_viewport().size.y - 200
	else :								size.y = 750
	position.y = ( get_viewport().size.y - size.y ) / 2
