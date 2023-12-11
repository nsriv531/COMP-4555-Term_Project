extends Node3D
signal pickup

@onready var keycard_obj = $self

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func interact(player):
	pickup.emit()
	self.get_parent().queue_free()
