extends CharacterBody2D

var player_chase = false
var player = null  
var player_inattack_zone = false 
var can_take_dmg = true 
var isSquishy = false
var squishTimer = 0.0
var health = 40
var speed = 95
var dmg_taken_multiplier = 1.0
var attackCooldown = 1.0 #the cooldown that the below gets reset to
var attackCountdown = 1.0 #the value that gets ticked down over time, resets to above
var attackPower = 1.0
var exp_multipler = 1.0
var mimic_inattack_zone = false
var mimic_ref = null

var setSpriteSheet : AnimatedSprite2D

var spawnTime = 0.0
@export_enum("Slime", "Goblin")
var enemyType: String
@export_enum("Green", "Blue", "Purple", "Red")
var slime_type: String 
@export_enum("Regular", "General")
var goblin_type: String 


func _ready() -> void:
	if enemyType == "Slime":
		match true:
			_ when spawnTime < 30:
				slime_type = ["Green", "Green", "Green", "Blue"].pick_random()
			_ when spawnTime < 60:
				slime_type = ["Green", "Blue", "Blue", "Purple"].pick_random()
			_ when spawnTime >= 60:
				slime_type = ["Green", "Green", "Blue", "Blue", "Purple", "Red"].pick_random()
		
		#slime_type = ["Green", "Green", "Green", "Blue", "Blue", "Purple", "Red"].pick_random()
		match slime_type:
			"Green":
				health = 80
				speed = 95
				dmg_taken_multiplier = 1.0
				attackPower = 1.0
				exp_multipler = 1.0
				scale = Vector2(1,1)
				setSpriteSheet = $greenSprites
				$hitParticles.modulate = Color(0.498, 0.941, 0.569, 1.0)
			"Blue":
				health = 100
				speed = 85
				dmg_taken_multiplier = 0.9
				attackPower = 1.2
				exp_multipler = 1.3
				scale = Vector2(1.15,1.15)
				setSpriteSheet = $blueSprites
				$hitParticles.modulate = Color(0.396, 0.694, 0.722)
			"Purple":
				health = 130
				speed = 75
				dmg_taken_multiplier = 0.8
				attackPower = 1.5
				exp_multipler = 1.6
				scale = Vector2(1.5,1.5)
				setSpriteSheet = $purpleSprites
				$hitParticles.modulate = Color(0.812, 0.361, 0.784, 1.0)
			"Red":
				health = 160
				speed = 60
				dmg_taken_multiplier = 0.7
				attackPower = 2.0
				exp_multipler = 2.0
				scale = Vector2(2,2)
				setSpriteSheet = $redSprites
				$hitParticles.modulate = Color(0.976, 0.349, 0.361, 1.0)
		
		setSpriteSheet.show()
		setSpriteSheet.play("walk")
		if randf_range(0,1) == 1:
			isSquishy = true
	elif enemyType == "Goblin":
		match true:
			_ when spawnTime < 30:
				goblin_type = ["Regular", "Regular", "Regular", "Regular", "General",].pick_random()
			_ when spawnTime < 60:
				goblin_type = ["Regular", "Regular", "Regular", "General", "General",].pick_random()
			_ when spawnTime >= 60:
				goblin_type = ["Regular", "Regular", "Regular", "General", "General", "General"].pick_random()
		
		#goblin_type = ["Regular", "Regular", "Regular", "General", "General",].pick_random()
		match goblin_type:
			"Regular":
				health = 70
				speed = 105
				dmg_taken_multiplier = 1.1
				exp_multipler = 1.2
				scale = Vector2(1,1)
				attackPower = 1.0
				setSpriteSheet = $RegSprites
			"General":
				health = 80
				speed = 100
				dmg_taken_multiplier = 0.9
				exp_multipler = 1.4
				scale = Vector2(1.15,1.15)
				attackPower = 1.0
				setSpriteSheet = $GeneralSprites
		
		setSpriteSheet.show()
		setSpriteSheet.play("walk")

func _physics_process(delta):
	if player != null:
		velocity = Vector2(player.position - position).normalized() * speed
		if(player.position.x - position.x) < 0:
			setSpriteSheet.flip_h = true 
		else:
			setSpriteSheet.flip_h = false 
	else:
		player = get_tree().get_first_node_in_group("player")
		#print("finding player")
	
	move_and_slide()
	
	if isSquishy:
		squishTimer += delta
		setSpriteSheet.scale.x = 3.5 + sin(squishTimer * PI * (5.0/3.0))
		setSpriteSheet.scale.y = 3.5 - sin(squishTimer * PI * (5.0/3.0))

func _on_enemy_hitbox_body_entered(body):
	if body == player:
		player_inattack_zone = true
	elif body.is_in_group("mimic"):
		mimic_inattack_zone = true
		mimic_ref = body

func _on_enemy_hitbox_body_exited(body):
	if body == player:
		player_inattack_zone = false
	elif body.is_in_group("mimic"):
		mimic_inattack_zone = false
		mimic_ref = null

func _process(delta: float) -> void:
	if player != null and player_inattack_zone == true:
		if attackCountdown <= 0:
			player.recieveDamage(attackPower)
			attackCountdown = attackCooldown
			if enemyType == "Goblin":
				setSpriteSheet.play("atk")
		else:
			attackCountdown -= delta
			if enemyType == "Goblin":
				if not setSpriteSheet.animation == "atk":
					setSpriteSheet.play("walk")
	
	if mimic_inattack_zone == true and is_instance_valid(mimic_ref):
		if attackCountdown <= 0:
			mimic_ref.take_damage(attackPower)
			attackCountdown = attackCooldown
			if enemyType == "Goblin":
				setSpriteSheet.play("atk")
		else:
			attackCountdown -= delta
			if enemyType == "Goblin":
				if not setSpriteSheet.animation == "atk":
					setSpriteSheet.play("walk")

func take_damage(mult: float):
	if can_take_dmg == true:
		var damageDealt = player.damage * dmg_taken_multiplier * mult
		if enemyType == "Slime":
			scale = (scale * 3)/4 + (((health - damageDealt)/health)*scale)/4
		health = health - damageDealt
		$take_dmg_cooldown.start() 
		modulate = Color(1.0, 0.0, 0.0, 1.0)
		$hitParticles.amount = ceil(mult * 2)
		$hitParticles.emitting = true
		can_take_dmg = false 
		#print(enemyType, " health = ", health)
		if health <= 0:
			player.gainEXP(10 * exp_multipler)
			self.queue_free() 

func _on_take_dmg_cooldown_timeout():
	can_take_dmg = true 
	modulate = Color(1.0, 1.0, 1.0, 1.0)
