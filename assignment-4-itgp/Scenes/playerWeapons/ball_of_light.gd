extends Node2D

var damage = 1.5
var speed = 20

func _process(delta: float) -> void:
	rotation += delta * speed / 2
	$pivotPoint.position.x += delta * speed * $Timer.time_left * 3

func _on_timer_timeout() -> void:
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.take_damage(damage)
		print("ball of light hit enemy")
		queue_free()
