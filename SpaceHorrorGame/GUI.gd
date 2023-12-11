extends Control

@onready var note_text_rect = $CanvasLayer/NoteTextRect
@onready var crosshair_text_rect = $CanvasLayer/CrosshairContainer/CrosshairTextRect

var showingNote = false

# Called when the node enters the scene tree for the first time.
func _ready():
	hideNote()
	crosshair_text_rect.texture.current_frame = 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func showNote(note):
	showingNote = true;
	note_text_rect.visible = true
	note_text_rect.texture = note

func hideNote():
	showingNote = false;
	note_text_rect.visible = false
