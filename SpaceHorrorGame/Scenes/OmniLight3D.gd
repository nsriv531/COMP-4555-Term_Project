@tool
extends OmniLight3D


var boxposition = Vector3(0,20.732,-13.409)
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.position = boxposition
	self.position.y = 22.917
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	self.position.x = boxposition.x + sin(time)
	self.position.z = boxposition.z + cos(time)
	pass
