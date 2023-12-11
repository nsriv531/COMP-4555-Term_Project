extends Node3D
@onready var animation_player = $AnimationPlayer

@onready var door_open = $DoorOpen
@onready var door_close = $DoorClose

@onready var keycard = $Keycard

@onready var near = false
@onready var playAnimation = $AnimationTree.get("parameters/playback")

@export var doorRegion:NavigationRegion3D = null

var open = false

func _ready():
	if doorRegion == null:
		doorRegion = get_node("DoorRegion")
	if doorRegion != null:
		doorRegion.set_navigation_layer_value(1, false)
	#self.add_to_group("navigation_mesh_source_group")
	#Global.emit_signal("mapChanged")
	animation_player.speed_scale = 0.01

func onButtonPress():
	if open:
		door_close.play(0.5)
		if doorRegion != null:
			doorRegion.set_navigation_layer_value(1, false)
		playAnimation.travel("Door_Closing")
		#self.add_to_group("navigation_mesh_source_group")
		open = false
	else:
		door_open.play(0.2)
		if doorRegion != null:
			doorRegion.set_navigation_layer_value(1, true)
		playAnimation.travel("Door_Opening")
		#self.remove_from_group("navigation_mesh_source_group")
		open = true
	
	#Global.emit_signal("mapChanged")

func doorPlay(nearArea):
	
	if(nearArea):
		playAnimation.travel("Door_Opening")
	else:
		playAnimation.travel("Door_Closing")

func _on_static_body_3d_button_press():
	if $Keycard == null:
		onButtonPress()
	pass # Replace with function body.
