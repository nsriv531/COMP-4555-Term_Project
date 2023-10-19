extends StaticBody3D

@export var noteImage:Texture2D

func interact(player):
	if noteImage:
		player.showNote(noteImage)
