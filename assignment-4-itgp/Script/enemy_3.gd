extends CharacterBody2D

var player_chase = false
var player = null  
var player_inattack_zone = false 
var can_take_dmg = true 
var health = 150
var speed = 60
var dmg_taken_multiplier = 0.6 
var exp_multipler = 2.0

var setSpriteSheet : AnimatedSprite2D

@export_enum("Brute")
var goblin_type: String 


func _ready() -> void:
	goblin_type = ["Brute"].pick_random()
	match goblin_type:
		"Brute":
			health = 150
			speed = 60
			dmg_taken_multiplier = 0.6
			exp_multipler = 2.0
			scale = Vector2(1.5,1.5)
			setSpriteSheet = $BruteSprites
		
	setSpriteSheet.show()
	setSpriteSheet.play("walk")


func _physics_process(delta):
	if player != null:
		position += Vector2(player.position - position).normalized() * speed * delta
		
		if(player.position.x - position.x) < 0:
			setSpriteSheet.flip_h = true 
		else:
			setSpriteSheet.flip_h = false 
	else:
		player = get_tree().get_first_node_in_group("player")
		
	move_and_slide()

func enemy():
	pass

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
