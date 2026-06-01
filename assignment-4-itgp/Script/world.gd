extends Node2D

#var spawnPoints
var spawnLine : PathFollow2D

var enemy = preload("res://Scenes/enemy.tscn")

var timer = 0.0

var slime_list = [
	preload("res://Scenes/enemy.tscn")
]
var goblin_list = [
	preload("res://Scenes/enemy_2.tscn")
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#spawnPoints = get_tree().get_nodes_in_group("spawn")
	spawnLine = get_tree().get_first_node_in_group("spawner")

func _process(delta: float) -> void:
	timer += delta
	$SlimeTimer.wait_time = 0.1 + pow(1.01, timer * -1)

func _on_spawn_timer_timeout():
	#var enemy_instance = enemy.instantiate()
	#add_child(enemy_instance)
	#enemy_instance.position = $spawnlocation.position
	
	var scene = slime_list.pick_random().instantiate()
	scene.spawnTime = timer
	#var pickedSpawn = spawnPoints.pick_random()
	spawnLine.progress_ratio = randf_range(0,1)
	scene.position = spawnLine.global_position
	add_child(scene)

func _on_goblin_timer_timeout():
	#var enemy_instance = enemy.instantiate()
	#add_child(enemy_instance)
	#enemy_instance.position = $spawnlocation.position
	
	var scene = goblin_list.pick_random().instantiate()
	scene.spawnTime = timer
	#var pickedSpawn = spawnPoints.pick_random()
	spawnLine.progress_ratio = randf_range(0,1)
	scene.position = spawnLine.global_position
	add_child(scene)
	
func _physics_process(delta):
	change_scene()

func _on_dungeontransitionpoint_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene = true


func _on_dungeontransitionpoint_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene = false
		
func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "world":
			get_tree().change_scene_to_file("res://Scenes/dungeon.tscn")
			global.finsih_changingscenes()
