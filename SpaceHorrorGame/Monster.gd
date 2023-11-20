extends CharacterBody3D

const SPEED = 3.0
const JUMP_VELOCITY = 4.5

@onready var navigation_region_3d = $"../MainNavRegion"

@export var player:CharacterBody3D = null
@onready var navigation_agent_3d = $NavigationAgent3D

enum {CHASE,WANDER,IDLE,LOOKING}

var footnum = 0
var state = IDLE
var playerInSight = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	$IdleTimer.start(4)
	return

func _process(delta):
	
	if state == IDLE:
		return
	
	if state == WANDER:
		return
		
	if state == CHASE:
		if playerInSight:
			update_target_loc(player.position)
		else:
			pass
			
		return
		
	return

func _physics_process(delta):
		
	
	
	var cur_loc = global_transform.origin
	var next_loc = navigation_agent_3d.get_next_path_position()
	var new_vel = (next_loc - cur_loc).normalized() * SPEED
	velocity = new_vel
		
	
	if state == CHASE:
		#$Neck.rotation.y = lerp_angle($Neck.rotation.y,  deg_to_rad(90)-(Vector2(next_loc.x, next_loc.z).angle_to_point(Vector2(position.x, position.z))), 0.1)
		$Neck.look_at(player.position)
	#self.rotation.y = lerp_angle(rotation.y,  deg_to_rad(90)-(Vector2(next_loc.x, next_loc.z).angle_to_point(Vector2(position.x, position.z))), 0.1)
	
	#Vector2(position.x, position.z).angle_to_point(Vector2(player.position.x, player.position.z))
	
	#self.look_at(player.position)
	
	move_and_slide()
	
func update_target_loc(tar_loc):
	navigation_agent_3d.target_position = tar_loc



func _on_sight_body_entered(body):
	if body == player:
		print("player entered view")
		playerInSight = true
		_on_raycast_timer_timeout()
	pass # Replace with function body.


func _on_sight_body_exited(body):
	if body == player:
		playerInSight = false
		#state = IDLE
		$RaycastTimer.stop()
	pass # Replace with function body.


func _on_raycast_timer_timeout():
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(self.position, player.position)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	if result.collider == player:
		state = CHASE
	else:
		state = IDLE
	$RaycastTimer.start(0.2)
	pass # Replace with function body.


func _on_footstep_timeout():
	get_node("footstep" + (footnum%2 + 1)).play()
	footnum += 1
	pass # Replace with function body.


func _on_navigation_agent_3d_target_reached():
	if state == WANDER:
		set_random_nav_target()
	pass # Replace with function body.

func set_random_nav_target():
	var list = navigation_region_3d.navigation_mesh.get_vertices()
		
	while true:
		var target = list[(randi_range(0,list.size()-1))]
		target.y = 22.214
		navigation_agent_3d.target_position = target
		if navigation_agent_3d.is_target_reachable():
			break


func _on_idle_timer_timeout():
	if state == IDLE:
		print("wanderin..")
		state = WANDER
		set_random_nav_target()
	pass # Replace with function body.
