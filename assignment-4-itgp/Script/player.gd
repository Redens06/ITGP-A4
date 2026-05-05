extends CharacterBody2D

const speed = 200
var current_dir = "none"
var start_position
var player_alive = true 
var enemy_inattack_range = false
var enemy_attack_cooldown = true 
var health = 175
var attack_ip = false 

func _ready():
	start_position = global_position
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta):
	_playermovement(delta)
	enemy_attack()
	if enemy_inattack_range and attack_ip == false:
		attack()

	update_health()
	if health <= 0:
		player_alive = false
		health = 0
		print("player has been killed")
		print("press r to respawn")
		self.queue_free()

 
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
	var dir = current_dir
	var anim = $AnimatedSprite2D
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walking")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walking")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	if dir == "down":
		anim.flip_h = true
		if movement == 1:
			anim.play("front_walking")
		elif movement == 0:
			if attack_ip == false:
				anim.play("front_idle")
	if dir == "up":
		anim.flip_h = true
		if movement == 1:
			anim.play("back_walking")
		elif movement == 0 :
			if attack_ip == false:
				anim.play("back_idle")


func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true 

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false 

func enemy_attack(): 
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - 10
		enemy_attack_cooldown = false 
		$atk_cd.start() 
		print(health)
		
func _on_atk_cd_timeout():
	enemy_attack_cooldown = true 

func player():
	pass 
	
func attack():
	var dir = current_dir
	global.player_current_attack = true 
	attack_ip = true
	if dir == "right":
		$AnimatedSprite2D.flip_h = false 
		$AnimatedSprite2D.play("side_atk")
		$deal_atk_timer.start()
	if dir == "left":
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("side_atk")
		$deal_atk_timer.start()
	if dir == "down":
		$AnimatedSprite2D.play("front_atk")	
		$deal_atk_timer.start()
	if dir == "up":
		$AnimatedSprite2D.play("back_atk")	
		$deal_atk_timer.start()	

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
