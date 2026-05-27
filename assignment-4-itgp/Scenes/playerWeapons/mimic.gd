extends CharacterBody2D

var health = 0.0
var damage = 0.0
var speed = 0.0
var target = null
var enemies_in_range = []
var can_attack = true
var is_attacking = false
var can_take_dmg = true
var health_max = 0.0
var player_ref = null
var is_dead = false
var is_respawning = false

func setup(player):
	player_ref = player
	health = player.health / 2.0
	health_max = health
	damage = player.damage / 2.0
	speed = player.baseSpeed / 2.0
	target = get_closest_enemy()
	#$AnimatedSprite2D.modulate = Color(1.0, 1.0, 1.0, 0.5)
	$healthbar.max_value = health_max
	$healthbar.value = health_max
	$healthbar.visible = false

func get_closest_enemy():
	var enemies = get_tree().get_nodes_in_group("enemy")
	var closest = null
	var closest_dist = INF
	for enemy in enemies:
		var dist = global_position.distance_to(enemy.global_position)
		if dist < closest_dist:
			closest_dist = dist
			closest = enemy
	return closest

func _process(delta: float) -> void:
	if not is_instance_valid(target):
		target = get_closest_enemy()

	if target and enemies_in_range.is_empty():
		var direction = (target.global_position - global_position).normalized()
		velocity = direction * speed
		if not is_attacking:
			$AnimatedSprite2D.flip_h = direction.x < 0
			if $AnimatedSprite2D.animation != "side_walking":
				$AnimatedSprite2D.play("side_walking")
	else:
		velocity = Vector2.ZERO
		if not is_attacking:
			if $AnimatedSprite2D.animation != "side_idle":
				$AnimatedSprite2D.play("side_idle")

	move_and_slide()

	if not enemies_in_range.is_empty() and can_attack:
		attack()

func attack():
	can_attack = false
	is_attacking = true
	if is_instance_valid(target):
		$AnimatedSprite2D.flip_h = (target.global_position.x - global_position.x) < 0
		$AnimatedSprite2D.play("side_atk")
	for enemy in enemies_in_range:
		if is_instance_valid(enemy):
			enemy.take_damage(0.5)
	$AttackTimer.start()

func _on_attack_timer_timeout():
	can_attack = true
	is_attacking = false

func _on_take_dmg_timeout() -> void:
	can_take_dmg = true
	modulate = Color(1.0, 1.0, 1.0, 1.0)
	$AnimatedSprite2D.modulate = Color(0.7, 1.0, 0.9, 0.5)

func update_health():
	$healthbar.value = health
	if health >= health_max:
		$healthbar.visible = false
	else:
		$healthbar.visible = true


func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemies_in_range.append(body)
		target = body

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	enemies_in_range.erase(body)

func recieveDamage(mult: float):
	take_damage(mult)


func die():
	if is_dead or is_respawning:
		return
	is_dead = true
	is_respawning = true
	$AnimatedSprite2D.play("death")
	set_physics_process(false)
	set_process(false)
	$healthbar.visible = false
	await get_tree().create_timer(0.5).timeout
	visible = false
	$respawntimer.start()

func _on_respawn_timeout() -> void:
	if not is_instance_valid(player_ref):
		return
	is_dead = false
	is_respawning = false
	health = player_ref.health / 2.0
	health_max = health
	$healthbar.max_value = health_max
	global_position = player_ref.global_position
	visible = true
	modulate = Color(1.0, 1.0, 1.0, 1.0)
	$AnimatedSprite2D.modulate = Color(1.0, 1.0, 1.0, 0.5)
	$AnimatedSprite2D.play("side_idle")
	set_physics_process(true)
	set_process(true)
	update_health()

func take_damage(mult: float):
	if not can_take_dmg or is_dead or is_respawning:
		return
	can_take_dmg = false
	health -= 10 * mult
	modulate = Color(1.0, 0.0, 0.0, 1.0)
	update_health()
	print("mimic health: ", health)
	$take_dmg.start()
	if health <= 0:
		die()

func levelUp():
	health_max = health_max * 1.2
	speed = speed * 1.2
