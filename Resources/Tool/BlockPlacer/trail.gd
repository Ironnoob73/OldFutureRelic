extends CSGPolygon3D

var changed = false

func _ready():
	var mat_d = material_override.duplicate()
	material_override = mat_d

func init_pos(pos0:Vector3,pos1:Vector3):
	var ind_path = Path3D.new()
	var ind_curve = Curve3D.new()
	ind_curve.add_point(pos0,Vector3(0.0,0.0,0.0),Vector3(0.0,1.0,0.0))
	ind_curve.add_point(pos1)
	ind_path.set_curve(ind_curve)
	add_child(ind_path)
	ind_path.name = "IndPath"
	set_path_node(get_node("IndPath").get_path())
