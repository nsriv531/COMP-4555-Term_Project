extends CharacterBody3D

var SPEED = 3.0
const JUMP_VELOCITY = 4.5

@onready var navigation_region_3d = $"../MainNavRegion"
@onready var albertZombie = $zombiewithanimations
@onready var albert_Animation_Player = $zombiewithanimations/AnimationPlayer
@export var player:CharacterBody3D = null
@onready var navigation_agent_3d = $NavigationAgent3D

enum {CHASE,WANDER,IDLE,LOOKING,DISABLED,INVESTIGATE}

var can_see_player = false
var last_seen_player
var footnum = 0
var state = DISABLED
var oldpos
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Global.bottleDrop.connect(on_sound_heard)
	oldpos = position
	return

func on_sound_heard(pos):
	if state == IDLE or state == WANDER:
		var sound_pos = NavigationServer3D.map_get_closest_point(navigation_agent_3d.get_navigation_map(), pos)
		SPEED = 6
		state = INVESTIGATE
		update_target_loc(sound_pos)
		print(sound_pos)
		print(pos)
	
func enable():
	
	if state == DISABLED:
		print("BRUH")
		state = IDLE
		$IdleTimer.start(1)
		$Jumpscare.play(0)

func _process(delta):
	
	
	if state == IDLE:
		$Neck/zombiewithanimations/AnimationPlayer.stop()
		return
	
	if state == WANDER:
		return
		
	if state == CHASE:
		if can_see_player:
			$Neck/zombiewithanimations/AnimationPlayer.play("Walk")
			#look_at(player.position)
			update_target_loc(player.position)
		else:
			pass
			
		return
	return

func _physics_process(delta):
		
	$AnimationPlayer.speed_scale = SPEED/3
	$Neck/zombiewithanimations/AnimationPlayer.speed_scale = SPEED/3
	if state != CHASE and state != INVESTIGATE:
		SPEED = 3
	else:
		
		SPEED += 0.001
	
	var cur_loc = global_transform.origin
	var next_loc = navigation_agent_3d.get_next_path_position()
	var new_vel = (next_loc - cur_loc).normalized() * SPEED
	
	if state != IDLE:
		velocity = new_vel
	else:
		velocity = Vector3.ZERO
	
	#print (velocity)
	
	if velocity == Vector3.ZERO:
		$AnimationPlayer.stop()
	else:
		$AnimationPlayer.play("walk")
	
	if state == CHASE:
		
		#$Neck.rotation.y = lerp_angle($Neck.rotation.y,  deg_to_rad(90)-(Vector2(next_loc.x, next_loc.z).angle_to_point(Vector2(position.x, position.z))), 0.1)
		if can_see_player:
			$To_Neck.look_at(next_loc)
			$Neck.rotation.y = lerp_angle($Neck.rotation.y, $To_Neck.rotation.y, 2 * delta)
			
	else:
		#var desired_rotation_y = atan2(cur_loc.y - next_loc.y, cur_loc.x - next_loc.x)
		if state != IDLE and state != DISABLED:
			$To_Neck.look_at(next_loc)
			$Neck.rotation.y = lerp_angle($Neck.rotation.y, $To_Neck.rotation.y, 2 * delta)
		
		#$Neck.rotation.y = lerp_angle($Neck.rotation.y, desired_rotation_y, 0.5 * delta)
		#$Neck.rotation.y = desired_rotation_y
		#print("current rot: ", $Neck.rotation.y, ". desired rot: ", desired_rotation_y)
	#self.rotation.y = lerp_angle(rotation.y,  deg_to_rad(90)-(Vector2(next_loc.x, next_loc.z).angle_to_point(Vector2(position.x, position.z))), 0.1)
	
	#Vector2(position.x, position.z).angle_to_point(Vector2(player.position.x, player.position.z))
	
	#self.look_at(player.position)
	
	move_and_slide()
	
#	if state != IDLE and state != DISABLED && oldpos == position:
#		print("stuck")
#		state = IDLE
#		$IdleTimer.start(0.5)
		
	oldpos = position
	
func update_target_loc(tar_loc):
	navigation_agent_3d.target_position = tar_loc
	
	$"../TargetPos".position = tar_loc
	#print(tar_loc, " : ", $"../TargetPos".position)


func _on_sight_body_entered(body):
	if body == player:
		print("player entered view")
		_on_raycast_timer_timeout()
	pass # Replace with function body.


func _on_sight_body_exited(body):
	if body == player:
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
		if SPEED == 3:
			SPEED = 6
		last_seen_player = player.position
		can_see_player = true
	else:
		can_see_player = false
		
	if state == CHASE && result.collider != player:
		update_target_loc(last_seen_player)
	$RaycastTimer.start(0.1)
	pass # Replace with function body.


func _on_footstep_timeout():
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(self.position, player.position)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	if result.collider == player:
		AudioServer.set_bus_effect_enabled(1,0, false)
	else:
		AudioServer.set_bus_effect_enabled(1,0, true)
	
	#print(AudioServer.get_bus_effect(1,0))
	#print(AudioServer.is_bus_effect_enabled(1,0))
	
	get_node("footstep" + str(footnum + 1)).play()
	footnum = (footnum + 1) % 2
	pass # Replace with function body.


func _on_navigation_agent_3d_target_reached():
	state = IDLE
	$IdleTimer.start(4)
	pass # Replace with function body.

func set_random_nav_target():
	var list = navigation_region_3d.navigation_mesh.get_vertices()
		
	while true:
		var target = list[(randi_range(0,list.size()-1))]
		target.y = 22.214
		if position.distance_to(target) > 10:
			update_target_loc(target)
			if navigation_agent_3d.is_target_reachable():
				break

func _on_idle_timer_timeout():
	if state == IDLE:
		print("wanderin..")
		state = WANDER
		set_random_nav_target()
	pass # Replace with function body.

func _on_detection_body_entered(body):
	print(body)
	print(player)
	if body == player:
		print("it works??")
		get_tree().root.queue_free()
	pass


