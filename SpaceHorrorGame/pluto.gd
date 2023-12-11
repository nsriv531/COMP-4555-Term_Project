extends Node3D
@onready var resource_preloader = $ResourcePreloader

@onready var animation_player = $AnimationPlayer
@onready var muffle_effect = $MuffleEffect
@onready var death_menu = preload("res://death menu.tscn")
var muffleEff
# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	
	$Transition.play("fade in")
	
	muffleEff = AudioEffectLowPassFilter.new()
	muffleEff.resonance = 0.1
	muffleEff.cutoff_hz = 800
	muffle_effect.hertz = 800
	
	var unmuffleAnim = Animation.new()
	var track_index1 = unmuffleAnim.add_track(Animation.TYPE_VALUE)
	unmuffleAnim.track_set_path(track_index1, "MuffleEffect:hertz")
	
	unmuffleAnim.length = 5.0
	unmuffleAnim.track_insert_key(track_index1, 0.0, 800)
	unmuffleAnim.track_insert_key(track_index1, 5.0, 20000)
	unmuffleAnim.loop_mode = Animation.LOOP_NONE

	var muffleAnim = Animation.new()
	var track_index2 = muffleAnim.add_track(Animation.TYPE_VALUE)
	muffleAnim.track_set_path(track_index2, "MuffleEffect:hertz")
	
	muffleAnim.length = 5.0
	muffleAnim.track_insert_key(track_index2, 0.0, 20000)
	muffleAnim.track_insert_key(track_index2, 5.0, 800)
	muffleAnim.loop_mode = Animation.LOOP_NONE

	var animlib = AnimationLibrary.new()
	
	animlib.add_animation("unmuffle", unmuffleAnim)
	animlib.add_animation("muffle", muffleAnim)
	
	animation_player.add_animation_library("muffles", animlib)
	
	
	print(animation_player.get_animation_list())
	if AudioServer.get_bus_effect_count(0) == 0:
		AudioServer.add_bus_effect(0,muffleEff)
	#animation_player.play("muffles/muffle")
	
	AudioServer.set_bus_mute(1, true)
	
	#print(AudioServer.bus_count)
	
	pass # Replace with function body.

func muffle():
	AudioServer.set_bus_mute(1, true)
	animation_player.play("muffles/muffle")
	
func unmuffle():
	AudioServer.set_bus_mute(1, false)
	animation_player.play("muffles/unmuffle")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#DebugDraw2D.clear_graphs()
	#DebugDraw3D.draw_line($Player.position, $TargetPos.position, Color(1, 0, 0))
	
	muffleEff = AudioServer.get_bus_effect(0,0)
	muffleEff.set_cutoff(muffle_effect.hertz)
	
	#AudioServer.add_bus_effect(0,muffle,0)
	
	#print(AudioServer.get_bus_effect(0,0).cutoff_hz)
	pass

func death():
	get_tree().root.add_child(death_menu.instantiate())
	get_tree().root.remove_child(self)

