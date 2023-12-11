class_name Bottle
extends RigidBody3D

var holding = false
var player = null
var state
var impacted = true

enum {HOLDING,DROPPED,THROWN}

# Called when the node enters the scene tree for the first time.
func _ready():
	state = DROPPED
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (state == HOLDING):
		self.position = player.hands.global_position
		self.rotation = player.hands.global_rotation
	pass


func _on_body_entered(body):
	if $BottleAudio.playing == false && state != HOLDING && impacted == false:
		impacted = true
		$BottleAudio.play(0)
		Global.bottleDrop.emit(self.global_position)
	pass # Replace with function body.
	
func interact(player):
	$BottleAudio.stop()
	self.player = player
	#self.freeze = true
	impacted = false
	self.state = HOLDING
	
	player.setHolding(self)

func throw(charge):
	#self.freeze = false
	#player.camera.get_global_transform().basis.z
	self.linear_velocity = player.camera.get_global_transform().basis.z * -charge/4.0
	state = THROWN
	pass

func drop():
	#self.freeze = false
	self.linear_velocity = Vector3(0,-1,0)
	state = DROPPED
	pass
