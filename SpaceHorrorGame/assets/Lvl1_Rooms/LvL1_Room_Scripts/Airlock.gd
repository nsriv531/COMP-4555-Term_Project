extends Node3D
@onready var floor_lights = $Floor_Lights
var color_ready = Color(0,1,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	floor_lights.material_override = floor_lights.get_active_material(0)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func changeColor(color):
	floor_lights.material_override.emission = color
