extends KinematicBody2D

export var id: String = '0' setget set_id

const SPEED: int = 150
var velocity: Vector2 = Vector2(0.0, 0.0)
var body_direction: Vector2 = Vector2(0.0, 0.0)

const BULLETS: int = 16
var bullets: int = BULLETS setget set_bullets, get_bullets

const MAGAZINES: int = 2
var magazines: int = MAGAZINES setget set_magazines

const HEALTH: int = 100
var health: float = HEALTH setget set_health, get_health

onready var HealthBar0: ProgressBar = get_node("/root/Game/HUD/Health0")
onready var HealthBar1: ProgressBar = get_node("/root/Game/HUD/Health1")
onready var Magazine0: TextureProgress = get_node("/root/Game/HUD/Magazine0")
onready var Magazine1: TextureProgress = get_node("/root/Game/HUD/Magazine1")
onready var Magazines0: Label = get_node("/root/Game/HUD/Magazines0")
onready var Magazines1: Label = get_node("/root/Game/HUD/Magazines1")

onready var Feet: AnimatedSprite = $Feet
onready var Body: AnimatedSprite = $Body
onready var HandgunShoot: AudioStreamPlayer = $HandgunShoot
onready var HandgunFailure: AudioStreamPlayer = $HandgunFailure
onready var HandgunReload: AudioStreamPlayer = $HandgunReload
onready var GunPosition = $Body/GunPosition
var Bullet = preload('res://player/Bullet.tscn')
var _Bullet = null
onready var Bullets = get_node('/root/Game/Bullets')

onready var PickupSound: AudioStreamPlayer = $PickupSound
onready var HealingSound: AudioStreamPlayer = $HealingSound
onready var HurtSounds: Array = [
	$HurtSound1, $HurtSound2, $HurtSound3,
	$HurtSound4, $HurtSound5, $HurtSound6,
	$HurtSound7
]
var random_HurtSound: AudioStreamPlayer = null


onready var Menu: Panel = get_node("/root/Game/HUD/Menu")
onready var Winner: Label = get_node("/root/Game/HUD/Menu/Winner")


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


func set_id(value):
	id = value


func set_health(value):
	if value > health:
		HealingSound.play()
	elif value < health:
		random_HurtSound = HurtSounds[randi() % 7]
		if (self.id == '1'):
			(random_HurtSound as AudioStreamPlayer).set_pitch_scale(2)
		random_HurtSound.play()
	if value <= 0:
		health = 0
		if self.id == '1':
			Winner.set_text('Terrorist Wins!')
		else:
			Winner.set_text('Police Wins!')
		Menu.set_visible(true)
		queue_free()
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
