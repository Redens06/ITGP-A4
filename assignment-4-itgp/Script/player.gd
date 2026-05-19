extends CharacterBody2D

const speed = 200
var current_dir = "none"
var start_position
var player_alive = true 
var enemy_inattack_range = false
var enemies_in_range = []
var enemy_attack_cooldown = true 
var health = 175
var maxHP = 175
var damage = 10
var attack_ip = false 

var exp = 0
var level = 1
var nextLevel = 50

var fireballSpawner = preload("res://Scenes/playerWeapons/fireballSpawner.tscn")
var lightSpawner = preload("res://Scenes/playerWeapons/ballOfLightSpawner.tscn")
var summonedsword = preload("res://Scenes/playerWeapons/SummonedSword.tscn")

func _ready():
	start_position = global_position
	$AnimatedSprite2D.play("front_idle")
	$Camera2D/CanvasLayer/EXPbar.max_value = nextLevel

func _physics_process(delta):
	_playermovement(delta)
	
	update_health()
	if health <= 0:
		player_alive = false
		health = 0
		get_tree().change_scene_to_file("res://titleScreen.tscn")

 
func _playermovement(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x += speed
		velocity.y += 0
	if Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x += -speed
		velocity.y += 0
	if Input.is_action_pressed("ui_down"):
		if velocity.x == 0:
			current_dir = "down"
			play_anim(1)
		velocity.y += speed
		velocity.x += 0
	if Input.is_action_pressed("ui_up"):
		if velocity.x == 0:
			current_dir = "up"
			play_anim(1)
		velocity.y += -speed
		velocity.x += 0
	if velocity == Vector2.ZERO:
		play_anim(0)
	move_and_slide()


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

func enemy_attack(): 
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - 10
		enemy_attack_cooldown = false 
		$atk_cd.start() 
		#print(health)

func _on_atk_cd_timeout():
	if enemy_inattack_range and attack_ip == false:
		attack()

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
	var healthbar = $healthbar
	healthbar.value = health
	
	if health >= 175:
		healthbar.visible = false
	else:
		healthbar.visible = true

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
		match randi_range(1, 2):
			1:
				add_child(fireballSpawner.instantiate())
			2:
				add_child(lightSpawner.instantiate())
		exp = 0
		health += (maxHP - health) / 2
		nextLevel = ceil(nextLevel * 1.2)
		$Camera2D/CanvasLayer/EXPbar.max_value = nextLevel
		$Camera2D/CanvasLayer/LevelLabel.text = "Level " + str(level)
	
	$Camera2D/CanvasLayer/expLabel.text = str(exp) + "/" + str(nextLevel)
	$Camera2D/CanvasLayer/EXPbar.value = exp
