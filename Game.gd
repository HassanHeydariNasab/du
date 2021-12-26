extends Node2D

onready var viewport: Viewport = get_tree().get_root()

var PlayerMaterial0 = preload('res://player/PlayerMatrerial0.tres')

onready var Items = $Items
var Magazine = preload('res://items/Magazine.tscn')
var _Magazine: Area2D = null
var Health = preload('res://items/Health.tscn')
var _Health: Area2D = null

func _ready():
	$Players/Player0/Body.set_material(PlayerMaterial0)


func _on_MagazineTimer_timeout():
	_Magazine = Magazine.instance()
	_Magazine.set_global_position(
		Vector2(
			rand_range(0, viewport.get_size().x),
			rand_range(100, viewport.get_size().y)
		)
	)
	Items.add_child(_Magazine)


func _on_HealthTimer_timeout():
	_Health = Health.instance()
	_Health.set_global_position(
		Vector2(
			rand_range(0, viewport.get_size().x),
			rand_range(100, viewport.get_size().y)
		)
	)
	Items.add_child(_Health)


func _on_Rematch_pressed():
	self.get_tree().reload_current_scene()


func _on_Exit_pressed():
	self.get_tree().quit(0)
