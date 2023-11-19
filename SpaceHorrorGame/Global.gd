extends Node

var plutoInst = preload("res://pluto.tscn")
var Pluto

# Called when the node enters the scene tree for the first time.
func _ready():
	Pluto = plutoInst.instantiate()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
