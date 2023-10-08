extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var mat:StandardMaterial3D = self.get_active_material(0)
	mat.texture_filter = 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
