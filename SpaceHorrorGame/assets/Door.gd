extends Node3D

@onready var near = false
@onready var playAnimation = $AnimationTree.get("parameters/playback")

func doorPlay(nearArea):
	
	if(nearArea):
		playAnimation.travel("Door_Opening")
	else:
		playAnimation.travel("Door_Closing")


func _on_area_3d_body_entered(body):
	if body.name == "Player":
		print("Player inside area")
		near = true
		doorPlay(near)


func _on_area_3d_body_exited(body):
	if body.name == "Player":
		print("Player outside area")
		near = false
		doorPlay(near)