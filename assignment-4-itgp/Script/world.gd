extends Node2D

#var spawnPoints
var spawnLine : PathFollow2D

var enemy = preload("res://Scenes/enemy.tscn")

var timer = 0.0

var enemy_list = [
	preload("res://Scenes/enemy.tscn")
	#preload("res://Scenes/enemy_2.tscn"),
	#preload("res://Scenes/enemy_3.tscn"),
	#preload("res://Scenes/enemy_4.tscn")
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#spawnPoints = get_tree().get_nodes_in_group("spawn")
	spawnLine = get_tree().get_first_node_in_group("spawner")

func _process(delta: float) -> void:
	timer += delta

func _on_spawn_timer_timeout():
	#var enemy_instance = enemy.instantiate()
	#add_child(enemy_instance)
	#enemy_instance.position = $spawnlocation.position
	
	var scene = enemy_list.pick_random().instantiate()
	#var pickedSpawn = spawnPoints.pick_random()
	spawnLine.progress_ratio = randf_range(0,1)
	scene.position = spawnLine.global_position
	add_child(scene)
