extends Area2D

onready var FadeOut: Tween = $FadeOut
onready var Symbol: Sprite = $Symbol

func _ready():
	FadeOut.interpolate_property(
		Symbol, 'modulate', Color(1.0, 1.0, 1.0, 1.0),
		Color(1.0, 1.0, 1.0, 0.0), 0.1
	)


func _on_Health_body_entered(body):
	$CollisionShape2D.free()
	body.health += 1
	FadeOut.start()


func _on_FadeOut_tween_completed(object, key):
	if (key == ':modulate' and object == Symbol):
		queue_free()


func _on_TTL_timeout():
	FadeOut.start()
