extends Area2D

const SPEED = 50

func _ready():
	pass

func _physics_process(delta):
	self.move_local_x(SPEED)
