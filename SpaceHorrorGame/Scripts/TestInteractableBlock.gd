extends StaticBody3D

var color1 = Color(0.111, 0.850, 0.147)
var color2 = Color(0.760, 0.0608, 0.0608)

# Called when the node enters the scene tree for the first time.
func _ready():
	$MeshInstance3D.material_override = StandardMaterial3D.new()
	$MeshInstance3D.material_override.albedo_color = color2
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func interact(player):
	$MeshInstance3D.material_override.albedo_color = color1
	pass
