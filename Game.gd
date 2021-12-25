extends Node2D

onready var viewport: Viewport = get_tree().get_root()

var PlayerMaterial0 = preload('res://player/PlayerMatrerial0.tres')
var Magazine = preload('res://items/Magazine.tscn')
onready var Items = $Items
var _Magazine: Area2D = null

func _ready():
	$Players/Player0/Body.set_material(PlayerMaterial0)



func _on_Timer_timeout():
	_Magazine = Magazine.instance()
	_Magazine.set_global_position(
		Vector2(
			rand_range(0, viewport.get_size().x),
			rand_range(0,viewport.get_size().y)
		)
	)
	Items.add_child(_Magazine)
	
