extends Node2D

var damage = 1.5
var speed = 20
var spinFactor = 1
var timeElapsed = 0.0

func _ready() -> void:
	rotation_degrees += randf_range(0, 360)
	if randi_range(0,1) == 1:
		spinFactor = -1

func _process(delta: float) -> void:
	rotation += delta * speed / 2 * spinFactor
	$pivotPoint.position.x += delta * speed * $Timer.time_left * 3
	timeElapsed += delta
	$pivotPoint/Area2D.scale = Vector2(timeElapsed, timeElapsed)

func _on_timer_timeout() -> void:
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.take_damage(damage * timeElapsed)
		#print("ball of light hit enemy")
		queue_free()
