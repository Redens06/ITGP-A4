extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var enemy = preload("res://Scenes/enemy.tscn")

func _on_spawn_timer_timeout():
	var enemy_instance = enemy.instantiate()
	add_child(enemy_instance)
	enemy_instance.position = $spawnlocation.position

	var nodes = get_tree().get_nodes_in_group("spawn")
	var node = nodes.pick_random()
	var position = node.position  
	$spawnlocation.position = position
