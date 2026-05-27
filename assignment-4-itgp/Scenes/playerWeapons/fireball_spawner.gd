extends Node2D

var fireballScene = preload("res://Scenes/playerWeapons/fireball.tscn")
var explosion = preload("res://Scenes/particleSpawner.tscn")
var setCooldown = 1.5
var cooldownTimer = 0.0
var closestEnemy = null
var explosionRadius = 55.0

func _process(delta: float) -> void:
	cooldownTimer += delta
	if cooldownTimer >= setCooldown:
		cooldownTimer -= setCooldown
		spawnFireball()

func getClosestEnemy():
	var allEnemies = get_tree().get_nodes_in_group("enemy")
	closestEnemy = null
	var closestDistance = 99999999999
	
	for enemy in allEnemies:
		var enemyDistance = global_position.distance_to(enemy.global_position)
		if enemyDistance < closestDistance:
			closestDistance = enemyDistance
			closestEnemy = enemy

func spawnFireball():
	var fireballInstance = fireballScene.instantiate()
	getClosestEnemy()
	fireballInstance.global_position = global_position
	if closestEnemy == null:
		fireballInstance.rotation_degrees = randf_range(0.0, 360.0)
	else:
		fireballInstance.look_at(closestEnemy.global_position)
	fireballInstance.setBlastRadius(explosionRadius)
	add_child(fireballInstance)

func playExplosion(coords : Vector2):
	var kaboom = explosion.instantiate()
	add_child(kaboom)
	kaboom.global_position = coords
	kaboom.playParticle("explosion")

func levelUp():
	explosionRadius = explosionRadius * 1.1
