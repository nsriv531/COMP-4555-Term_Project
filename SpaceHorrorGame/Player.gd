extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.003
const INTERACT_DISTANCE = 3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var head = $Head
@onready var camera = $Head/Camera3D



@onready var crosshair = $Head/Camera3D/CenterContainer/Crosshair

var cur_interactable = null

func _ready():
	crosshair.texture.current_frame = 1
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
		interact_raycast(INTERACT_DISTANCE)
		
func _process(delta):
	
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:	
			get_tree().quit()
			
	if Input.is_action_just_pressed("interact") && cur_interactable:
		cur_interactable.interact()
		
	pass
	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
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
		var query = PhysicsRayQueryParameters3D.create(from,to)
		var result = space_state.intersect_ray(query)
		
		if result && result.collider.has_method("interact"):
			crosshair.texture.current_frame = 0
			cur_interactable = result.collider	
		else:
			crosshair.texture.current_frame = 1
			cur_interactable = null
	
