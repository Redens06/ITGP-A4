extends CharacterBody2D

var player_chase = false
var player = null  
var player_inattack_zone = false 
var can_take_dmg = true 
var health = 70
var speed = 100
var dmg_taken_multiplier = 1.0 
var exp_multipler = 1.0

var setSpriteSheet : AnimatedSprite2D

var spawnTime = 0.0

@export_enum("Regular", "General",)
var goblin_type: String 


func _ready() -> void:
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
			setSpriteSheet = $RegSprites
		"General":
			health = 80
			speed = 100
			dmg_taken_multiplier = 0.9
			exp_multipler = 1.4
			scale = Vector2(1.15,1.15)
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
	
	move_and_slide()

func _on_enemy_hitbox_body_entered(body):
	if body == player:
		player_inattack_zone = true 

func _on_enemy_hitbox_body_exited(body):
	if body == player:
		player_inattack_zone = false 

func take_damage(mult: float):
	if can_take_dmg == true:
		health = health - player.damage * dmg_taken_multiplier * mult
		$take_dmg_cooldown.start() 
		can_take_dmg = false 
		print("slime health = ", health)
		if health <= 0:
			player.gainEXP(10 * exp_multipler)
			self.queue_free() 

func _on_take_dmg_cooldown_timeout():
	can_take_dmg = true 
