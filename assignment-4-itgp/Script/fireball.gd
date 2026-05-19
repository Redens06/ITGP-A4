extends Area2D

var damage = 10
var speed = 3

func _process(delta: float) -> void:
	position += global_transform.basis_xform(Vector2.RIGHT) * speed

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.take_damage(200)
		queue_free()


func _on_extinguish_timeout() -> void:
	queue_free()
