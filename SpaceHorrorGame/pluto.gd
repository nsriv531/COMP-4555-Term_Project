extends Node3D
@onready var resource_preloader = $ResourcePreloader

@onready var animation_player = $AnimationPlayer
@onready var muffle_effect = $MuffleEffect

var muffleEff
# Called when the node enters the scene tree for the first time.
func _ready():
	$Transition.play("fade in")
	
	muffleEff = AudioEffectLowPassFilter.new()
	muffleEff.cutoff_hz = 1000
	muffle_effect.hertz = 1000
	
	var unmuffleAnim = Animation.new()
	var track_index1 = unmuffleAnim.add_track(Animation.TYPE_VALUE)
	unmuffleAnim.track_set_path(track_index1, "MuffleEffect:hertz")
	
	unmuffleAnim.length = 5.0
	unmuffleAnim.track_insert_key(track_index1, 0.0, 1000)
	unmuffleAnim.track_insert_key(track_index1, 5.0, 20000)
	unmuffleAnim.loop_mode = Animation.LOOP_NONE

	var muffleAnim = Animation.new()
	var track_index2 = muffleAnim.add_track(Animation.TYPE_VALUE)
	muffleAnim.track_set_path(track_index2, "MuffleEffect:hertz")
	
	muffleAnim.length = 5.0
	muffleAnim.track_insert_key(track_index2, 0.0, 20000)
	muffleAnim.track_insert_key(track_index2, 5.0, 1000)
	muffleAnim.loop_mode = Animation.LOOP_NONE

	var animlib = AnimationLibrary.new()
	
	animlib.add_animation("unmuffle", unmuffleAnim)
	animlib.add_animation("muffle", muffleAnim)
	
	animation_player.add_animation_library("muffles", animlib)
	
	
	print(animation_player.get_animation_list())
	AudioServer.add_bus_effect(0,muffleEff)
	#animation_player.play("muffles/muffle")
	
	
	pass # Replace with function body.

func muffle():
	animation_player.play("muffles/muffle")
	
func unmuffle():
	animation_player.play("muffles/unmuffle")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	DebugDraw2D.clear_graphs()
	DebugDraw3D.draw_line($Player.position, $TargetPos.position, Color(1, 0, 0))
	
	muffleEff = AudioServer.get_bus_effect(0,0)
	muffleEff.set_cutoff(muffle_effect.hertz)
	
	#AudioServer.add_bus_effect(0,muffle,0)
	
	#print(AudioServer.get_bus_effect(0,0).cutoff_hz)
	pass
