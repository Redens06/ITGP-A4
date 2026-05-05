extends CharacterBody2D

var speed = 65
var player_chase = false
var player = null  
var health = 80
var player_inattack_zone = false 
var can_take_dmg = true 

var isSquishy = false
var squishTimer = 0.0

func _ready() -> void:
	$AnimatedSprite2D.play("walk") 
	if randi() == 1:
		isSquishy = true

func _physics_process(delta):
	deal_with_damage()
	if player != null:
		position += Vector2(player.position - position).normalized() * speed * delta
		
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true 
		else:
			$AnimatedSprite2D.flip_h = false 
	else:
		player = get_tree().get_first_node_in_group("player") 
		
	move_and_slide()
	
	if isSquishy:
		squishTimer += delta
		$AnimatedSprite2D.scale.x = 3.5 + sin(squishTimer * PI * (5.0/3.0))
		$AnimatedSprite2D.scale.y = 3.5 - sin(squishTimer * PI * (5.0/3.0))

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
			health = health - 15 
			$take_dmg_cooldown.start() 
			can_take_dmg = false 
			print("slime health = ", health)
			if health <= 0:
				var player = get_tree().get_first_node_in_group("player")
				player.gainEXP(1)
				self.queue_free() 

func _on_take_dmg_cooldown_timeout():
	can_take_dmg = true 
