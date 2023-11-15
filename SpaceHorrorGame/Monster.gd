extends CharacterBody3D

const SPEED = 3.0
const JUMP_VELOCITY = 4.5

@onready var navigation_agent_3d = $NavigationAgent3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	var cur_loc = global_transform.origin
	var next_loc = navigation_agent_3d.get_next_path_position()
	var new_vel = (next_loc - cur_loc).normalized() * SPEED
	
	velocity = new_vel
	move_and_slide()
	
func update_target_loc(tar_loc):
	navigation_agent_3d.target_position = tar_loc

