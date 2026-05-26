extends CharacterBody2D
var baseSpeed = 250
var curSpeed = 250
var current_dir = "none"
var start_position
var player_alive = true 
var enemy_inattack_range = false
var enemies_in_range = []
var enemy_attack_cooldown = true 
var health = 175.0
var maxHP = 175.0
var damage = 25
var attack_ip = false 
var dodgeCooldown = 1.0
var dodgeCountdown = 0.0

var exp = 0
var level = 1
var nextLevel = 50

var fireballSpawner = preload("res://Scenes/playerWeapons/fireballSpawner.tscn")
var lightSpawner = preload("res://Scenes/playerWeapons/ballOfLightSpawner.tscn")
var summonedsword = preload("res://Scenes/playerWeapons/SummonedSword.tscn")
var hasSword = false

func _ready():
	start_position = global_position
	$AnimatedSprite2D.play("front_idle")
	$Camera2D/CanvasLayer/EXPbar.max_value = nextLevel

func _physics_process(delta):
	_playermovement(delta)
	
	if Input.is_action_just_pressed("dodge"):
		if dodgeCountdown <= 0:
			dodgeCountdown = dodgeCooldown
			dodgeRoll()
	
	if dodgeCountdown > 0:
		dodgeCountdown -= delta
		if dodgeCountdown <= dodgeCooldown / 2:
			curSpeed = baseSpeed
			set_collision_layer_value(1, true)
			set_collision_mask_value(2, true)
			$AnimatedSprite2D.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	update_health()
	if health <= 0:
		player_alive = false
		health = 0
		get_tree().change_scene_to_file("res://titleScreen.tscn")

 
func _playermovement(delta):
	if dodgeCountdown <= dodgeCooldown / 2:
		velocity = Vector2.ZERO
		if Input.is_action_pressed("ui_right"):
			current_dir = "right"
			play_anim(1)
			velocity.x += 1
			velocity.y += 0
		if Input.is_action_pressed("ui_left"):
			current_dir = "left"
			play_anim(1)
			velocity.x += -1
			velocity.y += 0
		if Input.is_action_pressed("ui_up"):
			if velocity.x == 0:
				current_dir = "up"
				play_anim(1)
			velocity.y += -1
			velocity.x += 0
		if Input.is_action_pressed("ui_down"):
			if velocity.x == 0:
				current_dir = "down"
				play_anim(1)
			velocity.y += 1
			velocity.x += 0
	if velocity == Vector2.ZERO:
		play_anim(0)
	else:
		velocity = velocity.normalized() * curSpeed
	move_and_slide()

func dodgeRoll():
	set_collision_layer_value(1, false)
	set_collision_mask_value(2, false)
	$AnimatedSprite2D.self_modulate = Color(1.0, 1.0, 1.0, 0.451)
	curSpeed = baseSpeed * 2

func play_anim(movement):
	var anim = $AnimatedSprite2D
	if current_dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walking")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	if current_dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walking")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	if current_dir == "down":
		anim.flip_h = true
		if movement == 1:
			anim.play("front_walking")
		elif movement == 0:
			if attack_ip == false:
				anim.play("front_idle")
	if current_dir == "up":
		anim.flip_h = true
		if movement == 1:
			anim.play("back_walking")
		elif movement == 0 :
			if attack_ip == false:
				anim.play("back_idle")


func _on_player_hitbox_body_entered(body):
	if body.is_in_group("enemy"):
		#print("enemy entered")
		enemies_in_range.append(body)
		enemy_inattack_range = true
	#else:
		#print("not an enemy")

func _on_player_hitbox_body_exited(body):
	if body.is_in_group("enemy"):
		enemies_in_range.erase(body)
		if enemies_in_range.size() <= 0:
			enemy_inattack_range = false

func recieveDamage(mult : float): 
	health -= 10 * mult
	enemy_attack_cooldown = false
	update_health()
	#print(health)

func _on_atk_cd_timeout():
	if enemy_inattack_range and attack_ip == false and dodgeCountdown <= dodgeCooldown / 2:
		attack() #if an enemy is in range, you aren't already attacking, and you arent dodging

func attack():
	#print("ATTACK!")
	global.player_current_attack = true 
	attack_ip = true
	if current_dir == "right":
		$AnimatedSprite2D.flip_h = false 
		$AnimatedSprite2D.play("side_atk")
		$deal_atk_timer.start()
	elif current_dir == "left":
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("side_atk")
		$deal_atk_timer.start()
	elif current_dir == "up":
		$AnimatedSprite2D.play("back_atk")
		$deal_atk_timer.start()
	else:
		$AnimatedSprite2D.play("front_atk")
		$deal_atk_timer.start()
	
	for enemy in enemies_in_range:
		#print("hit an ememy")
		enemy.take_damage(1)
		if not $Attacksound.playing:
			$Attacksound.play()

func _on_deal_atk_timer_timeout():
	$deal_atk_timer.stop()
	global.player_current_attack = false 
	attack_ip = false 

func update_health():
	$healthbar.value = health
	if health >= 175:
		$healthbar.visible = false
	else:
		$healthbar.visible = true

func _on_regen_timeout():
	if health < 175:
		health = health + 10
		if health > 175:
			health = 175 
	if health <= 0:
		health = 0 

func _on_auto_atk_timer_timeout():
	if enemy_inattack_range and attack_ip == false:
		attack()




func gainEXP(value : int):
	exp += value
	if exp >= nextLevel:
		level += 1
		damage + 2
		
		$Camera2D/CanvasLayer/LevelUpUI.createOptions()
		if $Camera2D/CanvasLayer/GPUParticles2D.emitting == false:
			$Camera2D/CanvasLayer/GPUParticles2D.emitting = true
		get_tree().paused = true
		
		exp = 0
		health += (maxHP - health) / 2
		nextLevel = ceil(nextLevel * 1.2)
		$Camera2D/CanvasLayer/EXPbar.max_value = nextLevel
		$Camera2D/CanvasLayer/LevelLabel.text = "Level " + str(level)
	
	$Camera2D/CanvasLayer/expLabel.text = str(exp) + "/" + str(nextLevel)
	$Camera2D/CanvasLayer/EXPbar.value = exp

func gainWeapon(weapon : String):
	match weapon:
		"fireball":
			add_child(fireballSpawner.instantiate())
			print("player gained fireball")
		"lightOrb":
			add_child(lightSpawner.instantiate())
			print("player gained light orb")
		"sword":
			#if hasSword:
			#	return
			#hasSword = true
			var sword = summonedsword.instantiate()
			add_child(sword)
			print("player gained sword")
	
	if $Camera2D/CanvasLayer/GPUParticles2D.emitting == true:
		$Camera2D/CanvasLayer/GPUParticles2D.emitting = false
