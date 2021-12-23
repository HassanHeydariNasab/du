extends Node2D

const SPEED = 4
var velocity: Vector2 = Vector2(0.0, 0.0)

func _ready():
	pass

func _physics_process(delta):
	velocity = Input.get_vector('left0', 'right0', 'up0', 'down0', 0.1)
	self.translate(velocity * SPEED)
	

func _process(delta):
	if not(velocity.x == 0 and velocity.y == 0):
		self.set_rotation(atan2(velocity.y, velocity.x))
	if (abs(velocity.length()) > 0.99):
		$feet.play('run')
	elif (abs(velocity.x) > 0 or abs(velocity.y) > 0):
		$feet.play('walk')
	else:
		$feet.play('idle')


func _input(event):
	pass
	#print(event.as_text())

