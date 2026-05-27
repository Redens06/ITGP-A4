extends Area2D

var damage = 1.5
var speed = 400
var pierce = 2


var enemiesInRadius = []

func _process(delta: float) -> void:
	position += global_transform.basis_xform(Vector2.RIGHT) * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.take_damage(damage)
		if pierce > 0:
			pierce -= 1
		else:
			queue_free()

func _on_thaw_timeout() -> void:
	queue_free()
