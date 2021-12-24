extends Node2D

var Player = preload('res://player/Player.tscn')
var Player0 = null
var Player1 = null
onready var Players = $Players

func _ready():
	Player0 = Player.instance()
	Player1 = Player.instance()
	Player0.set_position(Vector2(300, 300))
	Player0.id = '0'
	Player1.id = '1'
	Players.add_child(Player0)
	Players.add_child(Player1)

