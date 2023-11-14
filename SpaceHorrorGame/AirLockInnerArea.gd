extends Area3D
var airSound = preload("res://Sounds/Air.ogg")
var isReady:bool = true
var audioStream

@onready var airlock_sound_player = $AirlockSoundPlayer

var doorArr = []

@export var door1:Node3D = null
@export var door2:Node3D = null
@export var airlockMesh:Node3D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	doorArr.resize(2)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if (isReady):
		
		if door1.open == true:
			Global.Pluto.unmuffle()
		else:
			Global.Pluto.muffle()
			
		isReady = false

		doorArr[int(door1.open)] = door1
		doorArr[int(door2.open)] = door2
		
		doorArr[1].onButtonPress()
		
		
		airlock_sound_player.play()
	pass # Replace with function body.

func _on_audio_finished():
	isReady = true
	doorArr[0].onButtonPress()
	airlockMesh.changeColor(Color(0,1,0))
	
