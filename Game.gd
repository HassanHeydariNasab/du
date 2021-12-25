extends Node2D

var PlayerMaterial0 = preload('res://player/PlayerMatrerial0.tres')

func _ready():
	$Players/Player0/Body.set_material(PlayerMaterial0)

