extends Node2D

const SPEED = 4
var velocity: Vector2 = Vector2(0.0, 0.0)
var body_direction: Vector2 = Vector2(0.0, 0.0)

onready var Feet = $Feet
onready var Body = $Body
onready var HandgunShoot = $HandgunShoot


func _ready():
	Body.play('idle')

func _physics_process(delta):
	velocity = Input.get_vector('l_left_0', 'l_right_0', 'l_up_0', 'l_down_0', 0.1)
	self.translate(velocity * SPEED)
	

func _process(delta):
	if not(velocity.x == 0 and velocity.y == 0):
		Feet.set_rotation(velocity.angle())
		if (Body.get_animation() == 'idle'):
			Body.play('move')
	body_direction = Input.get_vector('r_left_0', 'r_right_0', 'r_up_0', 'r_down_0', 0.1)
	if not(body_direction.x == 0 and body_direction.y == 0):
		Body.set_rotation(body_direction.angle())
	
	# feet animation
	if (abs(velocity.length()) > 0.99):
		Feet.play('run')
	elif (abs(velocity.x) > 0 or abs(velocity.y) > 0):
		Feet.play('walk')
	else:
		Feet.play('idle')

func _input(event):
	#print(event.as_text())
	if event.is_action_pressed('fire_0'):
		print('fire!')
		HandgunShoot.play()
		Body.play('shoot')


func _on_Body_animation_finished():
	if Body.get_animation() == 'shoot':
		Body.play('idle')
