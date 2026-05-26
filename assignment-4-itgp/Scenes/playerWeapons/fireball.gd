extends Area2D

var damage = 2
var speed = 3

var enemiesInRadius = []

func _process(delta: float) -> void:
	position += global_transform.basis_xform(Vector2.RIGHT) * speed

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		for object in enemiesInRadius:
			object.take_damage(damage)
		get_parent().playExplosion(global_position)
		queue_free()


func _on_extinguish_timeout() -> void:
	queue_free()


func _on_explosion_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemiesInRadius.append(body)

func _on_explosion_radius_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemiesInRadius.erase(body)
