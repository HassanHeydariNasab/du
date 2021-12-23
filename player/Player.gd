extends Node2D

const SPEED = 4
var velocity: Vector2 = Vector2(0.0, 0.0)
var body_direction: Vector2 = Vector2(0.0, 0.0)
const BULLETS: int = 16
var bullets: int = BULLETS

onready var Feet = $Feet
onready var Body = $Body
onready var HandgunShoot = $HandgunShoot
onready var HandgunFailure = $HandgunFailure
onready var HandgunReload = $HandgunReload
onready var GunPosition = $Body/GunPosition
var Bullet = preload('res://player/Bullet.tscn')
var _Bullet = null
onready var Bullets = get_node('../Bullets')


func _ready():
	Body.play('idle')

func _physics_process(_delta):
	velocity = Input.get_vector('l_left_0', 'l_right_0', 'l_up_0', 'l_down_0', 0.1)
	self.translate(velocity * SPEED)
	

func _process(_delta):
	if not(velocity.x == 0 and velocity.y == 0):
		Feet.set_rotation(velocity.angle())
		if (Body.get_animation() == 'idle'):
			Body.play('move')
	elif Body.get_animation() == 'move':
		Body.play('idle')
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
		if bullets == 0:
			HandgunFailure.play()
		else:
			bullets -= 1
			Body.play('shoot')
			HandgunShoot.play()
			_Bullet = Bullet.instance()
			_Bullet.set_global_position(GunPosition.get_global_position())
			_Bullet.set_rotation(Body.get_rotation())
			Bullets.add_child(_Bullet)
	if event.is_action_pressed('reload_0'):
		Body.play('reload')
		HandgunReload.play()

func _on_Body_animation_finished():
	if Body.get_animation() == 'shoot':
		Body.play('idle')
	elif Body.get_animation() == 'reload':
		bullets = BULLETS
		Body.play('idle')
