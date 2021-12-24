extends Area2D

const SPEED = 50

func _ready():
	pass

func _physics_process(delta):
	self.move_local_x(SPEED)


func _on_Bullet_body_entered(body):
	body.health -= 1
	self.queue_free()
