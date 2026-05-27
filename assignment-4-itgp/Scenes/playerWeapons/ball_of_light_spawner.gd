extends Node2D

var lightScene = preload("res://Scenes/playerWeapons/ballOfLight.tscn")
var particleSpawn = preload("res://Scenes/particleSpawner.tscn")
var setCooldown = 3.0
var cooldownTimer = 0.0

func _process(delta: float) -> void:
	cooldownTimer += delta
	if cooldownTimer >= setCooldown:
		cooldownTimer -= setCooldown
		spawnLight()

func spawnLight():
	var lightInstance = lightScene.instantiate()
	add_child(lightInstance)
	lightInstance.rotation_degrees = randf_range(0.0, 360.0)

func playShatter(coords : Vector2, orbSize : Vector2):
	var smash = particleSpawn.instantiate()
	add_child(smash)
	smash.global_position = coords
	#print("shatter spawned at x=", coords.x, " y=", coords.y)
	smash.scale = orbSize
	smash.playParticle("lightShatter")

func levelUp():
	setCooldown = setCooldown * 0.8
