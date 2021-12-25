extends KinematicBody2D

export var id: String = '0'

const SPEED: int = 150
var velocity: Vector2 = Vector2(0.0, 0.0)
var body_direction: Vector2 = Vector2(0.0, 0.0)

const BULLETS: int = 16
var bullets: int = BULLETS setget set_bullets, get_bullets

const MAGAZINES: int = 3
var magazines: int = MAGAZINES setget set_magazines

const HEALTH: int = 10
var health: float = HEALTH setget set_health, get_health

onready var HealthBar0: ProgressBar = get_node("../../HUD/Health0")
onready var HealthBar1: ProgressBar = get_node("../../HUD/Health1")
onready var Magazine0: TextureProgress = get_node("../../HUD/Magazine0")
onready var Magazine1: TextureProgress = get_node("../../HUD/Magazine1")
onready var Magazines0: Label = get_node("../../HUD/Magazines0")
onready var Magazines1: Label = get_node("../../HUD/Magazines1")

onready var Feet = $Feet
onready var Body = $Body
onready var HandgunShoot = $HandgunShoot
onready var HandgunFailure = $HandgunFailure
onready var HandgunReload = $HandgunReload
onready var GunPosition = $Body/GunPosition
var Bullet = preload('res://player/Bullet.tscn')
var _Bullet = null
onready var Bullets = get_node('../../Bullets')

onready var PickupSound = $PickupSound


func _ready():
	Body.play('idle')

func _physics_process(_delta):
	velocity = Input.get_vector('l_left_'+id, 'l_right_'+id, 'l_up_'+id, 'l_down_'+id, 0.1)
	self.move_and_slide(velocity * SPEED)
	

func _process(_delta):
	if not(velocity.x == 0 and velocity.y == 0):
		Feet.set_rotation(velocity.angle())
		if (Body.get_animation() == 'idle'):
			Body.play('move')
	elif Body.get_animation() == 'move':
		Body.play('idle')
	body_direction = Input.get_vector('r_left_'+id, 'r_right_'+id, 'r_up_'+id, 'r_down_'+id, 0.1)
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
	if event.is_action_pressed('fire_'+id):
		if self.bullets == 0:
			HandgunFailure.play()
		else:
			self.bullets -= 1
			Body.play('shoot')
			HandgunShoot.play()
			_Bullet = Bullet.instance()
			_Bullet.set_global_position(GunPosition.get_global_position())
			_Bullet.set_rotation(Body.get_rotation())
			Bullets.add_child(_Bullet)
	if event.is_action_pressed('reload_'+id):
		if self.magazines > 0:
			Body.play('reload')
			HandgunReload.play()

func _on_Body_animation_finished():
	if Body.get_animation() == 'shoot':
		Body.play('idle')
	elif Body.get_animation() == 'reload':
		self.bullets = BULLETS
		self.magazines -= 1
		Body.play('idle')

func set_health(value):
	if value <= 0:
		health = 0
	elif value > HEALTH:
		health = HEALTH
	else:
		health = value
	if id == '0':
		HealthBar0.set_as_ratio(health/HEALTH)
	else:
		HealthBar1.set_as_ratio(health/HEALTH)

func get_health():
	return health

func set_bullets(value):
	bullets = value
	if id == '0':
		Magazine0.set_value(value)
	else:
		Magazine1.set_value(value)
		
func get_bullets():
	return bullets

func set_magazines(value):
	if id == '0':
		Magazines0.set_text(str(value) + ' X')
	else:
		Magazines1.set_text(str(value) + ' X')
	if value > magazines:
		PickupSound.play()
	magazines = value
