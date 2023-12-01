extends CanvasLayer

func _ready():
	self.set_visible(false)
	pass

# this is required because player cannot be processed when paused so an external always running script is required
func _process(delta):
		if Input.is_action_just_pressed("ui_cancel"):
				if get_tree().get("paused") == true:
					unpause()

func pause():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	self.set_visible(true)
	get_tree().set_deferred("paused", true)
	
func unpause():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	self.set_visible(false)
	get_tree().set_deferred("paused", false)


func _on_resume_button_down():
	unpause()


func _on_continue_button_down():
	unpause()


func _on_quit_button_down():
	get_tree().quit()
