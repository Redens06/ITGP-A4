extends Node2D

var damage = 1.0
var orbit_speed = 90.0
var orbit_radius = 80.0
var bodies_in_range = []

func _ready() -> void:
	$pivotPoint.position = Vector2(orbit_radius, 0)
	$pivotPoint/SummonedSword.rotation_degrees = 90.0
	$DamageCooldown.timeout.connect(_on_damage_cooldown_timeout)

func _process(delta: float) -> void:
	rotation_degrees -= orbit_speed * delta

func _on_sswordhitbox_body_entered(body: Node2D) -> void:
	#print("hit: ", body.name)
	if body.is_in_group("enemy"):
		bodies_in_range.append(body)
		#print("enemy added: ", body.name)

func _on_sswordhitbox_body_exited(body: Node2D) -> void:
	bodies_in_range.erase(body)

func _on_damage_cooldown_timeout() -> void:
	#if bodies_in_range.size() > 0:
		#print("timer fired, enemies in range: ", bodies_in_range.size())
	for body in bodies_in_range:
		if body.is_in_group("enemy"):
			#print("dealing damage to: ", body.name)
			body.take_damage(damage)

func levelUp():
	orbit_speed = orbit_speed * 1.2
