extends Node2D

var viewport_initial_size = Vector2()

@onready var viewport = $SubViewportContainer/SubViewport

func _ready():
	get_viewport().size_changed.connect(self._root_viewport_size_changed)
	viewport_initial_size = viewport.size


# Called when the root's viewport size changes (i.e. when the window is resized).
# This is done to handle multiple resolutions without losing quality.
func _root_viewport_size_changed():
	# The viewport is resized depending on the window height.
	# To compensate for the larger resolution, the viewport sprite is scaled down.
	viewport.size = Vector2.ONE * get_viewport().size.y

