extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.003
const INTERACT_DISTANCE = 3

const CAMERA_MAX_ANGLE = 80
const CAMERA_MIN_ANGLE = -80

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var shhh = $Effects/CanvasLayer/AnimatedSprite2D
@onready var throw_bar_container = $GUI/CanvasLayer/ThrowBarContainer
@onready var throw_bar = $GUI/CanvasLayer/ThrowBarContainer/ThrowBar

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var effects = $Effects
@onready var gui = $GUI
@onready var walkingsound = $WalkingSound
@onready var hands = $Head/Camera3D/Hands

var camera_pos
var cur_interactable = null
var camera_up = false
var currentHolding = null

var chargeThrowing = false
var charge = 0


func _ready():
	throw_bar.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera_pos = camera.position
	
func _unhandled_input(event):
	if event is InputEventMouseMotion and !gui.showingNote:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(CAMERA_MIN_ANGLE), deg_to_rad(CAMERA_MAX_ANGLE))
	
	if event is InputEventMouseButton && currentHolding is Bottle:
		if event.is_action_pressed("throw"):
			#currentHolding.throw()
			#currentHolding = null
			chargeThrowing = true
		elif event.is_action_released("throw"):
			chargeThrowing = false
			currentHolding.throw(charge)
			charge = 0
			throw_bar.visible = false
			currentHolding = null
			
		elif event.is_action("drop"):
			currentHolding.drop()
			currentHolding = null
			
		
func _process(_delta):
	
	if chargeThrowing:
		print(charge)
		throw_bar.visible = true
		charge += _delta * 50
		charge = clamp(charge,0,75)
		throw_bar.custom_minimum_size = Vector2(int(charge), 5)
		
		
	
	interact_raycast(INTERACT_DISTANCE)
	if gui.showingNote:
		if Input.is_action_just_pressed("interact") || Input.is_action_just_pressed("ui_cancel"):
			gui.hideNote()
			effects.hideBlur()
		return
	
	if Input.is_action_just_pressed("ui_cancel"):
			if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			else:	
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
	if Input.is_action_just_pressed("interact") && cur_interactable:
		cur_interactable.interact(self)
		
	if self.position.y <= 0:
		if shhh.frame == 0:
			shhh.play("default")
		
	pass
	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
#	# Add walking sound
	if is_on_floor() && not velocity.is_zero_approx():
#		if $WalkingSoundTimer.time_left <= 0:
#			$WalkingSound.pitch_scale = randf_range(0.8, 1.2)
#			$WalkingSound.play()
		#$Head/Camera3D/CameraAnim.get_animation("bob").loop_mode = 1
		$Head/Camera3D/CameraAnim.play("bob")
		camera_up = true
		
#			$WalkingSoundTimer.start(0.35)
	else:
		#print($Head/Camera3D/CameraAnim.current_animation_position)
		#if $Head/Camera3D/CameraAnim.current_animation_position >= 0.99:
		#$Head/Camera3D/CameraAnim.get_animation("bob").loop_mode = 0
		if(camera_up == true):
			camera_up = false
			$Head/Camera3D/CameraAnim.stop(true)
#			print(camera.position.y)
#			$Head/Camera3D/CameraAnim.get_animation("unbob").track_set_key_value(0,0,Vector3(0,camera.position.y,0))
#			#camera.position = camera.position.lerp(camera_pos, delta * 10)
#			$Head/Camera3D/CameraAnim.play("unbob")
	#		$WalkingSoundTimer.start(0.2)

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Vector3(0,0,0)
	
	if !gui.showingNote:
		var input_dir = Input.get_vector("left", "right", "forward", "back")
		direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 0.9)
		velocity.z = move_toward(velocity.z, 0, 0.9)

	move_and_slide()


func _on_timer_timeout():
	pass # Replace with function body.
	
func interact_raycast(distance):
		var space_state = get_world_3d().direct_space_state
		var from = camera.project_ray_origin(get_viewport().get_visible_rect().size / 2)
		var to = from + camera.project_ray_normal(get_viewport().get_visible_rect().size / 2) * distance
		var query = PhysicsRayQueryParameters3D.create(from,to,2)
		var result = space_state.intersect_ray(query)
		
		if result && result.collider.has_method("interact"):
			gui.crosshair_text_rect.texture.current_frame = 0
			cur_interactable = result.collider	
		else:
			gui.crosshair_text_rect.texture.current_frame = 1
			cur_interactable = null
	
func showNote(note:Texture2D):
	effects.showBlur()
	gui.showNote(note)

func playWalkSound():
	$WalkingSound.pitch_scale = randf_range(0.8, 1.2)
	$WalkingSound.play()
	
func setHolding(obj):
	currentHolding = obj
