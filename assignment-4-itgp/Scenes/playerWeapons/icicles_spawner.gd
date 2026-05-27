extends Node2D

var icicleScene = preload("res://Scenes/playerWeapons/Icicle.tscn")
var particleSpawn = preload("res://Scenes/particleSpawner.tscn")
var setCooldown = 2.0
var cooldownTimer = 0.0
var angled = true

func _process(delta: float) -> void:
	cooldownTimer += delta
	if cooldownTimer >= setCooldown:
		cooldownTimer -= setCooldown
		spawnIciles()

func spawnIciles():
	angled = !angled
	for i in range(0,4):
		var icicle = icicleScene.instantiate()
		add_child(icicle)
		icicle.global_position = global_position
		icicle.rotation_degrees = i * 90
		if angled:
			icicle.rotation_degrees += 45

func playShatter(coords : Vector2, orbSize : Vector2):
	var smash = particleSpawn.instantiate()
	add_child(smash)
	smash.global_position = coords
	#print("shatter spawned at x=", coords.x, " y=", coords.y)
	smash.scale = orbSize
	smash.playParticle("lightShatter")

func levelUp():
	setCooldown = setCooldown * 0.8
