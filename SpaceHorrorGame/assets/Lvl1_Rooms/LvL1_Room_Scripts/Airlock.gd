extends Node3D
@onready var floor_lights = $Floor_Lights
@onready var wall_lights = $Wall_Interior_Lights
var color_ready = Color(0,1,0)
var color_notReady= Color.html("#a10000")
var lightsReady:bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	floor_lights.material_override = floor_lights.get_active_material(0)
	wall_lights.material_override = wall_lights.get_active_material(0)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func changeColor():
	if(lightsReady):
		floor_lights.material_override.emission = color_ready
		wall_lights.material_override.emission = color_ready
		lightsReady = false
	else:
		floor_lights.material_override.emission = color_notReady
		wall_lights.material_override.emission = color_notReady
		lightsReady = true
		
	
