extends Node2D

var lightScene = preload("res://Scenes/playerWeapons/ballOfLight.tscn")
var setCooldown = 4.5
var cooldownTimer = 0.0

func _process(delta: float) -> void:
	cooldownTimer += delta
	if cooldownTimer >= setCooldown:
		cooldownTimer -= setCooldown
		spawnLight()

func spawnLight():
	var lightInstance = lightScene.instantiate()
	lightInstance.global_position = global_position
	lightInstance.rotation_degrees = randf_range(0.0, 360.0)
	add_child(lightInstance)
