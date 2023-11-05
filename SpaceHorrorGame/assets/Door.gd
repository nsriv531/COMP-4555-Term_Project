extends Node3D
@onready var animation_player = $AnimationPlayer

@onready var door_open = $DoorOpen
@onready var door_close = $DoorClose

@onready var near = false
@onready var playAnimation = $AnimationTree.get("parameters/playback")

var open = false

func _ready():
	animation_player.speed_scale = 0.01

func onButtonPress():
	if open:
		door_close.play(0.5)
		playAnimation.travel("Door_Closing")
		open = false
	else:
		door_open.play(0.2)
		playAnimation.travel("Door_Opening")
		open = true
	

func doorPlay(nearArea):
	
	if(nearArea):
		playAnimation.travel("Door_Opening")
	else:
		playAnimation.travel("Door_Closing")


func _on_area_3d_body_entered(body):
	pass
	#if body.name == "Player":
	#	print("Player inside area")
	#	near = true
	#	doorPlay(near)


func _on_area_3d_body_exited(body):
	pass
	#if body.name == "Player":
	#	print("Player outside area")
	#	near = false
	#	doorPlay(near)


func _on_static_body_3d_button_press():
	onButtonPress()
	pass # Replace with function body.
