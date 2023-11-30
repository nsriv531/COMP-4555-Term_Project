extends Control


@onready var blur = $Blur
@onready var edge_fade = $EdgeFade
@onready var pause_menu = $PauseMenu


# Called when the node enters the scene tree for the first time.
func _ready():
	hideBlur()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func showBlur():
	blur.show()
	
func hideBlur():
	blur.hide()
	
