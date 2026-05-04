extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var enemy = preload("res://Scenes/enemy.tscn")

var enemy_list = [
	preload("res://Scenes/enemy.tscn"),
	preload("res://Scenes/enemy_2.tscn"),
	preload("res://Scenes/enemy_3.tscn"),
	preload("res://Scenes/enemy_4.tscn")
]

func _on_spawn_timer_timeout():
	#var enemy_instance = enemy.instantiate()
	#add_child(enemy_instance)
	#enemy_instance.position = $spawnlocation.position

	var scene = enemy_list.pick_random().instantiate()
	scene.position = $spawnlocation.position
	add_child(scene)

	var nodes = get_tree().get_nodes_in_group("spawn")
	var node = nodes.pick_random()
	var position = node.position  
	$spawnlocation.position = position
