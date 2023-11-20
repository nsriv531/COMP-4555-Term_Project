extends NavigationRegion3D


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("mapChanged", rebakeNavMesh)
	$Timer.start(1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func rebakeNavMesh():
	self.bake_navigation_mesh(true)
	return


func _on_timer_timeout():
	bake_navigation_mesh(true)
	$Timer.start(1)
	pass # Replace with function body.
