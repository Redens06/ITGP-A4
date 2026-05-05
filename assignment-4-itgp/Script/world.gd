extends Node2D

var spawnPoints

var enemy = preload("res://Scenes/enemy.tscn")

var enemy_list = [
	preload("res://Scenes/enemy.tscn"),
	preload("res://Scenes/enemy_2.tscn"),
	preload("res://Scenes/enemy_3.tscn"),
	preload("res://Scenes/enemy_4.tscn")
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnPoints = get_tree().get_nodes_in_group("spawn")

func _on_spawn_timer_timeout():
	#var enemy_instance = enemy.instantiate()
	#add_child(enemy_instance)
	#enemy_instance.position = $spawnlocation.position
	
	var scene = enemy_list.pick_random().instantiate()
	var pickedSpawn = spawnPoints.pick_random()
	scene.position = pickedSpawn.position 
	add_child(scene)
