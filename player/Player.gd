extends Node2D

const SPEED = 4
var axis0: float = 0.0
var axis1: float = 0.0

func _ready():
	pass

func _physics_process(delta):
	
	self.translate(Vector2(SPEED*axis0, SPEED*axis1))

func _process(delta):
	if (abs(axis0) > 0.99 or abs(axis1) > 0.99 or abs(axis0)+abs(axis1) > 1.99):
		$feet.play('run')
		print('run')
	elif (abs(axis0) > 0 or abs(axis1) > 0):
		$feet.play('walk')
		print('walk')


func _input(event):
	axis0 = Input.get_joy_axis(0, 0)
	axis1 = Input.get_joy_axis(0, 1)
#	if (-0.004 > _axis0 or _axis0 > 0.004):
#		axis0 = _axis0
#	if (-0.004 > _axis1 or _axis1 > 0.004):
#		axis1 = _axis1
	self.set_rotation(atan2(axis1, axis0))
	#print(event.as_text())

