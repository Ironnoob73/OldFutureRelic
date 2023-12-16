extends CSGPolygon3D

@onready var trail_curve = $Path.curve

func _ready():
	var mat_d = material_override.duplicate()
	material_override = mat_d

func init(pos0:Vector3,pos1:Vector3):
	trail_curve.set_point_position(0,pos0)
	trail_curve.set_point_position(1,pos1)
