extends CharacterBody2D

var player_chase = false
var player = null  
var player_inattack_zone = false 
var can_take_dmg = true 
var isSquishy = false
var squishTimer = 0.0
var health = 80
var speed = 60
var dmg_taken_multiplier = 1.0 
var exp_multipler = 1.0

var setSpriteSheet : AnimatedSprite2D

@export_enum("Green", "Blue", "Purple", "Red")
var slime_type: String 


func _ready() -> void:
	slime_type = ["Green", "Green", "Green", "Blue", "Blue", "Purple", "Red"].pick_random()
	match slime_type:
		"Green":
			health = 80
			speed = 60
			dmg_taken_multiplier = 1.0 
			exp_multipler = 1.0
			scale = Vector2(1,1)
			setSpriteSheet = $greenSprites
		"Blue":
			health = 100
			speed = 75
			dmg_taken_multiplier = 0.9
			exp_multipler = 1.3
			scale = Vector2(1,1)
			setSpriteSheet = $blueSprites
		"Purple":
			health = 130
			speed = 85
			dmg_taken_multiplier = 0.8
			exp_multipler = 1.6
			scale = Vector2(2,2)
			setSpriteSheet = $purpleSprites
		"Red":
			health = 160
			speed = 95
			dmg_taken_multiplier = 0.7
			exp_multipler = 2.0
			scale = Vector2(1.5,1.5)
			setSpriteSheet = $redSprites
	
	setSpriteSheet.show()
	setSpriteSheet.play("walk")
	if randf_range(0,1) == 1:
		isSquishy = true
	

func _physics_process(delta):
	deal_with_damage()
	if player != null:
		position += Vector2(player.position - position).normalized() * speed * delta
		
		if(player.position.x - position.x) < 0:
			setSpriteSheet.flip_h = true 
		else:
			setSpriteSheet.flip_h = false 
	else:
		player = get_tree().get_first_node_in_group("player")
		
	move_and_slide()
	
	if isSquishy:
		squishTimer += delta
		setSpriteSheet.scale.x = 3.5 + sin(squishTimer * PI * (5.0/3.0))
		setSpriteSheet.scale.y = 3.5 - sin(squishTimer * PI * (5.0/3.0))

func enemy():
	pass

func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_zone = true 

func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_zone = false 

func deal_with_damage():
	if player_inattack_zone and global.player_current_attack == true: 
		if can_take_dmg == true:
			health = health - player.damage * dmg_taken_multiplier
			$take_dmg_cooldown.start() 
			can_take_dmg = false 
			print("slime health = ", health)
			if health <= 0:
				var player = get_tree().get_first_node_in_group("player")
				player.gainEXP(1 * exp_multipler)
				self.queue_free() 

func _on_take_dmg_cooldown_timeout():
	can_take_dmg = true 
